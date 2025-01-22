part of 'clay_bottom_nav.dart';

/// Toggle button for the bottom sheet
class _SheetToggleButton extends StatelessWidget {
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final Color? parentColor;
  final Color? foregroundColor;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isOpen;

  const _SheetToggleButton({
    this.decoration,
    this.backgroundColor,
    this.parentColor,
    this.foregroundColor,
    required this.icon,
    this.onTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;

    // Invert colors when open
    final effectiveBgColor = isOpen ? fgColor : bgColor;
    final effectiveFgColor = isOpen ? bgColor : fgColor;

    return Center(
      child: InkResponse(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: ClayContainer(
            width: 56,
            height: 56,
            color: effectiveBgColor,
            parentColor: parentColor ?? theme.colorScheme.surface,
            spread: 8,
            depth: 16,
            borderRadius: 50,
            curveType: CurveType.none,
            child: Icon(
              icon,
              color: effectiveFgColor,
            ),
          ),
        ),
      ),
    );
  }
}
