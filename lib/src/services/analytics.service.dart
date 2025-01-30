import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

abstract class AnalyticsService {
  Future<void> loadService();
  NavigatorObserver getAnalyticsObserver();
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> setCurrentScreen(String screenName);
  Future<void> setUserId(String userId);
  Future<void> logLogin(String method);
  Future<void> logSignUp(String method);
  Future<void> logSearch(String searchTerm);
  Future<void> logSelectContent({required String contentType, required String itemId});
  Future<void> logShare({required String contentType, required String itemId, required String method});
  Future<void> logSelectPromotion({required String promotionId, required String promotionName});
  Future<void> logPurchase({required String transactionId, required double value, required String currency});
}

class FirebaseAnalyticsService implements AnalyticsService {
  final _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> loadService() async {
    // Initialize any required setup
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  @override
  NavigatorObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    await _analytics.setCurrentScreen(screenName: screenName);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  @override
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  @override
  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    await _analytics.logSelectContent(
      contentType: contentType,
      itemId: itemId,
    );
  }

  @override
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method,
    );
  }

  @override
  Future<void> logSelectPromotion({
    required String promotionId,
    required String promotionName,
  }) async {
    await _analytics.logSelectPromotion(
      promotionId: promotionId,
      promotionName: promotionName,
    );
  }

  @override
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
  }) async {
    await _analytics.logPurchase(
      transactionId: transactionId,
      value: value,
      currency: currency,
    );
  }
} 