import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/providers/topics_provider.dart';
import 'package:trancend/src/topics/candy_topic_item.dart';
import 'package:trancend/src/topics/topic_item.dart';
import 'package:trancend/src/ui/clay_button.dart';
import 'package:trancend/src/ui/clay_container.dart';
import 'package:trancend/src/ui/clay_text.dart';
import 'package:trancend/src/ui/candy_button.dart';
import 'package:trancend/src/ui/glass_bottom_sheet.dart';
import 'package:trancend/src/trance/trance_player.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/constants/enums.dart' as session;

class TopicsListView extends ConsumerStatefulWidget {
  const TopicsListView({super.key});

  @override
  ConsumerState<TopicsListView> createState() => _TopicsListViewState();
}

class _TopicsListViewState extends ConsumerState<TopicsListView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoriesScrollController = ScrollController();
  bool _useGlassItems = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _categoriesScrollController.dispose();
    super.dispose();
  }

  Widget _buildTopicsList() {
    return Consumer(
      builder: (context, ref, child) {
        final topics = ref.watch(topicsProvider);
        return topics.when(
          data: (topics) {
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 180, 20, 100),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return _useGlassItems
                    ? ClayTopicItem(
                        topic: topic,
                        onTap: () => _handleTopicTap(topic),
                      )
                    : CandyTopicItem(
                        topic: topic,
                        onTap: () => _handleTopicTap(topic),
                      );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error loading topics: $error')),
        );
      },
    );
  }

  void _handleTopicTap(Topic topic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Color.fromARGB(255, 25, 5, 51).withOpacity(.35),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return GlassBottomSheet(
          hasCloseButton: false,
          backgroundColor: const Color(0xFFDF5843).withOpacity(0.15),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFF7966E).withOpacity(0.4),
              blurRadius: 2,
              spreadRadius: 3,
            ),
          ],
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'TitilliumWeb',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Remix.heart_line,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        // TODO: Implement favorite functionality
                      },
                    ),
                  ],
                ),
                Text(
                  topic.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                CandyButton(
                  text: "Start Session",
                  icon: Remix.play_fill,
                  color: Theme.of(context).colorScheme.surfaceTint,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    Future.microtask(() {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              TrancePlayer(
                            topic: topic,
                            tranceMethod: TranceMethod.Hypnotherapy,
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.easeOutCubic;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        _buildTopicsList(),
        // Positioned(
        //   top: 80,
        //   left: 0,
        //   right: 0,
        //   child: Container(
        //     height: 100,
        //   ),
        // ),
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
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Clay Style",
                          style: TextStyle(
                            fontFamily: 'TitilliumWeb',
                            fontWeight: FontWeight.w300,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                          activeColor: theme.colorScheme.primary,
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
                color: Colors.transparent,
                child: ListView(
                  controller: _categoriesScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children:
                      ref.read(topicsProvider.notifier).getCategories().map((category) {
                    final isSelected = category ==
                        ref.read(topicsProvider.notifier).selectedCategory;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      child: ClayButton(
                        text: ref
                            .read(topicsProvider.notifier)
                            .getDisplayCategory(category),
                        color: isSelected && category != 'All'
                            ? AppColors.themedWithContext(
                                context,
                                AppColors.getColorName(category.toLowerCase()),
                                'light',
                                'flat'
                              )
                            : theme.colorScheme.surface,
                        parentColor: theme.colorScheme.surface,
                        variant: isSelected
                            ? ClayButtonVariant.outlined
                            : ClayButtonVariant.text,
                        size: ClayButtonSize.xsmall,
                        textColor: isSelected && category != 'All'
                            ? AppColors.themedWithContext(
                                context,
                                AppColors.getColorName(category.toLowerCase()),
                                'shadow',
                                'highlight'
                              )
                            : theme.colorScheme.onSurface,
                        spread: isSelected ? 3 : 2,
                        depth: isSelected ? 10 : 6,
                        curveType: isSelected ? CurveType.convex : null,
                        onPressed: () {
                          ref
                              .read(topicsProvider.notifier)
                              .setSelectedCategory(category);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
