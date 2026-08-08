import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/config/config.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';
import 'package:ufc_delivery_app/extensions/app_fonts.dart';
import 'package:ufc_delivery_app/models/user_model.dart';
import 'package:ufc_delivery_app/providers/order_analytics_provider.dart';
import 'package:ufc_delivery_app/providers/profile_provider.dart';
import 'package:ufc_delivery_app/screens/order_details_page.dart';
import 'package:ufc_delivery_app/shared/utils/constants/constants.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(userNotifierProvider.notifier).fetchUserProfile();
      await getOrderAnaytics('today');
    });
  }

  void btnTapped(int index, String filterBasedon) {
    setState(() {
      _selectedIndex = index;
    });
    getOrderAnaytics(filterBasedon);
  }

  String formatPhoneNumber(String phoneNumber) {
    // Ensure the phone number has enough digits
    if (phoneNumber.length != 12) {
      return phoneNumber; // Return as-is if it doesn't meet the expected length
    }

    // Format the phone number into the desired pattern (e.g., 966 570 115 758)
    return '${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6, 9)} ${phoneNumber.substring(9)}';
  }

  getOrderAnaytics(String filterBasedon) {
    final analyticsOrder = ref.read(orderAnalyticsProvider.notifier);
    analyticsOrder.fetchOrderAnalytics(filterBasedon);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userDetailsCard(
                appColors: appColors,
                driver: userState.user?.fullName ?? '',
                phone: userState.user?.phoneNumber != null
                    ? formatPhoneNumber(userState.user?.phoneNumber ?? '')
                    : '',
                stations: userState.user?.stations,
              ),
              kHeight20,
              if (!AppConfig.isProduction)
                vehicleDetailsCard(vehicle: '', type: '', appColors: appColors),
              kHeight20,
              Text(
                'Statistics'.tr(),
                style: AppFonts.boldHeadingStyle
                    .copyWith(color: appColors.primaryColor),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  customButtonForStatistics(
                    appColors: appColors,
                    text: 'Today'.tr(),
                    isOn: _selectedIndex == 0,
                    onPressed: () => btnTapped(0, 'today'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  customButtonForStatistics(
                      appColors: appColors,
                      text: 'Week'.tr(),
                      isOn: _selectedIndex == 1,
                      onPressed: () => btnTapped(1, 'week')),
                  const SizedBox(
                    width: 10,
                  ),
                  customButtonForStatistics(
                      appColors: appColors,
                      text: 'Month'.tr(),
                      isOn: _selectedIndex == 2,
                      onPressed: () => btnTapped(2, 'month')),
                ],
              ),
              kHeight15,
              _buildOrdersStatistics(),
              if (Constants.showRatingFeature) ...[
                kHeight20,
                Text(
                  'Ratings'.tr(),
                  style: AppFonts.boldHeadingStyle.copyWith(
                    color: appColors.primaryColor,
                  ),
                ),
                kHeight20,
                reviewsCard(
                  appColors,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersStatistics() {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final orderAnalytics = ref.watch(orderAnalyticsProvider);
    return SizedBox(
      height: 130,
      child: Row(
        children: [
          Expanded(
            child: ordersNumberCard(
              appColors: appColors,
              title: 'Orders Taken'.tr(),
              ordersCount:
                  (orderAnalytics.analytics?.ordersTaken ?? 0).toString(),
              isLoading: orderAnalytics.isLoading,
            ),
          ),
          kWidth10,
          Expanded(
            child: ordersNumberCard(
              appColors: appColors,
              title: 'Orders Delivered'.tr(),
              ordersCount:
                  (orderAnalytics.analytics?.ordersDelivered ?? 0).toString(),
              isLoading: orderAnalytics.isLoading,
            ),
          ),
          kWidth10,
          Expanded(
            child: ordersNumberCard(
              appColors: appColors,
              title: 'Orders Cancelled'.tr(),
              ordersCount:
                  (orderAnalytics.analytics?.ordersCancelled ?? 0).toString(),
              isLoading: orderAnalytics.isLoading,
            ),
          )
        ],
      ),
    );
  }
}

Widget reviewsCard(AppColors appColors) {
  return Container(
    height: 167,
    decoration: BoxDecoration(
      color: appColors.secondaryColor,
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ratingWidgetBig(rating: 5, totalStars: 5, appColors: appColors),
        const SizedBox(
          height: 12,
        ),
        Text(
          tr('Reviews'),
          style: AppFonts.lightHeadingTextStyle
              .copyWith(color: appColors.lightHeadingTextColor),
        ),
        const SizedBox(
          height: 10,
        ),
        reviewCard(
          appColors: appColors,
          customerName: 'Revi*******',
          date: '09 june',
          rating: 5,
          desc: 'Very good service!'.tr(),
        ),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: Text(
            'view all'.tr(),
            style: AppFonts.lightHeadingTextStyle.copyWith(
              color: appColors.highLightColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget reviewCard({
  required String customerName,
  required String date,
  required double rating,
  required String desc,
  required AppColors appColors,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            customerName,
            style: AppFonts.lightHeadingTextStyle
                .copyWith(color: appColors.primaryColor),
          ),
          Text(
            date,
            style: AppFonts.normalSmallTextStyle.copyWith(
              color: customGreyTextColor,
            ),
          )
        ],
      ),
      kHeight5,
      ratingWidgetSmall(rating: rating, totalStars: 5),
      kHeight5,
      Text(
        desc,
        style: AppFonts.smallTextStyle.copyWith(color: appColors.primaryColor),
      )
    ],
  );
}

Widget ratingWidgetBig({
  required double rating,
  required int totalStars,
  required AppColors appColors,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        children: List.generate(totalStars, (index) {
          if (index < rating.floor()) {
            return const Icon(
              Icons.star,
              color: ratingStarColor,
              size: 25,
            );
          } else if (index < rating && index < rating.floor() + 1) {
            return ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.amber, Colors.grey.shade300],
                  stops: [(rating - rating.floor()).clamp(0, 1), 0.0],
                  tileMode: TileMode.clamp,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: const Icon(
                Icons.star,
                color: ratingStarColor,
                size: 25,
              ),
            );
          } else {
            return const Icon(
              Icons.star_border,
              color: ratingStarColor,
              size: 25,
            );
          }
        }),
      ),
      const SizedBox(width: 10),
      Text(
        rating.toStringAsFixed(1),
        style: AppFonts.lightHeadingTextStyle
            .copyWith(color: appColors.primaryColor),
      ),
    ],
  );
}

Widget ratingWidgetSmall({
  required double rating,
  required int totalStars,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        children: List.generate(totalStars, (index) {
          if (index < rating.floor()) {
            return const Icon(
              Icons.star,
              color: ratingStarColor,
              size: 14,
            );
          } else if (index < rating && index < rating.floor() + 1) {
            return ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.amber, Colors.grey.shade300],
                  stops: [(rating - rating.floor()).clamp(0, 1), 0.0],
                  tileMode: TileMode.clamp,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: const Icon(
                Icons.star,
                color: ratingStarColor,
                size: 14,
              ),
            );
          } else {
            return const Icon(
              Icons.star_border,
              color: ratingStarColor,
              size: 14,
            );
          }
        }),
      ),
    ],
  );
}

Widget customButtonForStatistics({
  required String text,
  required bool isOn,
  required VoidCallback onPressed,
  required AppColors appColors,
}) {
  return IntrinsicWidth(
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        // height: 36,
        decoration: BoxDecoration(
          color:
              (isOn) ? appColors.secondaryColor : appColors.orderDetailsBgColor,
          border: Border.all(
            color: (isOn) ? appColors.highLightColor : inactiveBorderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: (isOn)
                ? AppFonts.mediumTitleTextStyle
                    .copyWith(color: appColors.highLightColor)
                : AppFonts.mediumTitleTextStyle.copyWith(
                    color: inactiveBorderColor,
                  ),
          ),
        ),
      ),
    ),
  );
}

Widget ordersNumberCard({
  required String title,
  required String ordersCount,
  bool isLoading = false,
  required AppColors appColors,
}) {
  return Container(
    decoration: BoxDecoration(
      color: appColors.orderDetailsBgColor,
      borderRadius: BorderRadius.circular(25),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppFonts.lightHeadingTextStyle.copyWith(
            color: appColors.lightHeadingTextColor,
          ),
        ),
        kHeight10,
        if (isLoading)
          Center(
            child: CupertinoActivityIndicator(),
          )
        else
          Text(
            ordersCount,
            style: AppFonts.bigBoldTextStyle.copyWith(
              color: appColors.highLightColor,
            ),
            textAlign: TextAlign.center,
          )
      ],
    ),
  );
}

Widget userDetailsCard({
  required String driver,
  required String phone,
  List<Station>? stations,
  required AppColors appColors,
}) {
  return Container(
    // width: 300,
    decoration: BoxDecoration(
      color: appColors.orderDetailsBgColor,
      borderRadius: BorderRadius.circular(25),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTitleAndValue(
            appColors: appColors, title: 'Driver'.tr(), value: driver),
        const SizedBox(
          height: 20,
        ),
        // Directionality(
        //   textDirection: TextDirection.ltr,
        // child:
        customTitleAndValue(
            appColors: appColors, title: '${'Phone'.tr()} #', value: phone),
        // ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Stations'.tr(),
          style: AppFonts.lightHeadingTextStyle
              .copyWith(color: appColors.lightHeadingTextColor),
        ),
        kHeight10,
        (stations != null)
            ? Row(
                children: List.generate(
                  stations.length,
                  (index) {
                    return stationNameCard(
                      stationName: stations[index].name,
                      appColors: appColors,
                    );
                  },
                ),
              )
            : SizedBox(
                height: 30,
                width: double.infinity,
                child: Text(
                  "no station available".tr(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                  ),
                ),
              )
      ],
    ),
  );
}

Widget stationNameCard({
  required String? stationName,
  required AppColors appColors,
}) {
  return Container(
    decoration: BoxDecoration(
      color: appColors.highLightColor,
      borderRadius: BorderRadius.circular(25),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        stationName ?? '',
        style: AppFonts.tabBarBtnTextStyle.copyWith(
          color: whiteColor,
        ),
      ),
    ),
  );
}

Widget vehicleDetailsCard(
    {required String vehicle,
    required String type,
    required AppColors appColors}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: appColors.orderDetailsBgColor,
      borderRadius: BorderRadius.circular(25),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTitleAndValue(
            appColors: appColors, title: '${"Vehicle".tr()} #', value: vehicle),
        kHeight20,
        customTitleAndValue(
            appColors: appColors, title: 'Type'.tr(), value: type),
      ],
    ),
  );
}
