import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/main_fields_widget.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/search_widget.dart';
import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_text_style.dart';

import '../controllers/job_seeker_dashboard_controller.dart';
import '../widgets/header_widget.dart';
import '../widgets/job_card_widget.dart';

class JobSeekerDashboardView extends GetView<JobSeekerDashboardController> {
  const JobSeekerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          color: AppColor.kblue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),

                Transform.translate(
                  offset: const Offset(0, -28),
                  child: SearchFilterWidget(
                    searchController: controller.searchTextController,
                    onChanged: controller.onSearch,
                    onFilterTap: () => _showFilterBottomSheet(context),
                  ),
                ),

                const MainFieldsWidget(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Job For You',
                        style: CustomTextstyle.poppinsBold.copyWith(
                          fontSize: 18,
                          color: AppColor.eblack,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.clearFilters,
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: AppColor.kblue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.filteredJobs.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: controller.filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = controller.filteredJobs[index];

                      return Obx(
                        () => JobCardWidget(
                          job: job,
                          isSaved: controller.isJobSaved(job.id),
                          onSaveTap: () => controller.toggleSaveJob(job.id),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 78, color: AppColor.greyLight),
            const SizedBox(height: 12),
            Text(
              'No jobs found',
              style: CustomTextstyle.poppins500Grey.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Try changing the search or filters',
              style: TextStyle(color: AppColor.greyLight, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Text(
                'Filter Jobs',
                style: CustomTextstyle.poppinsBold.copyWith(fontSize: 20),
              ),

              const SizedBox(height: 20),

              Text(
                'Job Type',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColor.eblack,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.jobTypes.map((type) {
                  final selected = controller.selectedJobType.value == type;

                  return _filterChip(
                    label: _formatFilterLabel(type),
                    selected: selected,
                    onTap: () => controller.setJobTypeFilter(type),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              Text(
                'Work Mode',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColor.eblack,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.workModes.map((mode) {
                  final selected = controller.selectedWorkMode.value == mode;

                  return _filterChip(
                    label: _formatFilterLabel(mode),
                    selected: selected,
                    onTap: () => controller.setWorkModeFilter(mode),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.clearFilters,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColor.kblue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Clear',
                        style: TextStyle(color: AppColor.kblue),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: Get.back,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.kblue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(color: AppColor.kwhite),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColor.kblue : const Color(0xffF5F7FA),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColor.kblue : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColor.kwhite : AppColor.greydark,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _formatFilterLabel(String value) {
    if (value == 'all') return 'All';
    if (value == 'FullTime') return 'Full Time';
    if (value == 'PartTime') return 'Part Time';
    return value;
  }
}
