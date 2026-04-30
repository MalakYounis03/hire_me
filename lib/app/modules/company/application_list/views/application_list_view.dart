import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/company/application_list/model/application_list_model.dart';
import '../controllers/application_list_controller.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/application_tile.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/applications_header.dart';

class ApplicationListView extends GetView<ApplicationListController> {
  const ApplicationListView({super.key});
  @override
  Widget build(BuildContext context) {
    final jobTitle = Get.arguments as String? ?? '';
    // dummy data مؤقتة
    final List<ApplicationListModel> applicants = [
      ApplicationListModel(
        id: '1',
        name: 'Shoroq Hamad',
        jobTitle: 'UX/UI Design · Flutter',
        location: 'Palestine, Gaza',
        appliedAt: '2d ago',
      ),
      ApplicationListModel(
        id: '2',
        name: 'Lina Abo Shaker',
        jobTitle: 'Graphic Designer',
        location: 'Palestine, Gaza',
        appliedAt: '3d ago',
      ),
      ApplicationListModel(
        id: '3',
        name: 'Sara Ahmad',
        jobTitle: 'UX/UI Design',
        location: 'Palestine, Gaza',
        appliedAt: '5d ago',
      ),
      ApplicationListModel(
        id: '4',
        name: 'Ahmad Ali',
        jobTitle: 'Visual Designer',
        location: 'Palestine, Gaza',
        appliedAt: '5d ago',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.Ewhite,
      body: Column(
        children: [
          ApplicantsHeader(jobTitle: jobTitle),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: applicants.length,
              itemBuilder: (_, index) =>
                  ApplicantTile(applicant: applicants[index]),
            ),
          ),
        ],
      ),
    );
  }
}
