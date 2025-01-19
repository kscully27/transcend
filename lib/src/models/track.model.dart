class Track {
  String? id;
  String? topic;
  String? title;
  String? description;
  String? url;
  int? duration;
  bool? approved;
  int? created;
  int? updated;

  Track({
    this.id,
    this.topic,
    this.title,
    this.description,
    this.url,
    this.duration,
    this.approved,
    this.created,
    this.updated,
  });

  factory Track.fromMap(Map? data) {
    if (data == null) return Track();
    try {
      // Handle duration conversion from double to int
      int? duration;
      if (data['duration'] != null) {
        if (data['duration'] is int) {
          duration = data['duration'];
        } else if (data['duration'] is double) {
          duration = data['duration'].toInt();
        }
      }
      
      return Track(
        id: data['id'],
        topic: data['topic'],
        title: data['title'],
        description: data['description'],
        url: data['url'],
        duration: duration,
        approved: data['approved'] ?? false,
        created: data['created'],
        updated: data['updated'],
      );
    } catch (e) {
      print('Error parsing track: $e');
      return Track();
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'topic': topic,
      'title': title,
      'description': description,
      'url': url,
      'duration': duration,
      'approved': approved,
      'created': created,
      'updated': updated,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}
