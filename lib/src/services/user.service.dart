import 'package:get/get.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends GetxController {
  static UserService get to => Get.find();
  
  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  void setUser(User? user) {
    _currentUser.value = user;
  }

  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void clearUser() {
    _currentUser.value = null;
  }

  // Helper method to update specific user fields
  void updateUser(Map<String, dynamic> updates) {
    if (_currentUser.value != null) {
      final updatedUser = User.fromMap({
        ..._currentUser.value!.toJson(),
        ...updates,
      });
      _currentUser.value = updatedUser;
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