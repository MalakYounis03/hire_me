import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/application_list_controller.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/application_tile.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/applications_header.dart';

class ApplicationListView extends GetView<ApplicationListController> {
  const ApplicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColor.Ewhite,
      body: Obx(() {
        final jobs = controller.jobs;
        final totalApplicants = jobs.fold<int>(
          0,
          (sum, job) => sum + job.applicants.length,
        );

        return Column(
          children: [
            ApplicantsHeader(
              jobsCount: jobs.length,
              applicantsCount: totalApplicants,
            ),
            Expanded(
              child: jobs.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.kwhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.greyVeryLight),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.kblack.withOpacity(0.04),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 32,
                              color: AppColor.kblue,
                            ),
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
                    )
                  : ListView.builder(
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
                                    color: AppColor.kblack.withOpacity(0.05),
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
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  initiallyExpanded: false,
                                  backgroundColor: AppColor.kblue.withOpacity(
                                    0.03,
                                  ),
                                  collapsedBackgroundColor: AppColor.kblue
                                      .withOpacity(0.08),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: AppColor.kblue.withOpacity(0.18),
                                    ),
                                  ),
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: AppColor.kblue.withOpacity(0.2),
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: job.applicants.length,
                                      itemBuilder: (_, applicantIndex) {
                                        final applicant =
                                            job.applicants[applicantIndex];
                                        return ApplicantTile(
                                          applicant: applicant,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLastJob)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
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
                    ),
            ),
          ],
        );
      }),
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
