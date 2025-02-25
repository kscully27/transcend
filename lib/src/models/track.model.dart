class Track {
  String? id;
  String? topic;
  String? text;
  String? description;
  String? url;
  String? category;
  int? words;
  int? duration;
  bool? approved;
  int? created;
  int? updated;

  Track({
    this.id,
    this.topic,
    this.text,
    this.description,
    this.url,
    this.words,
    this.duration,
    this.approved,
    this.category,
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
        text: data['text'],
        description: data['description'],
        url: data['url'],
        words: data['words'],
        duration: duration,
        approved: data['approved'] ?? false,
        category: data['category'],
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
      'text': text,
      'description': description,
      'url': url,
      'words': words,
      'duration': duration,
      'approved': approved,
      'category': category,
      'created': created,
      'updated': updated,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}
