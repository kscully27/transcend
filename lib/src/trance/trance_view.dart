import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/providers/trance_provider.dart';
import 'package:trancend/src/trance/trance_player.dart';
import 'package:trancend/src/ui/clay_button.dart';
import 'package:trancend/src/ui/glass_button.dart';

Color baseColor = const Color(0xFFD59074);

class TranceView extends ConsumerStatefulWidget {
  const TranceView({
    super.key,
    required this.topic,
    required this.tranceMethod,
  });

  final Topic topic;
  final session.TranceMethod tranceMethod;

  static const routeName = '/trance';

  @override
  ConsumerState<TranceView> createState() => _TranceViewState();
}

class _TranceViewState extends ConsumerState<TranceView> {
  @override
  void initState() {
    super.initState();
  }

  void _handleStartSession() {
    if (ref.read(tranceStateProvider).isLoading) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrancePlayer(
          topic: widget.topic,
          tranceMethod: widget.tranceMethod,
        ),
      ),
    );
  }

  int _getDefaultMinutes(session.TranceMethod method, AsyncValue<User?> userAsync) {
    final user = userAsync.value;
    if (user == null) return 10;

    switch (method) {
      case session.TranceMethod.Active:
        return user.defaultActiveHypnotherapyTime;
      case session.TranceMethod.Hypnotherapy:
        return user.defaultHypnotherapyTime;
      default:
        return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final tranceState = ref.watch(tranceStateProvider);
    final minutes = _getDefaultMinutes(widget.tranceMethod, userAsync);
    
    return Scaffold(
      backgroundColor: baseColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with close button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Session",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              widget.topic.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClayContainer(
                        color: baseColor,
                        height: 40,
                        width: 40,
                        borderRadius: 20,
                        child: IconButton(
                          icon: const Icon(Remix.close_line, color: Colors.black54),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Method
                        _buildSettingRow(
                          "Method",
                          ClayButton(
                            text: widget.tranceMethod.name,
                            icon: Remix.mental_health_line,
                            color: baseColor,
                            parentColor: baseColor,
                            variant: ClayButtonVariant.outlined,
                            size: ClayButtonSize.xsmall,
                            textColor: Colors.white,
                            onPressed: () {
                              // TODO: Implement method selection
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Background Sound
                        _buildSettingRow(
                          "Background",
                          ClayButton(
                            text: userAsync.value?.backgroundSound.name ?? "Waves",
                            icon: Remix.volume_up_line,
                            color: baseColor,
                            parentColor: baseColor,
                            variant: ClayButtonVariant.outlined,
                            size: ClayButtonSize.xsmall,
                            textColor: Colors.white,
                            onPressed: () {
                              // TODO: Implement background sound selection
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Duration
                        _buildSettingRow(
                          "Duration",
                          ClayButton(
                            text: "$minutes min",
                            icon: Remix.time_line,
                            color: baseColor,
                            parentColor: baseColor,
                            variant: ClayButtonVariant.outlined,
                            size: ClayButtonSize.xsmall,
                            textColor: Colors.white,
                            onPressed: () {
                              // TODO: Implement duration selection
                            },
                          ),
                        ),

                        const Spacer(),

                        // Advanced Settings Button
                        GlassButton(
                          text: "Advanced Settings",
                          icon: Remix.settings_3_line,
                          variant: GlassButtonVariant.text,
                          size: GlassButtonSize.small,
                          onPressed: () {
                            // TODO: Implement advanced settings
                          },
                        ),

                        const SizedBox(height: 20),

                        // Start Button
                        GlassButton(
                          text: "Start Session",
                          icon: Remix.play_fill,
                          width: double.infinity,
                          height: 60,
                          textColor: tranceState.isLoading ? Colors.grey : Colors.black,
                          onPressed: _handleStartSession,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (tranceState.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, Widget control) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        control,
      ],
    );
  }
} 