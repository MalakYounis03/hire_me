import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_seeker_main_fields_controller.dart';

class JobSeekerMainFieldsView extends GetView<JobSeekerMainFieldsController> {
  const JobSeekerMainFieldsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobSeekerMainFieldsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobSeekerMainFieldsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
