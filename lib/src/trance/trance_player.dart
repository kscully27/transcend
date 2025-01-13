import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/providers/background_sound_provider.dart';
import 'package:trancend/src/providers/trance_provider.dart';
import 'package:trancend/src/ui/clay_slider.dart';

class TrancePlayer extends ConsumerStatefulWidget {
  final Topic topic;
  final TranceMethod tranceMethod;

  const TrancePlayer({
    Key? key,
    required this.topic,
    required this.tranceMethod,
  }) : super(key: key);

  @override
  ConsumerState<TrancePlayer> createState() => _TrancePlayerState();
}

class _TrancePlayerState extends ConsumerState<TrancePlayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  double backgroundVolume = 0.4;
  int _currentMillisecond = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation1 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation2 = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);

    // Start listening to audio position
    ref.read(tranceStateProvider.notifier).positionStream.listen((position) {
      setState(() {
        _currentMillisecond = position.inMilliseconds;
      });
    });

    // Start the trance session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tranceStateProvider.notifier).startTranceSession(
        topic: widget.topic,
        tranceMethod: widget.tranceMethod,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tranceState = ref.watch(tranceStateProvider.notifier);
    final sessionState = ref.watch(tranceStateProvider);
    final isLoading = sessionState.isLoading;
    final isPlaying = tranceState.isPlaying;
    
    // Control animation based on play state
    if (isPlaying && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
    
    final size = MediaQuery.of(context).size;
    final outerSize = size.width * 0.9;
    final innerSize = outerSize * 0.7;

    // Format duration as mm:ss
    String formatDuration(int milliseconds) {
      final duration = Duration(milliseconds: milliseconds);
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    final currentPosition = formatDuration(tranceState.currentMillisecond);
    final totalDuration = formatDuration(TranceState.DEFAULT_SESSION_MINUTES * 60 * 1000);

    return Scaffold(
      backgroundColor: const Color(0xFFD59074),
      body: SafeArea(
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: ClayContainer(
                color: const Color(0xFFD59074),
                height: 40,
                width: 40,
                borderRadius: 20,
                depth: 20,
                spread: 2,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            
            // Animated circles and play button
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle
                      ScaleTransition(
                        scale: _scaleAnimation1,
                        child: ClayContainer(
                          color: const Color(0xFFD59074),
                          height: outerSize,
                          width: outerSize,
                          borderRadius: outerSize / 2,
                          depth: 30,
                          spread: 20,
                        ),
                      ),
                      
                      // Inner circle with play button
                      ScaleTransition(
                        scale: _scaleAnimation2,
                        child: ClayContainer(
                          color: const Color(0xFFD59074),
                          height: innerSize,
                          width: innerSize,
                          borderRadius: innerSize / 2,
                          depth: 15,
                          spread: 10,
                          child: IconButton(
                            iconSize: innerSize * 0.4,
                            icon: sessionState.isLoading 
                              ? const CircularProgressIndicator(color: Colors.white70)
                              : Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white70,
                                ),
                            onPressed: sessionState.isLoading 
                              ? null 
                              : () => tranceState.togglePlayPause(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Progress indicator
                  if (!isLoading) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ClayContainer(
                        color: const Color(0xFFD59074),
                        height: 4,
                        borderRadius: 2,
                        depth: -20,
                        spread: 2,
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: tranceState.currentMillisecond / (TranceState.DEFAULT_SESSION_MINUTES * 60 * 1000),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Duration text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentPosition,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            totalDuration,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 40),
                  
                  // Volume slider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ClaySlider(
                      value: backgroundVolume,
                      onChanged: (value) {
                        setState(() {
                          backgroundVolume = value;
                        });
                      },
                      parentColor: const Color(0xFFD59074),
                      activeSliderColor: Colors.white70,
                      hasKnob: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // First, stop the animation controller
    _controller.dispose();
    
    // Get the trance state before super.dispose()
    final tranceState = ref.read(tranceStateProvider.notifier);
    
    // Call super.dispose() before disposing tranceState
    super.dispose();
    
    // Finally dispose the trance state
    tranceState.dispose();
  }

  Widget _buildProgressIndicator(AsyncValue<Session> sessionState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Progress bar
          ClayContainer(
            color: const Color(0xFFD59074),
            height: 4,
            depth: -20,
            spread: 2,
            borderRadius: 2,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 
                    (_currentMillisecond / (sessionState.value?.totalSeconds ?? 1) / 1000),
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Time indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentMillisecond),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration((sessionState.value?.totalSeconds ?? 0) * 1000),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int milliseconds) {
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
} 