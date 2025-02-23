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
      heroImage: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 200,
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Icon(
            Icons.color_lens,
            size: 64,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
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
  const ColorTile({
    required this.color,
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: color,
    );
  }
}

List<Color> get allMaterialColors => [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];
