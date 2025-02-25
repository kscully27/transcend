import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

/// A card widget for displaying a modality option
class ModalityCard extends StatelessWidget {
  /// The title of the modality
  final String title;
  
  /// Whether this modality is selected
  final bool isSelected;
  
  /// Callback when the card is tapped
  final VoidCallback onTap;

  /// Creates a modality card
  const ModalityCard({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GlassContainer(
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.white12,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.shadow,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isSelected 
          ? Icon(
              Icons.check,
              color: theme.colorScheme.primary,
              size: 24.0,
            )
          : null,
        onTap: onTap,
      ),
    );
  }
} 