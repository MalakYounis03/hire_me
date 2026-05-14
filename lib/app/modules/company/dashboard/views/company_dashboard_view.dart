import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_color.dart';
import '../controllers/company_dashboard_controller.dart';

class CompanyDashboardView extends GetView<CompanyDashboardController> {
  const CompanyDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColor.kblue,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: AppColor.kwhite,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Icon(
            Icons.notifications_none_rounded,
            color: AppColor.kwhite,
            size: 26,
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
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 105),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsRow(),
                const SizedBox(height: 20),
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
            icon: Icons.business_center_outlined,
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
      height: 120,
      width: 120,
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.09),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColor.kblue, size: 23),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.eblack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            constraints: const BoxConstraints(minWidth: 34, minHeight: 18),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: BoxDecoration(
              color: AppColor.kblue,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.kwhite,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.2,
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

    final acceptedPercent = total == 0 ? 0.55 : accepted / total;
    final pendingPercent = total == 0 ? 0.45 : 1.0 - acceptedPercent;

    final acceptedText = '${(acceptedPercent * 100).round()}%';
    final pendingText = '${(pendingPercent * 100).round()}%';

    return Container(
      width: double.infinity,
      height: 227,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pie Chart',
            style: TextStyle(
              color: AppColor.eblack,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: 34,
                  right: 34,
                  top: -18,
                  child: SizedBox(
                    height: 130,
                    child: ClipRect(
                      child: CustomPaint(
                        painter: _CompanyPieChartPainter(
                          acceptedPercent: acceptedPercent,
                          blueColor: AppColor.kblue,
                          lightColor: const Color(0xffC9D8F0),
                          backgroundColor: AppColor.kwhite,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 46,
                  bottom: 0,
                  child: _chartLegend(
                    color: AppColor.kblue,
                    percent: acceptedText,
                    label: 'Accepted',
                  ),
                ),
                Positioned(
                  right: 40,
                  bottom: 0,
                  child: _chartLegend(
                    color: const Color(0xffC9D8F0),
                    percent: pendingText,
                    label: 'Pending',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartLegend({
    required Color color,
    required String percent,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 17,
          height: 17,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              percent,
              style: TextStyle(
                color: AppColor.eblack,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColor.greyLight,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentApplicants() {
    if (controller.recentApplicants.isEmpty) {
      return Container(
        width: double.infinity,
        height: 78,
        decoration: BoxDecoration(
          color: AppColor.kwhite,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: AppColor.kblack.withValues(alpha: 0.07),
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
              fontSize: 20,
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
      height: 96,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.07),
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
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    applicant.applicantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.eblack,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      //    height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        color: AppColor.kblue,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          applicant.jobTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColor.greyLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColor.kblue,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          applicant.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColor.greyLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  controller.formatDate(applicant.createdAt),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: AppColor.greyLight,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.greyLight,
                  size: 13,
                ),
              ],
            ),
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
        child: Icon(Icons.person_rounded, color: AppColor.kblue, size: 29),
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
            child: Icon(Icons.person_rounded, color: AppColor.kblue, size: 29),
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
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CompanyPieChartPainter extends CustomPainter {
  final double acceptedPercent;
  final Color blueColor;
  final Color lightColor;
  final Color backgroundColor;

  _CompanyPieChartPainter({
    required this.acceptedPercent,
    required this.blueColor,
    required this.lightColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.96);
    final radius = size.width * 0.36;
    const strokeWidth = 25.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final lightPaint = Paint()
      ..color = lightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final bluePaint = Paint()
      ..color = blueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final innerPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // نصف دائرة فقط مثل فيغما
    const startAngle = math.pi;
    const totalSweep = math.pi;

    final clampedPercent = acceptedPercent.clamp(0.0, 1.0);
    final blueSweep = totalSweep * clampedPercent;

    canvas.drawArc(rect, startAngle, totalSweep, false, lightPaint);

    canvas.drawArc(rect, startAngle, blueSweep, false, bluePaint);

    canvas.drawCircle(center, radius - strokeWidth / 1.55, innerPaint);

    final dotAngle = startAngle + blueSweep;
    final dotOffset = Offset(
      center.dx + radius * math.cos(dotAngle),
      center.dy + radius * math.sin(dotAngle),
    );

    final dotPaint = Paint()
      ..color = blueColor
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(dotOffset, 12, dotPaint);
    canvas.drawCircle(dotOffset, 12, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _CompanyPieChartPainter oldDelegate) {
    return oldDelegate.acceptedPercent != acceptedPercent ||
        oldDelegate.blueColor != blueColor ||
        oldDelegate.lightColor != lightColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
