import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_delivery_app/components/custom_end_drawer.dart';
import 'package:ufc_delivery_app/components/dotted_line_component.dart';
import 'package:ufc_delivery_app/config/config.dart';
import 'package:ufc_delivery_app/config/firebase_notification.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';
import 'package:ufc_delivery_app/extensions/app_fonts.dart';
import 'package:ufc_delivery_app/notifiers/order_notifier.dart';
import 'package:ufc_delivery_app/providers/order_provider.dart';
import 'package:ufc_delivery_app/screens/earnings_page.dart';
import 'package:ufc_delivery_app/screens/order_details_page.dart';
import 'package:ufc_delivery_app/screens/profile_page.dart';
import 'package:ufc_delivery_app/shared/utils/constants/constants.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends ConsumerState<OrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final ScrollController scrollController = ScrollController();
  String? savingsAmount;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
      _refreshController.resetNoData();
      _refreshController.refreshCompleted();
    });

    Future.microtask(() async => await FirebaseNotification.initMessaging());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      key: _scaffoldKey,
      // APP BAR
      appBar: _buildAppBar(
        appColors: appColors,
        orderQty: getOrderCountForSelectedTab(orderState),
        orderStatus: getOrderStatus(),
      ),
      endDrawer: CustomEndDrawer(), // END DRAWER
      body: _buildScreen(orderState, appColors), // PAGE UI
      bottomNavigationBar: bottomBar(appColors), // BOTTOM NAVIGATION BAR
    );
  }

  /// --------  WIDGETS ----------------//
  // main bottom bar (profile,earnings,orders)
  Widget bottomBar(AppColors appColors) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: appColors.primaryColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 16,
        bottom: Platform.isIOS ? 24 : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// ORDER TAB BAR
          customButton(
            appColors: appColors,
            text: 'Orders'.tr(),
            isOn: _currentIndex == 0,
            imagePath1: 'assets/icons/tabbar/orders1.png',
            imagePath2: 'assets/icons/tabbar/orders2.png',
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),

          /// EARNING TAB BAR
          customButton(
            appColors: appColors,
            text: 'Earnings'.tr(),
            isOn: _currentIndex == 1,
            imagePath1: 'assets/icons/tabbar/earnings2.png',
            imagePath2: 'assets/icons/tabbar/earnings1.png',
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),

          /// PROFILE TAB BAR
          customButton(
            appColors: appColors,
            text: 'Profile'.tr(),
            isOn: _currentIndex == 2,
            imagePath1: 'assets/icons/tabbar/profile2.png',
            imagePath2: 'assets/icons/tabbar/profile1.png',
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
        ],
      ),
    );
  }

  /// body of the page (profile page, earnings page, order lists)
  Widget _buildScreen(OrderState orderState, AppColors appColors) {
    switch (_currentIndex) {
      case 0:
        return _orderTabBarView(orderState, appColors);
      case 1:
        return EarningsPage();
      default:
        return const ProfilePage();
    }
  }

  /// app bar with order quantity and status
  PreferredSizeWidget _buildAppBar(
      {String? orderQty, String? orderStatus, required AppColors appColors}) {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Stack(
            clipBehavior: Clip.none,
            // alignment: Alignment.centerLeft,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Orders'.tr(),
                  style: AppFonts.boldTitleTextStyle.copyWith(
                    color: appColors.boldTitleTextColor,
                  ),
                ),
              ),
              Positioned(
                left: 3,
                top: 35,
                child: ordersQuantity(
                  appColors: appColors,
                  ordersQuantity: orderQty.toString(),
                  orderStatus: orderStatus.toString(),
                ),
              )
            ],
          ),
        );
      case 1:
        return AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Earnings'.tr(),
              style: AppFonts.boldTitleTextStyle.copyWith(
                color: appColors.boldTitleTextColor,
              ),
            ),
          ),
        );
      default:
        return AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${'Hello'.tr()}!',
              style: AppFonts.boldTitleTextStyle.copyWith(
                color: appColors.boldTitleTextColor,
              ),
            ),
          ),
          actions: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: SvgPicture.asset(
                    'assets/icons/settings.svg',
                    colorFilter: ColorFilter.mode(
                        appColors.primaryColor, BlendMode.srcIn),
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
            )
          ],
        );
    }
  }

  /// order list with tabs (new orders, scheduled, out for delivery, completed)
  Widget _orderTabBarView(OrderState orderState, AppColors appColors) {
    return Column(
      children: [
        kHeight25,

        /// SECOND TAB BAR AND ORDER LIST
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          controller: _scrollController,
          child: Row(
            children: [
              /// TAB BAR LIST
              customButtonForOrderList(
                appColors: appColors,
                text: 'New Orders/Today'.tr(),
                isOn: _selectedIndex == 0,
                onPressed: () => btnTapped(0),
              ),
              kWidth5,
              customButtonForOrderList(
                appColors: appColors,
                text: 'Scheduled'.tr(),
                isOn: _selectedIndex == 1,
                onPressed: () => btnTapped(1),
              ),
              kWidth5,
              customButtonForOrderList(
                appColors: appColors,
                text: 'Out for Delivery'.tr(),
                isOn: _selectedIndex == 2,
                onPressed: () => btnTapped(2),
              ),
              kWidth5,
              customButtonForOrderList(
                appColors: appColors,
                text: 'Completed'.tr(),
                isOn: _selectedIndex == 3,
                onPressed: () => btnTapped(3),
              ),
            ],
          ),
        ),
        kHeight10,

        /// TAB BAR VIEW
        Expanded(child: _buildOrderList(context, ref, orderState))
      ],
    );
  }

  /// order list with tab view (new orders, scheduled, out for delivery, completed)
  Widget _buildOrderList(
      BuildContext context, WidgetRef ref, OrderState orderState) {
    if (orderState.isLoadingOrders ||
        orderState.isLoadingScheduledOrders ||
        orderState.isLoadingOutForDeliveryOrders ||
        orderState.isLoadingCompletedOrders) {
      return const Center(child: CircularProgressIndicator());
    }
    final orders = getOrders(orderState, _selectedIndex);
    String errorMessages = getErrorMessageFromState(orderState, _selectedIndex);
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: true,
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          if (orders.isEmpty || orders.length < 10) return SizedBox();
          if (mode == LoadStatus.idle) {
            return Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Load more'.tr(),
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          if (mode == LoadStatus.failed) {
            return Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Load failed'.tr(),
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          if (mode == LoadStatus.noMore) {
            return Align(
              alignment: Alignment.topCenter,
              child: Text(
                'No more data'.tr(),
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          if (mode == LoadStatus.loading) {
            return const CupertinoActivityIndicator();
          }
          return const SizedBox();
        },
      ),
      child: errorMessages.isNotEmpty
          ? errorOccuredWidget(
              context,
              errorMessages,
            )
          : orders.isEmpty
              ? noOrderAvailableWidget(context)
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                  itemCount: orders.length, // Add 1 for the loading spinner
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return getOrderListItem(order, _selectedIndex);
                  },
                ),
    );
  }

  /// order quantity widget
  Widget ordersQuantity({
    required String ordersQuantity,
    required String orderStatus,
    required AppColors appColors,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: ordersQuantity,
            style: AppFonts.boldSecondaryTitleTextStyle.copyWith(
              color: appColors.primaryColor,
            ),
          ),
          TextSpan(
            text: orderStatus,
            style: AppFonts.mediumTitleTextStyle.copyWith(
              color: appColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// custom tab button for order list
  Widget customButtonForOrderList({
    required String text,
    required bool isOn,
    required VoidCallback onPressed,
    required AppColors appColors,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color:
              (isOn) ? appColors.highLightColor : appColors.orderDetailsBgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: (isOn)
                ? AppFonts.tabBarBtnTextStyle.copyWith(color: whiteTextColors)
                : AppFonts.tabBarBtnTextStyle.copyWith(
                    color: appColors.inactiveTabbarBtnTextColor,
                  ),
          ),
        ),
      ),
    );
  }

  /// order card for new orders
  Widget newOrderCard({
    required String orderNumber,
    required String orderedDate,
    required String deliveryFee,
    String load = '0 KG',
    required String scheduleDeliver,
    required String pickupfrom,
    required String deliverTo,
    required String distance,
    required BuildContext context,
    required bool canAcceptOrder,
  }) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (contex) => OrderDetailsPage(
              orderId: orderNumber,
              orderDate: orderedDate,
              scheduleDeliver: scheduleDeliver,
              isAcceptedOrder: !canAcceptOrder,
            ),
          ),
        );
      },
      child: Container(
        // height: 204,
        decoration: BoxDecoration(
          color: appColors.orderDetailsBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 72,
                  width: 64,
                  child: Image.asset('assets/images/secondary_logo.png'),
                ),
                kWidth20,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'Order'.tr()} #$orderNumber',
                            style: AppFonts.boldTextStyle
                                .copyWith(color: appColors.primaryColor),
                          ),
                          Text(
                            orderedDate,
                            style: AppFonts.boldTextStyle
                                .copyWith(color: appColors.primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery Fee'.tr(),
                                style: AppFonts.lightHeadingTextStyle.copyWith(
                                    color: appColors.lightHeadingTextColor),
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
                                          .copyWith(
                                              color: appColors.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: Constants.showLoad,
                            child: Column(
                              children: [
                                Text(
                                  'Load'.tr(),
                                  style: AppFonts.lightHeadingTextStyle
                                      .copyWith(
                                          color:
                                              appColors.lightHeadingTextColor),
                                ),
                                Text(
                                  load,
                                  style: AppFonts.boldTextStyle
                                      .copyWith(color: appColors.primaryColor),
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Schedule Deliver'.tr(),
                                style: AppFonts.lightHeadingTextStyle.copyWith(
                                    color: appColors.lightHeadingTextColor),
                              ),
                              Text(
                                scheduleDeliver,
                                style: AppFonts.boldTextStyle
                                    .copyWith(color: swipeBtnBgColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            kHeight15,
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pickup from'.tr(),
                      style: AppFonts.lightHeadingTextStyle
                          .copyWith(color: appColors.lightHeadingTextColor),
                    ),
                    Text(
                      'Deliver to'.tr(),
                      style: AppFonts.lightHeadingTextStyle
                          .copyWith(color: appColors.lightHeadingTextColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        pickupfrom,
                        style: AppFonts.boldTextStyle
                            .copyWith(color: appColors.primaryColor),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: DottedLineWithIcons(
                          isOrderTaken: true,
                          distance: distance,
                        ),
                      ),
                    ),
                    Text(
                      deliverTo,
                      style: AppFonts.boldTextStyle
                          .copyWith(color: appColors.primaryColor),
                    )
                  ],
                )
              ],
            ),
            kHeight10,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) => OrderDetailsPage(
                      isAcceptedOrder: false,
                      orderId: orderNumber,
                      orderDate: orderedDate,
                      scheduleDeliver: scheduleDeliver,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Order'.tr(),
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
            )
          ],
        ),
      ),
    );
  }

  /// order card for order taken
  Widget orderTakenCard(
      {required String orderNumber,
      required String orderedDateAndTime,
      required String orderAmount,
      required bool isOutToDeliver,
      required String deliverTo,
      required String pickupfrom,
      required BuildContext context}) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (contex) => OrderDetailsPage(
              orderId: orderNumber,
              orderDate: orderedDateAndTime,
              scheduleDeliver: '',
              isAcceptedOrder: true,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: appColors.orderDetailsBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 61,
                  width: 52,
                  child: Image.asset('assets/images/secondary_logo.png'),
                ),
                kWidth20,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'United Feeds Company',
                                style: AppFonts.boldTextStyle
                                    .copyWith(color: appColors.primaryColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${'Order'.tr()} #$orderNumber',
                                textAlign: TextAlign.end,
                                style: AppFonts.boldTextStyle.copyWith(
                                  color: appColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          orderedDateAndTime,
                          style: AppFonts.lightHeadingTextStyle
                              .copyWith(color: appColors.lightHeadingTextColor),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Amount'.tr(),
                                  style: AppFonts.lightHeadingTextStyle
                                      .copyWith(
                                          color:
                                              appColors.lightHeadingTextColor),
                                ),
                                Text(
                                  orderAmount,
                                  style: AppFonts.boldTextStyle.copyWith(
                                    color: appColors.primaryColor,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                (isOutToDeliver)
                    ? Text(
                        'Deliver to'.tr(),
                        style: AppFonts.boldTextStyle
                            .copyWith(color: appColors.primaryColor),
                      )
                    : Text(
                        'Pickup from'.tr(),
                        style: AppFonts.boldTextStyle
                            .copyWith(color: appColors.primaryColor),
                      ),
                const Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: DottedLineWithIcons(
                      isOrderTaken: false,
                      distance: "",
                    ),
                  ),
                ),
                (isOutToDeliver)
                    ? Text(
                        deliverTo,
                        style: AppFonts.tabBarBtnTextStyle
                            .copyWith(color: appColors.primaryColor),
                      )
                    : Text(
                        pickupfrom,
                        style: AppFonts.tabBarBtnTextStyle
                            .copyWith(color: appColors.primaryColor),
                      ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) => OrderDetailsPage(
                      orderId: orderNumber,
                      orderDate: orderedDateAndTime,
                      scheduleDeliver: '',
                      isAcceptedOrder: true,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Order'.tr(),
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
            )
          ],
        ),
      ),
    );
  }

  /// custom tab button for main bottom bar
  Widget customButton({
    required String text,
    required bool isOn,
    required String imagePath1,
    required String imagePath2,
    required VoidCallback onPressed,
    required AppColors appColors,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 45,
        // width: 112,
        decoration: BoxDecoration(
          color:
              (isOn) ? appColors.highLightColor : appColors.orderDetailsBgColor,
          borderRadius: BorderRadius.circular(21),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset((isOn) ? imagePath1 : imagePath2),
            const SizedBox(width: 8),
            Text(
              text,
              style: (isOn)
                  ? AppFonts.tabBarBtnTextStyle.copyWith(color: whiteTextColors)
                  : AppFonts.tabBarBtnTextStyle.copyWith(
                      color: appColors.inactiveTabbarBtnTextColor,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// get order count for selected tab
  String getOrderCountForSelectedTab(orderState) {
    switch (_selectedIndex) {
      case 0: // Open Orders
        return orderState.openTotalOrders.toString();
      case 1: // Scheduled Orders
        return orderState.scheduledTotalOrders.toString();
      case 2:
        return orderState.outForDeliveryTotalOrders.toString();
      default:
        return orderState.completedTotalOrders.toString();
    }
  }

  /// get order status
  String getOrderStatus() {
    return (_selectedIndex == 3) ? ' ${'completed'.tr()}' : ' ${'open'.tr()}';
  }

  /// error message widget
  Widget errorOccuredWidget(BuildContext context, String errorMessage) {
    return Container(
      height: MediaQuery.of(context).size.height / 2, // Match screen height
      alignment: Alignment.center, // Center content vertically
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_rounded,
            size: 25,
            color: Colors.grey[400],
          ),
          kHeight10,
          Text(
            AppConfig.isProduction ? "An error occurred".tr() : errorMessage,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// no order available widget
  Widget noOrderAvailableWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      alignment: Alignment.center,
      child: Text(
        getEmptyOrderMessage(_selectedIndex),
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  /// get order list
  List<dynamic> getOrders(OrderState orderState, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return orderState.orders;
      case 1:
        return orderState.scheduledOrders;
      case 2:
        return orderState.outForDeliveryOrders;
      default:
        return orderState.completedOrders;
    }
  }

  /// get error message from state
  String getErrorMessageFromState(OrderState orderState, int selectedIndex) {
    String message = '';
    switch (selectedIndex) {
      case 0:
        message = orderState.errorMessageOrders ?? '';
      case 1:
        message = orderState.errorMessageScheduledOrders ?? '';
      case 2:
        message = orderState.errorMessageOutForDeliveryOrders ?? '';
      default:
        message = orderState.errorMessageCompletedOrders ?? '';
    }
    if (message.isNotEmpty) {
      Sentry.captureException(message);
    }
    return message;
  }

  /// get empty order message
  String getEmptyOrderMessage(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return "No orders available".tr();
      case 1:
        return "No scheduled orders available".tr();
      case 2:
        return "No out for delivery orders available".tr();
      default:
        return "No completed orders".tr();
    }
  }

  Widget getOrderListItem(dynamic order, int selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        return Column(
          children: [
            newOrderCard(
              context: context,
              orderNumber: order.id.toString(),
              orderedDate: order.bookingDateTime,
              deliveryFee: order.deliveryFee?.toString() ?? '0',
              scheduleDeliver: 'N/A'.tr(),
              pickupfrom: order.shopName ?? 'No Station'.tr(),
              deliverTo: order.deliveryAddress?.split(',').first ??
                  'Unknown Address'.tr(),
              distance: '${order.deliveryDistance} KM',
              canAcceptOrder: order.driverCanAcceptOrder,
            ),
            kHeight15,
          ],
        );
      case 1:
        return Column(
          children: [
            orderTakenCard(
              context: context,
              orderNumber: order.id.toString(),
              orderedDateAndTime: order.bookingDateTime ?? '',
              orderAmount: order.amount.toString(),
              isOutToDeliver: false,
              deliverTo: order.deliveryAddress?.address?.split(',').first ??
                  'No address'.tr(),
              pickupfrom: order.shop?.nameEn ?? 'Nil'.tr(),
            ),
            kHeight15,
          ],
        );
      case 2:
        return Column(
          children: [
            orderTakenCard(
              context: context,
              orderNumber: order.id.toString(),
              orderedDateAndTime: order.bookingDateTime,
              orderAmount: order.amount.toString(),
              isOutToDeliver: true,
              deliverTo:
                  order.deliveryAddress?.split(',').first ?? 'No address'.tr(),
              pickupfrom: 'Nil',
            ),
            kHeight15,
          ],
        );
      default:
        return Column(
          children: [
            orderTakenCard(
              context: context,
              orderNumber: order.id.toString(),
              orderedDateAndTime: order.bookingDateTime,
              orderAmount: order.amount.toString(),
              isOutToDeliver: true,
              deliverTo:
                  order.deliveryAddress?.split(',').first ?? 'No address'.tr(),
              pickupfrom: 'Nil',
            ),
            kHeight15,
          ],
        );
    }
  }

  /// --------  FUNCTIONS ---------------- //
  Future<void> init() async {
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    // Fetch new data when the user swipes down to refresh
    await Future.wait([
      if (_selectedIndex == 0)
        ref.read(orderProvider.notifier).fetchOrders(isRefreshing: true),
      if (_selectedIndex == 1)
        ref
            .read(orderProvider.notifier)
            .fetchScheduledOrders(isRefreshing: true),
      if (_selectedIndex == 2)
        ref
            .read(orderProvider.notifier)
            .fetchOutForDeliveryOrders(isRefreshing: true),
      if (_selectedIndex == 3)
        ref
            .read(orderProvider.notifier)
            .fetchCompletedOrders(isRefreshing: true),
    ]);
    _refreshController.resetNoData();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    bool loadNoMoreData = false;
    if (_selectedIndex == 0) {
      loadNoMoreData = await ref.read(orderProvider.notifier).fetchOrders();
    } else if (_selectedIndex == 1) {
      loadNoMoreData =
          await ref.read(orderProvider.notifier).fetchScheduledOrders();
    } else if (_selectedIndex == 2) {
      loadNoMoreData =
          await ref.read(orderProvider.notifier).fetchOutForDeliveryOrders();
    } else {
      loadNoMoreData =
          await ref.read(orderProvider.notifier).fetchCompletedOrders();
    }
    if (!loadNoMoreData) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  void btnTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    double buttonWidth = 150.0;
    double scrollTo = index * (buttonWidth + 4);
    _scrollController.animateTo(
      scrollTo,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    _onRefresh();
  }
}
