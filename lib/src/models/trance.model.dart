import 'package:trancend/src/constants/enums.dart';

class UserInduction {
  String? id;
  String? uid;
  String? name;
  String? category;
  String? instructionId;
  List<String>? trackIds;
  int? totalSeconds;
  int? delayInSeconds;
  bool? isComplete;
  RecordingType? recordingType;

  UserInduction({
    this.id,
    this.uid,
    this.name,
    this.category,
    this.instructionId,
    this.trackIds,
    this.totalSeconds,
    this.delayInSeconds,
    this.isComplete,
    this.recordingType,
  });

  factory UserInduction.fromMap(Map? data) {
    if (data == null) return UserInduction();
    
    List<String> _phrases = [];
    if (data['trackIds'] != null && data['trackIds'].isNotEmpty) {
      data['trackIds'].forEach((s) {
        _phrases.add(s);
      });
    }

    return UserInduction(
      id: data['id'],
      uid: data['uid'],
      name: data['name'],
      trackIds: _phrases,
      instructionId: data['instructionId'],
      category: data['category'],
      totalSeconds: data['totalSeconds'] ?? 0,
      delayInSeconds: data['delayInSeconds'] ?? 4,
      recordingType:
          enumFromString(data['recordingType'], RecordingType.values),
      isComplete: data['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'name': name,
      'instructionId': instructionId,
      'trackIds': trackIds,
      "totalSeconds": totalSeconds,
      "category": category,
      "delayInSeconds": delayInSeconds,
      "isComplete": isComplete,
      "recordingType": recordingType?.string,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}

class UserAwakening {
  String? id;
  String? uid;
  String? name;
  String? category;
  String? instructionId;
  List<String>? trackIds;
  int? totalSeconds;
  int? delayInSeconds;
  bool? isComplete;
  RecordingType? recordingType;

  UserAwakening({
    this.id,
    this.uid,
    this.name,
    this.category,
    this.instructionId,
    this.trackIds,
    this.totalSeconds,
    this.delayInSeconds,
    this.isComplete,
    this.recordingType,
  });

  factory UserAwakening.fromMap(Map? data) {
    if (data == null) return UserAwakening();
    
    List<String> _phrases = [];
    if (data['trackIds'] != null && data['trackIds'].isNotEmpty) {
      data['trackIds'].forEach((s) {
        _phrases.add(s);
      });
    }

    return UserAwakening(
      id: data['id'],
      uid: data['uid'],
      name: data['name'],
      trackIds: _phrases,
      instructionId: data['instructionId'],
      category: data['category'],
      totalSeconds: data['totalSeconds'] ?? 0,
      delayInSeconds: data['delayInSeconds'] ?? 4,
      recordingType:
          enumFromString(data['recordingType'], RecordingType.values),
      isComplete: data['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'name': name,
      'instructionId': instructionId,
      'trackIds': trackIds,
      "totalSeconds": totalSeconds,
      "category": category,
      "delayInSeconds": delayInSeconds,
      "isComplete": isComplete,
      "recordingType": recordingType?.string,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}

class UserDeepening {
  String? id;
  String? uid;
  String? name;
  String? category;
  String? instructionId;
  List<String>? trackIds;
  int? totalSeconds;
  int? delayInSeconds;
  bool? isComplete;
  RecordingType? recordingType;

  UserDeepening({
    this.id,
    this.uid,
    this.name,
    this.category,
    this.instructionId,
    this.trackIds,
    this.totalSeconds,
    this.delayInSeconds,
    this.isComplete,
    this.recordingType,
  });

  factory UserDeepening.fromMap(Map? data) {
    if (data == null) return UserDeepening();
    
    List<String> _phrases = [];
    if (data['trackIds'] != null && data['trackIds'].isNotEmpty) {
      data['trackIds'].forEach((s) {
        _phrases.add(s);
      });
    }

    return UserDeepening(
      id: data['id'],
      uid: data['uid'],
      name: data['name'],
      trackIds: _phrases,
      instructionId: data['instructionId'],
      category: data['category'],
      totalSeconds: data['totalSeconds'] ?? 0,
      delayInSeconds: data['delayInSeconds'] ?? 4,
      recordingType:
          enumFromString(data['recordingType'], RecordingType.values),
      isComplete: data['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'name': name,
      'instructionId': instructionId,
      'trackIds': trackIds,
      "totalSeconds": totalSeconds,
      "category": category,
      "delayInSeconds": delayInSeconds,
      "isComplete": isComplete,
      "recordingType": recordingType?.string,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}
