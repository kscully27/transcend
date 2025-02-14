import 'package:flutter/material.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/ui/glass/glass_container.dart';

class CustomIntentionPage extends StatefulWidget {
  final session.TranceMethod tranceMethod;
  final Function(String intention) onContinue;

  const CustomIntentionPage({
    super.key,
    required this.tranceMethod,
    required this.onContinue,
  });

  @override
  State<CustomIntentionPage> createState() => _CustomIntentionPageState();
}

class _CustomIntentionPageState extends State<CustomIntentionPage> with SingleTickerProviderStateMixin {
  final TextEditingController _intentionController = TextEditingController();
  late AnimationController _placeholderAnimationController;
  late Animation<double> _placeholderOpacity;
  bool _showError = false;
  String? _errorMessage;
  final int _minCharacters = 10;
  
  final List<String> _placeholders = [
    "I want to feel more confident in social situations",
    "I want to sleep more deeply and wake up refreshed",
    "I want to develop a positive mindset",
    "I want to overcome my fear of public speaking",
    "I want to increase my focus and productivity",
  ];

  void _validateAndContinue() {
    final text = _intentionController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please describe your intention';
      });
      return;
    }
    
    if (text.length < _minCharacters) {
      setState(() {
        _showError = true;
        _errorMessage = 'Your intention should be at least $_minCharacters characters long to ensure it\'s specific enough';
      });
      return;
    }

    widget.onContinue(text);
  }

  @override
  void initState() {
    super.initState();
    _intentionController.text = '';
    
    _intentionController.addListener(() {
      if (_showError) {
        setState(() {
          _showError = false;
          _errorMessage = null;
        });
      }
    });
    
    _placeholderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _placeholderOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _placeholderAnimationController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _placeholderAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _intentionController.dispose();
    _placeholderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLength = _intentionController.text.trim().length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.shadow,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Your Intention',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.shadow,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'What would you like to accomplish today?',
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GlassContainer(
                      backgroundColor: Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                      border: _showError 
                        ? Border.all(color: Colors.red.withOpacity(0.7), width: 1.5)
                        : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FadeTransition(
                            opacity: _placeholderOpacity,
                            child: TextField(
                              controller: _intentionController,
                              maxLines: 5,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              onSubmitted: (_) => FocusScope.of(context).unfocus(),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: _placeholders[
                                    DateTime.now().microsecond % _placeholders.length],
                                hintStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 24,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                            child: currentLength >= _minCharacters
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.green.shade800,
                                  size: 26,
                                )
                              : Text(
                                  '$currentLength/$_minCharacters characters',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: _errorMessage != null ? 4.0 : 20.0,
                bottom: 110.0,
              ),
              child: GlassContainer(
                borderRadius: BorderRadius.circular(12),
                backgroundColor: Colors.white12,
                child: ListTile(
                  title: Text(
                    "Continue",
                    style: TextStyle(
                      color: theme.colorScheme.shadow,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: _validateAndContinue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 