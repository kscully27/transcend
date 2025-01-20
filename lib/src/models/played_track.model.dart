class PlayedTrack {
  final String? id;
  final String? uid;
  final String? sessionId;
  final String? trackId;
  final String? text;
  final int? duration;
  final int? words;
  final int? created;
  final int? startedTime;

  PlayedTrack({
    this.id,
    this.uid,
    this.sessionId,
    this.trackId,
    this.text,
    this.duration,
    this.words,
    this.created,
    this.startedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'sessionId': sessionId,
      'trackId': trackId,
      'text': text,
      'duration': duration,
      'words': words,
      'created': created,
      'startedTime': startedTime,
    };
  }

  factory PlayedTrack.fromJson(Map<String, dynamic> json) {
    return PlayedTrack(
      id: json['id'],
      uid: json['uid'],
      sessionId: json['sessionId'],
      trackId: json['trackId'],
      text: json['text'],
      duration: json['duration'],
      words: json['words'],
      created: json['created'],
      startedTime: json['startedTime'],
    );
  }
} 