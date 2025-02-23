import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/ui/wolt/button/wolt_elevated_button.dart';
import 'package:trancend/src/ui/wolt/colors/wolt_colors.dart';
import 'package:trancend/src/ui/wolt/text/modal_sheet_title.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithForcedMaxHeight {
  const SheetPageWithForcedMaxHeight._();

  static WoltModalSheetPage build(
    BuildContext context, {
    required int currentPage,
    bool isLastPage = true,
  }) {
    final container = ProviderScope.containerOf(context);
    final routerNotifier = container.read(routerProvider.notifier);
    
    return WoltModalSheetPage(
      backgroundColor: WoltColors.green8,
      forceMaxHeight: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: isLastPage
              ? routerNotifier.closeSheet
              : () => routerNotifier.goToPage(currentPage + 1),
          colorName: WoltColorName.green,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      hasTopBarLayer: false,
      pageTitle: const ModalSheetTitle(
        'Page with forced max height and background color',
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
This page height is forced to be the max height according to the provided max height ratio regardless of the intrinsic height of the child widget. This page also doesn't have a top bar nor navigation bar controls. 
''',
        ),
      ),
    );
  }
}
