import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/ui/wolt/button/wolt_elevated_button.dart';
import 'package:trancend/src/ui/wolt/button/wolt_modal_sheet_back_button.dart';
import 'package:trancend/src/ui/wolt/button/wolt_modal_sheet_close_button.dart';
import 'package:trancend/src/ui/wolt/text/modal_sheet_title.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithTextField {
  const SheetPageWithTextField._();

  static WoltModalSheetPage build(
    BuildContext context, {
    required int currentPage,
    bool isLastPage = true,
  }) {
    ValueNotifier<bool> isButtonEnabledNotifier = ValueNotifier(false);
    final textEditingController = TextEditingController();
    textEditingController.addListener(() {
      isButtonEnabledNotifier.value = textEditingController.text.isNotEmpty;
    });
    final container = ProviderScope.containerOf(context);
    final routerNotifier = container.read(routerProvider.notifier);
    
    return WoltModalSheetPage(
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (_, isEnabled, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: isLastPage
                  ? routerNotifier.closeSheet
                  : () => routerNotifier.goToPage(currentPage + 1),
              enabled: isEnabled,
              child: Text(
                !isEnabled
                    ? "Fill the text field to enable"
                    : (isLastPage ? "Submit" : "Next"),
              ),
            ),
          );
        },
      ),
      hasTopBarLayer: false,
      pageTitle: const ModalSheetTitle('Page with text field'),
      isTopBarLayerAlwaysVisible: true,
      leadingNavBarWidget: WoltModalSheetBackButton(
        onBackPressed: () => routerNotifier.goToPage(currentPage - 1),
      ),
      trailingNavBarWidget:
          WoltModalSheetCloseButton(onClosed: routerNotifier.closeSheet),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type something...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
