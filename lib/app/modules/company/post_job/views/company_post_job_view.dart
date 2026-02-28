import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/company_post_job_controller.dart';

class CompanyPostJobView extends GetView<CompanyPostJobController> {
  const CompanyPostJobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CompanyPostJobView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CompanyPostJobView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
