import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/ui/wolt/button/wolt_elevated_button.dart';
import 'package:trancend/src/ui/wolt/button/wolt_modal_sheet_back_button.dart';
import 'package:trancend/src/ui/wolt/button/wolt_modal_sheet_close_button.dart';
import 'package:trancend/src/ui/wolt/text/modal_sheet_title.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithLazyList {
  const SheetPageWithLazyList._();

  static SliverWoltModalSheetPage build(
    BuildContext context, {
    required int currentPage,
    bool isLastPage = true,
  }) {
    final colors = allMaterialColors;
    const titleText = 'Material Colors';
    final container = ProviderScope.containerOf(context);
    final routerNotifier = container.read(routerProvider.notifier);
    
    return SliverWoltModalSheetPage(
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: isLastPage
              ? routerNotifier.closeSheet
              : () => routerNotifier.goToPage(currentPage + 1),
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      heroImage: const Image(
        image: AssetImage('lib/assets/images/material_colors_hero.png'),
        fit: BoxFit.cover,
      ),
      pageTitle: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ModalSheetTitle(titleText),
      ),
      leadingNavBarWidget: WoltModalSheetBackButton(
        onBackPressed: () => routerNotifier.goToPage(currentPage - 1),
      ),
      trailingNavBarWidget:
          WoltModalSheetCloseButton(onClosed: routerNotifier.closeSheet),
      mainContentSliversBuilder: (context) => [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              if (index == 0) {
                return const _HorizontalPrimaryColorList();
              }
              return ColorTile(color: colors[index - 1]);
            },
            childCount: colors.length + 1,
          ),
        ),
      ],
    );
  }
}

class _HorizontalPrimaryColorList extends StatelessWidget {
  const _HorizontalPrimaryColorList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (Color color in Colors.primaries)
            Container(color: color, height: 100, width: 33),
        ],
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final Color color;

  const ColorTile({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 100,
      child: Center(
        child: Text(
          color.toString(),
          style: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

List<Color> get allMaterialColors {
  List<Color> allMaterialColorsWithShades = [];

  for (MaterialColor color in Colors.primaries) {
    allMaterialColorsWithShades.add(color.shade100);
    allMaterialColorsWithShades.add(color.shade200);
    allMaterialColorsWithShades.add(color.shade300);
    allMaterialColorsWithShades.add(color.shade400);
    allMaterialColorsWithShades.add(color.shade500);
    allMaterialColorsWithShades.add(color.shade600);
    allMaterialColorsWithShades.add(color.shade700);
    allMaterialColorsWithShades.add(color.shade800);
    allMaterialColorsWithShades.add(color.shade900);
  }
  return allMaterialColorsWithShades;
}
