library;

import 'dart:math' show max, pi, sqrt;
import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';

part 'clay_bottom_nav_item.dart';
part 'bottom_clipper.dart';
part 'bottom_painter.dart';
part 'sheet_toggle_button.dart';

Color _adjustColor(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}

class ClipShadowPath extends StatelessWidget {
  final List<BoxShadow> shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    super.key,
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final List<BoxShadow> shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    for (var s in shadow) {
      paint
        ..color = s.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sqrt(s.blurRadius));
      canvas.save();
      canvas.translate(s.offset.dx, s.offset.dy);
      // canvas.drawPath(shape, _shadowPaint);
      canvas.restore();
      // We want to avoid Canvas.drawShadow for neumorphism design,
      // as it draws a greyed shadow !
      //canvas.drawShadow(shape, s.color, sqrt(s.blurRadius), false);
    }
    var clipPath = clipper.getClip(size);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Animated, modern and highly customisable [BottomNavigationBar]
class ClayBottomNavNSheet extends StatefulWidget {
  /// List of [ClayBottomNavItem] (bottom navigation items)
  final List<ClayBottomNavItem> items;

  /// [Function] callback that returns index of selected [ClayBottomNavItem]
  final void Function(int index)? onTap;

  /// Index of default selected item
  final int? initialSelectedIndex;

  /// Bottom sheet to be displayed on dock icon click
  final Widget? sheet;

  /// Toggle button icon when sheet is open
  final IconData? sheetOpenIcon;

  /// Toggle button foreground [Color] when sheet is open
  final Color? sheetOpenIconBoxColor;

  /// Toggle button foreground [Color] when sheet is open
  final Color? sheetOpenIconColor;

  /// Toggle button background [Color] when sheet is closed
  final Color? sheetCloseIconBoxColor;

  /// Toggle button foreground [Color] when sheet is closed
  final Color? sheetCloseIconColor;

  /// Angle (in radians) to rotate toggle button when sheet is open
  final double? sheetIconRotateAngle;

  /// Toggle button icon when sheet is closed
  final IconData? sheetCloseIcon;

  /// [Decoration] for toggle button
  final BoxDecoration? sheetToggleDecoration;

  /// [List] of [Color] for border over [ClayBottomNavNSheet] ([Gradient] from left to right)
  final List<Color>? borderColors;

  /// Background [Color] of [ClayBottomNavNSheet]
  final Color? backgroundColor;
  final Color? parentColor;

  /// Background [Gradient] of [ClayBottomNavNSheet]
  final Gradient? backgroundGradient;

  /// [Color] of selected nav item
  final Color? selectedItemColor;

  /// [Color] of unselected nav item
  final Color? unselectedItemColor;

  /// [Gradient] of selected [ClayBottomNavItem]
  final Gradient? selectedItemGradient;

  /// [Gradient] of unselected [ClayBottomNavItem]
  final Gradient? unselectedItemGradient;

  /// [Function] callback that returns ```true``` if sheet is open
  /// and ```false``` if sheet is closed
  final void Function(bool value)? onSheetToggle;

  /// Clay container depth
  final int depth;

  /// Clay container spread
  final int spread;

  /// Clay container emboss
  final bool emboss;

  const ClayBottomNavNSheet({
    super.key,
    required this.items,
    this.onTap,
    this.initialSelectedIndex,
    this.sheet,
    this.borderColors,
    this.backgroundColor,
    this.parentColor,
    this.backgroundGradient,
    this.sheetToggleDecoration,
    this.sheetOpenIcon,
    this.sheetCloseIcon,
    this.onSheetToggle,
    this.sheetIconRotateAngle,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedItemGradient,
    this.unselectedItemGradient,
    this.sheetOpenIconBoxColor,
    this.sheetCloseIconBoxColor,
    this.sheetOpenIconColor,
    this.sheetCloseIconColor,
    this.depth = 40,
    this.spread = 100,
    this.emboss = true,
  })  : assert(items.length >= 2 && items.length <= 5,
            "There must be at least 2 and at most 5 items!"),
        assert(
          (items.length % 2 == 0 && sheet != null) || sheet == null,
          "Please add either 2 or 4 items with sheet!",
        );

  @override
  State<ClayBottomNavNSheet> createState() => _ClayBottomNavNSheetState();
}

class _ClayBottomNavNSheetState extends State<ClayBottomNavNSheet>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _animationController;
  late double _animValue = 0.0;
  bool _sheetOpen = false;

  PersistentBottomSheetController? _bottomSheetController;

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  _onSheetToggle(bool value) {
    setState(() {
      _sheetOpen = value;
    });
    if (widget.onSheetToggle != null) widget.onSheetToggle!(value);
  }

  _showBottomSheet() {
    if (_sheetOpen) {
      Scaffold.of(context).showBodyScrim(false, 0.0);
      _bottomSheetController?.close();
      return;
    }
    _onSheetToggle(true);
    _animationController.reset();
    _animationController.animateTo(1.0);
    _bottomSheetController = Scaffold.of(context).showBottomSheet(
      (_) => Transform.translate(
        offset: const Offset(0, 96),
        child: widget.sheet!,
      ),
      backgroundColor: Colors.transparent,
      transitionAnimationController: _animationController,
    )..closed.whenComplete(() {
        _animationController.animateBack(0.0).then((value) {
          _onSheetToggle(false);
        });
      });
  }

  _initAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animationController.addListener(() {
      setState(() {
        _animValue = _animationController.value;
      });
    });
  }

  @override
  void initState() {
    _initAnimation();
    _selectedIndex = widget.initialSelectedIndex;
    super.initState();
  }

  List<double> get padding => widget.items.length == 2
      ? [35.0, 35.0]
      : widget.items.length == 3
          ? [35.0, 25.0, 35.0]
          : widget.items.length == 4
              ? [35.0, 30.0, 30.0, 35.0]
              : [35.0, 30.0, 25.0, 30.0, 35.0];

  @override
  Widget build(BuildContext context) {
    List<ClayBottomNavItem> _items = widget.items;
    var theme = Theme.of(context);
    var items = <Widget>[];

    for (var item in _items) {
      var i = _items.indexOf(item);
      items.add(Expanded(
        child: _ClayBottomNavItem(
          icon: item.icon,
          activeIcon: item.activeIcon,
          // label: item.label,
          hide: _sheetOpen,
          selectedItemColor: widget.selectedItemColor,
          unselectedItemColor: widget.unselectedItemColor,
          selectedItemGradient: widget.selectedItemGradient,
          unselectedItemGradient: widget.unselectedItemGradient,
          padding: EdgeInsets.only(top: padding[i]),
          selected: _selectedIndex == i,
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!(i);
              setState(() {
                _selectedIndex = i;
              });
            }
          },
        ),
      ));
    }

    var openIcon = widget.sheetOpenIcon ?? Icons.add;
    var iconBg = _sheetOpen
        ? widget.sheetOpenIconBoxColor
        : widget.sheetCloseIconBoxColor ?? widget.sheetOpenIconBoxColor;
    var iconFg = _sheetOpen
        ? widget.sheetOpenIconColor
        : widget.sheetCloseIconColor ?? widget.sheetOpenIconColor;
    var fab = Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Transform.rotate(
          angle:
              _animValue * (pi / 180) * (widget.sheetIconRotateAngle ?? 45.0),
          child: _SheetToggleButton(
            onTap: () => _showBottomSheet(),
            backgroundColor: iconBg,
            parentColor: widget.backgroundColor,
            icon: _sheetOpen ? widget.sheetCloseIcon ?? openIcon : openIcon,
            foregroundColor: iconFg,
            decoration: widget.sheetToggleDecoration,
            isOpen: _sheetOpen,
          ),
        ),
      ),
    );

    if (widget.sheet != null) {
      if (_items.length == 2) {
        items.insert(1, fab);
      } else if (_items.length == 4) {
        items.insert(2, fab);
      }
    }

    var bgColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surface;

    var gradientColors = widget.borderColors ??
        [
          Colors.transparent,
          Colors.transparent,
          Colors.transparent,
        ];

    CustomPainter painter = _BottomPainterPlain(gradientColors);
    CustomClipper<Path> clipper = _BottomClipperPlain();

    if (widget.sheet != null) {
      painter = _BottomPainter(
        gradientColors,
        value: max(10, _animValue * 30),
      );
      clipper = _BottomClipper(
        value: max(10, _animValue * 30),
      );
    }

    final parentColorValue =
        widget.parentColor ?? Theme.of(context).colorScheme.surface;
    var shadowList = <BoxShadow>[
      BoxShadow(
        color: parentColorValue.withOpacity(0.3),
        offset: Offset(-widget.spread.toDouble(), -widget.spread.toDouble()),
        blurRadius: widget.spread.toDouble(),
      ),
      BoxShadow(
        color: parentColorValue.withOpacity(0.3),
        offset: Offset(widget.spread.toDouble(), widget.spread.toDouble()),
        blurRadius: widget.spread.toDouble(),
      ),
    ];

    return SizedBox(
      height: 160,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: -40,
            child: CustomPaint(
              painter: painter,
              child: SizedBox(
                height: 140,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -20,
            child: ClipShadowPath(
              clipper: clipper,
              shadow: shadowList,
              child: Material(
                color: bgColor,
                elevation: widget.depth.toDouble(),
                shadowColor: Colors.black.withOpacity(0.3),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: MediaQuery.of(context).padding.bottom + 24
                  ),
                  child: Material(
                    color: Colors.transparent,
                    clipBehavior: Clip.none,
                    type: MaterialType.transparency,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: items,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClayBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final List<ClayBottomNavItem> items;
  final ValueChanged<int> onItemSelected;

  const ClayBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = selectedIndex == index;

            return Expanded(
              child: ClayContainer(
                color: theme.colorScheme.surface,
                parentColor: theme.colorScheme.surface,
                spread: 2,
                depth: isSelected ? -20 : 20,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onItemSelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Icon(
                        isSelected && item.activeIcon != null ? item.activeIcon! : item.icon,
                        color: isSelected
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                        size: isSelected ? 24 : 21,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
