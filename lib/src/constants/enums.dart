
String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, List<T> values) =>
    values.where((v) => key == enumToString(v!)).firstOrNull as T;
