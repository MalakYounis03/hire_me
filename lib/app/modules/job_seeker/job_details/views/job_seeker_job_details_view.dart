import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/jobseeker_main_wrapper/views/main_wrapper_view.dart';

import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_text_style.dart';
import '../controllers/job_seeker_job_details_controller.dart';

class JobSeekerJobDetailsView extends GetView<JobSeekerJobDetailsController> {
  const JobSeekerJobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final job = controller.job.value;

      if (job == null) {
        return Scaffold(
          backgroundColor: const Color(0xffF5F7FA),
          body: Center(child: CircularProgressIndicator(color: AppColor.kblue)),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  child: _buildDetailsCard(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const MainBottomNavBar(navigateToWrapper: true),
      );
    });
  }

  Widget _buildAppBar() {
    return Container(
      height: 76,
      width: double.infinity,
      color: AppColor.kblue,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.kwhite,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              'Job Description',
              textAlign: TextAlign.center,
              style: CustomTextstyle.poppinsSemiBoldWhite.copyWith(
                fontSize: 18,
                color: AppColor.kwhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    final job = controller.job.value!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColor.eblack.withValues(alpha: 0.08),

            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobTopInfo(),

          const SizedBox(height: 12),

          _buildLocationAndSalary(),

          const SizedBox(height: 12),

          Row(
            children: [
              _buildBadge(
                controller.formatJobType(job.jobType),
                isPrimary: false,
              ),
              const SizedBox(width: 10),
              _buildBadge(job.workMode, isPrimary: true),
            ],
          ),

          const SizedBox(height: 22),

          _sectionTitle('Job Description:'),
          const SizedBox(height: 8),
          _sectionText(
            job.description.isNotEmpty
                ? job.description
                : 'No job description available.',
          ),

          const SizedBox(height: 22),

          _sectionTitle('Requirements and Skills'),
          const SizedBox(height: 8),
          _sectionText(
            job.requirements.isNotEmpty
                ? job.requirements
                : 'No requirements added for this job.',
          ),

          const SizedBox(height: 34),

          Center(
            child: SizedBox(
              width: 190,
              height: 42,
              child: ElevatedButton(
                onPressed: job.status == 'Closed'
                    ? null
                    : controller.goToApplyJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kblue,
                  disabledBackgroundColor: AppColor.greyLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  job.status == 'Closed' ? 'Closed' : 'Apply',
                  style: TextStyle(
                    color: AppColor.kwhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTopInfo() {
    final job = controller.job.value!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _logoBox(),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CustomTextstyle.poppinsSemiBold.copyWith(
                  fontSize: 16,
                  color: AppColor.eblack,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                job.companyName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor.greydark,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        Obx(
          () => IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: controller.toggleSaveJob,
            icon: Icon(
              controller.isSaved.value
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: AppColor.kblue,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  Widget _logoBox() {
    final job = controller.job.value!;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColor.ewhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: job.logoUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: job.logoUrl,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => Icon(
                  Icons.business_rounded,
                  color: AppColor.kblue,
                  size: 28,
                ),
              )
            : Icon(Icons.business_rounded, color: AppColor.kblue, size: 28),
      ),
    );
  }

  Widget _buildLocationAndSalary() {
    final job = controller.job.value!;

    return Padding(
      padding: const EdgeInsets.only(left: 58),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.green,
                size: 15,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  job.location.isNotEmpty ? job.location : 'Not specified',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColor.greydark, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            job.salary.isNotEmpty ? job.salary : 'Salary not specified',
            style: TextStyle(
              color: AppColor.kblue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, {required bool isPrimary}) {
    return Expanded(
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? AppColor.kblue : AppColor.kwhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.kblue, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? AppColor.kwhite : AppColor.kblue,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColor.eblack,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColor.eblack..withValues(alpha: 0.78),
        fontSize: 13,
        height: 1.55,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
