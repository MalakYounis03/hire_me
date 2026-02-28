import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_seeker_profile_controller.dart';

class JobSeekerProfileView extends GetView<JobSeekerProfileController> {
  const JobSeekerProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobSeekerProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobSeekerProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
