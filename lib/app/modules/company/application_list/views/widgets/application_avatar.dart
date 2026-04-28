import 'package:flutter/material.dart';

class ApplicantAvatar extends StatelessWidget {
  final String name;
  final String url;
  const ApplicantAvatar({required this.name, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
      backgroundColor: _getColor(name),
      child: url.isEmpty
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          : null,
    );
  }

  Color _getColor(String name) {
    final colors = [
      const Color(0xFF4A90D9),
      const Color(0xFFE8944A),
      const Color(0xFF7B68EE),
      const Color(0xFF48C78E),
      const Color(0xFFE05C7A),
    ];
    if (name.isEmpty) return colors[0];
    return colors[name.codeUnitAt(0) % colors.length];
  }
}
