import 'package:ufc_delivery_app/components/custom_snackbar.dart';
import 'package:ufc_delivery_app/extensions/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../extensions/app_colors.dart';

void launchPhoneCall(String phoneNumber) async {
  final cleanedPhoneNumber = phoneNumber.replaceAll(' ', '');
  final url = Uri.parse("tel:$cleanedPhoneNumber");
  // print('url :: $url');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}

//  Future<void> launchPhoneCall(String phoneNumber) async {
//   final cleanedPhoneNumber = phoneNumber.replaceAll(' ', '');
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: cleanedPhoneNumber,
//     );
//     await launchUrl(launchUri);
//   }

class UrlRedirectingTextView extends StatelessWidget {
  // Define the URL
  final String url;
  final String title;

  const UrlRedirectingTextView(
      {super.key, required this.url, required this.title});

  // Function to open the URL
  void _launchUrl(BuildContext context) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.show(context, 'Could not open the link!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () => _launchUrl(context),
      child: Text(
        title,
        style: AppFonts.boldTextStyle.copyWith(
          color: appColors.primaryColor,
        ),
      ),
    );
  }
}
