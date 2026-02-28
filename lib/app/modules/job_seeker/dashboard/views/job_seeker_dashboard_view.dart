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
      body: const Center(
        child: Text(
          'JobSeekerDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
