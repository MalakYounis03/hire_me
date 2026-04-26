// import 'package:flutter/material.dart';
// import 'package:hire_me/app/modules/job_seeker/chat/controllers/chat_controller.dart';
// import 'package:hire_me/core/utils/app_color.dart';

// class SearchBarWidget extends StatelessWidget {
//   final ChatController controller;
//   const SearchBarWidget({required this.controller, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColor.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColor.divider),
//         ),
//         child: TextField(
//           controller: controller.searchController,
//           onChanged: controller.onSearchChanged,
//           style: const TextStyle(fontSize: 15, color: AppColor.textPrimary),
//           decoration: InputDecoration(
//             hintText: 'Search',
//             hintStyle: const TextStyle(
//               color: AppColor.textSecondary,
//               fontSize: 15,
//             ),
//             prefixIcon: const Icon(
//               Icons.search_rounded,
//               color: AppColor.textSecondary,
//               size: 22,
//             ),
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(vertical: 14),
//           ),
//         ),
//       ),
//     );
//   }
// }
