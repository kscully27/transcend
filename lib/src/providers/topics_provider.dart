import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/locator.dart';

class TopicsProvider {
  static final TopicsProvider _instance = TopicsProvider._internal();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  
  List<Topic>? _topics;
  bool _isLoading = false;
  String _selectedCategory = 'All';

  factory TopicsProvider() {
    return _instance;
  }

  TopicsProvider._internal();

  String get selectedCategory => _selectedCategory;
  
  void setCategory(String group) {
    _selectedCategory = group;
  }

  List<String> getCategories() {
    if (_topics == null) return ['All'];
    
    final categories = _topics!
        .map((topic) => topic.group)
        .toSet()
        .toList();
    
    categories.sort();  // Sort alphabetically
    return ['All', ...categories];  // Add 'All' at the beginning
  }

  List<Topic> getFilteredTopics() {
    if (_topics == null) return [];
    if (_selectedCategory == 'All') return _topics!;
    
    return _topics!
        .where((topic) => topic.group == _selectedCategory)
        .toList();
  }

  Future<List<Topic>> getTopics() async {
    if (_topics != null) {
      return _topics!;
    }

    if (_isLoading) {
      // Wait until the first load completes
      while (_isLoading) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      return _topics ?? [];
    }

    _isLoading = true;
    try {
      final QuerySnapshot snapshot = await _firestoreService.getTopicQuery().get();
      _topics = snapshot.docs.map((doc) => doc.data() as Topic).toList();
      return _topics!;
    } catch (e) {
      print('Error loading topics: $e');
      return [];
    } finally {
      _isLoading = false;
    }
  }

  List<Topic>? get topics => _topics;
} 