import 'package:flutter/material.dart';
import 'package:hire_me/app/modules/job_seeker/my_applications/controllers/job_seeker_my_applications_controller.dart';

class ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> app;
  final JobSeekerMyApplicationsController controller;

  const ApplicationCard({
    super.key,
    required this.app,
    required this.controller,
  });

  static const _textDark = Color(0xFF1A1A2E);
  static const _textGrey = Color(0xFF8A8A9A);

  @override
  Widget build(BuildContext context) {
    final status = app['status'] as String? ?? 'pending';
    final statusColor = controller.statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app['jobTitle'] as String? ?? 'Job Title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  app['companyName'] as String? ?? 'Company',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          _buildStatusBadge(status, statusColor),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    final companyName = app['companyName'] as String? ?? 'Company';
    final initials = companyName.trim().isNotEmpty
        ? companyName.trim().characters.first.toUpperCase()
        : 'C';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF123456),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color statusColor) {
    return Container(
      constraints: const BoxConstraints(minWidth: 86),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.65),
          width: 1.2,
        ),
      ),
      child: Text(
        _formatStatus(status),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: statusColor,
        ),
      ),
    );
  }

  String _formatStatus(String value) {
    if (value.isEmpty) return 'Pending';
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
