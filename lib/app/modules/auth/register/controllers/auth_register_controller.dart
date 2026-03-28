import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class AuthRegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get _role {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    return args['role'] as String? ?? 'jobseeker';
  }

  void toggleObscurePassword() => obscurePassword.toggle();
  void toggleObscureConfirm() => obscureConfirm.toggle();

  Future<void> onSignUpPressed() async {
    if (!_isValid()) return;

    isLoading.value = true;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _saveUserToFirestore(credential.user!.uid);

      _navigateAfterRegister();
    } on FirebaseAuthException catch (e) {
      _showError(_mapFirebaseError(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  void onLoginPressed() => Get.back();

  bool _isValid() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      _showError('Please fill all fields');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      _showError('Please enter a valid email');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showError('Passwords do not match');
      return false;
    }
    if (passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return false;
    }
    return true;
  }

  Future<void> _saveUserToFirestore(String uid) async {
    final collection = _role == 'company' ? 'companies' : 'jobSeekers';
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': emailController.text.trim(),
      'role': _role,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection(collection).doc(uid).set({
      'uid': uid,
      'email': emailController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _navigateAfterRegister() {
    if (_role == 'company') {
      Get.offAllNamed(Routes.COMPANY_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.JOB_SEEKER_DASHBOARD);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
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
    confirmPasswordController.dispose();
    super.onClose();
  }
}
