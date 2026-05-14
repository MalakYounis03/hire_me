import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/core/utils/app_color.dart';
import '../../application_review/model/job_with_application.dart';
import '../controllers/application_list_controller.dart';
import '../model/company_job_model.dart';
import 'widgets/application_tile.dart';
import 'widgets/applications_header.dart';

class ApplicationListView extends GetView<ApplicationListController> {
  const ApplicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColor.ewhite,
      body: Obx(() {
        return Column(
          children: [
            ApplicantsHeader(
              jobsCount: controller.jobsCount.value,
              applicantsCount: controller.applicantsCount.value,
              onJobsTap: () => controller.switchTab('jobs'),
              onApplicationsTap: () => controller.switchTab('applications'),
            ),
            _TabBar(activeTab: controller.activeTab.value, onTab: controller.switchTab),
            if (controller.activeTab.value == 'applications')
              _StatusFilterBar(
                selectedStatus: controller.selectedStatus.value,
                onSelect: (s) => controller.selectedStatus.value = s,
                isReadOnly: controller.selectedStatus.value != 'Pending',
              ),
            Expanded(
              child: controller.activeTab.value == 'jobs'
                  ? _buildJobsTab(theme)
                  : _buildApplicationsTab(theme, controller.filteredJobs),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildJobsTab(ThemeData theme) {
    if (controller.isJobsLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final jobs = controller.companyJobs;
    if (jobs.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: AppColor.kwhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.greyVeryLight),
            boxShadow: [
              BoxShadow(
                color: AppColor.kblack.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.work_outline_rounded, size: 32, color: AppColor.kblue),
              const SizedBox(height: 12),
              Text(
                'No jobs posted yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColor.kblack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your posted jobs will appear here.',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColor.greyLight),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      itemCount: jobs.length,
      itemBuilder: (_, index) {
        final job = jobs[index];
        final isLast = index == jobs.length - 1;
        return Column(
          children: [
            _JobCard(job: job),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: AppColor.greyVeryLight, height: 1, thickness: 1),
              )
            else
              const SizedBox(height: 6),
          ],
        );
      },
    );
  }

  Widget _buildApplicationsTab(ThemeData theme, List<JobWithApplicants> jobs) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobs.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: AppColor.kwhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.greyVeryLight),
            boxShadow: [
              BoxShadow(
                color: AppColor.kblack.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 32, color: AppColor.kblue),
              const SizedBox(height: 12),
              Text(
                'No applications yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColor.kblack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'New applications will appear here.',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColor.greyLight),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      itemCount: jobs.length,
      itemBuilder: (_, jobIndex) {
        final job = jobs[jobIndex];
        final isLastJob = jobIndex == jobs.length - 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.kblack.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  initiallyExpanded: false,
                  backgroundColor: AppColor.kblue.withValues(alpha: 0.03),
                  collapsedBackgroundColor: AppColor.kblue.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: AppColor.kblue.withValues(alpha: 0.18)),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: AppColor.kblue.withValues(alpha: 0.2)),
                  ),
                  iconColor: AppColor.kblue,
                  collapsedIconColor: AppColor.kblue,
                  title: _buildHeaderTitle(
                    jobTitle: job.jobTitle,
                    applicantCount: job.applicants.length,
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: job.applicants.length,
                      itemBuilder: (_, applicantIndex) {
                        final applicant = job.applicants[applicantIndex];
                        return ApplicantTile(
                          applicant: applicant,
                          readOnly: controller.selectedStatus.value != 'Pending',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (!isLastJob)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: AppColor.greyVeryLight, height: 1, thickness: 1),
              )
            else
              const SizedBox(height: 6),
          ],
        );
      },
    );
  }

  Widget _buildHeaderTitle({
    required String jobTitle,
    required int applicantCount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColor.kblue,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '$applicantCount ${applicantCount == 1 ? 'applicant' : 'applicants'}',
                style: TextStyle(fontSize: 12, color: AppColor.greydark, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Icon(Icons.work_outline_rounded, color: AppColor.kblue, size: 24),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  final String activeTab;
  final void Function(String) onTab;

  const _TabBar({required this.activeTab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      child: Row(
        children: [
          _TabButton(
            label: 'Jobs',
            isActive: activeTab == 'jobs',
            onTap: () => onTab('jobs'),
          ),
          const SizedBox(width: 10),
          _TabButton(
            label: 'Applications',
            isActive: activeTab == 'applications',
            onTap: () => onTab('applications'),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterBar extends StatelessWidget {
  final String selectedStatus;
  final void Function(String) onSelect;
  final bool isReadOnly;

  const _StatusFilterBar({
    required this.selectedStatus,
    required this.onSelect,
    required this.isReadOnly,
  });

  static const _tabs = ['Pending', 'Accepted', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
      child: Row(
        children: _tabs.map((tab) {
          final isActive = selectedStatus == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColor.kblue : AppColor.kwhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? AppColor.kblue : AppColor.greyVeryLight,
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isActive ? AppColor.kwhite : AppColor.greydark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColor.kblue : AppColor.kwhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColor.kblue : AppColor.greyVeryLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColor.kwhite : AppColor.greydark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final CompanyJobModel job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.greyVeryLight),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  job.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.kblack,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: job.status == 'Open'
                      ? AppColor.ksuccess.withValues(alpha: 0.1)
                      : AppColor.greyVeryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: job.status == 'Open' ? AppColor.ksuccess : AppColor.greydark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow(Icons.location_on_outlined, job.location),
          const SizedBox(height: 4),
          _infoRow(Icons.calendar_today_outlined, job.datePosted),
          const SizedBox(height: 4),
          _infoRow(Icons.people_outline, '${job.applicantCount} applicant${job.applicantCount == 1 ? '' : 's'}'),
          if (job.salary.isNotEmpty) ...[
            const SizedBox(height: 4),
            _infoRow(Icons.attach_money_outlined, job.salary),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColor.greyLight),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: AppColor.greydark),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
