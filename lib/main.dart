import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/providers/theme_provider.dart';
import 'package:trancend/src/router/playground_route_information_parser.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/theme/app_theme.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() async {
  runMainApp(null);
}

void runMainApp(FirebaseOptions? firebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (firebaseOptions != null) {
      print('Initializing Firebase with options...');
      await Firebase.initializeApp(options: firebaseOptions);
      print('Firebase initialized successfully');
    }
    
    print('Initializing AppColors...');
    await AppColors.initialize();
    print('AppColors initialized');
    
    print('Setting up locator...');
    await setupLocator();
    print('Locator setup complete');

    runApp(const DemoApp());
  } catch (e, stackTrace) {
    print('Error initializing app: $e');
    print('Stack trace: $stackTrace');
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier =
      ValueNotifier((context) => [RootSheetPage.build(context)]);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {

            final appState = ref.watch(appStateProvider);
            print('appState: $appState');
            final isDarkMode = ref.watch(themeProvider);
          return
          
          
          
           MaterialApp.router(
            routeInformationParser: const PlaygroundRouteInformationParser(),
            backButtonDispatcher: RootBackButtonDispatcher(),
            routerDelegate: PlaygroundRouterDelegate(
              ref: ref,
              pageIndexNotifier: pageIndexNotifier,
              pageListBuilderNotifier: pageListBuilderNotifier,
            ),
            
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
