// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationTransition {
  static const String Fade = 'fade';
  static const String RightToLeft = 'righttoleft';
  static const String LeftToRight = 'lefttoright';
  static const String UpToDown = 'uptodown';
  static const String DownToUp = 'downtoup';
  static const String Rotate = 'zoom';
  static const String RightToLeftWithFade = 'righttoleftwithfade';
  static const String LeftToRighttWithFade = 'lefttorightwithfade';
}

/// Provides a service that can be injected into the ViewModels for navigation.
///
/// Uses the Get library for all navigation requirements
class NavigationService {
  final Map<String, Transition> _transitions = {
    NavigationTransition.Fade: Transition.fade,
    NavigationTransition.RightToLeft: Transition.rightToLeft,
    NavigationTransition.LeftToRight: Transition.leftToRight,
    NavigationTransition.UpToDown: Transition.upToDown,
    NavigationTransition.DownToUp: Transition.downToUp,
    NavigationTransition.Rotate: Transition.zoom,
    NavigationTransition.RightToLeftWithFade: Transition.rightToLeftWithFade,
    NavigationTransition.LeftToRighttWithFade: Transition.leftToRightWithFade,
  };

  GlobalKey<NavigatorState> get navigatorKey => Get.key;

  /// Returns the previous route
  String get previousRoute => Get.previousRoute;

  /// Returns the current route
  String get currentRoute => Get.currentRoute;

  /// Creates and/or returns a new navigator key based on the index passed in
  GlobalKey<NavigatorState>? nestedNavigationKey(int index) =>
      Get.nestedKey(index);

  /// Allows you to configure the default behaviour for navigation.
  ///
  /// [defaultTransition] can be set using the static members of [NavigationTransition]
  ///
  /// If you want to use the string directly. Defined [transition] values are
  /// - fade
  /// - rightToLeft
  /// - leftToRight
  /// - upToDown
  /// - downToUp
  /// - scale
  /// - rotate
  /// - size
  /// - rightToLeftWithFade
  /// - leftToRightWithFade
  /// - cupertino
  void config(
      {bool enableLog = false,
      bool defaultPopGesture = true,
      bool defaultOpaqueRoute = true,
      Duration defaultDurationTransition = const Duration(milliseconds: 300),
      bool defaultGlobalState = false,
      String defaultTransition = NavigationTransition.Fade}) {
    Get.config(
        enableLog: enableLog,
        defaultPopGesture: defaultPopGesture,
        defaultOpaqueRoute: defaultOpaqueRoute,
        defaultDurationTransition: defaultDurationTransition,
        defaultGlobalState: defaultGlobalState,
        defaultTransition: _getTransitionOrDefault(defaultTransition));
  }

  /// Pushes [page] onto the navigation stack. This uses the [page] itself (Widget) instead
  /// of routeName (String).
  ///
  /// Defined [transition] values can be accessed as static memebers of [NavigationTransition]
  ///
  /// If you want to use the string directly. Defined [transition] values are
  /// - fade
  /// - rightToLeft
  /// - leftToRight
  /// - upToDown
  /// - downToUp
  /// - scale
  /// - rotate
  /// - size
  /// - rightToLeftWithFade
  /// - leftToRightWithFade
  /// - cupertino
  Future? navigateWithTransition(Widget page,
      {bool opaque = true,
      String transition = NavigationTransition.Fade,
      Duration duration = const Duration(milliseconds: 300),
      bool popGesture = true,
      int id = 0}) {
    return Get.to(page,
        transition: _getTransitionOrDefault(transition),
        duration: duration,
        popGesture: popGesture,
        opaque: opaque,
        id: id);
  }

  /// Replaces current view in the navigation stack. This uses the [page] itself (Widget) instead
  /// of routeName (String).
  ///
  /// Defined [transition] values can be accessed as static memebers of [NavigationTransition]
  Future? replaceWithTransition(Widget page,
      {bool opaque = true,
      String transition = NavigationTransition.Fade,
      Duration duration = const Duration(milliseconds: 300),
      bool popGesture = true,
      int id = 0}) {
    return Get.off(
      page,
      transition: _getTransitionOrDefault(transition),
      duration: duration,
      popGesture: popGesture,
      opaque: opaque,
      id: id,
    );
  }

  /// Pops the current scope and indicates if you can pop again
  bool back({dynamic result}) {
    Get.back(result: result);
    return navigatorKey.currentState?.canPop() ?? false;
  }

  /// Pops the back stack until the predicate is satisfied
  void popUntil(RoutePredicate predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  /// Pops the back stack the number of times you indicate with [popTimes]
  void popRepeated(int popTimes) {
    Get.close(popTimes);
  }

  /// Pushes [routeName] onto the navigation stack
  Future<dynamic>? navigateTo(String routeName,
      {dynamic arguments, int id = 0}) {
    return Get.toNamed(routeName, arguments: arguments, id: id);
  }

  /// Pushes [view] onto the navigation stack
  Future<dynamic>? navigateToView(Widget view,
      {dynamic arguments, int id = 0}) {
    return Get.to(view, arguments: arguments, id: id);
  }

  /// Replaces the current route with the [routeName]
  Future<dynamic>? replaceWith(String routeName,
      {dynamic arguments, int id = 0}) {
    return Get.offNamed(routeName, arguments: arguments, id: id);
  }

  /// Clears the entire back stack and shows [routeName]
  Future<dynamic>? clearStackAndShow(String routeName,
      {dynamic arguments, int id = 0}) {
    return Get.offAllNamed(routeName, arguments: arguments, id: id);
  }

  /// Pops the navigation stack until there's 1 view left then pushes [routeName] onto the stack
  Future<dynamic>? clearTillFirstAndShow(String routeName,
      {dynamic arguments, int id = 0}) {
    _clearBackstackTillFirst();

    return navigateTo(routeName, arguments: arguments, id: id);
  }

  /// Pops the navigation stack until there's 1 view left then pushes [view] onto the stack
  Future<dynamic>? clearTillFirstAndShowView(Widget view,
      {dynamic arguments, int id = 0}) {
    _clearBackstackTillFirst();

    return navigateToView(view, arguments: arguments, id: id);
  }

  /// Push route and clear stack until predicate is satisfied
  Future<dynamic>? pushNamedAndRemoveUntil(String routeName,
      {RoutePredicate? predicate, dynamic arguments, int id = 0}) {
    return Get.offAllNamed(
      routeName,
      predicate: predicate,
      arguments: arguments,
      id: id,
    );
  }

  void _clearBackstackTillFirst() {
    navigatorKey.currentState?.popUntil((Route route) => route.isFirst);
  }

  Transition _getTransitionOrDefault(String transition) {
    String _transition = transition.toLowerCase();
    return _transitions[_transition] ?? Transition.fade;
  }
}
