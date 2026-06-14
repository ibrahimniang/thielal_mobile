// import 'package:flutter/material.dart';
// // import 'package:latlong2/latlong.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../../app/theme/app_colors.dart';
// import '../../../../app/theme/app_radius.dart';
// import '../../../../app/theme/app_spacing.dart';

// import '../../data/models/center_model.dart';
// import '../../../../l10n/app_localizations.dart';
// import '../screens/centers_map_screen.dart';

// class CenterDetailsScreen extends StatelessWidget {
//   final CenterModel center;

//   const CenterDetailsScreen({super.key, required this.center});

//   Future<void> _callCenter() async {
//     final uri = Uri.parse('tel:${center.telephone}');

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }

//   Future<void> _openDirections() async {
//     final url =
//         'https://www.google.com/maps/dir/?api=1&destination=${center.latitude},${center.longitude}';

//     final uri = Uri.parse(url);

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: AppColors.silverBackground,

//       body: CustomScrollView(
//         slivers: [
//           /// APP BAR
//           SliverAppBar(
//             expandedHeight: 240,
//             pinned: true,

//             backgroundColor: AppColors.primaryRed,

//             elevation: 0,

//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Color(0xFFE53946), Color(0xFFC1121F)],
//                   ),
//                 ),

//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.all(AppSpacing.xl),

//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,

//                       mainAxisAlignment: MainAxisAlignment.end,

//                       children: [
//                         Container(
//                           height: 78,
//                           width: 78,

//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.18),

//                             borderRadius: BorderRadius.circular(24),
//                           ),

//                           child: const Icon(
//                             Icons.local_hospital_rounded,

//                             color: Colors.white,

//                             size: 42,
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         Text(
//                           center.nom,

//                           style: const TextStyle(
//                             color: Colors.white,

//                             fontSize: 28,

//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),

//                         const SizedBox(height: 8),

//                         Text(
//                           center.ville,

//                           style: const TextStyle(
//                             color: Colors.white70,

//                             fontSize: 15,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           /// BODY
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(AppSpacing.screenPadding),

//               child: Column(
//                 children: [
//                   /// ADDRESS CARD
//                   _infoCard(
//                     icon: Icons.location_on_rounded,

//                     title: l10n.address,

//                     value: center.adresse,
//                   ),

//                   const SizedBox(height: 18),

//                   /// PHONE CARD
//                   _infoCard(
//                     icon: Icons.call_rounded,

//                     title: l10n.phone,

//                     value: center.telephone ?? l10n.notAvailable,
//                   ),

//                   const SizedBox(height: 18),

//                   /// GPS CARD
//                   _infoCard(
//                     icon: Icons.gps_fixed_rounded,

//                     title: l10n.gpsCoordinates,

//                     value: '${center.latitude}, ${center.longitude}',
//                   ),

//                   const SizedBox(height: 28),

//                   /// QUICK ACTIONS
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: _callCenter,

//                           icon: const Icon(Icons.call_rounded),

//                           label: Text(l10n.call),
//                         ),
//                       ),

//                       const SizedBox(width: 16),

//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             print('CENTER NAME = ${center.nom}');
//                             print('CENTER ID = ${center.id}');

//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) =>
//                                         CentersMapScreen(initialCenter: center),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.navigation_rounded),
//                           label: Text(l10n.directions),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 30),

//                   /// STATUS CARD
//                   Container(
//                     width: double.infinity,

//                     padding: const EdgeInsets.all(22),

//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.red.withOpacity(0.08),

//                           Colors.red.withOpacity(0.03),
//                         ],
//                       ),

//                       borderRadius: BorderRadius.circular(AppRadius.xl),
//                     ),

//                     child: Row(
//                       children: [
//                         Container(
//                           height: 56,
//                           width: 56,

//                           decoration: BoxDecoration(
//                             color: AppColors.primaryRed.withOpacity(0.12),

//                             borderRadius: BorderRadius.circular(18),
//                           ),

//                           child: const Icon(
//                             Icons.bloodtype_rounded,

//                             color: AppColors.primaryRed,
//                           ),
//                         ),

//                         const SizedBox(width: 16),

//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,

//                             children: [
//                               Text(
//                                 l10n.activeCenter,

//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w800,

//                                   fontSize: 16,
//                                 ),
//                               ),

//                               SizedBox(height: 4),

//                               Text(
//                                 l10n.centerAvailableDescription,
//                                 style: TextStyle(
//                                   color: AppColors.textSecondary,

//                                   height: 1.5,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoCard({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(AppSpacing.xl),

//       decoration: BoxDecoration(
//         color: Colors.white,

//         borderRadius: BorderRadius.circular(AppRadius.xl),

//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),

//             blurRadius: 18,

//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),

//       child: Row(
//         children: [
//           Container(
//             height: 54,
//             width: 54,

//             decoration: BoxDecoration(
//               color: AppColors.primaryRed.withOpacity(0.1),

//               borderRadius: BorderRadius.circular(18),
//             ),

//             child: Icon(icon, color: AppColors.primaryRed),
//           ),

//           const SizedBox(width: 16),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 Text(
//                   title,

//                   style: const TextStyle(
//                     color: AppColors.textSecondary,

//                     fontSize: 13,
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 Text(
//                   value,

//                   style: const TextStyle(
//                     fontWeight: FontWeight.w800,

//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
