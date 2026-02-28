import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_seeker_apply_job_controller.dart';

class JobSeekerApplyJobView extends GetView<JobSeekerApplyJobController> {
  const JobSeekerApplyJobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobSeekerApplyJobView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobSeekerApplyJobView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
