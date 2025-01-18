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
    final firestoreService = locator<FirestoreService>();
    _allTopics = await firestoreService.getTopics();
    return getFilteredTopics();
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