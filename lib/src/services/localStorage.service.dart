library local_storage_service;

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  static Future<LocalStorageService> getInstance() async {
    return LocalStorageServiceAdapter.getInstance();
  }
  
  bool get darkMode;
  set darkMode(bool value);
  String get referrerUid;
  set referrerUid(String value);
  String get topicId;
  set topicId(String value);
  bool get cameFromDynamicLink;
  set cameFromDynamicLink(bool value);
}

class LocalStorageServiceAdapter implements LocalStorageService {
  static final LocalStorageServiceAdapter _instance = LocalStorageServiceAdapter._();
  static SharedPreferences? _preferences;

  LocalStorageServiceAdapter._();

  static Future<LocalStorageService> getInstance() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  static const String darkModeKey = 'darkmode';
  static const String referrerKey = 'referrerUid';
  static const String topicIdKey = 'topicId';
  static const String dynamicLinkKey = 'cameFromDynamicLink';

  @override
  bool get darkMode => _getFromDisk(darkModeKey) ?? false;
  @override
  set darkMode(bool value) => _saveToDisk(darkModeKey, value);

  @override
  bool get cameFromDynamicLink => _getFromDisk(dynamicLinkKey) ?? false;
  @override
  set cameFromDynamicLink(bool value) => _saveToDisk(dynamicLinkKey, value);

  @override
  String get referrerUid => _getFromDisk(referrerKey) ?? '';
  @override
  set referrerUid(String value) => _saveToDisk(referrerKey, value);

  @override
  String get topicId => _getFromDisk(topicIdKey) ?? '';
  @override
  set topicId(String value) => _saveToDisk(topicIdKey, value);

  dynamic _getFromDisk(String key) {
    var value = _preferences?.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences?.setString(key, content);
    }
    if (content is bool) {
      _preferences?.setBool(key, content);
    }
    if (content is int) {
      _preferences?.setInt(key, content);
    }
    if (content is double) {
      _preferences?.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences?.setStringList(key, content);
    }
  }
}
