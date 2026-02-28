import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_seeker_job_details_controller.dart';

class JobSeekerJobDetailsView extends GetView<JobSeekerJobDetailsController> {
  const JobSeekerJobDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobSeekerJobDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobSeekerJobDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
