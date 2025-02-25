import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/providers/modal_sheet_provider.dart';
import 'package:trancend/src/topics/bottomsheet_topics_list.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
  
  final List<String> _placeholders = [
    "I want to feel more confident in social situations",
    "I want to sleep more deeply and wake up refreshed",
    "I want to develop a positive mindset",
    "I want to overcome my fear of public speaking",
    "I want to increase my focus and productivity",
  ];

  late AnimationController _placeholderController;
  late Animation<double> _placeholderOpacity;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedGoalIds = widget.selectedGoalIds;
    isCustomMode = widget.isCustomMode;
    customIntention = widget.initialCustomIntention;
    
    if (isCustomMode && widget.initialCustomIntention != null) {
      _intentionController.text = widget.initialCustomIntention!;
    }

    _intentionController.addListener(() {
      if (_showError) {
        setState(() {
          _showError = false;
          _errorMessage = null;
        });
      }
    });

    _placeholderController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _placeholderOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _placeholderController,
        curve: Curves.easeInOut,
      ),
    );

    _placeholderController.forward();
    
    // Auto-focus the text field when in custom mode
    if (isCustomMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
    }
  }

  @override
  void dispose() {
    _intentionController.dispose();
    _placeholderController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleIntentionSelection(IntentionSelectionType type) {
    if (type == IntentionSelectionType.custom && widget.isCustomMode) {
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

    switch (type) {
      case IntentionSelectionType.default_intention:
        widget.onContinue("I want to feel more relaxed and at peace");
        break;

      case IntentionSelectionType.custom:
        final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
        pageIndexNotifier.value = 1; // Index of CustomIntentionPage
        break;

      case IntentionSelectionType.previous:
        final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
        pageIndexNotifier.value = 2; // Index of PreviousIntentionsPage
        break;

      case IntentionSelectionType.goals:
        // Show the BottomSheetTopicsList
        _showTopicsBottomSheet(context);
        break;

      case IntentionSelectionType.none:
        // No action needed; handle "none" gracefully.
        break;
    }
  }

  void _showTopicsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: BottomSheetTopicsListView(
            selectedGoalIds: _selectedGoalIds,
            onSelectionChanged: (id, isSelected) {
              // Since we only want to allow one selection, clear previous selections
              if (isSelected) {
                setState(() {
                  _selectedGoalIds = {id};
                });
                
                // Update the provider
                ref.read(intentionSelectionProvider.notifier).setSelectedGoals({id});
                ref.read(intentionSelectionProvider.notifier).setSelection(IntentionSelectionType.goals);
              }
            },
            onGoalsSelected: (goals) {
              // This is called when the user clicks "Next" in the bottom sheet
              // Update the selected goals and navigate to modality page
              setState(() {
                _selectedGoalIds = goals;
              });
              
              // Update the provider
              ref.read(intentionSelectionProvider.notifier).setSelectedGoals(goals);
              ref.read(intentionSelectionProvider.notifier).setSelection(IntentionSelectionType.goals);
              
              // Navigate to modality page
              widget.onGoalsSelected(goals);
            },
          ),
        );
      },
    );
  }

  Widget _buildIntentionButton({
    required String title,
    required IntentionSelectionType type,
    required VoidCallback onTap,
    required bool isSelected,
    required int index,
  }) {
    final theme = Theme.of(context);
    return GlassContainer(
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
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.shadow.withOpacity(0.7),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLength = _intentionController.text.trim().length;
    final intentionState = ref.watch(intentionSelectionProvider);

    if (widget.isCustomMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FadeTransition(
                  opacity: _placeholderOpacity,
                  child: TextField(
                    controller: _intentionController,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLines: 3,
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
                        vertical: 16,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showError && _errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: _errorMessage != null ? 4.0 : 10.0,
              bottom: 20.0,
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
        SingleChildScrollView(
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