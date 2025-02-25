import 'package:flutter/material.dart';

/// Helper class for handling modal transitions with proper delay and error handling
class ModalNavigationHelper {
  ModalNavigationHelper._(); // Private constructor to prevent instantiation
  
  /// Standard delay for modal transitions
  static const Duration standardDelay = Duration(milliseconds: 300);
  
  /// Navigate after a modal is closed, with a proper delay to allow animations to complete
  /// 
  /// [context] - The current build context
  /// [navigationAction] - The action to perform after the delay
  /// [delay] - The delay to wait before navigation (defaults to 300ms)
  static Future<void> navigateAfterModalClose({
    required BuildContext context,
    required Function() navigationAction,
    Duration? delay,
  }) async {
    // Close the modal if it's open
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    
    // Wait for the specified delay
    await Future.delayed(delay ?? standardDelay);
    
    // Check if context is still valid after delay
    if (context.mounted) {
      try {
        // Execute the navigation action
        navigationAction();
      } catch (e) {
        debugPrint('Error navigating after modal close: $e');
      }
    }
  }
  
  /// Executes an action safely with error handling
  /// 
  /// [action] - The action to execute
  /// [errorMessage] - Message to log if an error occurs
  static void safeExecution(Function() action, [String? errorMessage]) {
    try {
      action();
    } catch (e) {
      debugPrint('${errorMessage ?? 'Error in navigation action'}: $e');
    }
  }
} 