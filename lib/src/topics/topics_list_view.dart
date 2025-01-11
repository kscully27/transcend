import 'dart:ui';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/providers/topics_provider.dart';
import 'package:trancend/src/ui/glass_button.dart';
import 'package:trancend/src/ui/glass_icon_button.dart';
import 'package:trancend/src/ui/clay_button.dart';

Color baseColor = const Color(0xFFD59074);
Color baseColor2 = const Color(0xFFC67E60);
Color textColor = const Color(0xFF883912);
Color titleColor = const Color(0xFFFBF3D8);
double firstDepth = 15;
double secondDepth = 10;
double thirdDepth = 50;
double fourthDepth = 50;

class TopicItem extends StatefulWidget {
  const TopicItem({super.key, required this.topic});
  final Topic topic;

  @override
  State<TopicItem> createState() => _TopicItemState();
}

class _TopicItemState extends State<TopicItem> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _opacityController;
  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 0,
    )..addListener(() {
        setState(() {});
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 0,
    )..addListener(() {
        setState(() {});
        if (_animationController.value == 1) {
          _opacityController.forward();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _fullWidth = _width > 70 ? 70 : _width;

    double? stagger(double value, double progress, double delay) {
      var newProgress = progress - (1 - delay);
      if (newProgress < 0) newProgress = 0;
      return value * (newProgress / delay);
    }

    final calculatedFirstDepth =
        stagger(firstDepth, _animationController.value, 0.25)!;

    // final calculatedSecondDepth =
    //     stagger(secondDepth, _animationController.value, 0.5)!;
    final calculatedThirdDepth = stagger(1, _opacityController.value, 0.75)!;
    final calculatedFourthDepth = stagger(1, _opacityController.value, 1)!;

    final topic = widget.topic;

    void _handleButtonPressed(topic) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              margin: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.black26,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.25,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GlassIconButton(
                                icon: Icons.close,
                                iconColor: Colors.black,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(topic.title,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87)),
                                      Text(topic.description,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black)),
                                      SizedBox(height: 12),
                                      GlassButton(
                                        text: "Add to Favorites",
                                        icon: Remix.heart_line,
                                        width: double.infinity,
                                        variant: GlassButtonVariant.text,
                                        size: GlassButtonSize.xsmall,
                                        align: GlassButtonAlign.center,
                                        onPressed: () {
                                          // Add your favorite logic here
                                        },
                                      ),
                                      Divider(
                                        height: 32,
                                        thickness: 1,
                                        color: Colors.black26,
                                      ),
                                      GlassButton(
                                        text: "Start Session",
                                        height: 80,
                                        icon: Remix.play_fill,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 12),
                                        onPressed: () {
                                          // Add your session start logic here
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => _handleButtonPressed(topic),
      child: Container(
          // color: baseColor,
          padding: const EdgeInsets.all(12),
          child: ClayContainer(
            color: baseColor,
            borderRadius: 20,
            height: 120,
            width: 400,
            curveType: CurveType.concave,
            spread: 5,
            depth: calculatedFirstDepth.toInt(),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    opacity: calculatedThirdDepth,
                    duration: _opacityController.duration!,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 180,
                        child: ClayText(topic.title,
                            emboss: true,
                            size: 24,
                            parentColor: baseColor,
                            textColor: Colors.white,
                            // textColor: AppColors.shadow(topic.appColor),
                            color: baseColor,
                            spread: 2,
                            style: TextStyle(fontWeight: FontWeight.w200)),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: calculatedFourthDepth,
                    duration: _opacityController.duration!,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: ClayContainer(
                                  surfaceColor: AppColors.light(topic.appColor),
                                  parentColor: baseColor,
                                  emboss: false,
                                  spread: 8,
                                  depth: 8,
                                  curveType: CurveType.concave,
                                  // surfaceColor: baseColor,
                                  width: 100,
                                  height: double.infinity,
                                  customBorderRadius: BorderRadius.only(
                                    topLeft: Radius.elliptical(0, 0),
                                    bottomLeft: Radius.elliptical(0, 0),
                                    topRight: Radius.elliptical(16, 16),
                                    bottomRight: Radius.elliptical(16, 16),
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 14),
                              child: Center(
                                child: SvgPicture.network(
                                  topic.svg,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                  color: AppColors.flat(topic.appColor),
                                  width: _fullWidth,
                                ),
                              ),
                            ),
                          ])),
                    ),
                  ),
                ]),
          )),
    );
  }
}

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
      
      // Delay the category scroll animation
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
      _topicsProvider.setCategory(category);
      _topics = _topicsProvider.getFilteredTopics();
    });
    
    // Delay the category scroll animation
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollToCategory(newIndex);
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
          return TopicItem(topic: topic);
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
