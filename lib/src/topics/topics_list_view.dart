import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/providers/topics_provider.dart';
import 'package:trancend/src/providers/user_topics_provider.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/topics/candy_topic_item.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

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

class _TopicsListViewState extends ConsumerState<TopicsListView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoriesScrollController = ScrollController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // Initialize both providers
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
        final selectedCategory = ref.watch(topicsProvider.notifier).selectedCategory;
        final selectedIndex = categories.indexOf(selectedCategory);

        return PageView(
          controller: _pageController,
          onPageChanged: (index) {
            ref.read(topicsProvider.notifier).setSelectedCategory(categories[index]);
            _scrollToCategory(index);
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
                top: 200.0,
                bottom: 96.0,
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

                    return CandyTopicItem(
                      topic: topic,
                      isFavorite: favoriteMap[topic.id] ?? false,
                      onFavoritePressed: () => _toggleFavorite(topic.id),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text(
                      'Error loading user topics: $error',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
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

  void _toggleFavorite(String topicId) async {
    final user = ref.read(userProvider).value;
    if (user == null) {
      _showLoginPrompt();
      return;
    }

    try {
      final firestoreService = locator<FirestoreService>();
      await firestoreService.toggleTopicFavorite(user.uid, topicId);
      ref.invalidate(userTopicsProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating favorite: ${e.toString()}')));
      debugPrint('Error toggling favorite: $e');
    }
  }

  void _showLoginPrompt() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign in Required',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You need to sign in to save your favorite topics and track your progress.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GlassButton(
                    text: 'Not Now',
                    onPressed: () => Navigator.pop(context),
                    glassColor: Colors.white12,
                    textColor: Colors.white70,
                  ),
                  GlassButton(
                    text: 'Sign In',
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to sign in page
                      // Navigator.pushNamed(context, '/signin');
                    },
                    glassColor: Colors.white24,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToCategory(int index) {
    if (!_categoriesScrollController.hasClients) return;
    
    final buttonWidth = 120.0;  // Approximate width of each button
    final padding = 4.0;  // Left margin of each button
    final screenPadding = 12.0; // The horizontal padding of the ListView
    
    // Calculate the target scroll position by multiplying the index by the button width and padding
    // Then subtract the screen padding to align with the left edge
    final targetScroll = (buttonWidth + padding) * index - screenPadding;

    _categoriesScrollController.animateTo(
      targetScroll.clamp(0.0, _categoriesScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
      _scrollToCategory(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final theme = Theme.of(context);

    return user.when(
      data: (user) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surfaceTint,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildTopicsList(),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GlassContainer(
                backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.5),
                fade: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 224, 167, 102).withOpacity(.9),
                    const Color(0xFFF7966E).withOpacity(0),
                  ],
                  stops: const [0.0, 1.0],
                ),
                child: SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 60,
                    bottom: 0,
                  ),
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white24,
                                Colors.white60,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              "Goals",
                              style: GoogleFonts.titilliumWeb(
                                textStyle: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      controller: _categoriesScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                          ),
                          child: GlassButton(
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
                            glassColor: Colors.white12.withOpacity(0.5),
                            textColor: Colors.white,
                            opacity: isSelected ? 0.1 : 0.0,
                            glowColor: Colors.white,
                            glowAmount:
                                isSelected ? GlowAmount.heavy : GlowAmount.light,
                            hasDivider: true,
                            size: GlassButtonSize.xsmall,
                            onPressed: () => _onCategorySelected(category),
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

  @override
  void dispose() {
    _pageController.dispose();
    _categoriesScrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
