import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class AuthOtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  final isLoading = false.obs;
  final resendCooldown = 0.obs;

  String _generatedOtp = '';

  String get email {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    return args['email'] as String? ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    _sendOtp();
  }

  String _generateOtp() {
    final random = Random();
    return List.generate(4, (_) => random.nextInt(10).toString()).join();
  }

  Future<void> _sendOtp() async {
    _generatedOtp = _generateOtp();

    _startResendCooldown();
  }

  void onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpCode => otpControllers.map((c) => c.text).join();

  Future<void> onConfirmPressed() async {
    if (_otpCode.length < 4) {
      _showError('Please enter the complete 4-digit code');
      return;
    }

    isLoading.value = true;
    try {
      if (_otpCode == _generatedOtp) {
        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(
          Routes.AUTH_FORGOT_PASSWORD,
          arguments: {'step': 'reset', 'email': email},
        );
      } else {
        _showError('Invalid OTP. Please try again');
      }
    } catch (_) {
      _showError('Something went wrong. Try again');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onResendPressed() async {
    if (resendCooldown.value > 0) return;

    isLoading.value = true;
    try {
      await _sendOtp();
      _showSuccess('OTP resent successfully!');
      for (final c in otpControllers) c.clear();
      focusNodes[0].requestFocus();
    } catch (_) {
      _showError('Failed to resend OTP. Try again');
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendCooldown() {
    resendCooldown.value = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
        return true;
      }
      return false;
    });
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

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF22C55E),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    for (final c in otpControllers) c.dispose();
    for (final f in focusNodes) f.dispose();
    super.onClose();
  }
}
