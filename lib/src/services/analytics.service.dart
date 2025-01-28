import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsService {
  Object getAnalyticsObserver();
  Future<bool> loadService();
  Future<void> logAppOpen(bool fromPush);
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });
  Future setUid(String uid);
  Future setUserProperty(String name, String value);
  Future logLogin(String method);
  Future logSignUp(String method);
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  });
  Future<void> logShareAccept({
    required String contentType,
    required String itemId,
    required String method,
  });
  Future logPresentOffer({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    double? price,
    double? value,
    String? currency,
  });
  Future logPurchase({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    double? price,
    double? value,
    String? currency,
  });
  Future<void> logSearch({
    required String searchTerm,
    String? contentType,
  });
  Future<void> setCurrentScreen(String screenName);
}

class FirebaseAnalyticsService implements AnalyticsService {
  final _analytics = FirebaseAnalytics.instance;
  bool _initialized = false;

  @override
  Object getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  @override
  Future<bool> loadService() async {
    try {
      _initialized = true;
      return true;
    } catch (e) {
      print('Error initializing analytics: $e');
      return false;
    }
  }

  @override
  Future<void> logAppOpen(bool fromPush) async {
    if (!_initialized) return;
    await _analytics.logAppOpen();
    if (fromPush) {
      await logEvent(name: 'app_open_from_push');
    }
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_initialized) return;
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  @override
  Future setUid(String uid) async {
    if (!_initialized) return;
    await _analytics.setUserId(id: uid);
  }

  @override
  Future setUserProperty(String name, String value) async {
    if (!_initialized) return;
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future logLogin(String method) async {
    if (!_initialized) return;
    await _analytics.logLogin(loginMethod: method);
  }

  @override
  Future logSignUp(String method) async {
    if (!_initialized) return;
    await _analytics.logSignUp(signUpMethod: method);
  }

  @override
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    if (!_initialized) return;
    await _analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method,
    );
  }

  @override
  Future<void> logShareAccept({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    if (!_initialized) return;
    await logEvent(
      name: 'share_accept',
      parameters: {
        'content_type': contentType,
        'item_id': itemId,
        'method': method,
      },
    );
  }

  @override
  Future logPresentOffer({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    double? price,
    double? value,
    String? currency,
  }) async {
    if (!_initialized) return;
    await _analytics.logSelectPromotion(
      creativeName: itemName,
      creativeSlot: itemCategory,
      locationId: itemId,
    );
  }

  @override
  Future logPurchase({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    double? price,
    double? value,
    String? currency,
  }) async {
    if (!_initialized) return;
    await _analytics.logPurchase(
      currency: currency ?? 'USD',
      value: value ?? 0.0,
    );
  }

  @override
  Future<void> logSearch({
    required String searchTerm,
    String? contentType,
  }) async {
    if (!_initialized) return;
    await _analytics.logSearch(
      searchTerm: searchTerm,
      origin: contentType,
    );
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    if (!_initialized) return;
    await _analytics.setCurrentScreen(screenName: screenName);
  }
} 