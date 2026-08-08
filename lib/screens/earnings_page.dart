import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ufc_delivery_app/components/chart.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';
import 'package:ufc_delivery_app/extensions/app_fonts.dart';
import 'package:ufc_delivery_app/notifiers/earnings_notifier.dart';
import 'package:ufc_delivery_app/notifiers/order_notifier.dart';
import 'package:ufc_delivery_app/providers/earnings_provider.dart';
import 'package:ufc_delivery_app/providers/order_provider.dart';
import 'package:ufc_delivery_app/screens/order_details_page.dart';
import 'package:ufc_delivery_app/shared/utils/constants/constants.dart';

class EarningsPage extends ConsumerStatefulWidget {
  const EarningsPage({super.key});

  @override
  EarningsPageState createState() => EarningsPageState();
}

class EarningsPageState extends ConsumerState<EarningsPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(earningsProvider.notifier).fetchEarnings();

      await ref
          .read(orderProvider.notifier)
          .fetchCompletedOrders(isRefreshing: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final earningsState = ref.watch(earningsProvider);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ----- TOTAL EARNINGS -------//
                ...totalEarningsWidget(earningsState, appColors),
                Align(
                  alignment: Alignment.center,
                  child: CustomPaint(
                    size: const Size(320, 2),
                    painter: DottedLinePainterHorizontal(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///-------- Previous month orders taken ----//
                      Expanded(
                          child:
                              previousMonthEarnings(earningsState, appColors)),

                      Align(
                        alignment: Alignment.center,
                        child: CustomPaint(
                          size: const Size(2, 50),
                          painter: DottedLinePainterVertical(),
                        ),
                      ),

                      ///-------- NO.of Orders taken --------//
                      Expanded(
                          child:
                              noOfOrdersTakenWidget(earningsState, appColors)),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ----- earnings graph ------//
                  graphOfEarnings(earningsState, appColors),

                  ///------ Delivery History -----//
                  kHeight20,
                  ...deliveryHistory(orderState, appColors),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// total earnings
  List<Widget> totalEarningsWidget(
      EarningsState earningsState, AppColors appColors) {
    return [
      Text(
        'Total Earnings'.tr(),
        style: AppFonts.lightHeadingTextStyle.copyWith(
          color: appColors.lightHeadingTextColor,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: NumberFormat('#,##0')
                  .format(earningsState.earningsData?.totalEarnings ?? 0),
              style: AppFonts.bigBoldTextStyle.copyWith(
                color: swipeBtnBgColor,
              ),
            ),
            TextSpan(
              text: ' ${'SAR'.tr()}',
              style: AppFonts.mediumBoldTextStyle
                  .copyWith(color: appColors.primaryColor),
            ),
          ],
        ),
      ),
      kHeight25,
    ];
  }

  /// Earnings in last month
  Widget previousMonthEarnings(
      EarningsState earningsState, AppColors appColors) {
    return Column(
      children: [
        Text(
          'Previous Month'.tr(),
          style: AppFonts.lightHeadingTextStyle.copyWith(
            color: appColors.lightHeadingTextColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${'SAR'.tr()} ',
                style: AppFonts.boldTextStyle.copyWith(
                  color: appColors.inactiveTabbarBtnTextColor,
                ),
              ),
              TextSpan(
                text: NumberFormat('#,##0')
                    .format(earningsState.earningsData?.lastMonthEarnings ?? 0),
                style: AppFonts.boldTextStyle3
                    .copyWith(color: appColors.inactiveTabbarBtnTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// NO. of Orders taken
  Widget noOfOrdersTakenWidget(
      EarningsState earningsState, AppColors appColors) {
    return Column(
      children: [
        Text(
          'Orders Taken'.tr(),
          style: AppFonts.lightHeadingTextStyle.copyWith(
            color: appColors.lightHeadingTextColor,
          ),
        ),
        kHeight10,
        Text(
          earningsState.earningsData?.totalOrders.toString() ?? '',
          style: AppFonts.boldTextStyle3.copyWith(
            color: swipeBtnBgColor,
          ),
        ),
      ],
    );
  }

  /// graph representation of earnings earned
  Widget graphOfEarnings(EarningsState earningsState, AppColors appColors) {
    return Container(
      height: 167,
      decoration: BoxDecoration(
        color: appColors.orderDetailsBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 1),
      child: BarChartScreen(
        embedded: true,
        barData: earningsState.earningsData?.ordersChart ?? [0, 0, 0, 0, 0, 0],
      ),
    );
  }

  /// list of previous delivery
  List<Widget> deliveryHistory(OrderState orderState, AppColors appColors) {
    return [
      Text(
        'Delivery History'.tr(),
        style:
            AppFonts.boldHeadingStyle.copyWith(color: appColors.primaryColor),
      ),
      const SizedBox(height: 20),
      Column(
        children: orderState.completedOrders.map((order) {
          return Column(
            children: [
              historyOrderDetailsCard(
                  orderNumberText: '${"Order".tr()} #${order.id}',
                  orderNumber: order.id.toString(),
                  context: context,
                  orderedDate: order.bookingDateTime),
              const SizedBox(height: 12),
            ],
          );
        }).toList(), // Convert Iterable to List
      )
    ];
  }
}

class DottedLinePainterHorizontal extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = swipeBtnBgColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 5;
    double dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DottedLinePainterVertical extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lightHeadingTextColors
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 4;
    double dashSpace = 4;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget historyOrderDetailsCard(
    {required String orderNumberText,
    required String orderNumber,
    required BuildContext context,
    required String orderedDate}) {
  final appColors = Theme.of(context).extension<AppColors>()!;
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (contex) => OrderDetailsPage(
                    orderId: orderNumber,
                    orderDate: orderedDate,
                    scheduleDeliver: '',
                    isAcceptedOrder: true,
                  )));
    },
    child: Container(
      width: 380,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 5, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            orderNumberText,
            style:
                AppFonts.boldTextStyle.copyWith(color: appColors.primaryColor),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View Details'.tr(),
                style: AppFonts.tabBarBtnTextStyle.copyWith(
                  color: swipeBtnBgColor,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: swipeBtnBgColor,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
