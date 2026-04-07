import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_seeker_dashboard_controller.dart';

class JobSeekerDashboardView extends GetView<JobSeekerDashboardController> {
  const JobSeekerDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobSeekerDashboardView'),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: controller.logout,
          child: const Icon(
            Icons.logout_rounded,
            color: Color(0xFF1A3794),
            size: 26,
          ),
        ),
      ),
    );
  }
}
