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
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // تعديل: استخدام Image.network بدلاً من Image.asset لعرض رابط سوبابيز
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: job.logoUrl.isNotEmpty
                    ? Image.network(
                        job.logoUrl,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        // في حال كان الرابط خطأ أو لا يوجد إنترنت تظهر أيقونة افتراضية
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 45,
                          height: 45,
                          color: AppColor.greyVeryLight,
                          child: const Icon(Icons.business, color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 45,
                        height: 45,
                        color: AppColor.greyVeryLight,
                        child: const Icon(Icons.business, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 1, // منع النص من النزول لسطر جديد
                      overflow: TextOverflow
                          .ellipsis, // وضع نقاط (...) إذا كان النص طويلاً
                      style: CustomTextstyle.Poppinssemibold.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      job.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextstyle.Poppins500grey.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.bookmark_border_rounded,
                color: AppColor.kblue.withOpacity(0.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Colors.green,
              ),
              const SizedBox(width: 4),
              // تعديل: تغليف النص بـ Expanded لمنع الـ Overflow في الرواتب الطويلة أو العناوين
              Expanded(
                child: Text(
                  job.location,
                  style: CustomTextstyle.Poppins500grey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "\$${job.salary}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // الـ Chips يفضل تغليفها بـ Wrap إذا كان عددها كبيراً، لكن هنا ستبقى Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip(job.type),
                const SizedBox(width: 8),
                _buildChip(job.category, isType: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isType = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isType
            ? AppColor.kblue.withOpacity(0.1)
            : AppColor.greyVeryLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isType ? AppColor.kblue : AppColor.greydark,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
