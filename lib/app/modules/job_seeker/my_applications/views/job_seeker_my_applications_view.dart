import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_seeker_my_applications_controller.dart';

class JobSeekerMyApplicationsView
    extends GetView<JobSeekerMyApplicationsController> {
  const JobSeekerMyApplicationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobSeekerMyApplicationsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobSeekerMyApplicationsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
