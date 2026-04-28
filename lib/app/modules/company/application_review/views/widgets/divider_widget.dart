import 'package:flutter/material.dart';
import 'package:hire_me/app/modules/company/application_review/model/application_review_model.dart';
import 'package:hire_me/core/utils/app_color.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: AppColor.greyVeryLight, indent: 16);
  }
}

/// Accept / Reject Buttons
class ActionButtons extends StatelessWidget {
  final ApplicationReviewModel applicant;
  const ActionButtons({required this.applicant, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.kwhite,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Reject logic
              },
              icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
              label: Text(
                'Reject',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Accept logic
              },
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Accept',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kblue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
