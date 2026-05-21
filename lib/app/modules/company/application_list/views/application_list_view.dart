import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/job_actions_sheet.dart';
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
              onJobsTap: controller.showJobsTab,
              onApplicationsTap: controller.showApplicationsTab,
            ),
            if (controller.activeTab.value == 'applications')
              _StatusFilterBar(
                selectedStatus: controller.selectedStatus.value,
                onSelect: (status) => controller.selectedStatus.value = status,
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
      return Center(child: CircularProgressIndicator(color: AppColor.kblue));
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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColor.greyLight,
                ),
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
            _JobCard(
              job: job,
              onEdit: () => controller.editJob(job),
              onClose: () => controller.confirmCloseJob(job),
              onDelete: () => controller.confirmDeleteJob(job),
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: AppColor.greyVeryLight,
                  height: 1,
                  thickness: 1,
                ),
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
      return Center(child: CircularProgressIndicator(color: AppColor.kblue));
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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColor.greyLight,
                ),
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
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  childrenPadding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 8,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  initiallyExpanded: false,
                  backgroundColor: AppColor.kblue.withValues(alpha: 0.03),
                  collapsedBackgroundColor: AppColor.kblue.withValues(
                    alpha: 0.08,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: AppColor.kblue.withValues(alpha: 0.18),
                    ),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: AppColor.kblue.withValues(alpha: 0.2),
                    ),
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
                          readOnly:
                              controller.selectedStatus.value != 'Pending',
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
                child: Divider(
                  color: AppColor.greyVeryLight,
                  height: 1,
                  thickness: 1,
                ),
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
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.greydark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.work_outline_rounded, color: AppColor.kblue, size: 24),
      ],
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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

class _JobCard extends StatelessWidget {
  final CompanyJobModel job;
  final VoidCallback onEdit;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  const _JobCard({
    required this.job,
    required this.onEdit,
    required this.onClose,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = job.status.toLowerCase() == 'open';

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isOpen
                      ? const Color(0xFFE8F7EE)
                      : AppColor.greyVeryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isOpen ? const Color(0xFF16A34A) : AppColor.greydark,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  JobActionsSheet.show(
                    jobTitle: job.title,
                    isOpen: isOpen,
                    onEdit: onEdit,
                    onClose: onClose,
                    onDelete: onDelete,
                  );
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColor.kblue.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppColor.kblue,
                    size: 22,
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
          _infoRow(
            Icons.people_outline,
            '${job.applicantCount} applicant${job.applicantCount == 1 ? '' : 's'}',
          ),
          if (job.salary.isNotEmpty) ...[
            const SizedBox(height: 4),
            _infoRow(Icons.attach_money_outlined, job.salary),
          ],
          if (job.jobTypeLabel.isNotEmpty || job.workMode.isNotEmpty) ...[
            const SizedBox(height: 4),
            _infoRow(
              Icons.work_history_outlined,
              '${job.jobTypeLabel}${job.workMode.isNotEmpty ? ' / ${job.workMode}' : ''}',
            ),
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
            text.isEmpty ? '-' : text,
            style: TextStyle(fontSize: 13, color: AppColor.greydark),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
