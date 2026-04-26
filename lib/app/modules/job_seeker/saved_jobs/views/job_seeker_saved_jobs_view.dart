import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_seeker_saved_jobs_controller.dart';

class JobSeekerSavedJobsView extends GetView<JobSeekerSavedJobsController> {
  const JobSeekerSavedJobsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobSeekerSavedJobsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobSeekerSavedJobsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
