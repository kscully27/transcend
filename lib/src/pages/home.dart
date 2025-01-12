import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/topics/topics_list_view.dart';
import 'package:trancend/src/ui/neo_bottom_nav/neo_bottom_nav.dart';

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

    Color baseColor = const Color(0xFFD59074);
    Color baseColor2 = const Color(0xFFC67E60);
    Color navColor = const Color(0xFFC6846A);
    Color textColor = const Color(0xFF883912);
    Color iconColor = const Color(0xFFE2BFAF);

    return appState.when(
      data: (data) {
        if (!data.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          extendBody: true,
          backgroundColor: baseColor,
          body: _index == 0
              ? data.topics.when(
                  data: (topics) => TopicsListView(),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error loading topics: $error')),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Page $_index',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: NeoBottomNavNSheet(
              backgroundColor: navColor,
              emboss: false,
              parentColor: baseColor,
              borderColors: [baseColor2, baseColor2, baseColor2, baseColor2],
              selectedItemColor: iconColor,
              unselectedItemColor: theme.colorScheme.secondary,
              sheetOpenIconBoxColor: iconColor,
              sheetOpenIconColor: textColor,
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
              // sheetCloseIconBoxColor: Colors.white,
              sheetCloseIconColor: theme.colorScheme.secondary,
              // sheetOpenIconColor: Colors.white,
              onSheetToggle: (v) {
                setState(() {});
            },
            items: [
              NeoBottomNavItem(
                  activeIcon: Remix.home_6_fill,
                  icon: Remix.home_6_line,
              ),
              NeoBottomNavItem(
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
      builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.zero,
          child: Container(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    border: Border.all(
                      color: Colors.black26,
                      width: 0.5,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.25,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                      spacing: 12,
                                children: const [],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      
      minChildSize: 0.5,
      initialChildSize: 0.75,
    );
  }
}
