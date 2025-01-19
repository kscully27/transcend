class PlayedTrack {
  String? id;
  String? uid;
  String? trackId;
  String? sessionId;
  String? text;
  String? topic;
  String? category;
  int? words;
  int? created;
  int? duration;
  int? startedTime;

  PlayedTrack({
    this.id,
    this.uid,
    this.trackId,
    this.sessionId,
    this.text,
    this.topic,
    this.category,
    this.words,
    this.created,
    this.duration,
    this.startedTime,
  });

  factory PlayedTrack.fromMap(Map? data) {
    if (data == null) return PlayedTrack();
    return PlayedTrack(
      id: data['id'],
      uid: data['uid'],
      trackId: data['trackId'],
      sessionId: data['sessionId'],
      text: data['text'],
      topic: data['topic'],
      category: data['category'],
      words: data['words'],
      created: data['created'],
      duration: data['duration'],
      startedTime: data['startedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'trackId': trackId,
      'sessionId': sessionId,
      'text': text,
      'topic': topic,
      'category': category,
      'words': words,
      'created': created,
      'duration': duration,
      'startedTime': startedTime,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
} 