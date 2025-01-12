class Suggestion {
  String id;
  String uid;
  String text;
  String url;
  String fileLocation;
  String goalId;
  int timesHeard;
  int duration;
  int fileSize;
  int created;

  Suggestion({
    required this.id,
    required this.uid,
    this.text = "",
    this.timesHeard = 0,
    required this.goalId,
    this.url = '',
    this.fileLocation = '',
    this.duration = 0,
    this.fileSize = 0,
    int? created,
  }) : created = created ?? DateTime.now().millisecondsSinceEpoch;

  factory Suggestion.fromMap(Map data) {
    return Suggestion(
      id: data['id'],
      uid: data['uid'],
      text: data['text'],
      goalId: data['goalId'],
      timesHeard: data['timesHeard'] ?? 0,
      url: data['url'],
      fileLocation: data['fileLocation'],
      duration: data['duration'] ?? 0,
      fileSize: data['fileSize'] ?? 0,
      created: data['created'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'text': text,
      'goalId': goalId,
      'timesHeard': timesHeard,
      'url': url,
      'fileLocation': fileLocation,
      'duration': duration,
      'fileSize': fileSize,
      "created": created,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}
