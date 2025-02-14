import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/pages/custom_intention_page.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/pages/topic_selection_page.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/topics/bottomsheet_topics_list.dart';
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
  // The three possible views
  static const int INITIAL_VIEW = 0;
  static const int CUSTOM_INPUT_VIEW = 1;
  static const int MODALITIES_VIEW = 2;

  int currentView = INITIAL_VIEW;
  session.TranceMethod? selectedMethod;
  String? customIntention;
  Set<String> selectedGoalIds = {};
  bool isAnimatingOut = false;

  void _selectMethod(session.TranceMethod method) {
    setState(() {
      selectedMethod = method;
    });
  }

  void _onIntentionSelected(String intention) {
    setState(() {
      if (intention.isEmpty) {
        // Show custom input view
        currentView = CUSTOM_INPUT_VIEW;
      } else {
        // User entered text and clicked continue
        customIntention = intention;
        currentView = MODALITIES_VIEW;
      }
    });
  }

  void _onGoalsSelected(Set<String> goals) {
    setState(() {
      selectedGoalIds = goals;
      if (goals.isNotEmpty) {
        currentView = MODALITIES_VIEW;
        customIntention = ""; // Set empty string to indicate goal-based selection
      }
    });
  }

  void _handleBack() {
    setState(() {
      if (currentView == MODALITIES_VIEW) {
        if (customIntention?.isNotEmpty == true) {
          // If we came from custom intention, go back to it
          currentView = CUSTOM_INPUT_VIEW;
        } else {
          // If we came from goals, go back to initial view
          currentView = INITIAL_VIEW;
          selectedGoalIds.clear();
        }
        selectedMethod = null;
      } else if (currentView == CUSTOM_INPUT_VIEW) {
        currentView = INITIAL_VIEW;
        customIntention = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      tween: Tween(
        begin: currentView != INITIAL_VIEW ? 0.7 : 0.6,
        end: currentView != INITIAL_VIEW ? 0.9 : 0.8,
      ),
      builder: (context, value, child) {
        return DraggableScrollableSheet(
          minChildSize: currentView != INITIAL_VIEW ? 0.7 : 0.6,
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
                          Expanded(
                            child: currentView == MODALITIES_VIEW
                                ? _buildModalities()
                                : IntentionContent(
                                    tranceMethod: selectedMethod ?? session.TranceMethod.values.first,
                                    onBack: _handleBack,
                                    onContinue: _onIntentionSelected,
                                    selectedGoalIds: selectedGoalIds,
                                    onGoalsSelected: _onGoalsSelected,
                                    initialCustomIntention: customIntention,
                                    isCustomMode: currentView == CUSTOM_INPUT_VIEW,
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

  Widget _buildModalities() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          children: [
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
                onPressed: _handleBack,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48.0,
                  vertical: 16.0,
                ),
                child: Text(
                  'Select a Modality',
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
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: session.TranceMethod.values.length,
            itemBuilder: (context, index) {
              final method = session.TranceMethod.values[index];
              final delay = Duration(milliseconds: 100 * index);

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                tween: Tween(
                  begin: 1.0,
                  end: 0.0,
                ),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value * 100, 0),
                    child: Opacity(
                      opacity: 1 - value,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: Colors.white12,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            isAnimatingOut = true;
                          });
                          
                          Future.delayed(const Duration(milliseconds: 200), () {
                            _selectMethod(method);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TopicSelectionPage(
                                  tranceMethod: method,
                                  intention: customIntention!,
                                ),
                              ),
                            );
                          });
                        },
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
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class IntentionContent extends StatefulWidget {
  final session.TranceMethod tranceMethod;
  final VoidCallback onBack;
  final Function(String intention) onContinue;
  final Set<String> selectedGoalIds;
  final Function(Set<String> goals) onGoalsSelected;
  final String? initialCustomIntention;
  final bool isCustomMode;

  const IntentionContent({
    super.key,
    required this.tranceMethod,
    required this.onBack,
    required this.onContinue,
    required this.selectedGoalIds,
    required this.onGoalsSelected,
    required this.initialCustomIntention,
    required this.isCustomMode,
  });

  @override
  State<IntentionContent> createState() => _IntentionContentState();
}

class _IntentionContentState extends State<IntentionContent>
    with SingleTickerProviderStateMixin {
  late Set<String> _selectedGoalIds;
  final TextEditingController _intentionController = TextEditingController();
  bool _showError = false;
  String? _errorMessage;
  final int _minCharacters = 10;
  late bool isCustomMode;
  String? customIntention;
  late AnimationController _placeholderAnimationController;
  late Animation<double> _placeholderOpacity;
  
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
    _selectedGoalIds = widget.selectedGoalIds;
    isCustomMode = widget.isCustomMode;
    customIntention = widget.initialCustomIntention;
    
    if (isCustomMode && widget.initialCustomIntention != null) {
      _intentionController.text = widget.initialCustomIntention!;
    }
    
    _placeholderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _placeholderOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _placeholderAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation after a longer delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _placeholderAnimationController.forward();
      }
    });

    _intentionController.addListener(() {
      if (_showError) {
        setState(() {
          _showError = false;
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _intentionController.dispose();
    _placeholderAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IntentionContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Re-run placeholder animation when switching to custom mode
    if (widget.isCustomMode && !oldWidget.isCustomMode) {
      _placeholderAnimationController.reset();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _placeholderAnimationController.forward();
        }
      });
    }
  }

  void _showGoalSelectionSheet() {
    final tempSelectedGoals = Set<String>.from(_selectedGoalIds);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceTint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                    Text(
                      'Goals',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (mounted) {
                          _selectedGoalIds = Set.from(tempSelectedGoals);
                          widget.onGoalsSelected(_selectedGoalIds);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BottomSheetTopicsListView(
                  selectedGoalIds: tempSelectedGoals,
                  onSelectionChanged: (String topicId, bool isSelected) {
                    setModalState(() {
                      if (isSelected) {
                        tempSelectedGoals.add(topicId);
                      } else {
                        tempSelectedGoals.remove(topicId);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomIntention() {
    setState(() {
      isCustomMode = true;
    });
    _placeholderAnimationController.forward();
    widget.onContinue("");
  }

  void _validateAndContinue() {
    final text = _intentionController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please describe your intention';
      });
      return;
    }
    
    if (text.length < _minCharacters) {
      setState(() {
        _showError = true;
        _errorMessage = 'Your intention should be at least $_minCharacters characters long to ensure it\'s specific enough';
      });
      return;
    }

    widget.onContinue(text);
  }

  void _handleBack() {
    setState(() {
      isCustomMode = false;
      _intentionController.clear();
    });
    _placeholderAnimationController.reset();
    widget.onBack();
  }

  String get _getGoalButtonText {
    if (_selectedGoalIds.isEmpty) {
      return "Select a Goal";
    }
    final count = _selectedGoalIds.length;
    return "$count Goal${count > 1 ? 's' : ''} Selected";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLength = _intentionController.text.trim().length;

    if (widget.isCustomMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.shadow,
                    size: 20,
                  ),
                  onPressed: _handleBack,
                ),
                Text(
                  'Create Your Intention',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
          ),
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
                    border: _showError 
                      ? Border.all(color: Colors.red.withOpacity(0.7), width: 1.5)
                      : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FadeTransition(
                          opacity: _placeholderOpacity,
                          child: TextField(
                            controller: _intentionController,
                            maxLines: 5,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            onSubmitted: (_) => FocusScope.of(context).unfocus(),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: _placeholders[
                                  DateTime.now().microsecond % _placeholders.length],
                              hintStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                          child: currentLength >= _minCharacters
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green.shade800,
                                size: 26,
                              )
                            : Text(
                                '$currentLength/$_minCharacters characters',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: _errorMessage != null ? 4.0 : 20.0,
              bottom: 110.0,
            ),
            child: GlassContainer(
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
                onTap: _validateAndContinue,
              ),
            ),
          ),
        ],
      );
    }

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
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 32),
                GlassContainer(
                  margin: const EdgeInsets.only(bottom: 12),
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white12,
                  child: ListTile(
                    title: Text(
                      _getGoalButtonText,
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      _selectedGoalIds.isEmpty
                          ? Icons.arrow_forward_ios
                          : Icons.check_circle_rounded,
                      color: _selectedGoalIds.isEmpty
                          ? theme.colorScheme.shadow.withOpacity(0.7)
                          : Colors.green.shade800,
                      size: 20,
                    ),
                    onTap: _showGoalSelectionSheet,
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
                      "Create Your Own",
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
                    onTap: _showCustomIntention,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
