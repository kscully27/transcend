import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/providers/topics_provider.dart';
import 'package:trancend/src/topics/candy_select_item.dart';
import 'package:trancend/src/ui/clay/clay_button.dart';

double firstDepth = 15;
double secondDepth = 10;
double thirdDepth = 50;
double fourthDepth = 50;

class BottomSheetTopicsListView extends ConsumerStatefulWidget {
  final Set<String> selectedGoalIds;
  final Function(String, bool) onSelectionChanged;
  final Function(Set<String>) onGoalsSelected;

  const BottomSheetTopicsListView({
    super.key,
    required this.selectedGoalIds,
    required this.onSelectionChanged,
    required this.onGoalsSelected,
  });

  static const routeName = '/';

  @override
  ConsumerState<BottomSheetTopicsListView> createState() =>
      _BottomSheetTopicsListViewState();
}

class _BottomSheetTopicsListViewState
    extends ConsumerState<BottomSheetTopicsListView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoriesScrollController = ScrollController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Listen to page scroll changes
    _pageController.addListener(() {
      // Calculate the current page from the scroll position
      final page = _pageController.page;
      if (page != null) {
        // Calculate target scroll position based on current page
        final buttonWidth = 100.0; // Match the width in the Container
        final buttonMargin = 8.0; // Total horizontal margins (4 + 4)
        final sectionWidth = buttonWidth + buttonMargin;
        final targetScroll = sectionWidth * page;

        // Update category scroll position
        _categoriesScrollController.jumpTo(targetScroll.clamp(
            0.0, _categoriesScrollController.position.maxScrollExtent));
      }
    });

    // Initialize providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider);
      ref.read(topicsProvider);
    });
  }

  Widget _buildTopicsList() {
    final topicsAsync = ref.watch(topicsProvider);

    return topicsAsync.when(
      data: (topics) {
        final categories = ref.read(topicsProvider.notifier).getCategories();
        final selectedCategory =
            ref.watch(topicsProvider.notifier).selectedCategory;

        return PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // Only update the selected category
            ref
                .read(topicsProvider.notifier)
                .setSelectedCategory(categories[index]);
          },
          children: categories.map((category) {
            final filteredTopics = topics
                .where((t) => category == 'All' || t.group == category)
                .toList();

            if (filteredTopics.isEmpty) {
              return Center(
                child: Text(
                  'No topics found for $category',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.builder(
              key: ValueKey<String>(category),
              controller: _scrollController,
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 0.0,
                bottom: 96.0,
              ),
              itemCount: filteredTopics.length,
              itemBuilder: (context, index) {
                final topic = filteredTopics[index];
                return CandySelectItem(
                  topic: topic,
                  isSelected: widget.selectedGoalIds.contains(topic.id),
                  onSelectPressed: () {
                    final newIsSelected = !widget.selectedGoalIds.contains(topic.id);
                    widget.onSelectionChanged(topic.id, newIsSelected);
                  },
                  onTap: () {
                    final newIsSelected = !widget.selectedGoalIds.contains(topic.id);
                    widget.onSelectionChanged(topic.id, newIsSelected);
                  },
                );
              },
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading topics: $error',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  void _onCategorySelected(String category) {
    final categories = ref.read(topicsProvider.notifier).getCategories();
    final index = categories.indexOf(category);
    if (index != -1) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return user.when(
      data: (user) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surfaceTint,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView(
                    controller: _categoriesScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: ref
                        .read(topicsProvider.notifier)
                        .getCategories()
                        .map((category) {
                      final isSelected = category ==
                          ref.read(topicsProvider.notifier).selectedCategory;
                      return Container(
                        margin: const EdgeInsets.only(
                          left: 4,
                          top: 8,
                          bottom: 8,
                          right: 4,
                        ),
                        width: 120,
                        child: ClayButton(
                          color: isSelected
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.surfaceTint,
                          parentColor: Theme.of(context).colorScheme.surfaceTint,
                          borderRadius: 17,
                          borderWidth: .5,
                          borderColor: Colors.white24,
                          text: ref
                              .read(topicsProvider.notifier)
                              .getDisplayCategory(category),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textColor: Colors.white,
                          onPressed: () => _onCategorySelected(category),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.selectedGoalIds.isNotEmpty ? 120 : 0,
                    ),
                    child: _buildTopicsList(),
                  ),
                ),
              ],
            ),
          ),
          if (widget.selectedGoalIds.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ClayButton(
                  color: Colors.white,
                  parentColor: Theme.of(context).colorScheme.surface,
                  borderRadius: 12,
                  borderWidth: .5,
                  borderColor: Colors.white24,
                  text: 'Next',
                  textColor: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  onPressed: () {
                    if (mounted) {
                      widget.onSelectionChanged("", false); // Trigger parent update
                      widget.onGoalsSelected(widget.selectedGoalIds);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _categoriesScrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
