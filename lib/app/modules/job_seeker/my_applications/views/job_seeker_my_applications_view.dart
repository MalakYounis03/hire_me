import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job_seeker_my_applications_controller.dart';

class JobSeekerMyApplicationsView
    extends GetView<JobSeekerMyApplicationsController> {
  const JobSeekerMyApplicationsView({super.key});

  static const _primaryBlue = Color(0xFF1A3794);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Status',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _primaryBlue),
          );
        }

        final list = controller.filteredApplications;

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_off_outlined,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No applications yet',
                  style: TextStyle(color: Color(0xFF8A8A9A)),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: list.length,
          itemBuilder: (_, i) =>
              _ApplicationCard(app: list[i], controller: controller),
        );
      }),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> app;
  final JobSeekerMyApplicationsController controller;

  const _ApplicationCard({required this.app, required this.controller});

  @override
  Widget build(BuildContext context) {
    final status = app['status'] as String? ?? 'pending';
    final statusColor = controller.statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Company Logo
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A5C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'Ps',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app['jobTitle'] as String? ?? 'Job Title',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  app['companyName'] as String? ?? 'Company',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8A9A),
                  ),
                ),
                const SizedBox(height: 10),

                // Status Badge — محاذاة لليمين
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1.5),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
