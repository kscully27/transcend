import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/providers/topics_provider.dart';
import 'package:trancend/src/providers/user_topics_provider.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/topics/glass_topic_item.dart';
import 'package:trancend/src/topics/topic_item.dart';
import 'package:trancend/src/ui/clay_button.dart';

Color baseColor = const Color(0xFFD59074);
Color baseColor2 = const Color(0xFFC67E60);
Color textColor = const Color(0xFF883912);
Color titleColor = const Color(0xFFFBF3D8);
double firstDepth = 15;
double secondDepth = 10;
double thirdDepth = 50;
double fourthDepth = 50;

class TopicsListView extends ConsumerStatefulWidget {
  const TopicsListView({super.key});

  static const routeName = '/';

  @override
  ConsumerState<TopicsListView> createState() => _TopicsListViewState();
}

class _TopicsListViewState extends ConsumerState<TopicsListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoriesScrollController = ScrollController();
  late AnimationController _swipeController;
  double _swipeProgress = 0;
  bool _isAnimating = false;
  final String _selectedCategory = 'All';
  bool _useGlassItems = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    ref.read(userProvider);
  }

  Widget _buildTopicsList() {
    final topicsAsync = ref.watch(topicsProvider);
    
    return Stack(
      children: [
        // Current list
        Transform.translate(
          offset: Offset(_swipeProgress * MediaQuery.of(context).size.width, 0),
          child: _buildList(topicsAsync, false),
        ),
        // Next list
        if (_swipeProgress != 0)
          Transform.translate(
            offset: Offset(
              (_swipeProgress > 0 ? -1 : 1) * MediaQuery.of(context).size.width +
              (_swipeProgress * MediaQuery.of(context).size.width),
              0
            ),
            child: _buildList(topicsAsync, true),
          ),
      ],
    );
  }

  Widget _buildList(AsyncValue<List<Topic>> topicsAsync, bool isNext) {
    return topicsAsync.when(
      data: (topics) {
        final categories = ref.read(topicsProvider.notifier).getCategories();
        final currentCategory = ref.read(topicsProvider.notifier).selectedCategory;
        final currentIndex = categories.indexOf(currentCategory);
        
        // Determine which category to show
        final targetIndex = currentIndex + (_swipeProgress > 0 ? 1 : -1);
        final targetCategory = isNext && targetIndex >= 0 && targetIndex < categories.length
            ? categories[targetIndex]
            : currentCategory;

        final filteredTopics = topics.where((t) => 
          targetCategory == 'All' || t.group == targetCategory
        ).toList();

        return ListView.builder(
          key: ValueKey<String>('${targetCategory}_${isNext ? 'next' : 'current'}'),
          controller: _scrollController,
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 200.0,
            bottom: 96.0
          ),
          itemCount: filteredTopics.length,
          itemBuilder: (context, index) {
            final topic = filteredTopics[index];
            final userTopicsAsync = ref.watch(userTopicsProvider);
            
            return userTopicsAsync.when(
              data: (userTopics) {
                final favoriteMap = {
                  for (var ut in userTopics) ut.topicId: ut.isFavorite
                };
                
                return _useGlassItems
                  ? GlassTopicItem(
                      index: index,
                      shouldAnimate: _isAnimating,
                      topic: topic,
                      isFavorite: favoriteMap[topic.id] ?? false,
                      onFavoritePressed: () => _toggleFavorite(topic.id),
                    )
                  : TopicItem(
                      index: index,
                      shouldAnimate: _isAnimating,
                      topic: topic,
                      isFavorite: favoriteMap[topic.id] ?? false,
                      onFavoritePressed: () => _toggleFavorite(topic.id),
                    );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  void _toggleFavorite(String topicId) async {
    final user = ref.read(userProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to favorite topics'))
      );
      return;
    }
    
    try {
      final firestoreService = locator<FirestoreService>();
      await firestoreService.toggleTopicFavorite(user.uid, topicId);
      
      // Force a refresh of the userTopics provider
      ref.invalidate(userTopicsProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorite: ${e.toString()}'))
      );
      print('Error toggling favorite: $e');
    }
  }

  void _scrollToCategory(int index) {
    final buttonWidth = 120.0;
    final padding = 4.0;
    final targetScroll = (buttonWidth + (padding * 2)) * index;

    _categoriesScrollController.animateTo(
      targetScroll.clamp(
          0.0, _categoriesScrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onCategorySelected(String category) {
    if (_isAnimating) return;
    
    final categories = ref.read(topicsProvider.notifier).getCategories();
    final oldIndex = categories.indexOf(ref.read(topicsProvider.notifier).selectedCategory);
    final newIndex = categories.indexOf(category);
    
    if (oldIndex == newIndex) return;
    
    setState(() {
      _swipeProgress = oldIndex < newIndex ? -1 : 1;
    });

    _completeSwipe(oldIndex < newIndex ? 1 : -1);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    
    return user.when(
      data: (user) => GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (_isAnimating) return;
          
          // Get current category index
          final categories = ref.read(topicsProvider.notifier).getCategories();
          final currentIndex = categories.indexOf(
            ref.read(topicsProvider.notifier).selectedCategory
          );
          
          // Prevent swiping left on first item or right on last item
          if ((currentIndex == 0 && details.delta.dx > 0) || 
              (currentIndex == categories.length - 1 && details.delta.dx < 0)) {
            return;
          }

          setState(() {
            _swipeProgress += details.delta.dx / MediaQuery.of(context).size.width;
            // Clamp the progress to prevent over-swiping
            _swipeProgress = _swipeProgress.clamp(-1.0, 1.0);
          });
        },
        onHorizontalDragEnd: (details) {
          if (_isAnimating) return;
          final velocity = details.primaryVelocity ?? 0;
          
          // Get current category index
          final categories = ref.read(topicsProvider.notifier).getCategories();
          final currentIndex = categories.indexOf(
            ref.read(topicsProvider.notifier).selectedCategory
          );
          
          // Prevent completing swipe in invalid directions
          if ((currentIndex == 0 && velocity > 0) || 
              (currentIndex == categories.length - 1 && velocity < 0)) {
            _cancelSwipe();
            return;
          }

          // Determine if we should complete the swipe
          final shouldComplete = velocity.abs() > 300 || _swipeProgress.abs() > 0.5;
          final direction = _swipeProgress > 0 ? -1 : 1;

          if (shouldComplete) {
            _completeSwipe(direction);
          } else {
            _cancelSwipe();
          }
        },
        onHorizontalDragCancel: () {
          _cancelSwipe();
        },
        child: Stack(
          children: [
            _buildTopicsList(),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      baseColor,
                      baseColor,
                      baseColor,
                      baseColor.withAlpha((0.9 * 255).round()),
                      baseColor.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 60,
                    bottom: 0,
                  ),
                  color: baseColor,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ClayText(
                            "Goals",
                            emboss: false,
                            size: 36,
                            parentColor: baseColor,
                            textColor: titleColor.withAlpha((0.8 * 255).round()),
                            color: baseColor,
                            depth: 9,
                            spread: 3,
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Glass Style",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            Switch(
                              value: _useGlassItems,
                              onChanged: (value) {
                                setState(() {
                                  _useGlassItems = value;
                                });
                              },
                              activeColor: Colors.white70,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    color: baseColor,
                    child: ListView(
                      controller: _categoriesScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      children: ref.read(topicsProvider.notifier).getCategories().map((category) {
                        final isSelected =
                            category == ref.read(topicsProvider.notifier).selectedCategory;
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: ClayButton(
                            text: ref.read(topicsProvider.notifier).getDisplayCategory(category),
                            color: isSelected && category != 'All'
                                ? AppColors.flat(AppColors.getColorName(
                                    category.toLowerCase()))
                                : baseColor,
                            parentColor: baseColor,
                            variant: isSelected
                                ? ClayButtonVariant.outlined
                                : ClayButtonVariant.text,
                            size: ClayButtonSize.xsmall,
                            textColor: Colors.white,
                            spread: isSelected ? 3 : 2,
                            depth: isSelected ? 10 : 6,
                            curveType:
                                isSelected ? CurveType.convex : CurveType.concave,
                            onPressed: () {
                              // Directly update the category in the provider
                              ref.read(topicsProvider.notifier).setCategory(category);
                              
                              // Scroll to the correct category button
                              final categories = ref.read(topicsProvider.notifier).getCategories();
                              _scrollToCategory(categories.indexOf(category));
                            },
                            padding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            width: 120,
                            height: 34,
                            borderRadius: 17,
                            emboss: isSelected,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  void _completeSwipe(int direction) async {
    if (_isAnimating) return;
    _isAnimating = true;

    final categories = ref.read(topicsProvider.notifier).getCategories();
    final currentCategory = ref.read(topicsProvider.notifier).selectedCategory;
    final currentIndex = categories.indexOf(currentCategory);
    final nextIndex = currentIndex + direction;

    if (nextIndex >= 0 && nextIndex < categories.length) {
      setState(() {
        ref.read(topicsProvider.notifier).setCategory(categories[nextIndex]);
      });
      
      await _swipeController.animateTo(
        direction > 0 ? 1.0 : -1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      
      setState(() {
        _swipeProgress = 0;
      });
      
      _scrollToCategory(nextIndex);
    }
    
    _isAnimating = false;
  }

  void _cancelSwipe() async {
    if (_isAnimating) return;
    _isAnimating = true;

    await _swipeController.animateTo(
      0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    
    setState(() {
      _swipeProgress = 0;
    });
    
    _isAnimating = false;
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _categoriesScrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
