class PlayedTrack {
  String? id;
  String? uid;
  String? trackId;
  String? sessionId;
  int? created;
  int? duration;

  PlayedTrack({
    this.id,
    this.uid,
    this.trackId,
    this.sessionId,
    this.created,
    this.duration,
  });

  factory PlayedTrack.fromMap(Map? data) {
    if (data == null) return PlayedTrack();
    return PlayedTrack(
      id: data['id'],
      uid: data['uid'],
      trackId: data['trackId'],
      sessionId: data['sessionId'],
      created: data['created'],
      duration: data['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'trackId': trackId,
      'sessionId': sessionId,
      'created': created,
      'duration': duration,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
} 