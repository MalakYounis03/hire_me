import 'package:get/get.dart';
import 'package:hire_me/app/modules/company/application_review/model/application_review_model.dart';
import 'package:hire_me/app/modules/company/application_review/model/job_with_application.dart';

class ApplicationListController extends GetxController {
  final jobs = <JobWithApplicants>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    jobs.value = [
      JobWithApplicants(
        jobId: 'j1',
        jobTitle: 'Graphic Designer',
        applicants: [
          ApplicationReviewModel(
            id: '1',
            name: 'Shoroq Hamad',
            jobTitle: 'Graphic Designer',
            location: 'Palestine, Gaza',
            appliedAt: '2d ago',
            email: 'shoroq@example.com',
            skills: 'Adobe Photoshop, Illustrator',
            experience: '3 years',
            education: 'Bachelor of Fine Arts',
            cvUrl: 'https://example.com/cv/shoroq.pdf',
          ),
          ApplicationReviewModel(
            id: '2',
            name: 'Lina Abo Shaker',
            jobTitle: 'Graphic Designer',
            location: 'Palestine, Gaza',
            appliedAt: '3d ago',
            email: 'lina@example.com',
            skills: 'Adobe Photoshop, Illustrator',
            experience: '2 years',
            education: 'Bachelor of Fine Arts',
            cvUrl: 'https://example.com/cv/lina.pdf',
          ),
        ],
      ),
      JobWithApplicants(
        jobId: 'j2',
        jobTitle: 'UX/UI Designer',
        applicants: [
          ApplicationReviewModel(
            id: '3',
            name: 'Sara Ahmad',
            jobTitle: 'UX/UI Designer',
            location: 'Palestine, Gaza',
            appliedAt: '5d ago',
            email: 'sara@example.com',
            skills: 'Figma, Adobe XD, Prototyping',
            experience: '4 years',
            education: 'B.Sc Computer Science',
            cvUrl: 'https://example.com/cv/sara.pdf',
          ),
          ApplicationReviewModel(
            id: '4',
            name: 'Ahmad Ali',
            jobTitle: 'UX/UI Designer',
            location: 'Palestine, Gaza',
            appliedAt: '5d ago',
            email: 'ahmad@example.com',
            skills: 'Figma, Sketch',
            experience: '1 year',
            education: 'Bachelor of Visual Arts',
            cvUrl: 'https://example.com/cv/ahmad.pdf',
          ),
        ],
      ),
      JobWithApplicants(
        jobId: 'j3',
        jobTitle: 'Flutter Developer',
        applicants: [
          ApplicationReviewModel(
            id: '5',
            name: 'Mohammed Nasser',
            jobTitle: 'Flutter Developer',
            location: 'Palestine, Ramallah',
            appliedAt: '1d ago',
            email: 'mohammed@example.com',
            skills: 'Flutter, Dart, Firebase',
            experience: '2 years',
            education: 'B.Sc Software Engineering',
            cvUrl: 'https://example.com/cv/mohammed.pdf',
          ),
        ],
      ),
    ];
  }
}
