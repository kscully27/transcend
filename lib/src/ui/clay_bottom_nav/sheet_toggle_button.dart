part of 'clay_bottom_nav.dart';

/// Toggle button for the bottom sheet
class _SheetToggleButton extends StatelessWidget {
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final Color? parentColor;
  final Color? foregroundColor;
  final IconData icon;
  final VoidCallback? onTap;

  const _SheetToggleButton({
    this.decoration,
    this.backgroundColor,
    this.parentColor,
    this.foregroundColor,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;

    return Center(
      child: InkResponse(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: ClayContainer(
            width: 56,
            height: 56,
            color: bgColor,
            parentColor: parentColor ?? theme.colorScheme.surface,
            surfaceColor: bgColor,
            spread: 8,
            depth: 16,
            borderRadius: 50,
            curveType: CurveType.concave,
            child: Icon(
              icon,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}
