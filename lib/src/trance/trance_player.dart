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
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation1 = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation2 = Tween<double>(begin: 1.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start trance session
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tranceState = ref.read(tranceStateProvider.notifier);
      
      // First load pre-trance to initialize audio
      await tranceState.loadPreTrance(
        topic: widget.topic,
        tranceMethod: widget.tranceMethod,
      );
      
      // Then start the actual session
      await tranceState.startTranceSession(
        topic: widget.topic,
        tranceMethod: widget.tranceMethod,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(tranceStateProvider);
    final backgroundVolume = ref.watch(backgroundSoundProvider);
    final tranceState = ref.watch(tranceStateProvider.notifier);
    final backgroundState = ref.watch(backgroundSoundProvider.notifier);

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
                spread: 2,
                depth: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),

            // Animated circles
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final size = MediaQuery.of(context).size;
                  final outerSize = size.width * 0.9;
                  final innerSize = outerSize * 0.7;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle
                      Transform.scale(
                        scale: _scaleAnimation1.value,
                        child: ClayContainer(
                          color: const Color(0xFFD59074),
                          height: outerSize,
                          width: outerSize,
                          borderRadius: outerSize / 2,
                          spread: 20,
                          depth: 20,
                        ),
                      ),

                      // Inner circle with play/pause button
                      Transform.scale(
                        scale: _scaleAnimation2.value,
                        child: ClayContainer(
                          color: const Color(0xFFD59074),
                          height: innerSize,
                          width: innerSize,
                          borderRadius: innerSize / 2,
                          spread: 10,
                          depth: 10,
                          child: IconButton(
                            iconSize: innerSize * 0.4,
                            icon: Icon(
                              tranceState.isPlaying 
                                ? Icons.pause 
                                : Icons.play_arrow,
                              color: Colors.white70,
                            ),
                            onPressed: () => tranceState.togglePlayPause(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Volume slider
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: Column(
                children: [
                  ClaySlider(
                    value: backgroundVolume,
                    onChanged: (value) => backgroundState.updateVolume(value),
                    parentColor: const Color(0xFFD59074),
                    activeSliderColor: Colors.white70,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Background Volume',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 