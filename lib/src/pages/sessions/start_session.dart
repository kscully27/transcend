import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/navigation/bottomsheet_declarative_routing.dart';
import 'package:trancend/src/navigation/bottomsheet_flow_notifier.dart';
import 'package:trancend/src/navigation/bottomsheet_flow_widget.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';

class StartSession extends ConsumerWidget {
  const StartSession({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetFlowWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Start Session",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassButton(
                      text: "Start Session",
                      icon: Remix.play_fill,
                      width: double.infinity,
                      height: 60,
                      textColor: Colors.black,
                      glassColor: Colors.white24,
                      onPressed: () {
                        ref.read(bottomSheetFlowProvider.notifier).openFlow(
                          BottomSheetFlowName.defaultIntentionFlow,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
