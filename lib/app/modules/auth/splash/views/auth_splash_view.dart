import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_splash_controller.dart';

class AuthSplashView extends GetView<AuthSplashController> {
  const AuthSplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthSplashView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthSplashView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
