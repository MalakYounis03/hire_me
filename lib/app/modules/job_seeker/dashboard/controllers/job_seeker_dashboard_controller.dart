import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hire_me/app/data/models/job_model.dart';
// تأكدي من إنشاء ملف الموديل هذا كما اقترحنا سابقاً
import 'package:hire_me/app/data/models/category_model.dart';

class JobSeekerDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Observables (المتغيرات المراقبة) ---
  var allJobs = <Job>[].obs;
  var filteredJobs = <Job>[].obs;
  var isLoading = true.obs;
  var userName = "User".obs;
  var searchQuery = "".obs;
  var selectedCategory = "الكل".obs;

  // إضافات جديدة للتصنيفات الديناميكية
  var categories = <CategoryModel>[].obs;
  var isCategoriesLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchCategories(); // جلب التصنيفات من Firestore
    loadRecentJobs();
  }

  // --- 1. جلب بيانات المستخدم ---
  void fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('jobSeekers').doc(uid).get();
        if (doc.exists) {
          userName.value = doc.data()?['fullName'] ?? "User";
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // --- 2. جلب التصنيفات ديناميكياً (الجديد) ---
  void fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      // جلب كولكشن categories الذي أنشأتِه في Firestore
      var snapshot = await _firestore.collection('categories').get();

      var fetchedCategories = snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
          .toList();

      categories.value = fetchedCategories;
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  // --- 3. جلب الوظائف من Firebase ---
  Future<void> loadRecentJobs() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .get();

      allJobs.value = snapshot.docs
          .map((doc) => Job.fromMap(doc.id, doc.data()))
          .toList();

      applyFilters();
    } catch (e) {
      print("Error loading jobs: $e");
      Get.snackbar("Error", "فشل في تحميل الوظائف");
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. منطق البحث والفلترة ---

  void onSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = 'الكل';
    } else {
      selectedCategory.value = category;
    }
    applyFilters();
  }

  void applyFilters() {
    Iterable<Job> results = allJobs;

    if (selectedCategory.value != 'الكل') {
      results = results.where(
        (job) =>
            job.category.toLowerCase() == selectedCategory.value.toLowerCase(),
      );
    }

    if (searchQuery.value.isNotEmpty) {
      results = results.where(
        (job) =>
            job.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            job.companyName.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
      );
    }

    filteredJobs.value = results.toList();
  }

  Future<void> refreshDashboard() async {
    fetchUserData();
    fetchCategories();
    await loadRecentJobs();
  }
}
