import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeSlider extends StatefulWidget {
  final List<int> values;
  final String delimiter;
  final Color color;
  final Function(int) onValueChanged;
  final double height;

  const TimeSlider({
    super.key,
    this.values = const [3, 5, 8, 10, 15, 20, 25, 30],
    this.delimiter = 'min',
    required this.color,
    required this.onValueChanged,
    this.height = 120,
  });

  @override
  State<TimeSlider> createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  late PageController _pageController;
  late int _selectedValue;
  double _itemWidth = 80.0;

  @override
  void initState() {
    super.initState();
    final initialPage = widget.values.length ~/ 2;
    _selectedValue = widget.values[initialPage];
    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 1 / 6,
    );
  }

  void _handlePageChanged(int page) {
    if (page >= 0 && page < widget.values.length) {
      setState(() {
        _selectedValue = widget.values[page];
      });
      widget.onValueChanged(_selectedValue);
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Selected time display
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '$_selectedValue ${widget.delimiter}',
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Center indicator line
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 4,
                  height: widget.height * 0.4,
                  color: widget.color,
                  margin: const EdgeInsets.only(top: 50),
                ),
              ),
              // Scrollable ticks
              Positioned(
                top: widget.height * 0.5 - 10,
                bottom: 0,
                left: 0,
                right: 0,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        widget.color,
                        widget.color,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.15, 0.85, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _handlePageChanged,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.values.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          width: 2,
                          height: 20,
                          color: widget.color,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
