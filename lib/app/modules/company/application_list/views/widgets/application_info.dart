import 'package:flutter/material.dart';
import 'package:hire_me/app/core/utils/app_color.dart';

class ApplicantInfo extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String location;
  const ApplicantInfo({
    required this.name,
    required this.jobTitle,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.kblack,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(Icons.work_outline_rounded, size: 12, color: AppColor.kblue),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                jobTitle,
                style: TextStyle(fontSize: 12, color: AppColor.greydark),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 12,
              color: AppColor.greyLight,
            ),
            const SizedBox(width: 4),
            Text(
              location,
              style: TextStyle(fontSize: 12, color: AppColor.greyLight),
            ),
          ],
        ),
      ],
    );
  }
}
