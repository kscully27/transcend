import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/pages/day.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/topics/topics_list_view.dart';
import 'package:trancend/src/ui/clay_bottom_nav/clay_bottom_nav.dart';
import 'package:trancend/src/pages/sessions/startSession.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';

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
    // Clear selection when sheet is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(intentionSelectionProvider.notifier).clearSelection();
    });
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
                    data: (topics) => Day(),
                    loading: () => Material(
                      color: theme.colorScheme.onSurface,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stack) =>
                        Center(child: Text('Error loading topics: $error')),
                  )
                : const SettingsPage(),
          ),
          bottomNavigationBar: ClayBottomNavNSheet(
            backgroundColor: theme.colorScheme.surface,
            emboss: false,
            parentColor: theme.colorScheme.surface,
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
            },
            sheet: const Sheet(),
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
