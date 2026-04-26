import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire_me/app/data/models/job_model.dart';

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

  @override
  void onInit() {
    super.onInit();
    // استدعاء البيانات عند بدء تشغيل الصفحة
    fetchUserData();
    loadRecentJobs();
  }

  // --- 1. جلب بيانات المستخدم (الاسم) ---
  void fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('jobSeekers').doc(uid).get();
        if (doc.exists) {
          // جلب fullName كما هو مخزن في Firestore
          userName.value = doc.data()?['fullName'] ?? "User";
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // --- 2. جلب الوظائف من Firebase ---
  Future<void> loadRecentJobs() async {
    try {
      isLoading.value = true;

      // جلب الوظائف النشطة فقط
      // ملاحظة: إذا فعلتي orderBy('postedDate')، يجب الضغط على الرابط في Console لإنشاء Index
      final snapshot = await _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          // .orderBy('postedDate', descending: true) // فاعليها بعد إنشاء الـ Index
          .get();

      allJobs.value = snapshot.docs
          .map((doc) => Job.fromMap(doc.id, doc.data()))
          .toList();

      // تطبيق الفلترة الأولية بعد تحميل البيانات
      applyFilters();
    } catch (e) {
      print("Error loading jobs: $e");
      Get.snackbar("Error", "فشل في تحميل الوظائف، تأكد من اتصال الإنترنت");
    } finally {
      isLoading.value = false;
    }
  }

  // --- 3. منطق البحث والفلترة ---

  // عند الكتابة في حقل البحث
  void onSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  // عند اختيار فئة معينة (Category)
  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = 'الكل'; // إلغاء التحديد إذا ضغط مرة ثانية
    } else {
      selectedCategory.value = category;
    }
    applyFilters();
  }

  // دالة الفلترة الشاملة
  void applyFilters() {
    Iterable<Job> results = allJobs;

    // أولاً: فلترة حسب الفئة المختارة
    if (selectedCategory.value != 'الكل') {
      results = results.where(
        (job) =>
            job.category.toLowerCase() == selectedCategory.value.toLowerCase(),
      );
    }

    // ثانياً: فلترة حسب نص البحث (العنوان أو اسم الشركة)
    if (searchQuery.value.isNotEmpty) {
      results = results.where(
        (job) =>
            job.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            job.companyName.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
      );
    }

    // تحديث القائمة التي يراقبها الـ UI
    filteredJobs.value = results.toList();
  }

  // دالة لعمل Refresh يدوي من قبل المستخدم
  Future<void> refreshDashboard() async {
    await loadRecentJobs();
    fetchUserData();
  }
}
