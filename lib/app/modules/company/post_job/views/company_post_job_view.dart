import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_text_style.dart';

import '../controllers/company_post_job_controller.dart';

class CompanyPostJobView extends GetView<CompanyPostJobController> {
  const CompanyPostJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyLogo(),

                      const SizedBox(height: 22),

                      _label(
                        icon: Icons.work_outline_rounded,
                        text: 'Job Title',
                      ),
                      const SizedBox(height: 8),
                      _textField(
                        controller: controller.titleController,
                        hint: 'e.g UI/UX Designer',
                        validatorText: 'Please enter job title',
                      ),

                      const SizedBox(height: 18),

                      _label(icon: Icons.category_outlined, text: 'Category'),
                      const SizedBox(height: 8),
                      _buildCategoryDropdown(),

                      const SizedBox(height: 18),

                      _label(
                        icon: Icons.work_history_outlined,
                        text: 'Job Type',
                      ),
                      const SizedBox(height: 10),
                      _buildJobTypeSelector(),

                      const SizedBox(height: 18),

                      _label(
                        icon: Icons.location_on_outlined,
                        text: 'Location',
                      ),
                      const SizedBox(height: 8),
                      _textField(
                        controller: controller.locationController,
                        hint: 'Gaza, Palestine',
                        validatorText: 'Please enter location',
                      ),

                      const SizedBox(height: 18),

                      _label(
                        icon: Icons.attach_money_rounded,
                        text: 'Salary Range',
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _textField(
                              controller: controller.minSalaryController,
                              hint: 'Min Salary',
                              keyboardType: TextInputType.number,
                              validatorText: 'Required',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _textField(
                              controller: controller.maxSalaryController,
                              hint: 'Max Salary',
                              keyboardType: TextInputType.number,
                              validatorText: 'Required',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _label(
                        icon: Icons.description_outlined,
                        text: 'Job Description',
                      ),
                      const SizedBox(height: 8),
                      _textField(
                        controller: controller.descriptionController,
                        hint: 'Describe the role, responsibilities and more',
                        maxLines: 5,
                        validatorText: 'Please enter job description',
                      ),

                      const SizedBox(height: 18),

                      _label(
                        icon: Icons.list_alt_rounded,
                        text: 'Requirements',
                      ),
                      const SizedBox(height: 8),
                      _textField(
                        controller: controller.requirementsController,
                        hint: 'Add requirements or skills',
                        maxLines: 3,
                        validatorText: 'Please enter requirements',
                      ),

                      const SizedBox(height: 30),

                      _publishButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 76,
      width: double.infinity,
      color: AppColor.kblue,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.kwhite,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              'Post a Job',
              textAlign: TextAlign.center,
              style: CustomTextstyle.poppinsSemiBoldWhite.copyWith(
                fontSize: 18,
                color: AppColor.kwhite,
              ),
            ),
          ),
          Icon(
            Icons.notifications_none_rounded,
            color: AppColor.kwhite,
            size: 26,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo() {
    return Center(
      child: Column(
        children: [
          Obx(
            () => GestureDetector(
              onTap: controller.isUploadingLogo.value
                  ? null
                  : controller.pickAndUploadCompanyLogo,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xffDEE8F8),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.kblue.withOpacity(0.25)),
                ),
                child: ClipOval(
                  child: controller.isUploadingLogo.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.kblue,
                            strokeWidth: 2,
                          ),
                        )
                      : controller.companyLogoUrl.value.isNotEmpty
                      ? Image.network(
                          controller.companyLogoUrl.value,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _logoPlaceholder();
                          },
                        )
                      : _logoPlaceholder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Company logo',
            style: TextStyle(
              color: AppColor.eblack,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoPlaceholder() {
    return Icon(Icons.camera_alt_outlined, color: AppColor.kblue, size: 30);
  }

  Widget _label({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColor.kblue),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: AppColor.eblack,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required String validatorText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return validatorText;
        }
        return null;
      },
      style: TextStyle(color: AppColor.eblack, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColor.greyLight, fontSize: 12),
        filled: true,
        fillColor: AppColor.kwhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColor.eblack.withOpacity(0.04)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColor.kblue),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(() {
      if (controller.isMainFieldsLoading.value) {
        return Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.kwhite,
            borderRadius: BorderRadius.circular(7),
          ),
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: AppColor.kblue,
              strokeWidth: 2,
            ),
          ),
        );
      }

      if (controller.mainFields.isEmpty) {
        return Container(
          height: 52,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColor.kwhite,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            'No categories found',
            style: TextStyle(color: AppColor.greyLight, fontSize: 13),
          ),
        );
      }

      return Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColor.kwhite,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: AppColor.eblack.withOpacity(0.04)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedMainFieldId.value.isEmpty
                ? controller.mainFields.first.id
                : controller.selectedMainFieldId.value,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColor.greyLight,
            ),
            items: controller.mainFields.map((field) {
              return DropdownMenuItem<String>(
                value: field.id,
                child: Text(
                  field.name,
                  style: TextStyle(
                    color: AppColor.eblack,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              final field = controller.mainFields.firstWhere(
                (element) => element.id == value,
              );

              controller.selectMainField(field);
            },
          ),
        ),
      );
    });
  }

  Widget _buildJobTypeSelector() {
    return Obx(
      () => Row(
        children: [
          _pill(
            text: 'Freelance',
            value: 'Freelance',
            groupValue: controller.selectedJobType.value,
            onTap: controller.selectJobType,
          ),
          const SizedBox(width: 8),
          _pill(
            text: 'Full Time',
            value: 'FullTime',
            groupValue: controller.selectedJobType.value,
            onTap: controller.selectJobType,
          ),
          const SizedBox(width: 8),
          _pill(
            text: 'Remote',
            value: 'Remote',
            groupValue: controller.selectedWorkMode.value,
            onTap: controller.selectWorkMode,
          ),
        ],
      ),
    );
  }

  Widget _pill({
    required String text,
    required String value,
    required String groupValue,
    required void Function(String value) onTap,
  }) {
    final isSelected = value == groupValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColor.kblue : AppColor.kwhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.kblue),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColor.kwhite : AppColor.kblue,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _publishButton() {
    return Obx(
      () => Center(
        child: SizedBox(
          width: 170,
          height: 42,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.publishJob,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.kblue,
              disabledBackgroundColor: AppColor.greyLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColor.kwhite,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Publish Job',
                    style: TextStyle(
                      color: AppColor.kwhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:hire_me/app/core/utils/app_color.dart';
// import 'package:hire_me/app/core/utils/app_text_style.dart';

// import '../controllers/company_post_job_controller.dart';

// class CompanyPostJobView extends GetView<CompanyPostJobController> {
//   const CompanyPostJobView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F7FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildAppBar(),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
//                 child: Form(
//                   key: controller.formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildCompanyLogo(),

//                       const SizedBox(height: 22),

//                       _label(
//                         icon: Icons.work_outline_rounded,
//                         text: 'Job Title',
//                       ),
//                       const SizedBox(height: 8),
//                       _textField(
//                         controller: controller.titleController,
//                         hint: 'e.g UI/UX Designer',
//                         validatorText: 'Please enter job title',
//                       ),

//                       const SizedBox(height: 18),

//                       _label(icon: Icons.category_outlined, text: 'Category'),
//                       const SizedBox(height: 8),
//                       _buildCategoryDropdown(),

//                       const SizedBox(height: 18),

//                       _label(
//                         icon: Icons.work_history_outlined,
//                         text: 'Job Type',
//                       ),
//                       const SizedBox(height: 10),
//                       _buildJobTypeSelector(),

//                       const SizedBox(height: 18),

//                       _label(
//                         icon: Icons.location_on_outlined,
//                         text: 'Location',
//                       ),
//                       const SizedBox(height: 8),
//                       _textField(
//                         controller: controller.locationController,
//                         hint: 'Gaza, Palestine',
//                         validatorText: 'Please enter location',
//                       ),

//                       const SizedBox(height: 18),

//                       _label(
//                         icon: Icons.attach_money_rounded,
//                         text: 'Salary Range',
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _textField(
//                               controller: controller.minSalaryController,
//                               hint: 'Min Salary',
//                               keyboardType: TextInputType.number,
//                               validatorText: 'Required',
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: _textField(
//                               controller: controller.maxSalaryController,
//                               hint: 'Max Salary',
//                               keyboardType: TextInputType.number,
//                               validatorText: 'Required',
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 18),

//                       _label(
//                         icon: Icons.description_outlined,
//                         text: 'Job Description',
//                       ),
//                       const SizedBox(height: 8),
//                       _textField(
//                         controller: controller.descriptionController,
//                         hint: 'Describe the role, responsibilities and more',
//                         maxLines: 5,
//                         validatorText: 'Please enter job description',
//                       ),

//                       const SizedBox(height: 18),

//                       _label(
//                         icon: Icons.list_alt_rounded,
//                         text: 'Requirements',
//                       ),
//                       const SizedBox(height: 8),
//                       _textField(
//                         controller: controller.requirementsController,
//                         hint: 'Add requirements or skills',
//                         maxLines: 3,
//                         validatorText: 'Please enter requirements',
//                       ),

//                       const SizedBox(height: 30),

//                       _publishButton(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar() {
//     return Container(
//       height: 76,
//       width: double.infinity,
//       color: AppColor.kblue,
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Get.back(),
//             child: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: AppColor.kwhite,
//               size: 20,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               'Post a Job',
//               textAlign: TextAlign.center,
//               style: CustomTextstyle.Poppinssemiboldwhite.copyWith(
//                 fontSize: 18,
//                 color: AppColor.kwhite,
//               ),
//             ),
//           ),
//           Icon(
//             Icons.notifications_none_rounded,
//             color: AppColor.kwhite,
//             size: 26,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompanyLogo() {
//     return Center(
//       child: Column(
//         children: [
//           Obx(
//             () => Container(
//               width: 72,
//               height: 72,
//               decoration: BoxDecoration(
//                 color: const Color(0xffDEE8F8),
//                 shape: BoxShape.circle,
//                 border: Border.all(color: AppColor.kblue.withOpacity(0.25)),
//               ),
//               child: ClipOval(
//                 child: controller.companyLogoUrl.value.isNotEmpty
//                     ? Image.network(
//                         controller.companyLogoUrl.value,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return _logoPlaceholder();
//                         },
//                       )
//                     : _logoPlaceholder(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Company logo',
//             style: TextStyle(
//               color: AppColor.Eblack,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _logoPlaceholder() {
//     return Icon(Icons.camera_alt_outlined, color: AppColor.kblue, size: 30);
//   }

//   Widget _label({required IconData icon, required String text}) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: AppColor.kblue),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: TextStyle(
//             color: AppColor.Eblack,
//             fontSize: 13,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _textField({
//     required TextEditingController controller,
//     required String hint,
//     required String validatorText,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return validatorText;
//         }
//         return null;
//       },
//       style: TextStyle(color: AppColor.Eblack, fontSize: 13),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: AppColor.greyLight, fontSize: 12),
//         filled: true,
//         fillColor: AppColor.kwhite,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 14,
//           vertical: 14,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(7),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(7),
//           borderSide: BorderSide(color: AppColor.Eblack.withOpacity(0.04)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(7),
//           borderSide: BorderSide(color: AppColor.kblue),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryDropdown() {
//     return Obx(() {
//       if (controller.isMainFieldsLoading.value) {
//         return Container(
//           height: 52,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: AppColor.kwhite,
//             borderRadius: BorderRadius.circular(7),
//           ),
//           child: SizedBox(
//             width: 22,
//             height: 22,
//             child: CircularProgressIndicator(
//               color: AppColor.kblue,
//               strokeWidth: 2,
//             ),
//           ),
//         );
//       }

//       if (controller.mainFields.isEmpty) {
//         return Container(
//           height: 52,
//           alignment: Alignment.centerLeft,
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           decoration: BoxDecoration(
//             color: AppColor.kwhite,
//             borderRadius: BorderRadius.circular(7),
//           ),
//           child: Text(
//             'No categories found',
//             style: TextStyle(color: AppColor.greyLight, fontSize: 13),
//           ),
//         );
//       }

//       return Container(
//         height: 52,
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         decoration: BoxDecoration(
//           color: AppColor.kwhite,
//           borderRadius: BorderRadius.circular(7),
//           border: Border.all(color: AppColor.Eblack.withOpacity(0.04)),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: controller.selectedMainFieldId.value.isEmpty
//                 ? controller.mainFields.first.id
//                 : controller.selectedMainFieldId.value,
//             isExpanded: true,
//             icon: Icon(
//               Icons.keyboard_arrow_down_rounded,
//               color: AppColor.greyLight,
//             ),
//             items: controller.mainFields.map((field) {
//               return DropdownMenuItem<String>(
//                 value: field.id,
//                 child: Text(
//                   field.name,
//                   style: TextStyle(
//                     color: AppColor.Eblack,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               );
//             }).toList(),
//             onChanged: (value) {
//               if (value == null) return;

//               final field = controller.mainFields.firstWhere(
//                 (element) => element.id == value,
//               );

//               controller.selectMainField(field);
//             },
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildJobTypeSelector() {
//     return Obx(
//       () => Row(
//         children: [
//           _pill(
//             text: 'Freelance',
//             value: 'Freelance',
//             groupValue: controller.selectedJobType.value,
//             onTap: controller.selectJobType,
//           ),
//           const SizedBox(width: 8),
//           _pill(
//             text: 'Full Time',
//             value: 'FullTime',
//             groupValue: controller.selectedJobType.value,
//             onTap: controller.selectJobType,
//           ),
//           const SizedBox(width: 8),
//           _pill(
//             text: 'Remote',
//             value: 'Remote',
//             groupValue: controller.selectedWorkMode.value,
//             onTap: controller.selectWorkMode,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _pill({
//     required String text,
//     required String value,
//     required String groupValue,
//     required void Function(String value) onTap,
//   }) {
//     final isSelected = value == groupValue;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () => onTap(value),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           height: 36,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: isSelected ? AppColor.kblue : AppColor.kwhite,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: AppColor.kblue),
//           ),
//           child: Text(
//             text,
//             style: TextStyle(
//               color: isSelected ? AppColor.kwhite : AppColor.kblue,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _publishButton() {
//     return Obx(
//       () => Center(
//         child: SizedBox(
//           width: 170,
//           height: 42,
//           child: ElevatedButton(
//             onPressed: controller.isLoading.value
//                 ? null
//                 : controller.publishJob,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.kblue,
//               disabledBackgroundColor: AppColor.greyLight,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(22),
//               ),
//             ),
//             child: controller.isLoading.value
//                 ? SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       color: AppColor.kwhite,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : Text(
//                     'Publish Job',
//                     style: TextStyle(
//                       color: AppColor.kwhite,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
