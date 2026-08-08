import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_delivery_app/components/custom_switch.dart';
import 'package:ufc_delivery_app/components/url_launcher.dart';
import 'package:ufc_delivery_app/config/loading_dailog.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';
import 'package:ufc_delivery_app/extensions/app_fonts.dart';
import 'package:ufc_delivery_app/generated/l10n.dart';
import 'package:ufc_delivery_app/main.dart';
import 'package:ufc_delivery_app/notifiers/auth_notifier.dart';
import 'package:ufc_delivery_app/providers/auth_provider.dart';
import 'package:ufc_delivery_app/providers/theme_provider.dart';
import 'package:ufc_delivery_app/screens/order_page.dart';
import 'package:ufc_delivery_app/screens/signin_page.dart';
import 'package:ufc_delivery_app/shared/theme/theme.dart';
import 'package:ufc_delivery_app/shared/utils/constants/constants.dart';

class CustomEndDrawer extends ConsumerStatefulWidget {
  const CustomEndDrawer({super.key});

  @override
  ConsumerState<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends ConsumerState<CustomEndDrawer> {
  bool isDropdownOpen = false;

  int langIndex = 0;

  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() {
    setState(() {
      // Retrieve the saved language index or set a default
      int? savedLangIndex = preferences.getInt("language") ?? 0;
      if (savedLangIndex < Constants.languageData.length) {
        selectedLanguage = Constants.languageData[savedLangIndex];
        langIndex = savedLangIndex;
      } else {
        selectedLanguage = null; // No language selected initially
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        backgroundColor: appColors.secondaryColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kHeight55,
              if (Platform.isIOS) kHeight20,

              /// back button
              backButton(context, appColors),
              kHeight30,

              ///------change language button------ //
              languageButton(appColors),

              ///------ language drop down ------ //
              languageDropDownWidget(appColors),
              kHeight30,

              ///------change theme button------ //
              themeButton(themeMode, appColors),
              kHeight25,
              _buildDottedDivider(),
              kHeight25,

              ///------ ABOUT APP ------ //
              UrlRedirectingTextView(
                url: 'https://ufc-app.com/ufc-logistics',
                title: tr('About the App'),
              ),
              kHeight30,

              /// ------TERMS AND CONDITION ------//
              UrlRedirectingTextView(
                url: 'https://ufc-app.com/ufc-logistics/privacy-policy',
                title: tr(
                  'Terms & Conditions',
                ),
              ),
              kHeight30,

              /// ------PRIVACY POLICY ------//
              UrlRedirectingTextView(
                url: 'https://ufc-app.com/ufc-logistics/privacy-policy',
                title: tr(
                  'Privacy Policy',
                ),
              ),
              kHeight25,
              _buildDottedDivider(),
              kHeight25,

              ///------ LOG OUT BUTTON ------//
              logoutButton(authNotifier, context),
            ],
          ),
        ),
      ),
    );
  }

  /// back button
  Widget backButton(BuildContext context, AppColors appColors) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: SizedBox(
        width: 22,
        height: 13,
        child: SvgPicture.asset(
          'assets/icons/front.svg',
          colorFilter:
              ColorFilter.mode(appColors.primaryColor, BlendMode.srcIn),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Language button, on tap of it will show dropdown
  Widget languageButton(AppColors appColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
            });
          },
          child: Text(
            'language'.tr(),
            style: AppFonts.boldTextStyle.copyWith(
              color: appColors.primaryColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
            });
          },
          child: Text(
            selectedLanguage!.tr(),
            style: AppFonts.smallBoldText.copyWith(color: swipeBtnBgColor),
          ),
        ),
      ],
    );
  }

  Widget themeButton(themeData, AppColors appColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tr('Theme'),
          style: AppFonts.boldTextStyle.copyWith(color: appColors.primaryColor),
        ),
        CustomSwitch(
          initialValue: themeData == AppTheme.dark,
          onChanged: (value) {
            ref.read(themeProvider.notifier).toggleTheme(value);
          },
        ),
      ],
    );
  }

  /// Logout button
  Widget logoutButton(AuthNotifier authNotifier, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await authNotifier.logout();
        await preferences.clear();
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      },
      child: Text(
        tr('Logout'),
        style: AppFonts.boldTextStyle.copyWith(
          color: swipeBtnBgColor,
        ),
      ),
    );
  }

  /// LANGUAGE DROP DOWN
  Widget languageDropDownWidget(AppColors appColors) {
    return AnimatedOpacity(
      opacity: isDropdownOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: isDropdownOpen
            ? Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: appColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(
                    Constants.languageData.length * 2 -
                        1, // Account for dividers
                    (index) {
                      if (index.isEven) {
                        // Build dropdown item
                        int languageIndex = index ~/ 2;
                        return _buildDropdownItem(
                          Constants.languageData[languageIndex],
                          appColors,
                        );
                      } else {
                        // Build divider
                        return Divider(
                          height: 1,
                          color: appColors.dividerColor,
                        );
                      }
                    },
                  ),
                ),
              ) // Prevents taking up space when hidden
            : SizedBox.shrink(),
      ),
    );
  }

  /// BUILD drop down item
  Widget _buildDropdownItem(String language, AppColors appColors) {
    return GestureDetector(
      onTap: () async {
        selectedLanguage = language;
        langIndex = Constants.languageData.indexOf(selectedLanguage!);
        final future = selectLanguage(context, langIndex);
        await LoadingDialog.show(context, future);
        isDropdownOpen = false;
        setState(() {});
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderPage()),
        ); //
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        color: Colors.transparent,
        child: Center(
          child: Text(
            language.tr(),
            style: AppFonts.smallBoldText.copyWith(
              color: appColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  /// drawer item
  Widget buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
    );
  }

  /// divider
  Widget _buildDottedDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        children: List.generate(
          30, // Number of dots
          (index) => Expanded(
            child: Container(
              height: 1,
              color: index.isEven ? Colors.grey : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> selectLanguage(BuildContext context, int index) async {
  await context.setLocale(L10n.all[index]);
  await preferences.setInt("language", index);
}
