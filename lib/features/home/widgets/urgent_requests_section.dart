// import 'package:flutter/material.dart';

// import '../../../../app/theme/app_spacing.dart';

// import 'urgent_request_card.dart';

// class UrgentRequestsSection extends StatelessWidget {
//   const UrgentRequestsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,

//         children: [
//           /// HEADER
//           Row(
//             children: [
//               const Text(
//                 'DEMANDES URGENTES',

//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
//               ),

//               const SizedBox(width: 10),

//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 5,
//                 ),

//                 decoration: BoxDecoration(
//                   color: Colors.red,

//                   borderRadius: BorderRadius.circular(30),
//                 ),

//                 child: const Text(
//                   'LIVE',

//                   style: TextStyle(
//                     color: Colors.white,

//                     fontWeight: FontWeight.w800,

//                     fontSize: 11,
//                   ),
//                 ),
//               ),

//               const Spacer(),

//               TextButton(onPressed: () {}, child: const Text('Voir tout')),
//             ],
//           ),

//           const SizedBox(height: 22),

//           /// FILTERS
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,

//             child: Row(
//               children: [
//                 _chip('Tous', true),

//                 _chip('O+', false),

//                 _chip('A+', false),

//                 _chip('B+', false),

//                 _chip('AB+', false),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           /// REQUESTS
//           UrgentRequestCard(
//             hospital: 'Hôpital National',

//             bloodGroup: 'O+',

//             urgency: 'Critique',

//             quantity: '2 poches',

//             distance: '2.1 km',

//             critical: true,

//             onTap: () {},
//           ),

//           UrgentRequestCard(
//             hospital: 'Centre CNTS',

//             bloodGroup: 'A+',

//             urgency: 'Stock bas',

//             quantity: '4 poches',

//             distance: '4.8 km',

//             critical: false,

//             onTap: () {},
//           ),

//           UrgentRequestCard(
//             hospital: 'Hôpital Amitié',

//             bloodGroup: 'O-',

//             urgency: 'Urgent',

//             quantity: '1 poche',

//             distance: '7.3 km',

//             critical: true,

//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _chip(String text, bool active) {
//     return Container(
//       margin: const EdgeInsets.only(right: 10),

//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

//       decoration: BoxDecoration(
//         color: active ? Colors.red : Colors.white,

//         borderRadius: BorderRadius.circular(30),

//         border: Border.all(color: active ? Colors.red : Colors.grey.shade300),
//       ),

//       child: Text(
//         text,

//         style: TextStyle(
//           color: active ? Colors.white : Colors.black87,

//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }
