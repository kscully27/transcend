import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/pages/intention_page.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/pages/topic_selection_page.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/topics/topics_list_view.dart';
import 'package:trancend/src/ui/clay_bottom_nav/clay_bottom_nav.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    var theme = Theme.of(context);

    return appState.when(
      data: (data) {
        if (!data.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          extendBody: true,
          backgroundColor: theme.colorScheme.surface,
          body: Container(
            decoration: AppColors.enableGradients
                ? BoxDecoration(
                    gradient: AppColors.marsBackgroundGradient(context),
                  )
                : null,
            child: _index == 0
                ? data.topics.when(
                    data: (topics) => TopicsListView(),
                    loading: () => Material(
                      color: theme.colorScheme.onSurface,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stack) =>
                        Center(child: Text('Error loading topics: $error')),
                  )
                : const SettingsPage(),
          ),
          bottomNavigationBar: ClayBottomNavNSheet(
            backgroundColor: theme.colorScheme.surface,
            emboss: false,
            parentColor: theme.colorScheme.surface,
            selectedItemColor: theme.colorScheme.onSurface,
            unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
            sheetOpenIconBoxColor: theme.colorScheme.primary,
            sheetOpenIconColor: theme.colorScheme.onPrimary,
            sheetCloseIconBoxColor: theme.colorScheme.surface,
            sheetCloseIconColor: theme.colorScheme.onSurfaceVariant,
            initialSelectedIndex: _index,
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
            sheet: const Sheet(),
            sheetOpenIcon: Remix.play_large_line,
            sheetCloseIcon: Remix.add_line,
            onSheetToggle: (v) {
              setState(() {});
            },
            items: [
              ClayBottomNavItem(
                activeIcon: Remix.home_6_fill,
                icon: Remix.home_6_line,
              ),
              ClayBottomNavItem(
                icon: Remix.user_3_line,
                activeIcon: Remix.user_3_fill,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class Sheet extends ConsumerStatefulWidget {
  const Sheet({super.key});

  @override
  ConsumerState<Sheet> createState() => _SheetState();
}

class _SheetState extends ConsumerState<Sheet> {
  session.TranceMethod? selectedMethod;
  session.TranceMethod? animatingMethod;
  bool isAnimatingOut = false;

  void _selectMethod(session.TranceMethod method) {
    setState(() {
      animatingMethod = method;
      isAnimatingOut = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          selectedMethod = method;
          isAnimatingOut = false;
        });
      }
    });
  }

  Widget _buildModalities() {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: session.TranceMethod.values.length,
      itemBuilder: (context, index) {
        final method = session.TranceMethod.values[index];
        
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          tween: Tween(
            begin: 0.0,
            end: isAnimatingOut ? 1.0 : 0.0,
          ),
          builder: (context, value, child) {
            final slideOffset = method == animatingMethod ? 
              value * -200.0 : // Selected button slides left
              value * -400.0;  // Other buttons slide left faster
            
            final opacity = method == animatingMethod ?
              (1.0 - value).clamp(0.0, 1.0) : // Selected button fades out
              (1.0 - (value * 2.0)).clamp(0.0, 1.0); // Other buttons fade out faster

            return Transform.translate(
              offset: Offset(slideOffset, 0),
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.white12,
              child: ListTile(
                title: Text(
                  method.name,
                  style: TextStyle(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.shadow.withOpacity(0.7),
                  size: 20,
                ),
                onTap: isAnimatingOut ? null : () => _selectMethod(method),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      tween: Tween(
        begin: selectedMethod != null ? 0.7 : 0.6,
        end: selectedMethod != null ? 0.9 : 0.8,
      ),
      builder: (context, value, child) {
        return DraggableScrollableSheet(
          minChildSize: selectedMethod != null ? 0.7 : 0.6,
          initialChildSize: value,
          maxChildSize: 0.9,
          builder: (context, controller) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border.all(
                      color: Colors.white24,
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20.0,
                        sigmaY: 20.0,
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.25,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
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
                              if (selectedMethod != null)
                                Positioned(
                                  left: 4,
                                  top: 8,
                                  bottom: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: theme.colorScheme.shadow.withOpacity(0.7),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedMethod = null;
                                        animatingMethod = null;
                                        isAnimatingOut = false;
                                      });
                                    },
                                  ),
                                ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: selectedMethod != null ? 48.0 : 0.0,
                                    right: selectedMethod != null ? 48.0 : 0.0,
                                    top: 16.0,
                                    bottom: 16.0,
                                  ),
                                  child: Text(
                                    selectedMethod != null ? 'Outline Your Intention' : 'Select a Modality',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.shadow,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: selectedMethod == null
                              ? _buildModalities()
                              : IntentionContent(
                                  tranceMethod: selectedMethod!,
                                  onBack: () {
                                    setState(() {
                                      selectedMethod = null;
                                      animatingMethod = null;
                                      isAnimatingOut = false;
                                    });
                                  },
                                  onContinue: (intention) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TopicSelectionPage(
                                          tranceMethod: selectedMethod!,
                                          intention: intention,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class IntentionContent extends StatefulWidget {
  final session.TranceMethod tranceMethod;
  final VoidCallback onBack;
  final Function(String intention) onContinue;

  const IntentionContent({
    super.key,
    required this.tranceMethod,
    required this.onBack,
    required this.onContinue,
  });

  @override
  State<IntentionContent> createState() => _IntentionContentState();
}

class _IntentionContentState extends State<IntentionContent> {
  final TextEditingController _intentionController = TextEditingController();
  final List<String> _placeholders = [
    "I want to feel more confident in social situations",
    "I want to sleep more deeply and wake up refreshed",
    "I want to develop a positive mindset",
    "I want to overcome my fear of public speaking",
    "I want to increase my focus and productivity",
  ];

  @override
  void initState() {
    super.initState();
    _intentionController.text = '';
  }

  @override
  void dispose() {
    _intentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'What would you like to accomplish today?',
                  style: TextStyle(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GlassContainer(
                  backgroundColor: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _intentionController,
                    maxLines: 3,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: _placeholders[DateTime.now().microsecond % _placeholders.length],
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black12,
                              Colors.black87,
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black87,
                              Colors.black12,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                GlassContainer(
                  margin: const EdgeInsets.only(bottom: 12),
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white12,
                  child: ListTile(
                    title: Text(
                      "Select a Goal",
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: theme.colorScheme.shadow.withOpacity(0.7),
                      size: 20,
                    ),
                    onTap: () {
                      // TODO: Implement goal selection
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GlassContainer(
            margin: const EdgeInsets.only(bottom: 70),
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.white12,
            child: ListTile(
              title: Text(
                "Continue",
                style: TextStyle(
                  color: theme.colorScheme.shadow,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () => widget.onContinue(_intentionController.text),
            ),
          ),
        ),
      ],
    );
  }
}
