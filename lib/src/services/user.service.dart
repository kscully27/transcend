import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trancend/src/models/user.model.dart';

part 'user.service.g.dart';

@Riverpod(keepAlive: true)
class UserService extends _$UserService {
  User? _currentUser;
  bool _isLoading = false;

  @override
  Future<User?> build() async {
    return _currentUser;
  }

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  void setUser(User? user) {
    _currentUser = user;
    state = AsyncValue.data(user);
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    // Notify listeners if needed
    state = AsyncValue.data(_currentUser);
  }

  void clearUser() {
    _currentUser = null;
    state = const AsyncValue.data(null);
  }

  // Helper method to update specific user fields
  void updateUser(Map<String, dynamic> updates) {
    if (_currentUser != null) {
      final updatedUser = User.fromJson({
        ..._currentUser!.toJson(),
        ...updates,
      });
      _currentUser = updatedUser;
      state = AsyncValue.data(updatedUser);
    }
  }

  Future<void> saveEmailForSignIn(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailForSignIn', email);
  }

  Future<String?> getEmailForSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('emailForSignIn');
  }

  Future<void> clearEmailForSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('emailForSignIn');
  }
}

// Global provider to access the UserService instance
@Riverpod(keepAlive: true)
UserService userServiceInstance(UserServiceInstanceRef ref) {
  return ref.watch(userServiceProvider.notifier);
} 