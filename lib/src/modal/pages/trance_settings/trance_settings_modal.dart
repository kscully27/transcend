import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/trance_settings/modal_page_definitions.dart';
import 'package:trancend/src/modal/pages/trance_settings/root_page.dart';
import 'package:trancend/src/modal/pages/trance_settings/modality_select_page.dart';
import 'package:trancend/src/modal/pages/trance_settings/settings_page.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A class to handle the trance settings modal
class TranceSettingsModal {
  const TranceSettingsModal._();

  /// Show the trance settings modal
  static Future<void> show(BuildContext context) async {
    // Create a provider scope to isolate the modal's state
    final pageIndexNotifier = ValueNotifier<int>(PageIndices.rootPage);
    
    final pageListBuilderNotifier = ValueNotifier<WoltModalSheetPageListBuilder>(
      (context) => [
        // Root page (intention selection)
        RootPage.build(context),
        
        // Modality selection page
        ModalitySelectPage.build(context),
        
        // Settings page
        SettingsPage.build(context),
      ]
    );
    
    await Navigator.of(context).push(
      WoltModalSheetRoute(
        pageIndexNotifier: pageIndexNotifier,
        pageListBuilderNotifier: pageListBuilderNotifier,
        onModalDismissedWithBarrierTap: () {
          Navigator.of(context).pop();
        },
        onModalDismissedWithDrag: () {
          Navigator.of(context).pop();
        },
        modalBarrierColor: Colors.black.withOpacity(0.1),
        barrierDismissible: true,
        enableDrag: true,
        useSafeArea: true,
        pageContentDecorator: (child) => GlassContainer(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: child,
        ),
      ),
    );
  }
} 