import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:hire_me/app/services/storage_service.dart';

class AuthLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = StorageService.to;

  void toggleObscure() => obscurePassword.toggle();
  void toggleRememberMe() => rememberMe.toggle();

  Future<void> onSignInPressed() async {
    if (!_isValid()) return;

    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await _navigateAfterLogin();
    } on FirebaseAuthException catch (e) {
      _showError(_mapFirebaseError(e.code));
    } catch (_) {
      await _auth.signOut();
      await _storage.clearAuthSession();
      _showError('Unable to complete sign in');
    } finally {
      isLoading.value = false;
    }
  }

  void onForgotPasswordPressed() {
    Get.toNamed(Routes.AUTH_FORGOT_PASSWORD);
  }

  void onCreateAccountPressed() {
    Get.toNamed(Routes.AUTH_SELECT_USER);
  }

  bool _isValid() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showError('Please fill all fields');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      _showError('Please enter a valid email');
      return false;
    }
    return true;
  }

  Future<void> _navigateAfterLogin() async {
    final user = _auth.currentUser;

    if (user == null) {
      _showError('Unable to complete sign in');
      return;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final role = StorageService.normalizeRole(doc.data()?['role'] as String?);

    if (role == null) {
      await _auth.signOut();
      await _storage.clearAuthSession();
      _showError('No valid role was found for this account');
      return;
    }

    await _storage.saveAuthSession(
      userId: user.uid,
      role: role,
      accessToken: await user.getIdToken(),
      companyId: role == AppUserRole.company.value ? user.uid : null,
      jobSeekerId: role == AppUserRole.job_seeker.value ? user.uid : null,
    );

    if (role == AppUserRole.company.value) {
      Get.offAllNamed(Routes.COMPANY_MAIN_WRAPPER);
    } else {
      Get.offAllNamed(Routes.MAIN_WRAPPER);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Something went wrong. Please try again';
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
