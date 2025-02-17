import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/pages/sessions/active.dart';
import 'package:trancend/src/pages/sessions/breathwork.dart';
import 'package:trancend/src/pages/sessions/hypnotherapy.dart';
import 'package:trancend/src/pages/sessions/hypnotherapyMethods.dart';
import 'package:trancend/src/pages/sessions/inductions.dart';
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/pages/sessions/meditation.dart';
import 'package:trancend/src/pages/sessions/previous_intentions.dart';
import 'package:trancend/src/pages/sessions/sleep.dart';
import 'package:trancend/src/pages/sessions/soundscapes.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';

class Sheet extends ConsumerStatefulWidget {
  const Sheet({super.key});

  @override
  ConsumerState<Sheet> createState() => _SheetState();
}

class _SheetState extends ConsumerState<Sheet> with TickerProviderStateMixin {
  session.TranceMethod? selectedMethod;
  String? customIntention;
  bool isAnimatingOut = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _controller;
  int? _selectedIndex;
  final ValueNotifier<double> _heightNotifier = ValueNotifier(0.65);

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
    _heightNotifier.dispose();
    super.dispose();
  }

  double _getSheetHeight(String route) {
    switch (route) {
      case '/modalities':
        return 0.7;
      case '/intention_selection':
        return 0.65;
      case '/hypnotherapy':
        return 0.6;
      case '/soundscapes':
        return 0.9;
      case '/hypnotherapy_methods':
        return 0.5;
      default:
        return 0.65;
    }
  }

  void _selectMethod(session.TranceMethod method, int index) {
    if (_selectedIndex != null || !mounted) return;

    setState(() {
      selectedMethod = method;
      _selectedIndex = index;
    });

    _controller.forward().then((_) {
      if (!mounted) return;

      String route = '';
      switch (method) {
        case session.TranceMethod.Hypnosis:
          route = '/hypnotherapy';
          break;
        case session.TranceMethod.Meditation:
          route = '/meditation';
          break;
        case session.TranceMethod.Breathe:
          route = '/breathwork';
          break;
        case session.TranceMethod.Active:
          route = '/active';
          break;
        case session.TranceMethod.Sleep:
          route = '/sleep';
          break;
      }

      _heightNotifier.value = _getSheetHeight(route);
      _navigatorKey.currentState?.pushReplacementNamed(route);
    });
  }

  Future<void> _onIntentionSelected(String intention) async {
    if (!mounted) return;

    if (intention.isEmpty) {
      final selectedType = ref.read(intentionSelectionProvider).type;
      if (selectedType == IntentionSelectionType.previous) {
        _heightNotifier.value = _getSheetHeight('/previous_intentions');
        await _navigatorKey.currentState
            ?.pushReplacementNamed('/previous_intentions');
      } else {
        _heightNotifier.value = _getSheetHeight('/custom_intention');
        await _navigatorKey.currentState
            ?.pushReplacementNamed('/custom_intention');
      }
    } else {
      setState(() {
        customIntention = intention;
      });
      _heightNotifier.value = _getSheetHeight('/modalities');
      await _navigatorKey.currentState?.pushReplacementNamed('/modalities');
    }
  }

  Future<void> _onGoalsSelected(Set<String> goals) async {
    if (!mounted) return;

    if (goals.isNotEmpty) {
      ref.read(intentionSelectionProvider.notifier).setSelectedGoals(goals);
      _heightNotifier.value = _getSheetHeight('/modalities');
      await _navigatorKey.currentState?.pushReplacementNamed('/modalities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: ValueListenableBuilder<double>(
        valueListenable: _heightNotifier,
        builder: (context, height, child) {
          return DraggableScrollableSheet(
            initialChildSize: height,
            maxChildSize: 0.95,
            minChildSize: 0.15,
            snap: true,
            snapSizes: const [0.65, 0.75, 0.85],
            builder: (context, scrollController) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border.all(
                    color: Colors.white24,
                    width: 0.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20.0,
                      sigmaY: 20.0,
                    ),
                    child: Navigator(
                      key: _navigatorKey,
                      initialRoute: '/intention_selection',
                      onGenerateRoute: (settings) {
                        Widget page;

                        switch (settings.name) {
                          case '/intention_selection':
                            page = IntentionContent(
                              tranceMethod: selectedMethod ??
                                  session.TranceMethod.values.first,
                              onBack: null,
                              onContinue: _onIntentionSelected,
                              selectedGoalIds: ref
                                  .watch(intentionSelectionProvider)
                                  .selectedGoalIds,
                              onGoalsSelected: _onGoalsSelected,
                              initialCustomIntention: customIntention,
                              isCustomMode: false,
                            );
                            break;

                          case '/custom_intention':
                            page = IntentionContent(
                              tranceMethod: selectedMethod ??
                                  session.TranceMethod.values.first,
                              onBack: () {
                                _heightNotifier.value =
                                    _getSheetHeight('/intention_selection');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed(
                                        '/intention_selection');
                              },
                              onContinue: _onIntentionSelected,
                              selectedGoalIds: ref
                                  .watch(intentionSelectionProvider)
                                  .selectedGoalIds,
                              onGoalsSelected: _onGoalsSelected,
                              initialCustomIntention: customIntention,
                              isCustomMode: true,
                            );
                            break;

                          case '/previous_intentions':
                            page = PreviousIntentions(
                              onBack: () {
                                _heightNotifier.value =
                                    _getSheetHeight('/intention_selection');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed(
                                        '/intention_selection');
                              },
                              onIntentionSelected: _onIntentionSelected,
                            );
                            break;

                          case '/modalities':
                            page = Inductions(
                              controller: _controller,
                              selectedMethod: _selectedIndex == null
                                  ? null
                                  : selectedMethod,
                              selectedIndex: _selectedIndex,
                              navigatorKey: _navigatorKey,
                              onBack: () {
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                });
                                _heightNotifier.value =
                                    _getSheetHeight('/modalities');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed('/modalities');
                              },
                              onSelectMethod: _selectMethod,
                            );
                            break;

                          case '/hypnotherapy':
                            page = Hypnotherapy(
                              onBack: () {
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                });
                                _heightNotifier.value =
                                    _getSheetHeight('/hypnotherapy');

                                _navigatorKey.currentState
                                    ?.pushReplacementNamed('/hypnotherapy');
                              },
                              changePage: (pageName) => {
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                }),
                                _heightNotifier.value =
                                    _getSheetHeight(pageName),
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed(pageName)
                              },
                              onStart: (duration) {
                                // Handle start session
                              },
                            );
                            break;

                          case '/soundscapes':
                            page = Soundscapes(
                              onPlayStateChanged: (isPlaying) {
                                print('isPlaying: $isPlaying');
                                // setState(() => _isPlaying = isPlaying);
                              },
                              onBack: () {
                                print('onBack');
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                });
                                _heightNotifier.value =
                                    _getSheetHeight('/hypnotherapy');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed('/hypnotherapy');
                              },
                            );
                            break;

                          case '/hypnotherapy_methods':
                            page = HypnosisMethods(
                              onBack: () async {
                                print('onBack');
                                // Wait a frame to ensure Firestore update is complete
                                await Future.delayed(const Duration(milliseconds: 100));
                                _heightNotifier.value = _getSheetHeight('/hypnotherapy');
                                _navigatorKey.currentState?.pushReplacementNamed('/hypnotherapy');
                              },
                            );
                            break;

                          case '/meditation':
                            page = Meditation(
                              onBack: () {
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                });
                                _heightNotifier.value =
                                    _getSheetHeight('/modalities');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed('/modalities');
                              },
                              onStart: (duration) {
                                // Handle start session
                              },
                            );
                            break;

                          case '/breathwork':
                            page = Breathwork(
                              onBack: () {
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                });
                                _heightNotifier.value =
                                    _getSheetHeight('/modalities');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed('/modalities');
                              },
                              onStart: (duration) {
                                // Handle start session
                              },
                            );
                            break;

                          case '/active':
                            page = Active(
                              onBack: () {
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                });
                                _heightNotifier.value =
                                    _getSheetHeight('/modalities');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed('/modalities');
                              },
                              onStart: (duration) {
                                // Handle start session
                              },
                            );
                            break;

                          case '/sleep':
                            page = Sleep(
                              onBack: () {
                                setState(() {
                                  selectedMethod = null;
                                  _selectedIndex = null;
                                  _controller.reset();
                                });
                                _heightNotifier.value =
                                    _getSheetHeight('/modalities');
                                _navigatorKey.currentState
                                    ?.pushReplacementNamed('/modalities');
                              },
                              onStart: (duration) {
                                // Handle start session
                              },
                            );
                            break;

                          default:
                            page = const SizedBox();
                        }

                        return MaterialPageRoute(
                          builder: (context) => Column(
                            children: [
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.25,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
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
                              if (settings.name != '/intention_selection')
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .shadow
                                              .withOpacity(0.7),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          if (settings.name == '/modalities') {
                                            setState(() {
                                              selectedMethod = null;
                                              _selectedIndex = null;
                                              _controller.reset();
                                            });
                                            _heightNotifier.value =
                                                _getSheetHeight(
                                                    '/intention_selection');
                                            _navigatorKey.currentState
                                                ?.pushReplacementNamed(
                                                    '/intention_selection');
                                          } else if (settings.name == '/hypnotherapy_methods' || settings.name == '/soundscapes') {
                                            _heightNotifier.value =
                                                _getSheetHeight('/hypnotherapy');
                                            _navigatorKey.currentState
                                                ?.pushReplacementNamed('/hypnotherapy');
                                          } else {
                                            setState(() {
                                              selectedMethod = null;
                                              _selectedIndex = null;
                                              _controller.reset();
                                            });
                                            _heightNotifier.value =
                                                _getSheetHeight('/modalities');
                                            _navigatorKey.currentState
                                                ?.pushReplacementNamed(
                                                    '/modalities');
                                          }
                                        },
                                      ),
                                      Text(
                                        _getTitle(settings.name ?? ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .shadow,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                      ),
                                      const SizedBox(width: 48),
                                    ],
                                  ),
                                ),
                              Expanded(
                                child: page,
                              ),
                            ],
                          ),
                          settings: settings,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getTitle(String route) {
    switch (route) {
      case '/intention_selection':
        return '';
      case '/custom_intention':
        return 'Create Intention';
      case '/previous_intentions':
        return 'Previous Intentions';
      case '/modalities':
        return 'Select Modality';
      case '/hypnotherapy':
        return 'Hypnotherapy';
      case '/soundscapes':
        return 'Select Background Sound';
      case '/hypnotherapy_methods':
        return 'Hypnotherapy Methods';
      case '/meditation':
        return 'Meditation';
      case '/breathwork':
        return 'Breathwork';
      case '/active':
        return 'Active Hypnotherapy';
      case '/sleep':
        return 'Sleep Programming';
      default:
        return '';
    }
  }
}
