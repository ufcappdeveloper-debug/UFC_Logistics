// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// Future<void> showUnauthorizedBottomSheet(BuildContext context,
//     {required VoidCallback onSignInPressed}) {
//   return showModalBottomSheet<void>(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//     ),
//     builder: (BuildContext context) {
//       return SizedBox(
//           height: 280,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 // Lottie Animation
//                 Lottie.asset(
//                   'assets/ufc/auth_icon_animation.json', // Ensure this path is correct
//                   height: 100, // Adjusted size for better centering
//                   width: 100,
//                   fit: BoxFit.contain,
//                 ),
//                 // const SizedBox(height: 5),
//                 // Title
//                 Text(
//                   'You need to sign in',
//                   style: const TextStyle(
//                     fontSize: 16, // Reduced font size for better alignment
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 5),
//                 // Subtitle
//                 Text(
//                   'Sign in to access this feature.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 // Sign-In Button
//                 InkWell(
//                   onTap: onSignInPressed,
//                   splashColor: Colors.green[300],
//                   borderRadius: BorderRadius.circular(9.0),
//                   child: Ink(
//                     height: 38, // Smaller height for a compact button
//                     width: 160, // Reduced width for a balanced appearance
//                     decoration: BoxDecoration(
//                       color: const Color(0xff78B833),
//                       borderRadius: BorderRadius.circular(9.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'SIGN IN',
//                         style: const TextStyle(
//                           fontSize: 14, // Smaller font for a sleek button
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                     height: 20), // Ensure no extra free space at the bottom
//               ],
//             ),
//           ));
//     },
//   );
// }
