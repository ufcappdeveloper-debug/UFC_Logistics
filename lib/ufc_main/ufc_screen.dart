// import 'package:flutter/material.dart';
// import 'package:ufc_delivery_app/ufc_main/ufc_colors.dart';
// import 'package:ufc_delivery_app/ufc_main/ufc_fonts.dart';
// import 'package:dotted_decoration/dotted_decoration.dart';

// class UfcScreen extends StatelessWidget {
//   const UfcScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         driverCardWidget(
//             driverName: 'Abdulaziz Ali',
//             driverRating: '4.7',
//             driverFee: '2500 SAR',
//             driverImg: 'assets/ufc/driver2.png',
//             isActive: false),
//         SizedBox(
//           height: 20,
//         ),
//         driverCardWidget(
//             driverName: 'Raju Kumar',
//             driverRating: '4.9',
//             driverFee: '2550 SAR',
//             driverImg: 'assets/ufc/driver.png',
//             isActive: true),
//         SizedBox(
//           height: 20,
//         ),
//         driverCardWidget(
//             driverName: 'Mohammed Khan',
//             driverRating: '4.2',
//             driverFee: '2400 SAR',
//             driverImg: 'assets/ufc/driver3.png',
//             isActive: false),
//         SizedBox(
//           height: 20,
//         ),
//         rewardCouponClaimCardWidget(couponAmount: 'SAR 500')
//       ],
//     )));
//   }
// }

// Widget driverCardWidget(
//     {required String driverName,
//     required String driverRating,
//     required String driverFee,
//     required String driverImg,
//     required bool isActive}) {
//   return Container(
//       width: 380,
//       height: 56,
//       decoration: BoxDecoration(
//         color: isActive
//             ? UfcAppColors.driverCardActiveBgCOlor
//             : UfcAppColors.driverCardTextColor,
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(
//           color: UfcAppColors.driverCardBorderColor,
//           width: 1,
//         ),
//       ),
//       padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 ClipOval(
//                   child: Container(
//                     width: 46,
//                     height: 46, // Diameter of the circle
//                     color: Colors
//                         .grey[200], // Optional background color for the circle
//                     child: Image.asset(
//                       driverImg, // Replace with your image path
//                       fit: BoxFit
//                           .cover, // Ensures the image covers the circle area
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12.5),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ClipOval(
//                         child: SizedBox(
//                       width: 12,
//                       height: 12,
//                       child: Image.asset(
//                         'assets/ufc/star.png',
//                         fit: BoxFit.cover,
//                       ),
//                     )),
//                     SizedBox(
//                       height: 3,
//                     ),
//                     Text(driverRating,
//                         style: UfcAppFonts.driverRatingTextStyle.copyWith(
//                           color: isActive
//                               ? UfcAppColors.driverCardTextColor
//                               : UfcAppColors.driverCardInactiveTextColor,
//                         ))
//                   ],
//                 ),
//                 SizedBox(width: 12.5),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Driver Name',
//                         style: UfcAppFonts.driverCardHeadingTextStyle.copyWith(
//                           color: isActive
//                               ? UfcAppColors.driverCardHeadingTextColor
//                               : UfcAppColors.driverCardInactiveHeadingTextColor,
//                         )),
//                     SizedBox(
//                       height: 3,
//                     ),
//                     Text(driverName,
//                         style: UfcAppFonts.driverCardTextStyle.copyWith(
//                           color: isActive
//                               ? UfcAppColors.driverCardTextColor
//                               : UfcAppColors.driverCardInactiveTextColor,
//                         ))
//                   ],
//                 ),
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Driver Fee',
//                     style: UfcAppFonts.driverCardHeadingTextStyle.copyWith(
//                       color: isActive
//                           ? UfcAppColors.driverCardHeadingTextColor
//                           : UfcAppColors.driverCardInactiveHeadingTextColor,
//                     )),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Text(driverFee,
//                     style: UfcAppFonts.driverCardTextStyle.copyWith(
//                       color: isActive
//                           ? UfcAppColors.driverCardTextColor
//                           : UfcAppColors.driverCardInactiveTextColor,
//                     ))
//               ],
//             )
//           ]));
// }

// Widget rewardCouponClaimCardWidget({
//   required String couponAmount,
// }) {
//   return Container(
//       width: 370,
//       height: 56,
//       decoration: DottedDecoration(
//           shape: Shape.box,
//           borderRadius: BorderRadius.circular(20),
//           color: UfcAppColors.driverCardActiveBgCOlor),
//       padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Voucher',
//                     style: UfcAppFonts.rewardVoucherTitleTextStyle
//                         .copyWith(color: UfcAppColors.driverCardActiveBgCOlor)),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Text(couponAmount,
//                     style: UfcAppFonts.rewardVoucherAmountTextStyle.copyWith(
//                       color: UfcAppColors.driverCardActiveBgCOlor,
//                     ))
//               ],
//             ),
//             Center(
//               child: Text('Get now',
//                   style: UfcAppFonts.rewardVoucherBtnTextStyle
//                       .copyWith(color: UfcAppColors.driverCardActiveBgCOlor)),
//             ),
//           ]));
// }
