import 'package:flutter/material.dart';

class BloodRequestNotificationCard extends StatelessWidget {
  final String bloodGroup;
  final String city;
  final String date;
  final bool isRead;
  final VoidCallback? onTap;

  const BloodRequestNotificationCard({
    super.key,
    required this.bloodGroup,
    required this.city,
    required this.date,
    required this.isRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: isRead ? Colors.grey.shade100 : const Color(0xFFE3F2FD),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: isRead ? Colors.grey.shade300 : const Color(0xFF4FC3F7),
        ),
      ),

      child: Row(
        children: [
          /// ICONE
          Container(
            height: 50,
            width: 50,

            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.bloodtype, color: Colors.red),
          ),

          const SizedBox(width: 16),

          /// TEXTE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "🚨 Besoin de sang $bloodGroup",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(city, style: TextStyle(color: Colors.grey.shade700)),

                const SizedBox(height: 4),

                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

       Container(
  margin: const EdgeInsets.only(left: 12),

  child: ElevatedButton(
    onPressed: onTap,

    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFC1121F),

      foregroundColor: Colors.white,

      minimumSize: const Size(90, 42),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    child: const Text("J'y vais"),
  ),
)
        ],
      ),
    );
  }
}
