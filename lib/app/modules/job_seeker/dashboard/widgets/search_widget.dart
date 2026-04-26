// lib/app/modules/job_seeker/dashboard/widgets/search_widget.dart
import 'package:flutter/material.dart';
import 'package:hire_me/app/core/utils/app_color.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;
  final String hint;

  const SearchBarWidget({
    required this.searchController,
    required this.onChanged,
    this.hint = 'Search',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.kblue.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: onChanged,
          style: TextStyle(fontSize: 15, color: AppColor.kwhite),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColor.greyLight, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: AppColor.greyLight),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}
