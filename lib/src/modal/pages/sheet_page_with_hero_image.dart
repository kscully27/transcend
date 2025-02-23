import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/ui/wolt/button/wolt_elevated_button.dart';
import 'package:trancend/src/ui/wolt/button/wolt_modal_sheet_back_button.dart';
import 'package:trancend/src/ui/wolt/button/wolt_modal_sheet_close_button.dart';
import 'package:trancend/src/ui/wolt/text/modal_sheet_content_text.dart';
import 'package:trancend/src/ui/wolt/text/modal_sheet_title.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithHeroImage {
  const SheetPageWithHeroImage._();

  static WoltModalSheetPage build(
    BuildContext context, {
    required int currentPage,
    bool isLastPage = true,
  }) {
    final container = ProviderScope.containerOf(context);
    final routerNotifier = container.read(routerProvider.notifier);
    
    return WoltModalSheetPage(
      heroImage: const Image(
        image: AssetImage('lib/assets/images/hero_image.jpg'),
        fit: BoxFit.cover,
      ),
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: isLastPage
              ? routerNotifier.closeSheet
              : () => routerNotifier.goToPage(currentPage + 1),
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      pageTitle: const ModalSheetTitle('Page with a hero image'),
      leadingNavBarWidget: WoltModalSheetBackButton(
        onBackPressed: () => routerNotifier.goToPage(currentPage - 1),
      ),
      trailingNavBarWidget:
          WoltModalSheetCloseButton(onClosed: routerNotifier.closeSheet),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 80, top: 16, right: 16, left: 16),
        child: ModalSheetContentText('''
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
'''),
      ),
    );
  }
}
