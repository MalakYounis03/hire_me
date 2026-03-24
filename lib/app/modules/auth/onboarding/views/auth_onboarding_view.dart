import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_onboarding_controller.dart';

class AuthOnboardingView extends GetView<AuthOnboardingController> {
  const AuthOnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [Column(children: [])]),
    );
  }
}
