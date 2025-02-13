import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/pages/topic_selection_page.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

final List<String> _placeholders = [
  "I want to feel more confident in social situations",
  "I want to sleep more deeply and wake up refreshed",
  "I want to develop a positive mindset",
  "I want to overcome my fear of public speaking",
  "I want to increase my focus and productivity",
];

class IntentionPage extends ConsumerStatefulWidget {
  final session.TranceMethod tranceMethod;

  const IntentionPage({
    super.key,
    required this.tranceMethod,
  });

  @override
  ConsumerState<IntentionPage> createState() => _IntentionPageState();
}

class _IntentionPageState extends ConsumerState<IntentionPage> {
  final TextEditingController _intentionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Randomly select a placeholder
    _intentionController.text = '';
  }

  @override
  void dispose() {
    _intentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20.0,
              sigmaY: 20.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Outline Your Intention',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            bottom: 100.0, // Add padding for the button
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GlassContainer(
                                backgroundColor: Colors.white12,
                                child: TextField(
                                  controller: _intentionController,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: _placeholders[DateTime.now().microsecond % _placeholders.length],
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                    contentPadding: const EdgeInsets.all(16),
                                    border: InputBorder.none,
                                    label: Text(
                                      '?',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black12,
                                            Colors.black87,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black87,
                                            Colors.black12,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              GlassButton(
                                text: "Select a Goal",
                                icon: Remix.flag_line,
                                textColor: Colors.black,
                                glassColor: Colors.white24,
                                onPressed: () {
                                  // TODO: Implement goal selection
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: GlassButton(
                        text: "Continue",
                        width: double.infinity,
                        height: 56,
                        textColor: Colors.black,
                        glassColor: Colors.white24,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicSelectionPage(
                                tranceMethod: widget.tranceMethod,
                                intention: _intentionController.text,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 