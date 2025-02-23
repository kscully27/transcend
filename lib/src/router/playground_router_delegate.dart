import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/multi_page_path_name.dart';
import 'package:trancend/src/navigation/bottomsheet_declarative_routing.dart';
import 'package:trancend/src/navigation/bottomsheet_flow_notifier.dart';
import 'package:trancend/src/pages/home.dart';
import 'package:trancend/src/router/playground_router_configuration.dart';
import 'package:trancend/src/router/router_pages/sheet_page.dart';
import 'package:trancend/src/unknown/unknown_screen.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// Router state
class RouterState {
  final bool isUnknown;
  final bool isModalSheetVisible;
  final MultiPagePathName? pathName;
  final int pageIndex;
  final BottomSheetFlowName? flowName;

  const RouterState({
    this.isUnknown = false,
    this.isModalSheetVisible = false,
    this.pathName,
    this.pageIndex = 0,
    this.flowName,
  });

  RouterState copyWith({
    bool? isUnknown,
    bool? isModalSheetVisible,
    MultiPagePathName? pathName,
    int? pageIndex,
    BottomSheetFlowName? flowName,
  }) {
    return RouterState(
      isUnknown: isUnknown ?? this.isUnknown,
      isModalSheetVisible: isModalSheetVisible ?? this.isModalSheetVisible,
      pathName: pathName ?? this.pathName,
      pageIndex: pageIndex ?? this.pageIndex,
      flowName: flowName ?? this.flowName,
    );
  }
}

// Router notifier
class RouterNotifier extends StateNotifier<RouterState> {
  RouterNotifier(this.ref) : super(const RouterState()) {
    // Listen to bottom sheet flow changes
    _subscription = ref.listen(bottomSheetFlowProvider, (previous, next) {
      if (next.isOpen != state.isModalSheetVisible) {
        state = state.copyWith(
          isModalSheetVisible: next.isOpen,
          flowName: next.flow,
          pageIndex: next.pageIndex,
        );
      }
    });
  }

  final Ref ref;
  late final ProviderSubscription _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  void showOnUnknownScreen() {
    state = const RouterState(isUnknown: true);
  }

  void closeSheet() {
    state = const RouterState();
    ref.read(bottomSheetFlowProvider.notifier).closeFlow();
  }

  void goToPage(int pageIndex) {
    if (state.isModalSheetVisible) {
      state = state.copyWith(pageIndex: pageIndex);
      if (state.flowName != null) {
        ref.read(bottomSheetFlowProvider.notifier).goToPage(pageIndex);
      }
    }
  }

  void onPathUpdated(MultiPagePathName pathName) {
    if (state.isModalSheetVisible) {
      state = state.copyWith(pathName: pathName);
    }
  }

  void onPathAndPageIndexUpdated(MultiPagePathName pathName, int pageIndex) {
    state = RouterState(
      isModalSheetVisible: true,
      pathName: pathName,
      pageIndex: pageIndex,
    );
  }

  void onShowModalSheetButtonPressed() {
    if (!state.isModalSheetVisible && !state.isUnknown) {
      state = RouterState(
        isModalSheetVisible: true,
        pathName: MultiPagePathName.defaultPath,
      );
    }
  }

  void openFlow(BottomSheetFlowName flowName, {int pageIndex = 0}) {
    state = RouterState(
      isModalSheetVisible: true,
      flowName: flowName,
      pageIndex: pageIndex,
    );
    ref.read(bottomSheetFlowProvider.notifier).openFlow(flowName, pageIndex: pageIndex);
  }
}

// Provider
final routerProvider = StateNotifierProvider<RouterNotifier, RouterState>(
  (ref) => RouterNotifier(ref),
);

class PlaygroundRouterDelegate
    extends RouterDelegate<PlaygroundRouterConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PlaygroundRouterConfiguration> {
  PlaygroundRouterDelegate({
    required this.ref,
    required ValueNotifier<int> pageIndexNotifier,
    required ValueNotifier<WoltModalSheetPageListBuilder>
        pageListBuilderNotifier,
  })  : _pageIndexNotifier = pageIndexNotifier,
        _pageListBuilderNotifier = pageListBuilderNotifier {
    // Listen to router state changes
    _subscription = ref.listenManual(
      routerProvider,
      (_, __) => notifyListeners(),
    );
  }

  final WidgetRef ref;
  late final ProviderSubscription<RouterState> _subscription;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final ValueNotifier<int> _pageIndexNotifier;
  final ValueNotifier<WoltModalSheetPageListBuilder> _pageListBuilderNotifier;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(routerProvider);
    List<Page> pages = [const HomePage()];
    
    if (state.isModalSheetVisible && state.pathName != null) {
      _pageIndexNotifier.value = state.pageIndex;
      _pageListBuilderNotifier.value = state.pathName!.pageListBuilder;
      pages = [
        const HomePage(),
        SheetPage(
          pageIndexNotifier: _pageIndexNotifier,
          pageListBuilderNotifier: _pageListBuilderNotifier,
        ),
      ];
    } else if (state.isUnknown) {
      pages = [MaterialPage(child: const UnknownScreen())];
    }
    
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() {
    if (_navigatorKey.currentState != null &&
        _navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop();
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  PlaygroundRouterConfiguration get currentConfiguration {
    final state = ref.read(routerProvider);
    if (state.isUnknown) {
      return PlaygroundRouterConfiguration.unknown();
    } else if (state.isModalSheetVisible && state.pathName != null) {
      _pageIndexNotifier.value = state.pageIndex;
      _pageListBuilderNotifier.value = state.pathName!.pageListBuilder;
      return PlaygroundRouterConfiguration.modalSheet(
        multiPagePathName: state.pathName!,
        index: state.pageIndex,
      );
    }
    return PlaygroundRouterConfiguration.home();
  }

  @override
  Future<void> setNewRoutePath(
    PlaygroundRouterConfiguration configuration,
  ) async {
    final notifier = ref.read(routerProvider.notifier);
    if (configuration.isUnknown) {
      notifier.showOnUnknownScreen();
    } else if (configuration.isHomePage) {
      notifier.closeSheet();
    } else if (configuration.isSheetPage) {
      notifier.onPathAndPageIndexUpdated(
        configuration.multiPagePathName!,
        configuration.pageIndex,
      );
    }
  }

  @override
  void dispose() {
    _subscription.close();
    _pageIndexNotifier.dispose();
    _pageListBuilderNotifier.dispose();
    super.dispose();
  }
}
