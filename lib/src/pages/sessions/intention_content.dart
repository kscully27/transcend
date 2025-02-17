import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/topics/bottomsheet_topics_list.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class IntentionContent extends ConsumerStatefulWidget {
  final session.TranceMethod tranceMethod;
  final VoidCallback? onBack;
  final Function(String intention) onContinue;
  final Set<String> selectedGoalIds;
  final Function(Set<String> goals) onGoalsSelected;
  final String? initialCustomIntention;
  final bool isCustomMode;

  const IntentionContent({
    super.key,
    required this.tranceMethod,
    this.onBack,
    required this.onContinue,
    required this.selectedGoalIds,
    required this.onGoalsSelected,
    required this.initialCustomIntention,
    required this.isCustomMode,
  });

  @override
  ConsumerState<IntentionContent> createState() => _IntentionContentState();
}

class _IntentionContentState extends ConsumerState<IntentionContent>
    with TickerProviderStateMixin {
  late Set<String> _selectedGoalIds;
  final TextEditingController _intentionController = TextEditingController();
  bool _showError = false;
  String? _errorMessage;
  final int _minCharacters = 10;
  late bool isCustomMode;
  String? customIntention;
  late AnimationController _controller;
  late AnimationController _placeholderController;
  late Animation<double> _placeholderOpacity;
  IntentionSelectionType? _selectedType;
  
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

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _placeholderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _placeholderOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _placeholderController,
      curve: Curves.easeInOut,
    ));

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
    _controller.dispose();
    _placeholderController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IntentionContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCustomMode && !oldWidget.isCustomMode) {
      _placeholderController.reset();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _placeholderController.forward();
        }
      });
    }
  }

  void _handleIntentionSelection(IntentionSelectionType type) {
    if (widget.isCustomMode) {
      final intention = _intentionController.text.trim();
      if (intention.length < _minCharacters) {
        setState(() {
          _showError = true;
          _errorMessage = "Please enter at least $_minCharacters characters";
        });
        return;
      }
      widget.onContinue(intention);
      return;
    }

    setState(() {
      _selectedType = type;
    });

    _controller.forward().then((_) {
      switch (type) {
        case IntentionSelectionType.goals:
          ref.read(intentionSelectionProvider.notifier).setSelection(type);
          _showGoalSelectionSheet();
          break;
        case IntentionSelectionType.previous:
          ref.read(intentionSelectionProvider.notifier).setSelection(type);
          widget.onContinue("");
          break;
        case IntentionSelectionType.default_intention:
          ref.read(intentionSelectionProvider.notifier).setSelection(type);
          widget.onContinue("I want to feel more relaxed and at peace");
          break;
        case IntentionSelectionType.custom:
          ref.read(intentionSelectionProvider.notifier).setSelection(type);
          _showCustomIntention();
          break;
        default:
          break;
      }
    });
  }

  Widget _buildIntentionButton({
    required String title,
    required IntentionSelectionType type,
    required VoidCallback onTap,
    required bool isSelected,
    required int index,
  }) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t;
        if (isSelected) {
          // Selected item animates last
          t = _controller.value < 0.5 ? 0.0 : (_controller.value - 0.5) * 2;
        } else {
          // Other items animate based on their index
          final itemCount = 4; // Total number of buttons
          final startTime = (index / (itemCount - 1)) * 0.5;
          t = _controller.value < startTime ? 0.0 
              : (_controller.value - startTime) / (0.5 - startTime);
        }
        
        final progress = Curves.easeInOut.transform(t.clamp(0.0, 1.0));
        
        return Transform.translate(
          offset: Offset(-progress * MediaQuery.of(context).size.width, 0),
          child: Opacity(
            opacity: 1 - progress,
            child: child,
          ),
        );
      },
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: 12),
        borderRadius: BorderRadius.circular(12),
        backgroundColor: Colors.white12,
        child: ListTile(
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.shadow.withOpacity(0.7),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : null,
          ),
          title: Text(
            title,
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
          onTap: onTap,
        ),
      ),
    );
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
                      onPressed: () {
                        setState(() {
                          _selectedType = null;
                          _controller.reset();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Intentions',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                        if (tempSelectedGoals.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tempSelectedGoals.length.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
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
                  onGoalsSelected: (goals) {
                    if (mounted) {
                      _selectedGoalIds = Set.from(goals);
                      widget.onGoalsSelected(_selectedGoalIds);
                    }
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
    _controller.forward();
    _placeholderController.reset();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _placeholderController.forward();
      }
    });
    widget.onContinue("");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLength = _intentionController.text.trim().length;
    final intentionState = ref.watch(intentionSelectionProvider);

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
                  onPressed: () {
                    setState(() {
                      _selectedType = null;
                      _controller.reset();
                    });
                    if (widget.onBack != null) {
                      widget.onBack!();
                    }
                  },
                ),
                Text(
                  'Create Your Intention',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w600,
                    fontSize: 20
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
                  // Text(
                  //   'What would you like to accomplish today?',
                  //   style: TextStyle(
                  //     color: theme.colorScheme.shadow,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 32,
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
              bottom: 160.0,
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
                onTap: () => _handleIntentionSelection(IntentionSelectionType.custom),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'What would you like to accomplish today?',
                  style: TextStyle(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 32),
                _buildIntentionButton(
                  title: _getGoalButtonText,
                  type: IntentionSelectionType.goals,
                  isSelected: intentionState.type == IntentionSelectionType.goals,
                  index: 0,
                  onTap: () => _handleIntentionSelection(IntentionSelectionType.goals),
                ),
                _buildIntentionButton(
                  title: "Use Previous Intention",
                  type: IntentionSelectionType.previous,
                  isSelected: intentionState.type == IntentionSelectionType.previous,
                  index: 1,
                  onTap: () => _handleIntentionSelection(IntentionSelectionType.previous),
                ),
                _buildIntentionButton(
                  title: "Use Default Intention",
                  type: IntentionSelectionType.default_intention,
                  isSelected: intentionState.type == IntentionSelectionType.default_intention,
                  index: 2,
                  onTap: () => _handleIntentionSelection(IntentionSelectionType.default_intention),
                ),
                _buildIntentionButton(
                  title: "Create An Intention",
                  type: IntentionSelectionType.custom,
                  isSelected: intentionState.type == IntentionSelectionType.custom,
                  index: 3,
                  onTap: () => _handleIntentionSelection(IntentionSelectionType.custom),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String get _getGoalButtonText {
    if (_selectedGoalIds.isEmpty) {
      return "Select Intentions";
    }
    final count = _selectedGoalIds.length;
    return "$count Intention${count > 1 ? 's' : ''} Selected";
  }
} 