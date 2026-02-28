import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_role_selector_controller.dart';

class AuthRoleSelectorView extends GetView<AuthRoleSelectorController> {
  const AuthRoleSelectorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthRoleSelectorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthRoleSelectorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
