import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:remixicon/remixicon.dart';

class BottomSheetPage extends StatefulWidget {
  final String backPage;
  final Widget content;
  final Widget? settingsContent;
  final bool hasBottomButton;
  final VoidCallback? onBottomButtonTap;
  final String? bottomButtonText;
  final String title;
  final bool showBackButton;

  const BottomSheetPage({
    super.key,
    required this.backPage,
    required this.content,
    this.settingsContent,
    this.hasBottomButton = false,
    this.onBottomButtonTap,
    this.bottomButtonText,
    required this.title,
    this.showBackButton = true,
  });

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _heightAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _heightAnimation = Tween<double>(
        begin: MediaQuery.of(context).size.height * 0.5,
        end: MediaQuery.of(context).size.height * 0.8,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: Colors.white24,
              width: 0.5,
            ),
          ),
          height: _heightAnimation?.value ?? MediaQuery.of(context).size.height * 0.8,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: Column(
                children: [
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.25,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.showBackButton)
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: theme.colorScheme.shadow.withOpacity(0.7),
                              size: 20,
                            ),
                            onPressed: () {
                              _controller.reverse().then((_) {
                                Navigator.pushReplacementNamed(context, widget.backPage);
                              });
                            },
                          )
                        else
                          const SizedBox(width: 48),
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.shadow,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: widget.content,
                  ),
                  if (widget.hasBottomButton)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 160.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            widget.bottomButtonText ?? "Continue",
                            style: TextStyle(
                              color: theme.colorScheme.shadow,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: widget.onBottomButtonTap,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 