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
        actions: [
          Obx(() => Stack(
                children: [
                  IconButton(
                    onPressed: controller.onNotificationsTap,
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  if (controller.unreadCount.value > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          controller.unreadCount.value > 99
                              ? '99+'
                              : controller.unreadCount.value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
        ],
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
