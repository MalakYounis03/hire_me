import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/my_applications/views/widgets/application_card.dart';

import '../controllers/job_seeker_my_applications_controller.dart';

class JobSeekerMyApplicationsView
    extends GetView<JobSeekerMyApplicationsController> {
  const JobSeekerMyApplicationsView({super.key});

  static const _primaryBlue = Color(0xFF1A3794);
  static const _backgroundColor = Color(0xFFF5F7FF);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textGrey = Color(0xFF8A8A9A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        title: const Text(
          'Application Status',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: _primaryBlue),
                );
              }

              final list = controller.filteredApplications;

              if (list.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: list.length,
                itemBuilder: (_, i) =>
                    ApplicationCard(app: list[i], controller: controller),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.tabs.map((tab) {
              final isSelected = controller.selectedTab.value == tab;

              return GestureDetector(
                onTap: () => controller.selectTab(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? _primaryBlue : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.035),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _textGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 68,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            const Text(
              'No applications found',
              style: TextStyle(
                color: _textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Applications will appear here after you apply',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textGrey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
