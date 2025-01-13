enum RecordingType { Phrases, Instruction, Suggestion }

String enumToString(dynamic enumValue) => enumValue.toString().split('.').last;

extension RecordingTypeX on RecordingType {
  String get string => toString().split('.').last;
}

T enumFromString<T>(String key, List<T> values) => values.firstWhere(
      (v) => v.toString().split('.').last == key,
      orElse: () => values.first,
    );
