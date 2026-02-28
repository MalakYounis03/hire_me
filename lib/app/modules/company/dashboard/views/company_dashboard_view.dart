import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/company_dashboard_controller.dart';

class CompanyDashboardView extends GetView<CompanyDashboardController> {
  const CompanyDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CompanyDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CompanyDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
