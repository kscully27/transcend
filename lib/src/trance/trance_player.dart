import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/providers/trance_provider.dart';
import 'package:trancend/src/ui/clay/clay_button.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';
import 'package:trancend/src/ui/clay/clay_slider.dart';
import 'package:trancend/src/ui/clay/clay_text.dart';
import 'package:trancend/src/ui/pond_effect.dart';

class TrancePlayer extends ConsumerStatefulWidget {
  final Topic topic;
  final TranceMethod tranceMethod;

  const TrancePlayer({
    super.key,
    required this.topic,
    required this.tranceMethod,
  });

  @override
  ConsumerState<TrancePlayer> createState() => _TrancePlayerState();
}

class _TrancePlayerState extends ConsumerState<TrancePlayer>
    with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  double backgroundVolume = 0.4;
  double voiceVolume = 0.5;
  int _currentMillisecond = 0;
  final GlobalKey<PondEffectState> _pondEffectKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _scaleAnimation1 = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController1,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation2 = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController2,
      curve: Curves.easeInOut,
    ));

    // Initialize the trance session without auto-playing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(tranceStateProvider.notifier)
          .startTranceSession(
            topic: widget.topic,
            tranceMethod: widget.tranceMethod,
          )
          .then((_) {
        // Auto-play after session is initialized
        if (mounted) {
          ref.read(tranceStateProvider.notifier).togglePlayPause();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      // Start animations with a slight offset
      _animationController1.repeat(reverse: true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _animationController2.repeat(reverse: true);
        }
      });

      // Start listening to audio position
      ref.read(tranceStateProvider.notifier).positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentMillisecond = position.inMilliseconds;
          });
        }
      });
    }
  }

  @override
  void deactivate() {
    _animationController1.stop();
    _animationController2.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    print('dispose in trance player');

    // Only handle animation cleanup in dispose
    _animationController1.stop();
    _animationController2.stop();
    _animationController1.dispose();
    _animationController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tranceState = ref.watch(tranceStateProvider.notifier);

    final sessionState = ref.watch(tranceStateProvider);
    final isLoading = sessionState.isLoading;
    final isLoadingAudio = tranceState.isLoadingAudio;
    final isPlaying = tranceState.isPlaying;

    // Control animation based on play state
    if (isPlaying && !_animationController1.isAnimating) {
      _animationController1.repeat(reverse: true);
    } else if (!isPlaying && _animationController1.isAnimating) {
      _animationController1.stop();
    }

    final size = MediaQuery.of(context).size;
    final outerSize = size.width * 0.3;
    final innerSize = outerSize * 0.8;

    void _handleClose() {
      ref.read(tranceStateProvider.notifier).clearState();
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surfaceTint,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PondEffect(
                      key: _pondEffectKey,
                      size: Size(size.width, size.height),
                      color1: theme.colorScheme.surfaceTint,
                      color2: theme.colorScheme.surface,
                      child: Container()),
                ),

                // Close button
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      ClayContainer(
                        color: theme.colorScheme.surfaceTint,
                        parentColor: theme.colorScheme.surfaceTint,
                        height: 40,
                        width: 40,
                        borderRadius: 20,
                        depth: 20,
                        spread: 2,
                        child: IconButton(
                          icon: Icon(Icons.list,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7)),
                          onPressed: () => _showPlayedTracks(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClayContainer(
                        color: theme.colorScheme.surfaceTint,
                        parentColor: theme.colorScheme.surfaceTint,
                        height: 40,
                        width: 40,
                        borderRadius: 20,
                        depth: 20,
                        spread: 2,
                        child: IconButton(
                          icon: Icon(Icons.close,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7)),
                          onPressed: () => _handleClose(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Session Type Title
                Positioned(
                  top: 24,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClayText(
                        widget.tranceMethod.name,
                        // emboss: false,
                        style: theme.textTheme.titleLarge,
                        size: 32,
                        parentColor: theme.colorScheme.surfaceTint,
                        textColor: theme.colorScheme.onSurface.withOpacity(0.7),
                        color: theme.colorScheme.surface,
                        spread: 2,
                        // style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.topic.title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated circles and play button
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 280),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer circle
                          // ScaleTransition(
                          //   scale: _scaleAnimation1,
                          //   child: ClayContainer(
                          //     color: theme.colorScheme.surface,
                          //     parentColor: theme.colorScheme.surface,
                          //     height: outerSize,
                          //     width: outerSize,
                          //     borderRadius: outerSize / 2,
                          //     depth: 30,
                          //     spread: 30,
                          //     child: Container(),
                          //   ),
                          // ),

                          // Progress indicator
                          // ScaleTransition(
                          //   scale: _scaleAnimation1,
                          //   child: SizedBox(
                          //     height: outerSize * 0.65,
                          //     width: outerSize * 0.65,
                          //     child: CircularProgressIndicator(
                          //       value: (tranceState.currentMillisecond
                          //               .toDouble()) /
                          //           (TranceState.DEFAULT_SESSION_MINUTES *
                          //               60 *
                          //               1000),
                          //       strokeWidth: 40,
                          //       color: theme.colorScheme.onSurface
                          //           .withOpacity(0.7),
                          //       backgroundColor: theme.colorScheme.onSurface
                          //           .withOpacity(0.1),
                          //     ),
                          //   ),
                          // ),

                          // Inner circle with play button
                          ScaleTransition(
                            scale: _scaleAnimation2,
                            child: ClayContainer(
                                color: theme.colorScheme.surface,
                                parentColor: theme.colorScheme.surface,
                                height: innerSize,
                                width: innerSize,
                                borderRadius: innerSize / 2,
                                depth: 25,
                                spread: 8,
                                emboss: isPlaying,
                                child: isLoadingAudio
                                    ? Center(
                                        child: SizedBox(
                                          width: innerSize * 0.4,
                                          height: innerSize * 0.4,
                                          child: CircularProgressIndicator(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.7),
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTapDown: (details) {
                                          print('tap down');
                                          _pondEffectKey.currentState?.click(
                                              details.globalPosition.dx.toInt(),
                                              details.globalPosition.dy
                                                  .toInt());
                                        },
                                        child: IconButton(
                                          iconSize: innerSize * 0.4,
                                          icon: Icon(
                                            isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                          onPressed: () {
                                            // _pondEffectKey.currentState?.update();
                                            if (isPlaying) {
                                              tranceState.pauseCombinedAudio();
                                            } else {
                                              tranceState.playCombinedAudio();
                                            }
                                          },
                                        ),
                                      )),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Current track display
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 40),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         _formatTrackText(tranceState.currentTrack?.text),
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //           color: theme.colorScheme.onSurface
                      //               .withOpacity(0.7),
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      const SizedBox(height: 20),

                      // Progress indicator
                      // if (!isLoading) ...[
                      //   // Duration text
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 40),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           _formatDuration(tranceState.currentMillisecond),
                      //           style: TextStyle(
                      //               color: theme.colorScheme.onSurface
                      //                   .withOpacity(0.7)),
                      //         ),
                      //         Text(
                      //           _formatDuration(
                      //               TranceState.DEFAULT_SESSION_MINUTES *
                      //                   60 *
                      //                   1000),
                      //           style: TextStyle(
                      //               color: theme.colorScheme.onSurface
                      //                   .withOpacity(0.7)),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ],

                      const SizedBox(height: 140),

                      // Settings button
                      ClayButton(
                        text: 'Trance Settings',
                        size: ClayButtonSize.medium,
                        textColor: theme.colorScheme.onSurface,
                        icon: Icons.settings,
                        color: theme.colorScheme.surface,
                        parentColor: theme.colorScheme.surface,
                        depth: 20,
                        spread: 4,
                        width: 280,
                        onPressed: () => _showTranceSettings(context),
                      ),

                      const SizedBox(height: 400),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int milliseconds) {
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showPlayedTracks(BuildContext context) {
    final theme = Theme.of(context);
    final session = ref.read(tranceStateProvider).value;
    final playedTracks = session?.playedTracks ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              'Played Tracks (${playedTracks.length})',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: playedTracks.length,
                itemBuilder: (context, index) {
                  final track = playedTracks[index];
                  final minutes = track.startedTime! ~/ (60 * 1000);
                  final seconds = (track.startedTime! % (60 * 1000)) ~/ 1000;
                  final tranceText = (track.text!.length > 30
                          ? track.text!.substring(0, 30)
                          : track.text)
                      ?.replaceAll("\n", " ");
                  return ListTile(
                    title: Text(
                      tranceText ?? 'Unknown Text',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Started at ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7)),
                        ),
                        Text(
                          '${track.words ?? 0} words',
                          style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7)),
                        ),
                        Text(
                          '${track.duration} seconds',
                          style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showTranceSettings(BuildContext context) {
    final theme = Theme.of(context);
    final tranceState = ref.read(tranceStateProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                'Trance Settings',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Background Volume',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClaySlider(
                      value: backgroundVolume,
                      onChanged: (value) {
                        setState(() {
                          backgroundVolume = value;
                        });
                        tranceState.setBackgroundVolume(value);
                      },
                      parentColor: theme.colorScheme.surface,
                      activeSliderColor:
                          theme.colorScheme.onSurface.withOpacity(0.7),
                      hasKnob: false,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Voice Volume',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClaySlider(
                      value: voiceVolume,
                      onChanged: (value) {
                        setState(() {
                          voiceVolume = value;
                        });
                        tranceState.setVoiceVolume(value);
                      },
                      parentColor: theme.colorScheme.surface,
                      activeSliderColor:
                          theme.colorScheme.onSurface.withOpacity(0.7),
                      hasKnob: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTrackText(String? text) {
    if (text == null) return 'Loading...';
    final cleanText = text.replaceAll("\n", " ");
    return cleanText.length > 30
        ? cleanText.substring(0, 30) + "..."
        : cleanText;
  }
}
