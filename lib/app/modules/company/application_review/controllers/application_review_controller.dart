import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/application_review_model.dart';

class ApplicationReviewController extends GetxController {
  late Rx<ApplicationReviewModel> applicant;

  final _firestore = FirebaseFirestore.instance;
  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  final isProcessing = false.obs;
  final companyName = ''.obs;

  String get companyId => _auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    _initializeApplicant();
    _fetchCompanyName();
  }

  Future<void> _fetchCompanyName() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!isClosed && doc.exists) {
        companyName.value = doc.data()?['name'] ?? '';
      }
    } catch (e) {
      debugPrint('Failed to fetch company name: $e');
    }
  }

  void _initializeApplicant() {
    if (Get.arguments != null && Get.arguments is ApplicationReviewModel) {
      applicant = (Get.arguments as ApplicationReviewModel).obs;
    } else {
      applicant = ApplicationReviewModel(
        id: '0',
        jobSeekerId: '0',
        name: 'Unknown',
        jobTitle: 'Unknown',
        location: 'Unknown',
        email: 'Unknown',
        skills: 'Unknown',
        experience: 'Unknown',
        education: 'Unknown',
        cvUrl: '',
        appliedAt: '',
      ).obs;
    }
  }

  /// Accepts the application, updates its status in Firestore, creates a new
  /// chat document in Realtime Database (to match the existing chat
  /// architecture), seeds an initial auto-message, and routes to the company
  /// chat details screen.
  Future<void> acceptApplication(
    String applicationId,
    String jobSeekerId,
    String jobSeekerName,
    String companyId,
    String companyName,
  ) async {
    isProcessing.value = true;

    try {
      // 1. Update application status to Accepted in Firestore
      await _firestore.collection('applications').doc(applicationId).set(
        {'status': 'Accepted'},
        SetOptions(merge: true),
      );

      if (isClosed) return;

      // Fallback: fetch company name if not available yet
      String resolvedCompanyName = companyName;
      if (resolvedCompanyName.isEmpty && companyId.isNotEmpty) {
        final doc = await _firestore.collection('users').doc(companyId).get();
        resolvedCompanyName = doc.data()?['name'] ?? 'Company';
      }

      if (isClosed) return;

      // 2. Create chat document in REALTIME DATABASE
      //    (NOT Firestore — the whole chat system lives in RTDB)
      final chatId = '${companyId}_$jobSeekerId';
      final now = DateTime.now();

      await _db.child('chats/$chatId').set({
        'companyId': companyId,
        'seekerId': jobSeekerId,
        'jobId': '',
        'companyName': resolvedCompanyName,
        'seekerName': jobSeekerName,
        'lastMessage': 'You have been accepted for this position.',
        'lastMessageTime': now.millisecondsSinceEpoch,
        'lastMessageAuthor': companyId,
        'avatarUrl': applicant.value.avatarUrl,
        'unreadSeeker': 1,
        'unreadCompany': 0,
      });

      if (isClosed) return;

      // 3. Add initial auto-message in RTDB messages sub-node
      final msgRef = _db.child('chats/$chatId/messages').push();
      await msgRef.set({
        'text': 'You have been accepted for this position.',
        'senderId': companyId,
        'time': now.millisecondsSinceEpoch,
        'isRead': false,
      });

      if (isClosed) return;

      // 4. Route to company chat details
      Get.toNamed(
        Routes.COMPANY_CHAT_DETAILS,
        arguments: {
          'chatId': chatId,
          'chatName': jobSeekerName,
          'avatarUrl': applicant.value.avatarUrl,
          'seekerId': jobSeekerId,
          'companyId': companyId,
        },
      );
    } catch (e, s) {
      debugPrint('acceptApplication error: $e\n$s');
      if (!isClosed) {
        _showError('Failed to accept application. Please try again.');
      }
    } finally {
      if (!isClosed) isProcessing.value = false;
    }
  }

  /// Rejects the application by updating its status and navigates back.
  Future<void> rejectApplication(String applicationId) async {
    isProcessing.value = true;

    try {
      await _firestore.collection('applications').doc(applicationId).set(
        {'status': 'Rejected'},
        SetOptions(merge: true),
      );

      if (isClosed) return;

      Get.back();
    } catch (e, s) {
      debugPrint('rejectApplication error: $e\n$s');
      if (!isClosed) {
        _showError('Failed to reject application. Please try again.');
      }
    } finally {
      if (!isClosed) isProcessing.value = false;
    }
  }

  /// Opens the applicant's CV URL using url_launcher.
  /// Falls back to a dummy PDF if no URL is provided.
  Future<void> viewApplicantCV(String? cvUrl) async {
    final url = cvUrl?.isNotEmpty == true
        ? cvUrl!
        : 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

    final uri = Uri.parse(url);

    try {
      // Attempt to launch directly. On Android 11+ this requires the
      // <queries> intent in AndroidManifest.xml (already added).
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _showError('No app found to open this link');
      }
    } catch (e) {
      debugPrint('viewApplicantCV error: $e');
      _showError('Failed to open CV. Please try again.');
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
