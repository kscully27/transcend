import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/models/trance.model.dart';
import 'package:trancend/src/ui/glass_bottom_sheet.dart';
import 'package:trancend/src/ui/glass_button.dart';
import 'package:trancend/src/trance/trance_player.dart';

Color baseColor = const Color(0xFFD59074);

class TopicItem extends StatefulWidget {
  const TopicItem({
    super.key, 
    required this.topic,
    required this.index,
    required this.shouldAnimate,
    required this.isFavorite,
    required this.onFavoritePressed,
  }); 
  
  final Topic topic;
  final int index;
  final bool shouldAnimate;
  final bool isFavorite;
  final Function() onFavoritePressed;
  @override
  State<TopicItem> createState() => _TopicItemState();
}

class _TopicItemState extends State<TopicItem> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isEmbossed = false;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    if (widget.shouldAnimate) {
      Future.delayed(Duration(milliseconds: widget.index * 200), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else {
      _animationController.value = 1.0;  // Immediately show at final position
    }
  }

  @override
  void didUpdateWidget(TopicItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reset animation if shouldAnimate changes to true
    if (widget.shouldAnimate && !oldWidget.shouldAnimate) {
      _animationController.reset();
      Future.delayed(Duration(milliseconds: widget.index * 200), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleButtonPressed(Topic topic) {
    setState(() {
      _isEmbossed = !_isEmbossed;
    });
    
    GlassBottomSheet.show(
      context: context,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  topic.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                GlassButton(
                  text: widget.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                  icon: widget.isFavorite ? Remix.heart_fill : Remix.heart_line,
                  width: double.infinity,
                  variant: GlassButtonVariant.text,
                  size: GlassButtonSize.xsmall,
                  align: GlassButtonAlign.center,
                  onPressed: () {
                    widget.onFavoritePressed();
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 32,
                  thickness: 1,
                  color: Colors.black26,
                ),
                GlassButton(
                  text: "Start Session",
                  height: 80,
                  icon: Remix.play_fill,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet first
                    Future.microtask(() {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => TrancePlayer(
                            topic: widget.topic,
                            tranceMethod: session.TranceMethod.Hypnotherapy,
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.easeOutCubic;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _isEmbossed = !_isEmbossed;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _fullWidth = _width > 70 ? 70 : _width;
    final topic = widget.topic;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTap: () => _handleButtonPressed(topic),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: ClayContainer(
                  color: baseColor,
                  borderRadius: 20,
                  height: 120,
                  width: 400,
                  curveType: !_isEmbossed ? CurveType.concave : CurveType.none,
                  spread: _isEmbossed ? 3 : 5,
                  depth: _isEmbossed ? 30 :15,
                  emboss: _isEmbossed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          width: 180,
                          child: ClayText(
                            topic.title,
                            emboss: _isEmbossed,
                            size: 24,
                            parentColor: baseColor,
                            textColor: !_isEmbossed ? Colors.white : AppColors.shadow(topic.appColor),
                            color: baseColor,
                            spread: 2,
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                            ClayContainer(
                              surfaceColor: _isEmbossed ?  AppColors.dark(topic.appColor) : AppColors.light(topic.appColor),
                              parentColor: baseColor,
                              emboss: _isEmbossed,
                              spread: 8,
                              depth: 8,
                              curveType: CurveType.concave,
                              width: 100,
                              height: double.infinity,
                              customBorderRadius: BorderRadius.only(
                                topRight: Radius.elliptical(16, 16),
                                bottomRight: Radius.elliptical(16, 16),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 14),
                              child: Center(
                                child: SvgPicture.network(
                                  topic.svg,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                  color: AppColors.flat(topic.appColor),
                                  width: _fullWidth,
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
            ),
          ),
        );
      },
    );
  }
} 