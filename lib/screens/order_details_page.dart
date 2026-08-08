import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_delivery_app/components/arrow.dart';
import 'package:ufc_delivery_app/components/custom_snackbar.dart';
import 'package:ufc_delivery_app/components/show_location_on_maps.dart';
import 'package:ufc_delivery_app/components/url_launcher.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';
import 'package:ufc_delivery_app/providers/order_provider.dart';
import 'package:ufc_delivery_app/screens/order_page.dart';
import 'package:ufc_delivery_app/shared/utils/constants/constants.dart';

import '../extensions/app_fonts.dart';

class OrderDetailsPage extends ConsumerStatefulWidget {
  final String orderId;
  final String orderDate;
  final String scheduleDeliver;
  final bool isAcceptedOrder;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
    required this.orderDate,
    required this.scheduleDeliver,
    required this.isAcceptedOrder,
  });

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  // late Future<void> _fetchOrderDetailsFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetails();
    });
  }

  Future<void> _fetchOrderDetails() async {
    final orderNotifier = ref.read(orderProvider.notifier);
    await orderNotifier.fetchOrderDetails(widget.orderId);
  }

  String get formattedDate {
    try {
      String bookingDateTime = widget.orderDate;
      DateTime dateTime = DateTime.parse(bookingDateTime);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (_) {
      return widget.orderDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: SvgPicture.asset(
                      'assets/icons/Back.svg',
                      colorFilter: ColorFilter.mode(
                        appColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  )),
            ),
            Positioned(
              left: 45,
              child: Text(
                '${'Order'.tr()} #${widget.orderId}',
                style: AppFonts.boldTitleTextStyle
                    .copyWith(color: appColors.boldTitleTextColor),
              ),
            )
          ],
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final orderState = ref.watch(orderProvider);

          if (orderState.isLoadingdOrderDetails) {
            return Center(child: CircularProgressIndicator());
          }

          if ((orderState.orderDetails ?? {}).isEmpty) {
            return Center(child: Text('No order details available'.tr()));
          }

          if ((orderState.errorMessageOrderDetails ?? '').isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    (orderState.errorMessageOrderDetails ?? '').tr(),
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          if ((orderState.orderDetails ?? {}).isNotEmpty &&
              orderState.orderDetails?['status'] == 'fail') {
            // Handle API failure case (e.g., "You are not authorized to access this order")
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    orderState.orderDetails?['data']['message'] ??
                        'Unknown error occurred'.tr(),
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            // child: Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  orderDetailsCard(
                      orderNumber: widget.orderId,
                      orderedDate: formattedDate,
                      deliveryFee: orderState
                              .orderDetails?['delivery_fee']
                              ?.toString() ??
                          '0',
                      load: '90',
                      scheduleDeliver: widget.scheduleDeliver,
                      customerName:
                          '${orderState.orderDetails?['customer_info']?['name']}',
                      customerPhone:
                          orderState.orderDetails?['delivery_address']
                                  ?['phone_number'] ??
                              '0',
                      context: context),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Order Locations'.tr(),
                    style: AppFonts.boldHeadingStyle
                        .copyWith(color: appColors.primaryColor),
                  ),
                  kHeight20,
                  orderLocationCustomView(
                    address: address(orderState.orderDetails ?? {}),
                    title1: 'From'.tr(),
                    value1: orderState.orderDetails?['shop']?['name_en'] ??
                        'No Station'.tr(),
                    title2: 'To',
                    value2: orderState.orderDetails?['delivery_address']
                                ?['address']
                            ?.split(',')
                            .first ??
                        'No City Name'.tr(),
                    context: context,
                    shopLat: orderState.orderDetails?['shop']?['latitude'] ?? 0,
                    shopLong:
                        orderState.orderDetails?['shop']?['longitude'] ?? 0,
                    deliveryLat: orderState.orderDetails?['delivery_address']
                            ?['latitude'] ??
                        0,
                    deliveryLong: orderState.orderDetails?['delivery_address']
                            ?['longitude'] ??
                        0,
                  ),
                  kHeight20,
                  Text(
                    'Delivery Details'.tr(),
                    style: AppFonts.boldHeadingStyle.copyWith(
                      color: appColors.primaryColor,
                    ),
                  ),
                  kHeight20,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      (orderState.orderDetails?['items']?.length ?? 0),
                      (index) {
                        var item = orderState.orderDetails?['items']?[index];
                        if (item == null) {
                          return const SizedBox();
                        }
                        return orderItem(
                          appColors: appColors,
                          item: item['product_name'] ?? 'Unknown'.tr(),
                          quantity: item['quantity'].toString(),
                          imgPath: 'assets/images/item1.png',
                          // Fallback if no image URL
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: (!widget.isAcceptedOrder &&
              (orderState.errorMessageOrderDetails ?? '').isEmpty)
          ? Container(
              decoration: BoxDecoration(
                color: appColors.secondaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: AcceptOrderSwipeButton(orderId: widget.orderId, ref: ref),
            )
          : null,
    );
  }

  String address(Map<String, dynamic> orderDetails) {
    return orderDetails['delivery_address']?['address'] ?? '';
  }
}

Widget orderDetailsCard(
    {required String orderNumber,
    required String orderedDate,
    required String deliveryFee,
    required String load,
    required String scheduleDeliver,
    required String customerName,
    required String customerPhone,
    required BuildContext context}) {
  final appColors = Theme.of(context).extension<AppColors>()!;
  return Container(
    // height: 204,
    decoration: BoxDecoration(
      color: appColors.orderDetailsBgColor,
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTitleAndValue(
                appColors: appColors,
                title: '${'Order'.tr()} #',
                value: orderNumber,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Fee'.tr(),
                    style: AppFonts.lightHeadingTextStyle
                        .copyWith(color: appColors.inactiveTabbarBtnTextColor),
                  ),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: deliveryFee,
                          style: AppFonts.boldTextStyle.copyWith(
                            color: appColors.primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: ' ${'SAR'.tr()}',
                          style: AppFonts.lightHeadingTextStyle
                              .copyWith(color: appColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              customTitleAndValue(
                  appColors: appColors,
                  title: 'Customer Name'.tr(),
                  value: customerName),
            ],
          ),
          const SizedBox(
            width: 80,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTitleAndValue(
                title: 'Date'.tr(),
                value: orderedDate,
                appColors: appColors,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // customTitleAndValue(
              //     appColors: appColors, title: 'Load'.tr(), value: load),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule Deliver'.tr(),
                    style: AppFonts.lightHeadingTextStyle
                        .copyWith(color: appColors.inactiveTabbarBtnTextColor),
                  ),
                  Text(
                    scheduleDeliver,
                    style:
                        AppFonts.boldTextStyle.copyWith(color: swipeBtnBgColor),
                  )
                ],
              ),
            ],
          )
        ]),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: roundedRectangleCustomView(
            title: 'Call Customer'.tr(),
            value: customerName,
            context: context,
            customerPhone: customerPhone,
          ),
        )
      ],
    ),
  );
}

Widget customTitleAndValue({
  required String title,
  required String value,
  required AppColors appColors,
  bool isUnderlined = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title.tr(),
        style: AppFonts.lightHeadingTextStyle.copyWith(
          color: appColors.inactiveTabbarBtnTextColor,
        ),
      ),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppFonts.boldTextStyle.copyWith(
          fontWeight: isUnderlined ? FontWeight.w300 : null,
          color:
              isUnderlined ? appColors.highLightColor : appColors.primaryColor,
        ),
      )
    ],
  );
}

Widget roundedRectangleCustomView({
  required String title,
  required String value,
  required String customerPhone,
  required BuildContext context,
}) {
  final appColors = Theme.of(context).extension<AppColors>()!;
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: appColors.secondaryColor,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: appColors.dividerColor,
        width: 1,
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            kWidth10,
            customTitleAndValue(
                appColors: appColors, title: title, value: value),
          ],
        ),
        GestureDetector(
          onTap: () async {
            try {
              launchPhoneCall(customerPhone);
            } catch (e) {
              // if (!mounted) return;
              // CustomSnackBar.show(context, e.toString());
            }
          },
          child: ClipOval(
            child: Image.asset(
              'assets/icons/call_red.png',
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget orderLocationCustomView({
  required String title1,
  required String value1,
  required String title2,
  required String value2,
  required double shopLat,
  required double shopLong,
  required double deliveryLat,
  required double deliveryLong,
  required String address,
  required BuildContext context,
}) {
  final appColors = Theme.of(context).extension<AppColors>()!;
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Column(
        children: [
          Container(
            width: 380,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: appColors.inactiveTabbarBtnTextColor,
                        size: 25,
                      ),
                      kWidth5,
                      customTitleAndValue(
                        appColors: appColors,
                        title: title1,
                        value: value1,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        showLocationOnMaps(context, shopLat, shopLong);
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View Location'.tr(),
                            style: AppFonts.tabBarBtnTextStyle
                                .copyWith(color: swipeBtnBgColor)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios,
                            size: 16, color: swipeBtnBgColor),
                      ],
                    ),
                  ),
                ]),
          ),
          kHeight10,
          Container(
            width: 380,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// TO ADDRESS
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(
                                address.isEmpty ? 'No Address'.tr() : address),
                          ),
                        );
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: appColors.inactiveTabbarBtnTextColor,
                              size: 25,
                            ),
                            kWidth5,
                            Expanded(
                              child: customTitleAndValue(
                                appColors: appColors,
                                title: title2,
                                value: value2,
                                isUnderlined: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// vew location button for to address
                  vewLocationOnMapForToAddress(
                    context,
                    deliveryLat,
                    deliveryLong,
                  ),
                ]),
          ),
        ],
      ),
      Positioned(
        top: 45,
        left: MediaQuery.of(context).size.width / 2 - 20, // Adjust as needed
        child: const Align(
          alignment: Alignment.center,
          child: VerticalDottedLineWithIcons(),
        ),
      )
    ],
  );
}

GestureDetector vewLocationOnMapForToAddress(
    BuildContext context, double deliveryLat, double deliveryLong) {
  return GestureDetector(
    onTap: () async {
      try {
        showLocationOnMaps(context, deliveryLat, deliveryLong);
      } catch (e) {
        // if (!mounted) return;
        // CustomSnackBar.show(context, e.toString());
      }
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'View Location'.tr(),
          style: AppFonts.tabBarBtnTextStyle.copyWith(
            color: swipeBtnBgColor,
          ),
        ),
        kWidth10,
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: swipeBtnBgColor,
        ),
      ],
    ),
  );
}

class VerticalDottedLineWithIcons extends StatelessWidget {
  const VerticalDottedLineWithIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: appColors.inactiveTabbarBtnTextColor,
              shape: BoxShape.circle,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(2, 30),
                painter: DottedLinePainter(),
              ),
            ],
          ),
          Icon(
            Icons.arrow_drop_down,
            color: appColors.inactiveTabbarBtnTextColor,
            size: 18,
          ),
        ],
      );
    });
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = inactiveTabbarBtnTextColors
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 2;
    double dashSpace = 2;
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

Widget orderItem({
  required String item,
  required String quantity,
  required String imgPath,
  required AppColors appColors,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset(imgPath),
              customTitleAndValue(
                  appColors: appColors, title: 'item'.tr(), value: item),
            ],
          ),
        ),
        customTitleAndValue(
            appColors: appColors, title: 'Qty'.tr(), value: quantity)
      ],
    ),
  );
}

class AcceptOrderSwipeButton extends StatefulWidget {
  final WidgetRef ref;
  final String orderId;

  const AcceptOrderSwipeButton({
    super.key,
    required this.ref,
    required this.orderId,
  });

  @override
  AcceptOrderSwipeButtonState createState() => AcceptOrderSwipeButtonState();
}

class AcceptOrderSwipeButtonState extends State<AcceptOrderSwipeButton> {
  double _circlePosition = 6;
  final double _circleSize = 49;
  bool _isComplete = false;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double barWidth = (deviceWidth - 80);
    double swipeThreshold = (deviceWidth - 80) - 12;

    double swipeProgress = (_circlePosition - 12) / (swipeThreshold - 12);
    swipeProgress = swipeProgress.clamp(0.0, 1.0);
    final appColors = Theme.of(context).extension<AppColors>()!;
    bool isRtl = context.locale.languageCode != 'en';

    return Container(
      width: barWidth,
      height: 61,
      decoration: BoxDecoration(
        color: appColors.highLightColor
            .withOpacity(0.7 + (0.3 * (1 - swipeProgress))),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          swipeText(swipeProgress),
          Positioned(
            left: isRtl ? null : _circlePosition,
            right: isRtl ? _circlePosition : null,
            top: (61 - _circleSize) / 2,
            child: swipeAnimation(swipeThreshold, context, isRtl),
          ),
        ],
      ),
    );
  }

  GestureDetector swipeAnimation(
      double swipeThreshold, BuildContext context, bool isRtl) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _circlePosition =
              (_circlePosition + (isRtl ? -details.delta.dx : details.delta.dx))
                  .clamp(12.0, swipeThreshold);

          _isComplete = _circlePosition >= swipeThreshold;
        });
      },
      onPanEnd: (details) async {
        if (_isComplete) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );

          try {
            final result = await widget.ref
                .read(acceptOrderProvider(widget.orderId).future);

            if (!context.mounted) return;
            Navigator.pop(context);

            if (result['status'] == 'success') {
              CustomSnackbar.show(context, 'Order Accepted Successfully'.tr());

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OrderPage()),
              );
            } else {
              CustomSnackbar.show(
                  context, result['message'] ?? 'Failed to accept order'.tr());

              resetSwipe();
            }
          } catch (e) {
            Navigator.pop(context);
            CustomSnackbar.show(context, 'Oops..! Something went wrong'.tr());

            resetSwipe();
          }
        } else {
          resetSwipe();
        }
      },
      child: Container(
        width: _circleSize,
        height: _circleSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: _isComplete
                ? const Icon(Icons.check, color: swipeBtnBgColor)
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ArrowAnimation(isAnimationActive: true),
                  ),
          ),
        ),
      ),
    );
  }

  void resetSwipe() {
    setState(() {
      _circlePosition = 6;
      _isComplete = false;
    });
  }

  Center swipeText(double swipeProgress) {
    return Center(
      child: Opacity(
        opacity: 0.7 + (0.3 * (1 - swipeProgress)),
        child: Text(
          "Swipe to accept order".tr(),
          style: AppFonts.boldTextStyle.copyWith(
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
