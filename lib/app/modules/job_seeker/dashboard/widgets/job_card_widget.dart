import 'package:flutter/material.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/core/utils/app_text_style.dart';
import 'package:hire_me/app/data/models/job_model.dart';

class JobCardWidget extends StatelessWidget {
  final Job job;
  const JobCardWidget({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ الأبعاد الثابتة من فيجما لضمان عدم الانضغاط
      width: 391,
      height: 256,
      margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
      padding: const EdgeInsets.all(20), // Padding متناسق
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.Eblack.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الجزء العلوي (Logo + Info + Bookmark)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.Ewhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(job.logoUrl, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: CustomTextstyle.Poppinssemibold.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ), // مسافة بسيطة جداً بين العنوان والشركة
                    Text(
                      job.companyName,
                      style: TextStyle(color: AppColor.greydark, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.bookmark_border_rounded,
                color: AppColor.kblue,
                size: 26,
              ),
            ],
          ),

          // ✅ الخط الفاصل الأزرق كما في الفيجما
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              color: AppColor.kblue, // أزرق شفاف جداً
              thickness: 1,
            ),
          ),

          // 2. الموقع والسعر (بدون كونتينر للسعر وبمسافات متناسقة)
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: AppColor.kblue),
              const SizedBox(width: 6),
              Text(
                job.location,
                style: TextStyle(color: AppColor.greydark, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 8), // مسافة محددة بين الموقع والسعر
          // ✅ السعر كنص حر بارز بلون أزرق
          Text(
            job.salary,
            style: TextStyle(
              color: AppColor.kblue,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          // 3. أزرار الحالة (Pill Shape)
          Row(
            children: [
              _buildBadge(job.type, true),
              const SizedBox(width: 8),
              _buildBadge("Remote", false),
            ],
          ),
        ],
      ),
    );
  }

  // ويجت البادج مع إمكانية تغيير اللون إذا لزم الأمر
  Widget _buildBadge(String text, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.kblue, // لون موحد حسب لقطة المحاكي الأخيرة
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColor.kwhite,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
