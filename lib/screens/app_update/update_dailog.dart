// // import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// import 'package:url_launcher/url_launcher.dart';

// import 'app_update.dart';

// class UpdateDialog extends StatelessWidget {
//   final bool mandatory;
//   const UpdateDialog({super.key, required this.mandatory});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//         title: Text(
//           // "New version available".tr(),
//           "New version available",
//           style: const TextStyle(
//               color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w700),
//         ),
//         content: Text(
//           mandatory
//               ? "please update your application. otherwise you will not be able to use the app"
//               // .tr()
//               : "Would you like to update your application?",
//           // .tr(),
//           style: const TextStyle(
//               color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
//         ),
//         actions: [
//           mandatory
//               ? const SizedBox.shrink()
//               : TextButton(
//                   style: const ButtonStyle(
//                       backgroundColor:
//                           WidgetStatePropertyAll(Colors.redAccent)),
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     'UPDATE LATER',
//                     // .tr(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//           TextButton(
//             style: ButtonStyle(
//                 backgroundColor: WidgetStatePropertyAll(Colors.orangeAccent)),
//             onPressed: () => launchUrl(Uri.parse(AppUpdate.storeUrl ?? ''),
//                 mode: LaunchMode.externalApplication),
//             child: Text(
//               "UPDATE",
//               // .tr(),
//               style: const TextStyle(color: Colors.white),
//             ),
//           )
//         ]);
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'app_update.dart';

// class UpdateDialog extends StatelessWidget {
//   final bool mandatory;
//   const UpdateDialog({super.key, required this.mandatory});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0), // Rounded dialog edges
//       ),
//       title: Text(
//         "New version available",
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.black,
//           fontSize: 20.0,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             mandatory
//                 ? "Please update your application. Otherwise, you will not be able to use the app."
//                 : "Would you like to update your application?",
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 16.0,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const SizedBox(height: 16.0), // Space between text and buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               if (!mandatory)
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Colors.grey, // Grey theme for "Update Later"
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(14.0), // Slightly rounded edges
//                     ),
//                     minimumSize: const Size(90, 32), // Reduced button size
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14.0, vertical: 8.0),
//                     elevation: 0, // No shadow for a minimalistic look
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text(
//                     'LATER',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                 ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent, // Red theme for "Update"
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(14.0), // Slightly rounded edges
//                   ),
//                   minimumSize: const Size(90, 32), // Reduced button size
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12.0, vertical: 8.0),
//                   elevation: 0, // No shadow for a minimalistic look
//                 ),
//                 onPressed: () => launchUrl(
//                   Uri.parse(AppUpdate.storeUrl ?? ''),
//                   mode: LaunchMode.externalApplication,
//                 ),
//                 child: const Text(
//                   'UPDATE',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add google_fonts package in pubspec.yaml
import 'package:url_launcher/url_launcher.dart';

import 'app_update.dart';

class UpdateDialog extends StatelessWidget {
  final bool mandatory;
  const UpdateDialog({super.key, required this.mandatory});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Rounded dialog edges
      ),
      title: Text(
        "New version available",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mandatory
                ? "Please update your application. Otherwise, you will not be able to use the app."
                : "Would you like to update your application?",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16.0), // Space between text and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!mandatory)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Grey theme for "Later"
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14.0), // Rounded edges
                    ),
                    minimumSize: const Size(90, 32), // Reduced button size
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    elevation: 2, // Subtle shadow for depth
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                  label: Text(
                    'LATER',
                    style: GoogleFonts.poppins(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Red theme for "Update"
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0), // Rounded edges
                  ),
                  minimumSize: const Size(90, 32), // Reduced button size
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  elevation: 2, // Subtle shadow for depth
                ),
                onPressed: () => launchUrl(
                  Uri.parse(AppUpdate.storeUrl ?? ''),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(
                  Icons.system_update_alt,
                  size: 16,
                ),
                label: Text(
                  'UPDATE',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
