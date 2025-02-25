import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A base class for state notifiers that safely handles state updates
/// to prevent errors when the notifier is disposed or during build
class SafeStateNotifier<T> extends StateNotifier<T> {
  SafeStateNotifier(T state) : super(state) {
    _isSafeToUse = true;
  }
  
  /// Tracks if it's safe to update the state
  bool _isSafeToUse = true;
  
  /// Whether the notifier is currently in an async update operation
  bool _isUpdating = false;
  
  /// Safely updates the state if the notifier is still mounted and safe to use
  @protected
  void safeUpdateState(T newState) {
    if (!mounted || !_isSafeToUse) return;
    try {
      state = newState;
    } catch (e) {
      debugPrint('Error updating state: $e');
      // Don't rethrow to prevent crashes
    }
  }
  
  /// Safely executes an async operation, preventing concurrent operations
  /// and checking if the notifier is still mounted before updating state
  @protected
  Future<void> safeAsyncUpdate(Future<void> Function() updateFn) async {
    if (!mounted || !_isSafeToUse || _isUpdating) return;
    
    _isUpdating = true;
    try {
      await updateFn();
    } catch (e) {
      debugPrint('Error in async update: $e');
    } finally {
      if (mounted && _isSafeToUse) {
        _isUpdating = false;
      }
    }
  }
  
  @override
  void dispose() {
    _isSafeToUse = false;
    super.dispose();
  }
} 