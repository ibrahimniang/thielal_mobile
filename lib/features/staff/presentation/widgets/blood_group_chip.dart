import 'package:flutter/material.dart';

class BloodGroupChip extends StatelessWidget {
  final String group;
  final int count;

  const BloodGroupChip({super.key, required this.group, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        "$group : $count",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
