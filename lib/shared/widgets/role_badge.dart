import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  Color _backgroundColor() {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color(0xFFFFE5E5);
      case 'staff':
        return const Color(0xFFE3F2FD);
      case 'directeur':
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _textColor() {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color(0xFFC62828);
      case 'staff':
        return const Color(0xFF1565C0);
      case 'directeur':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: _textColor(),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
