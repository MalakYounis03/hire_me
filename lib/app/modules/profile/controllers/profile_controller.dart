import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userLocation = ''.obs;
  final userImage = ''.obs;
  final isLoading = false.obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final doc = await _firestore.collection('jobSeekers').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        userName.value = data['name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userLocation.value = data['location'] ?? '';
        userImage.value = data['profileImage'] ?? '';
      } else {
        userEmail.value = _auth.currentUser?.email ?? '';
      }
    } catch (e) {
      userEmail.value = _auth.currentUser?.email ?? '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.SPLASH);
  }
}
