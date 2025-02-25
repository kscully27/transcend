import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_settings_modal.dart';
import 'package:trancend/src/models/session.model.dart';

/// A provider wrapper for the trance settings modal
class TranceSettingsModalProvider {
  const TranceSettingsModalProvider._();

  /// Show the trance settings modal with a provider scope
  static Future<void> show(BuildContext context) async {
    // Use a ProviderScope to isolate the modal's state
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProviderScope(
            child: Builder(
              builder: (context) {
                // Show the modal inside the provider scope
                return Material(
                  type: MaterialType.transparency,
                  child: FutureBuilder(
                    future: Future.microtask(() {
                      // Use a microtask to ensure the widget tree is built
                      return TranceSettingsModal.show(context);
                    }),
                    builder: (context, snapshot) {
                      // Return an empty container that will be replaced by the modal
                      return Container();
                    },
                  ),
                );
              },
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }
} 