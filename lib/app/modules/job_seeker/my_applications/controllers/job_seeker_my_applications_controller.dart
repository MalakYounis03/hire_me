import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobSeekerMyApplicationsController extends GetxController {
  final applications = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedTab = 'All'.obs;
  final tabs = ['All', 'Pending', 'Accepted', 'Rejected'];

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadApplications();
  }

  Future<void> loadApplications() async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final snapshot = await _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: uid)
          .get();

      applications.assignAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList(),
      );
    } catch (e) {
      applications.assignAll([
        {
          'jobTitle': 'Graphic Designer',
          'companyName': 'Zain Design Company',
          'status': 'unacceptable',
        },
        {
          'jobTitle': 'Graphic Designer',
          'companyName': 'Zain Design Company',
          'status': 'acceptable',
        },
        {
          'jobTitle': 'Graphic Designer',
          'companyName': 'Zain Design Company',
          'status': 'on hold',
        },
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredApplications {
    if (selectedTab.value == 'All') return applications;
    final filter = selectedTab.value.toLowerCase();
    return applications.where((a) {
      final status = (a['status'] as String? ?? '').toLowerCase();
      return status == filter;
    }).toList();
  }

  void selectTab(String tab) => selectedTab.value = tab;

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'acceptable':
        return const Color(0xFF22C55E);
      case 'unacceptable':
        return const Color(0xFFEF4444);
      case 'on hold':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF8A8A9A);
    }
  }
}
