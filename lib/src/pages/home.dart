import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/topics/topics_list_view.dart';
import 'package:trancend/src/ui/clay_bottom_nav/clay_bottom_nav.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    var theme = Theme.of(context);

    return appState.when(
      data: (data) {
        if (!data.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          extendBody: true,
          backgroundColor: theme.colorScheme.surface,
          body: Container(
            decoration: AppColors.enableGradients
                ? BoxDecoration(
                    gradient: AppColors.marsBackgroundGradient(context),
                  )
                : null,
            child: _index == 0
                ? data.topics.when(
                    data: (topics) => TopicsListView(),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error loading topics: $error')),
                  )
                : const SettingsPage(),
          ),
          bottomNavigationBar: ClayBottomNavNSheet(
            backgroundColor: theme.colorScheme.surface,
            emboss: false,
            parentColor: theme.colorScheme.surface,
            borderColors: [
              theme.colorScheme.primary.withOpacity(0.2),
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.2),
            ],
            selectedItemColor: theme.colorScheme.onSurface,
            unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
            sheetOpenIconBoxColor: theme.colorScheme.primary,
            sheetOpenIconColor: theme.colorScheme.onPrimary,
            sheetCloseIconBoxColor: theme.colorScheme.surface,
            sheetCloseIconColor: theme.colorScheme.onSurfaceVariant,
            initialSelectedIndex: _index,
            onTap: (index) {
              setState(() {
                _index = index;
              });
                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    _index = index;
                  });
                });
              },
              sheet: Sheet(),
              sheetOpenIcon: Remix.play_large_line,
              sheetCloseIcon: Remix.add_line,
              onSheetToggle: (v) {
                setState(() {});
            },
            items: [
              ClayBottomNavItem(
                activeIcon: Remix.home_6_fill,
                icon: Remix.home_6_line,
              ),
              ClayBottomNavItem(
                icon: Remix.user_3_line,
                activeIcon: Remix.user_3_fill,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class Sheet extends StatelessWidget {
  const Sheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.5,
      initialChildSize: 0.75,
      builder: (context, controller) {
        return Container(
          margin: const EdgeInsets.all(8),
          child: ClipRRect( 
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.black26,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.25,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        type: MaterialType.transparency,
                        child: ListView(
                          controller: controller,
                          padding: const EdgeInsets.all(20),
                          children: const [],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
