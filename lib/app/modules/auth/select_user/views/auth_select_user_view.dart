import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_select_user_controller.dart';

class AuthSelectUserView extends GetView<AuthSelectUserController> {
  const AuthSelectUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthSelectUserView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthSelectUserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
