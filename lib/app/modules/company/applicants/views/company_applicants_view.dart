import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/company_applicants_controller.dart';

class CompanyApplicantsView extends GetView<CompanyApplicantsController> {
  const CompanyApplicantsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CompanyApplicantsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CompanyApplicantsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
