// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:ufc_delivery_app/ufc_main/bottom_sheet.dart';

// class SignInPromptScreen extends StatelessWidget {
//   const SignInPromptScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Animated Icon
//               Container(
//                 height: 200,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 15,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Lottie.asset(
//                     'assets/ufc/auth_icon_animation.json',
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),

//               // Spacing
//               SizedBox(height: 30),

//               // Sign-in Text
//               Text(
//                 "Welcome Back!",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               SizedBox(height: 12),

//               // Subtext
//               Text(
//                 "Sign in to continue and unlock all features",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black54,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               SizedBox(height: 40),

//               // Custom Sign-in Button
//               GestureDetector(
//                 // onTap: () {
//                 //   Navigator.pushNamed(context, '/sign_in');
//                 // },
//                 onTap: () {
//                   showUnauthorizedBottomSheet(context, onSignInPressed: () {});
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                       vertical: 12, horizontal: 35), // Reduced size
//                   decoration: BoxDecoration(
//                     color: Colors.green, // Changed to green
//                     borderRadius: BorderRadius.circular(20), // Less roundness
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.green.withOpacity(0.5),
//                         blurRadius: 8, // Reduced blur for a subtler effect
//                         offset: Offset(0, 4), // Slightly smaller shadow offset
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     "Go to Sign In",
//                     style: TextStyle(
//                       fontSize: 16, // Slightly smaller font size
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Main Function to Run the App
// // void main() {
// //   runApp(MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     home: SignInPromptScreen(),
// //     routes: {
// //       '/sign_in': (context) => SignInPage(),
// //     },
// //   ));
// // }

// // Placeholder for the Sign In Page
// class SignInPage extends StatelessWidget {
//   const SignInPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Sign In"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Center(
//         child: Text(
//           "Sign In Page",
//           style: TextStyle(color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }
