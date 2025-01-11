part of './neo_bottom_nav.dart';

/// Toggle button for the bottom sheet
class _SheetToggleButton extends StatelessWidget {
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData icon;
  final VoidCallback? onTap;

  const _SheetToggleButton(
      {Key? key,
      this.decoration,
      this.backgroundColor,
      this.foregroundColor,
      required this.icon,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.secondary;
    
    return Center(
      child: InkResponse(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: ClayContainer(
            width: 56,
            height: 56,
            color: bgColor,
            parentColor: bgColor,
            surfaceColor: bgColor,
            spread: 20,
            depth: 20,
            borderRadius: 50,
            curveType: CurveType.concave,
            child: Icon(
              icon,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}