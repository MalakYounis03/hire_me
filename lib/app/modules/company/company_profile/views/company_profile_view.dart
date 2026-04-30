import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/company_profile_controller.dart';

class CompanyProfileView extends GetView<CompanyProfileController> {
  const CompanyProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CompanyProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CompanyProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
