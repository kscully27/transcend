import 'package:flutter/material.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/pages/sessions/hypnotherapy.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class Inductions extends StatelessWidget {
  final AnimationController controller;
  final session.TranceMethod? selectedMethod;
  final int? selectedIndex;
  final VoidCallback onBack;
  final Function(session.TranceMethod method, int index) onSelectMethod;

  const Inductions({
    super.key,
    required this.controller,
    required this.selectedMethod,
    required this.selectedIndex,
    required this.onBack,
    required this.onSelectMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (selectedMethod == session.TranceMethod.Hypnosis) {
      return Hypnotherapy(
        onBack: onBack,
        onStart: (duration) {
          // TODO: Implement start with duration
          print('Starting hypnotherapy session with duration: $duration');
        },
      );
    }

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              left: 4,
              top: 8,
              bottom: 8,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: theme.colorScheme.shadow.withOpacity(0.7),
                  size: 20,
                ),
                onPressed: onBack,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48.0,
                  vertical: 16.0,
                ),
                child: Text(
                  selectedMethod?.name ?? 'Select a Modality',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: session.TranceMethod.values.length,
            itemBuilder: (context, index) {
              final method = session.TranceMethod.values[index];
              final isSelected = method == selectedMethod;
              
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final double t;
                  if (isSelected) {
                    // Selected item animates last
                    t = controller.value < 0.5 ? 0.0 : (controller.value - 0.5) * 2;
                  } else {
                    // Other items animate based on their index, ensuring last item animates
                    final itemCount = session.TranceMethod.values.length;
                    final startTime = (index / (itemCount - 1)) * 0.5; // Spread animations over first half
                    t = controller.value < startTime ? 0.0 
                        : (controller.value - startTime) / (0.5 - startTime);
                  }
                  
                  final progress = Curves.easeInOut.transform(t.clamp(0.0, 1.0));
                  
                  return Transform.translate(
                    offset: Offset(-progress * MediaQuery.of(context).size.width, 0),
                    child: Opacity(
                      opacity: 1 - progress,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: Colors.white12,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        splashColor: Colors.white24,
                        highlightColor: Colors.white12,
                        onTap: () => onSelectMethod(method, index),
                        child: ListTile(
                          title: Text(
                            method.name,
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
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 