import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/trance/trance_player.dart';
import 'package:trancend/src/ui/clay_button.dart';

class ClayTopicItem extends StatefulWidget {
  final Topic topic;
  final VoidCallback? onTap;
  final bool useGlass;

  const ClayTopicItem({
    super.key,
    required this.topic,
    this.onTap,
    this.useGlass = false,
  });

  @override
  State<ClayTopicItem> createState() => _ClayTopicItemState();
}

class _ClayTopicItemState extends State<ClayTopicItem> {
  final bool _isEmbossed = false;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _fullWidth = _width > 70 ? 70 : _width;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: ClayContainer(
          color: theme.colorScheme.surface,
          parentColor: theme.colorScheme.surface,
          borderRadius: 20,
          height: 120,
          width: 400,
          curveType: !_isEmbossed ? CurveType.concave : CurveType.none,
          spread: _isEmbossed ? 3 : 5,
          depth: _isEmbossed ? 10 : 15,
          emboss: _isEmbossed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: 180,
                  child: Text(
                    widget.topic.title,

                    style: GoogleFonts.titilliumWeb(
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                    // emboss: _isEmbossed,
                    // size: 20,
                    // parentColor: theme.colorScheme.surface,
                    // textColor: !_isEmbossed
                    //     ? theme.colorScheme.onSurface
                    //     : AppColors.themedWithContext(context, widget.topic.appColor, "flat", "flat"),
                    // color: theme.colorScheme.surface,
                    // spread: 2,
                    // style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    ClayContainer(
                      surfaceColor: AppColors.themedWithContext(
                          context, widget.topic.appColor, "light", "shadow"),
                      parentColor: theme.colorScheme.surface,
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
                          widget.topic.svg,
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter,
                          color: AppColors.themedWithContext(
                              context, widget.topic.appColor, "flat", "flat"),
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
    );
  }
}
