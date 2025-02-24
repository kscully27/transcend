import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Provider for the modal sheet page index
final modalPageIndexProvider = Provider<ValueNotifier<int>>((ref) {
  return ValueNotifier<int>(0);
});

/// Provider for the modal sheet page list builder
final modalPageListBuilderProvider = Provider<ValueNotifier<WoltModalSheetPageListBuilder>>((ref) {
  return ValueNotifier<WoltModalSheetPageListBuilder>((context) => []);
}); 