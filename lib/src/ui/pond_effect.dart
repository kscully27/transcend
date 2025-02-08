import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

class PondEffect extends StatefulWidget {
  final Widget child;
  final Size size;
  final Color? color1;
  final Color? color2;

  const PondEffect(
      {required this.child,
      required this.size,
      this.color1,
      this.color2,
      super.key});

  @override
  PondEffectState createState() => PondEffectState();
}

class PondEffectState extends State<PondEffect>
    with SingleTickerProviderStateMixin {
  FragmentShader? shader;
  late final AnimationController _controller;
  Offset _lastTapPosition = Offset.zero;
  ui.Image? _texture;
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _initializeEffect();
  }

  Future<void> _initializeEffect() async {
    await _loadShader();
    if (!_isDisposed) {
      await _captureBackground();
    }
  }

  Future<void> _loadShader() async {
    if (_isDisposed) return;

    try {
      print('Loading shader...');
      final program =
          await FragmentProgram.fromAsset('shaders/pond_effect.frag');
      if (_isDisposed) return;

      print('Shader program loaded');
      setState(() {
        shader = program.fragmentShader();
        _isLoading = false;
        print('Shader initialized and ready');
      });
    } catch (e, stack) {
      if (_isDisposed) return;
      print('Error loading shader: $e');
      print('Stack trace: $stack');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _captureBackground() async {
    if (_isDisposed) return;

    try {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.22, 0.7], // Second color starts at 30% from top
          colors: [
            widget.color1 ?? const ui.Color.fromARGB(255, 232, 122, 92),
            widget.color2 ?? const ui.Color.fromARGB(255, 226, 116, 97)
          ],
        ).createShader(Offset(0, -120) & widget.size);

      canvas.drawRect(Offset.zero & widget.size, paint);

      final picture = recorder.endRecording();
      _texture = await picture.toImage(
        widget.size.width.round(),
        widget.size.height.round(),
      );

      if (!_isDisposed) {
        setState(() {});
      }
    } catch (e) {
      print('Error capturing background: $e');
    }
  }

  void click(int x, int y) {
    if (_isDisposed || shader == null) return;
    
    _lastTapPosition = Offset(x.toDouble(), y.toDouble());
    _controller
      ..reset()
      ..forward();
      
    setState(() {});
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    _texture?.dispose();
    shader = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) return widget.child;

    return Stack(
      children: [
        widget.child,
        if (!_isLoading && shader != null && _texture != null)
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: widget.size,
                    painter: ShaderPainter(
                      shader: shader!,
                      time: _controller.value,
                      resolution: widget.size,
                      mousePosition: _controller.isAnimating ? _lastTapPosition : Offset.zero,
                      texture: _texture!,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
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
      ..setFloat(2, mousePosition == Offset.zero ? -1000 : mousePosition.dx)
      ..setFloat(3, mousePosition == Offset.zero ? -1000 : mousePosition.dy)
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

      final maxRadius = size.width * 0.4; // Larger radius
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

  const ShaderWidget(
      {super.key, super.child,
      this.fullSize,
      required this.canvasSize,
      required this.waveOverlay});

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
        width: canvasSize.width.round(), height: canvasSize.height.round());
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
