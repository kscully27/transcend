import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/pages/sessions/active.dart';
import 'package:trancend/src/pages/sessions/breathwork.dart';
import 'package:trancend/src/pages/sessions/hypnotherapy.dart';
import 'package:trancend/src/pages/sessions/hypnotherapy_methods.dart';
import 'package:trancend/src/pages/sessions/inductions.dart';
import 'package:trancend/src/pages/sessions/meditation.dart';
import 'package:trancend/src/pages/sessions/previous_intentions.dart';
import 'package:trancend/src/pages/sessions/sleep.dart';
import 'package:trancend/src/pages/sessions/soundscapes.dart';
import 'package:trancend/src/pages/sessions/modality_select.dart';

/// The provider for the sheet controller
final sheetControllerProvider = Provider.autoDispose((ref) => SheetController());

class SheetController {
  session.TranceMethod? selectedMethod;
  String? customIntention;
  AnimationController? _controller;
  int? selectedIndex;
  VoidCallback? onDismiss;

  AnimationController _getController(BuildContext context) {
    _controller ??= AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: Navigator.of(context).overlay!,
    );
    return _controller!;
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  void showSheet(BuildContext context) {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalContext) => [
        WoltModalSheetPage(
          hasSabGradient: false,
          isTopBarLayerAlwaysVisible: true,
          backgroundColor: Colors.white70,
          surfaceTintColor: Colors.white,
          hasTopBarLayer: false,
          child: Consumer(
            builder: (context, ref, _) {
              final intentionState = ref.watch(intentionSelectionProvider);
              return IntentionContent(
                tranceMethod: selectedMethod ?? session.TranceMethod.values.first,
                onBack: null,
                onContinue: (intention) => _onIntentionSelected(context, ref, intention),
                selectedGoalIds: intentionState.selectedGoalIds,
                onGoalsSelected: (goals) => _onGoalsSelected(context, ref, goals),
                initialCustomIntention: customIntention,
                isCustomMode: false,
              );
            }
          ),
        ),
      ],
      modalTypeBuilder: (context) => const WoltBottomSheetType(),
      onModalDismissedWithBarrierTap: () {
        Navigator.of(context).pop();
        onDismiss?.call();
      },
      onModalDismissedWithDrag: () {
        Navigator.of(context).pop();
        onDismiss?.call();
      },
      modalBarrierColor: Colors.transparent,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      barrierDismissible: true,
      modalDecorator: (child) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: Colors.white24,
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, WoltModalSheetPage page) {
    WoltModalSheet.of(context).pushPage(page);
  }

  Future<void> _onIntentionSelected(BuildContext context, WidgetRef ref, String intention) async {
    if (intention.isNotEmpty) {
      customIntention = intention;
      _navigateToPage(context, WoltModalSheetPage(
        hasSabGradient: false,
        isTopBarLayerAlwaysVisible: true,
        backgroundColor: Colors.white70,
        surfaceTintColor: Colors.white,
        hasTopBarLayer: false,
        child: ModalitySelect(
          selectedMethod: selectedIndex == null ? null : selectedMethod,
          selectedIndex: selectedIndex,
          onBack: WoltModalSheet.of(context).showPrevious,
          onSelectMethod: (method, index) => _selectMethod(context, ref, method, index),
        ),
      ));
      return;
    }

    final selectedType = ref.read(intentionSelectionProvider).type;
    if (selectedType == IntentionSelectionType.previous) {
      _navigateToPage(context, WoltModalSheetPage(
        hasSabGradient: false,
        isTopBarLayerAlwaysVisible: true,
        backgroundColor: Colors.transparent,
        hasTopBarLayer: true,
        topBarTitle: const Text('Previous Intentions'),
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(16),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: WoltModalSheet.of(context).showPrevious,
        ),
        child: PreviousIntentions(
          onBack: WoltModalSheet.of(context).showPrevious,
          onIntentionSelected: (intention) => _onIntentionSelected(context, ref, intention),
        ),
      ));
    } else {
      _navigateToPage(context, WoltModalSheetPage(
        hasSabGradient: false,
        isTopBarLayerAlwaysVisible: true,
        backgroundColor: Colors.transparent,
        hasTopBarLayer: true,
        topBarTitle: const Text('Create Intention'),
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(16),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: WoltModalSheet.of(context).showPrevious,
        ),
        child: IntentionContent(
          tranceMethod: selectedMethod ?? session.TranceMethod.values.first,
          onBack: WoltModalSheet.of(context).showPrevious,
          onContinue: (intention) => _onIntentionSelected(context, ref, intention),
          selectedGoalIds: ref.read(intentionSelectionProvider).selectedGoalIds,
          onGoalsSelected: (goals) => _onGoalsSelected(context, ref, goals),
          initialCustomIntention: customIntention,
          isCustomMode: true,
        ),
      ));
    }
  }

  void _selectMethod(BuildContext context, WidgetRef ref, session.TranceMethod method, int index) {
    if (selectedIndex != null) return;

    selectedMethod = method;
    selectedIndex = index;

    _controller?.forward().then((_) {
      late WoltModalSheetPage page;
      switch (method) {
        case session.TranceMethod.Hypnosis:
          page = WoltModalSheetPage(
            hasSabGradient: false,
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Colors.transparent,
            hasTopBarLayer: true,
            topBarTitle: const Text('Hypnotherapy'),
            leadingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(16),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: WoltModalSheet.of(context).showPrevious,
            ),
            child: Hypnotherapy(
              onBack: WoltModalSheet.of(context).showPrevious,
              changePage: (pageName) {
                selectedMethod = null;
                selectedIndex = null;
                _controller?.reset();
                if (pageName == '/hypnotherapy_methods') {
                  _navigateToPage(context, WoltModalSheetPage(
                    hasSabGradient: false,
                    isTopBarLayerAlwaysVisible: true,
                    backgroundColor: Colors.transparent,
                    hasTopBarLayer: true,
                    topBarTitle: const Text('Hypnotherapy Methods'),
                    leadingNavBarWidget: IconButton(
                      padding: const EdgeInsets.all(16),
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: WoltModalSheet.of(context).showPrevious,
                    ),
                    child: HypnosisMethods(
                      onBack: WoltModalSheet.of(context).showPrevious,
                    ),
                  ));
                } else if (pageName == '/soundscapes') {
                  _navigateToPage(context, WoltModalSheetPage(
                    hasSabGradient: false,
                    isTopBarLayerAlwaysVisible: true,
                    backgroundColor: Colors.transparent,
                    hasTopBarLayer: true,
                    topBarTitle: const Text('Select Background Sound'),
                    leadingNavBarWidget: IconButton(
                      padding: const EdgeInsets.all(16),
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: WoltModalSheet.of(context).showPrevious,
                    ),
                    child: Soundscapes(
                      onPlayStateChanged: (isPlaying) {
                        print('isPlaying: $isPlaying');
                      },
                      onBack: WoltModalSheet.of(context).showPrevious,
                    ),
                  ));
                }
              },
              onStart: (duration) {
                // Handle start session
              },
            ),
          );
          break;
        case session.TranceMethod.Meditation:
          page = WoltModalSheetPage(
            hasSabGradient: false,
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Colors.transparent,
            hasTopBarLayer: true,
            topBarTitle: const Text('Meditation'),
            leadingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(16),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: WoltModalSheet.of(context).showPrevious,
            ),
            child: Meditation(
              onBack: WoltModalSheet.of(context).showPrevious,
              onStart: (duration) {
                // Handle start session
              },
            ),
          );
          break;
        case session.TranceMethod.Breathe:
          page = WoltModalSheetPage(
            hasSabGradient: false,
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Colors.transparent,
            hasTopBarLayer: true,
            topBarTitle: const Text('Breathwork'),
            leadingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(16),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: WoltModalSheet.of(context).showPrevious,
            ),
            child: Breathwork(
              onBack: WoltModalSheet.of(context).showPrevious,
              onStart: (duration) {
                // Handle start session
              },
            ),
          );
          break;
        case session.TranceMethod.Active:
          page = WoltModalSheetPage(
            hasSabGradient: false,
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Colors.transparent,
            hasTopBarLayer: true,
            topBarTitle: const Text('Active Hypnotherapy'),
            leadingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(16),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: WoltModalSheet.of(context).showPrevious,
            ),
            child: Active(
              onBack: WoltModalSheet.of(context).showPrevious,
              onStart: (duration) {
                // Handle start session
              },
            ),
          );
          break;
        case session.TranceMethod.Sleep:
          page = WoltModalSheetPage(
            hasSabGradient: false,
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Colors.transparent,
            hasTopBarLayer: true,
            topBarTitle: const Text('Sleep Programming'),
            leadingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(16),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: WoltModalSheet.of(context).showPrevious,
            ),
            child: Sleep(
              onBack: WoltModalSheet.of(context).showPrevious,
              onStart: (duration) {
                // Handle start session
              },
            ),
          );
          break;
      }

      _navigateToPage(context, page);
    });
  }

  Future<void> _onGoalsSelected(BuildContext context, WidgetRef ref, Set<String> goals) async {
    if (goals.isNotEmpty) {
      ref.read(intentionSelectionProvider.notifier).setSelectedGoals(goals);
      _navigateToPage(context, WoltModalSheetPage(
        hasSabGradient: false,
        isTopBarLayerAlwaysVisible: true,
        backgroundColor: Colors.white70,
        surfaceTintColor: Colors.white,
        hasTopBarLayer: false,
        child: ModalitySelect(
          selectedMethod: selectedIndex == null ? null : selectedMethod,
          selectedIndex: selectedIndex,
          onBack: WoltModalSheet.of(context).showPrevious,
          onSelectMethod: (method, index) => _selectMethod(context, ref, method, index),
        ),
      ));
    }
  }
}

class Sheet extends ConsumerStatefulWidget {
  const Sheet({super.key});

  @override
  ConsumerState<Sheet> createState() => _SheetState();
}

class _SheetState extends ConsumerState<Sheet> with TickerProviderStateMixin {
  late AnimationController _controller;
  session.TranceMethod? selectedMethod;
  String? customIntention;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intentionState = ref.watch(intentionSelectionProvider);
    return IntentionContent(
      tranceMethod: selectedMethod ?? session.TranceMethod.values.first,
      onBack: null,
      onContinue: _onIntentionSelected,
      selectedGoalIds: intentionState.selectedGoalIds,
      onGoalsSelected: _onGoalsSelected,
      initialCustomIntention: customIntention,
      isCustomMode: false,
    );
  }

  Future<void> _onIntentionSelected(String intention) async {
    if (!mounted) return;

    if (intention.isEmpty) {
      final selectedType = ref.read(intentionSelectionProvider).type;
      if (selectedType == IntentionSelectionType.previous) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PreviousIntentions(
              onBack: () => Navigator.of(context).pop(),
              onIntentionSelected: _onIntentionSelected,
            ),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IntentionContent(
              tranceMethod: selectedMethod ?? session.TranceMethod.values.first,
              onBack: () => Navigator.of(context).pop(),
              onContinue: _onIntentionSelected,
              selectedGoalIds: ref.read(intentionSelectionProvider).selectedGoalIds,
              onGoalsSelected: _onGoalsSelected,
              initialCustomIntention: customIntention,
              isCustomMode: true,
            ),
          ),
        );
      }
    } else {
      setState(() {
        customIntention = intention;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ModalitySelect(
            selectedMethod: selectedIndex == null ? null : selectedMethod,
            selectedIndex: selectedIndex,
            onBack: () => Navigator.of(context).pop(),
            onSelectMethod: _selectMethod,
          ),
        ),
      );
    }
  }

  void _selectMethod(session.TranceMethod method, int index) {
    if (selectedIndex != null || !mounted) return;

    setState(() {
      selectedMethod = method;
      selectedIndex = index;
    });

    _controller.forward().then((_) {
      if (!mounted) return;

      late Widget page;
      String title = '';
      switch (method) {
        case session.TranceMethod.Hypnosis:
          title = 'Hypnotherapy';
          page = Hypnotherapy(
            onBack: () => Navigator.of(context).pop(),
            changePage: (pageName) {
              setState(() {
                selectedMethod = null;
                selectedIndex = null;
                _controller.reset();
              });
              if (pageName == '/hypnotherapy_methods') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HypnosisMethods(
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),
                );
              } else if (pageName == '/soundscapes') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Soundscapes(
                      onPlayStateChanged: (isPlaying) {
                        print('isPlaying: $isPlaying');
                      },
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),
                );
              }
            },
            onStart: (duration) {
              // Handle start session
            },
          );
          break;
        case session.TranceMethod.Meditation:
          title = 'Meditation';
          page = Meditation(
            onBack: () => Navigator.of(context).pop(),
            onStart: (duration) {
              // Handle start session
            },
          );
          break;
        case session.TranceMethod.Breathe:
          title = 'Breathwork';
          page = Breathwork(
            onBack: () => Navigator.of(context).pop(),
            onStart: (duration) {
              // Handle start session
            },
          );
          break;
        case session.TranceMethod.Active:
          title = 'Active Hypnotherapy';
          page = Active(
            onBack: () => Navigator.of(context).pop(),
            onStart: (duration) {
              // Handle start session
            },
          );
          break;
        case session.TranceMethod.Sleep:
          title = 'Sleep Programming';
          page = Sleep(
            onBack: () => Navigator.of(context).pop(),
            onStart: (duration) {
              // Handle start session
            },
          );
          break;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: page,
          ),
        ),
      );
    });
  }

  Future<void> _onGoalsSelected(Set<String> goals) async {
    if (!mounted) return;

    if (goals.isNotEmpty) {
      ref.read(intentionSelectionProvider.notifier).setSelectedGoals(goals);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ModalitySelect(
            selectedMethod: selectedIndex == null ? null : selectedMethod,
            selectedIndex: selectedIndex,
            onBack: () => Navigator.of(context).pop(),
            onSelectMethod: _selectMethod,
          ),
        ),
      );
    }
  }
}
