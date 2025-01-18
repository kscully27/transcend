library;

import 'dart:math' show max, pi, sqrt;

import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/utils/clay_utils.dart';
import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass_bottom_sheet.dart';

part 'clay_bottom_nav_item.dart';
part 'bottom_clipper.dart';
part 'bottom_painter.dart';
part 'sheet_toggle_button.dart';

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
          bgColor.withOpacity(0.8),
          Theme.of(context).colorScheme.primary.withOpacity(0.6),
          bgColor.withOpacity(0.8),
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
        color: ClayUtils.getAdjustColor(
          parentColorValue,
          widget.emboss ? 0 - widget.depth : widget.depth,
        ).withOpacity(0.3),
        offset:
            Offset(0 - widget.spread.toDouble(), 0 - widget.spread.toDouble()),
        blurRadius: widget.spread.toDouble(),
      ),
      BoxShadow(
        color: ClayUtils.getAdjustColor(
          parentColorValue,
          widget.emboss ? widget.depth : 0 - widget.depth,
        ).withOpacity(0.3),
        offset: Offset(widget.spread.toDouble(), widget.spread.toDouble()),
        blurRadius: widget.spread.toDouble(),
      ),
    ];

    return SizedBox(
      height: 96,
      child: Stack(
        children: [
          CustomPaint(
            painter: painter,
            child: Container(),
          ),
          ClipShadowPath(
            clipper: clipper,
            shadow: shadowList,
            // shadow: Shadow(
            //   color: Colors.white.withOpacity(0.6),
            //   offset: Offset(-5, -5),
            //   blurRadius: 16,
            //   // spreadRadius: 1,
            // ),
            child: ClayAnimatedContainer(
              color: bgColor,
              parentColor: bgColor,
              spread: 20,
              depth: 20,
              borderRadius: 0,
              width: double.infinity,
              duration: const Duration(milliseconds: 300),
              height: 96,
              surfaceColor: bgColor,
              curveType: CurveType.concave,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
