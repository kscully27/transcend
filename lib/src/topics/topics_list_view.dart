import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/providers/topics_provider.dart';
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

class TopicsListView extends StatefulWidget {
  const TopicsListView({super.key});

  static const routeName = '/';

  @override
  State<TopicsListView> createState() => _TopicsListViewState();
}

class _TopicsListViewState extends State<TopicsListView> with SingleTickerProviderStateMixin {
  final TopicsProvider _topicsProvider = locator<TopicsProvider>();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoriesScrollController = ScrollController();
  late AnimationController _slideController;
  List<Topic> _topics = [];
  List<String> _categories = [];
  int _slideDirection = 1;
  String _previousCategory = 'All';
  bool _hasAnimation = true;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final topics = await _topicsProvider.getTopics();
    setState(() {
      _topics = _topicsProvider.getFilteredTopics();
      _categories = _topicsProvider.getCategories();
      _hasAnimation = true;
    });
    
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _hasAnimation = false;
        });
      }
    });
  }

  void _onCategoryChange(int direction) {
    final currentIndex = _categories.indexOf(_topicsProvider.selectedCategory);
    final nextIndex = currentIndex + direction;
    
    if (nextIndex >= 0 && nextIndex < _categories.length) {
      setState(() {
        _slideDirection = direction;
        _topicsProvider.setCategory(_categories[nextIndex]);
        _topics = _topicsProvider.getFilteredTopics();
      });
      
      Future.delayed(Duration(milliseconds: 500), () {
        _scrollToCategory(nextIndex);
      });
    }
  }

  void _scrollToCategory(int index) {
    final buttonWidth = 120.0;
    final padding = 4.0;
    final targetScroll = (buttonWidth + (padding * 2)) * index;
    
    _categoriesScrollController.animateTo(
      targetScroll.clamp(
        0.0,
        _categoriesScrollController.position.maxScrollExtent
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onCategorySelected(String category) {
    final oldIndex = _categories.indexOf(_topicsProvider.selectedCategory);
    final newIndex = _categories.indexOf(category);
    setState(() {
      _slideDirection = newIndex > oldIndex ? 1 : -1;
      _previousCategory = _topicsProvider.selectedCategory;
      _topicsProvider.setCategory(category);
      _topics = _topicsProvider.getFilteredTopics();
      _hasAnimation = true;
    });
    
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollToCategory(newIndex);
    });

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _hasAnimation = false;
        });
      }
    });
  }

  Widget _buildTopicsList() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween(
            begin: Offset(-_slideDirection.toDouble(), 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.0, 1.0,
              curve: Curves.easeOutCubic,
            ),
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.3, 1.0,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          ),
        );
      },
      child: ListView.builder(
        key: ValueKey<String>(_topicsProvider.selectedCategory),
        controller: _scrollController,
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 120.0,
          bottom: 96.0
        ),
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return TopicItem(
            topic: topic,
            index: index,
            shouldAnimate: _hasAnimation,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! > 0) {
          _onCategoryChange(-1);  // Swipe right
        } else if (details.primaryVelocity! < 0) {
          _onCategoryChange(1);   // Swipe left
        }
      },
      child: Stack(
        children: [
          _buildTopicsList(),
          Positioned(
            top: 40,
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
                height: 60,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 0,
                ),
                color: baseColor,
                child: Align(
                  alignment: Alignment.bottomLeft,
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
                    children: _categories.map((category) {
                      final isSelected = category == _topicsProvider.selectedCategory;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: ClayButton(
                          text: category,
                          color: baseColor,
                          parentColor: baseColor,
                          variant: isSelected ? ClayButtonVariant.outlined : ClayButtonVariant.text,
                          size: ClayButtonSize.xsmall,
                          textColor: Colors.white,
                          spread: isSelected ? 3 : 2,
                          depth: isSelected ? 20 : 20,
                          curveType: isSelected ? CurveType.convex : CurveType.concave,
                          onPressed: () => _onCategorySelected(category),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  @override
  void dispose() {
    _categoriesScrollController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
