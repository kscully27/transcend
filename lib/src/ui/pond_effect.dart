import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class PondEffect extends StatefulWidget {
  final Widget child;
  final Size size;

  const PondEffect({required this.child, required this.size, Key? key}) : super(key: key);

  @override
  PondEffectState createState() => PondEffectState();
}

class PondEffectState extends State<PondEffect> with SingleTickerProviderStateMixin {
  FragmentShader? shader;
  late final AnimationController _controller;
  Offset? _lastTapPosition;
  ui.Image? _texture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      setState(() {});
    });
    _loadShader();
    _captureBackground();
  }

  Future<void> _loadShader() async {
    try {
      print('Loading shader...');
      final program = await FragmentProgram.fromAsset('shaders/pond_effect.frag');
      print('Shader program loaded');
      if (!mounted) return;
      setState(() {
        shader = program.fragmentShader();
        _isLoading = false;
        print('Shader initialized and ready');
        _controller.repeat();
      });
    } catch (e, stack) {
      print('Error loading shader: $e');
      print('Stack trace: $stack');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _captureBackground() async {
    try {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Draw the background gradient
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const ui.Color.fromARGB(255, 231, 118, 87), const ui.Color.fromARGB(255, 186, 77, 71)],
        ).createShader(Offset.zero & widget.size);
      
      canvas.drawRect(Offset.zero & widget.size, paint);
      
      final picture = recorder.endRecording();
      _texture = await picture.toImage(
        widget.size.width.round(),
        widget.size.height.round(),
      );
      
      if (mounted) setState(() {});
    } catch (e) {
      print('Error capturing background: $e');
    }
  }

  void click(int x, int y) {
    print('Click at ($x, $y)');
    if (shader == null) {
      print('Shader is null, cannot process click');
      return;
    }
    setState(() {
      _lastTapPosition = Offset(x.toDouble(), y.toDouble());
      print('Updated tap position to $_lastTapPosition');
      // Reset and start the animation
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _texture?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        click(details.localPosition.dx.toInt(), details.localPosition.dy.toInt());
      },
      child: Stack(
        children: [
          widget.child,
          if (!_isLoading && shader != null && _texture != null)
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  size: widget.size,
                  painter: ShaderPainter(
                    shader: shader!,
                    time: _controller.value,
                    resolution: widget.size,
                    mousePosition: _lastTapPosition ?? Offset.zero,
                    texture: _texture!,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final Size resolution;
  final Offset mousePosition;
  final ui.Image texture;

  ShaderPainter({
    required this.shader,
    required this.time,
    required this.resolution,
    required this.mousePosition,
    required this.texture,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, resolution.width)
      ..setFloat(1, resolution.height)
      ..setFloat(2, mousePosition.dx)
      ..setFloat(3, mousePosition.dy)
      ..setFloat(4, time)
      ..setImageSampler(0, texture);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) =>
      time != oldDelegate.time || mousePosition != oldDelegate.mousePosition;
}

class Ripple {
  final double x;
  final double y;
  double progress;

  Ripple({
    required this.x,
    required this.y,
    required this.progress,
  });
}

class RipplePainter extends CustomPainter {
  final List<Ripple> ripples;

  RipplePainter({required this.ripples});

  @override
  void paint(Canvas canvas, Size size) {
    for (var ripple in ripples) {
      final paint = Paint()
        ..color = Colors.white.withOpacity((1 - ripple.progress) * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final maxRadius = size.width * 0.4;  // Larger radius
      final radius = maxRadius * ripple.progress;
      
      // Draw multiple circles for each ripple
      for (var i = 0; i < 3; i++) {
        final innerRadius = radius - (i * 10);
        if (innerRadius > 0) {
          canvas.drawCircle(
            Offset(ripple.x, ripple.y),
            innerRadius,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => true;
}

class ShaderWidget extends SingleChildRenderObjectWidget {
  final img.Image waveOverlay;
  final Size canvasSize;
  final Size? fullSize;

  ShaderWidget(
      {Widget? child,
      this.fullSize,
      required this.canvasSize,
      required this.waveOverlay})
      : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderShader(canvasSize: canvasSize, fullSize: fullSize);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    (renderObject as RenderShader).waveChanged(waveOverlay);
  }
}

class RenderShader extends RenderProxyBox {
  late img.Image _editableImage;
  ui.Image? drawImage;
  Size canvasSize;
  Rect? srcRect;
  final Size? fullSize;

  RenderShader({required this.canvasSize, this.fullSize, RenderBox? renderBox})
      : super(renderBox) {
    _editableImage = img.Image(
        width: canvasSize.width.round(),
        height: canvasSize.height.round());
    srcRect = Offset.zero & canvasSize;
  }

  void waveChanged(img.Image overlay) {
    _editableImage = overlay;
    drawCurrent();
  }

  drawCurrent() {
    ui.decodeImageFromPixels(
        _editableImage.getBytes(),
        canvasSize.width.round(),
        canvasSize.height.round(),
        ui.PixelFormat.rgba8888, (result) {
      drawImage = result;
      markNeedsPaint();
    });
  }

  final painter = Paint()
    ..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2)
    ..colorFilter = ColorFilter.mode(
      Colors.white.withOpacity(0.3),
      BlendMode.srcOver,
    )
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);
    if (drawImage != null) {
      context.canvas.saveLayer(offset & (fullSize ?? size), Paint());
      context.canvas.drawImageRect(
          drawImage!, srcRect!, Offset.zero & (fullSize ?? size), painter);
      context.canvas.restore();
    }
  }
}

Color colorFromABGR(int value) {
  final alpha = value & 0xff000000;
  final blue = value & 0x00ff0000;
  final green = value & 0x0000ff00;
  final red = value & 0x000000ff;
  return Color.fromARGB(alpha, red, green, blue);
}
