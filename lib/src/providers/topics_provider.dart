import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/services/firestore.service.dart';

part 'topics_provider.g.dart';

@Riverpod(keepAlive: true)
class Topics extends _$Topics {
  String _selectedCategory = 'All';
  List<Topic> _allTopics = [];
  
  @override
  Future<List<Topic>> build() async {
    try {
      debugPrint('🔍 Topics Provider: Starting build...');
      
      if (!locator.isRegistered<FirestoreService>()) {
        throw Exception('FirestoreService not registered in locator');
      }
      
      final firestoreService = locator<FirestoreService>();
      debugPrint('🔍 Topics Provider: Got FirestoreService instance');
      
      debugPrint('🔍 Topics Provider: Fetching topics from Firestore...');
      _allTopics = await firestoreService.getTopics();
      debugPrint('🔍 Topics Provider: Fetched ${_allTopics.length} topics');
      
      final filtered = getFilteredTopics();
      debugPrint('🔍 Topics Provider: Returning ${filtered.length} filtered topics');
      return filtered;
    } catch (e, stackTrace) {
      debugPrint('❌ Topics Provider Error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  List<String> getCategories() {
    final categories = _allTopics.map((t) => t.group).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  String getDisplayCategory(String category) {
    if (category == 'All') return 'All';
    return category.split(' ').map((word) => 
      word[0].toUpperCase() + word.substring(1).toLowerCase()
    ).join(' ');
  }

  List<Topic> getFilteredTopics() {
    if (_selectedCategory == 'All') return _allTopics;
    return _allTopics.where((t) => t.group == _selectedCategory).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    state = AsyncValue.data(getFilteredTopics());
  }

  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) => _selectedCategory = value;

  void setSelectedCategory(String category) {
    state = AsyncValue.data(state.value!);
    selectedCategory = category;
  }
} 