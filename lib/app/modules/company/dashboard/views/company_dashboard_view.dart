import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../../core/utils/app_color.dart';
import '../controllers/company_dashboard_controller.dart';

class CompanyDashboardView extends GetView<CompanyDashboardController> {
  const CompanyDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColor.kblue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: AppColor.kwhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const SizedBox(width: 20),
        // leading: Icon(
        //   Icons.arrow_back_ios_new_rounded,
        //   color: AppColor.kwhite,
        //   size: 20,
        // ),
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.COMPANY_NOTIFICATIONS),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: AppColor.kwhite,
                  size: 26,
                ),
                Obx(
                  () => controller.unreadCount > 0
                      ? Positioned(
                          right: -3,
                          top: -3,
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
                              '${controller.unreadCount.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.kblue),
          );
        }

        return RefreshIndicator(
          color: AppColor.kblue,
          onRefresh: () async {
            controller.listenToCompanyDashboard();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsRow(),
                const SizedBox(height: 22),
                _buildPieChartCard(),
                const SizedBox(height: 22),
                _sectionTitle('Recent Applicants'),
                const SizedBox(height: 12),
                _buildRecentApplicants(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.work_outline_rounded,
            title: 'Total Jobs',
            value: controller.totalJobs.value.toString(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.groups_outlined,
            title: 'Applicants',
            value: controller.totalApplicants.value.toString(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Accepted',
            value: controller.acceptedApplicants.value.toString(),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColor.kblue, size: 22),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.eblack,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            constraints: const BoxConstraints(minWidth: 26, minHeight: 18),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.kblue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  color: AppColor.kwhite,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard() {
    final total = controller.totalApplicants.value;
    final accepted = controller.acceptedApplicants.value;

    final acceptedPercent = total == 0 ? 0.0 : accepted / total;
    final pendingPercent = total == 0 ? 1.0 : 1.0 - acceptedPercent;

    final acceptedText = total == 0
        ? '0%'
        : '${(acceptedPercent * 100).round()}%';
    final pendingText = total == 0
        ? '0%'
        : '${(pendingPercent * 100).round()}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Pie Chart'),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              width: 210,
              height: 145,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 145,
                    height: 145,
                    child: CircularProgressIndicator(
                      value: total == 0 ? 0.55 : acceptedPercent,
                      strokeWidth: 22,
                      backgroundColor: const Color(0xffC9D8F0),
                      color: AppColor.kblue,
                    ),
                  ),
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColor.kwhite,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    left: 4,
                    bottom: 24,
                    child: _legendDot(
                      color: AppColor.kblue,
                      text: '$acceptedText\nAccepted',
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 24,
                    child: _legendDot(
                      color: const Color(0xffC9D8F0),
                      text: '$pendingText\nPending',
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 47,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColor.kblue,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.kwhite, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: AppColor.eblack,
            fontSize: 10,
            height: 1.1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentApplicants() {
    if (controller.recentApplicants.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppColor.kwhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColor.kblack.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'No applicants yet',
            style: TextStyle(
              color: AppColor.greyLight,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Column(
      children: controller.recentApplicants.map((applicant) {
        return _applicantCard(applicant);
      }).toList(),
    );
  }

  Widget _applicantCard(CompanyRecentApplicant applicant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _avatar(applicant.imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicant.applicantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor.eblack,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.work_outline_rounded,
                      color: AppColor.kblue,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        applicant.jobTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColor.greyLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColor.kblue,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        applicant.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColor.greyLight,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.formatDate(applicant.createdAt),
                style: TextStyle(
                  color: AppColor.greyLight,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColor.greyLight,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xffDEE8F8),
          borderRadius: BorderRadius.circular(27),
        ),
        child: Icon(Icons.person_rounded, color: AppColor.kblue, size: 30),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(27),
      child: Image.network(
        imageUrl,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xffDEE8F8),
              borderRadius: BorderRadius.circular(27),
            ),
            child: Icon(Icons.person_rounded, color: AppColor.kblue, size: 30),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColor.eblack,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
