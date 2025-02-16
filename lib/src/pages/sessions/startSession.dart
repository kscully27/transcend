import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/pages/sessions/inductions.dart';
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/pages/sessions/previous_intentions.dart';

class Sheet extends ConsumerStatefulWidget {
  const Sheet({super.key});

  @override
  ConsumerState<Sheet> createState() => _SheetState();
}

class _SheetState extends ConsumerState<Sheet> with TickerProviderStateMixin {
  // The three possible views
  static const int INITIAL_VIEW = 0;
  static const int CUSTOM_INPUT_VIEW = 1;
  static const int PREVIOUS_INTENTIONS_VIEW = 2;
  static const int MODALITIES_VIEW = 3;

  int currentView = INITIAL_VIEW;
  session.TranceMethod? selectedMethod;
  String? customIntention;
  bool isAnimatingOut = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _controller;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      setState(() {
        selectedMethod = null;
        _selectedIndex = null;
        _controller.reset();
      });
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectMethod(session.TranceMethod method, int index) {
    if (_selectedIndex != null) return;

    setState(() {
      selectedMethod = method;
      _selectedIndex = index;
    });

    _controller.forward().then((_) {
      if (mounted) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TopicSelectionPage(
        //       tranceMethod: selectedMethod!,
        //       intention: "",
        //     ),
        //   ),
        // ).then((_) {
        //   if (mounted) {
        //     setState(() {
        //       selectedMethod = null;
        //       _selectedIndex = null;
        //       _controller.reset();
        //     });
        //   }
        // });
      }
    });
  }

  void _onIntentionSelected(String intention) {
    setState(() {
      if (intention.isEmpty) {
        final selectedType = ref.read(intentionSelectionProvider).type;
        if (selectedType == IntentionSelectionType.previous) {
          currentView = PREVIOUS_INTENTIONS_VIEW;
        } else {
          currentView = CUSTOM_INPUT_VIEW;
        }
      } else {
        customIntention = intention;
        currentView = MODALITIES_VIEW;
        _selectedIndex = null;
        _controller.reset();
      }
    });
  }

  void _onGoalsSelected(Set<String> goals) {
    setState(() {
      if (goals.isNotEmpty) {
        currentView = MODALITIES_VIEW;
        customIntention = "";
        _selectedIndex = null;
        _controller.reset();
        ref.read(intentionSelectionProvider.notifier).setSelectedGoals(goals);
      }
    });
  }

  void _handleBack() {
    setState(() {
      if (currentView == MODALITIES_VIEW) {
        final selectedType = ref.read(intentionSelectionProvider).type;
        switch (selectedType) {
          case IntentionSelectionType.custom:
            currentView = CUSTOM_INPUT_VIEW;
            break;
          case IntentionSelectionType.previous:
            currentView = PREVIOUS_INTENTIONS_VIEW;
            break;
          case IntentionSelectionType.goals:
          case IntentionSelectionType.default_intention:
          case IntentionSelectionType.none:
            currentView = INITIAL_VIEW;
            break;
        }
        selectedMethod = null;
        _selectedIndex = null;
        _controller.reset();
      } else if (currentView == CUSTOM_INPUT_VIEW ||
          currentView == PREVIOUS_INTENTIONS_VIEW) {
        currentView = INITIAL_VIEW;
        customIntention = null;
        _selectedIndex = null;
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reset animation when returning to modalities view
    if (currentView == MODALITIES_VIEW && _selectedIndex == null) {
      _controller.reset();
    }

    final theme = Theme.of(context);
    final intentionState = ref.watch(intentionSelectionProvider);

    return Transform.translate(
      offset: const Offset(0, 0),
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tween: Tween(
              begin: currentView != INITIAL_VIEW ? 0.6 : 0.5,
              end: currentView != INITIAL_VIEW ? 0.9 : 0.8,
            ),
            builder: (context, value, child) {
              return DraggableScrollableSheet(
                minChildSize: currentView != INITIAL_VIEW ? 0.6 : 0.5,
                initialChildSize: value,
                maxChildSize: 0.9,
                builder: (context, controller) {
                  return Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 120),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            border: Border.all(
                              color: Colors.white24,
                              width: 0.5,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height+120,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
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
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
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
                                        ? Inductions(
                                            controller: _controller,
                                            selectedMethod: selectedMethod,
                                            selectedIndex: _selectedIndex,
                                            onBack: _handleBack,
                                            onSelectMethod: _selectMethod,
                                          )
                                        : currentView == PREVIOUS_INTENTIONS_VIEW
                                            ? PreviousIntentions(
                                                onBack: _handleBack,
                                                onIntentionSelected:
                                                    _onIntentionSelected,
                                              )
                                            : IntentionContent(
                                                tranceMethod: selectedMethod ??
                                                    session.TranceMethod.values
                                                        .first,
                                                onBack: _handleBack,
                                                onContinue: _onIntentionSelected,
                                                selectedGoalIds: intentionState
                                                    .selectedGoalIds,
                                                onGoalsSelected: _onGoalsSelected,
                                                initialCustomIntention:
                                                    customIntention,
                                                isCustomMode: currentView ==
                                                    CUSTOM_INPUT_VIEW,
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
