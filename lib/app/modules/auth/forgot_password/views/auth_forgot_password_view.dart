import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_forgot_password_controller.dart';

class AuthForgotPasswordView extends GetView<AuthForgotPasswordController> {
  const AuthForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthForgotPasswordView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthForgotPasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
