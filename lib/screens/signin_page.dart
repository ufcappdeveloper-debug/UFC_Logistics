import 'dart:async';
import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:ufc_delivery_app/components/custom_snackbar.dart';
import 'package:ufc_delivery_app/config/config.dart';
import 'package:ufc_delivery_app/config/loading_dailog.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';
import 'package:ufc_delivery_app/extensions/app_fonts.dart';
import 'package:ufc_delivery_app/notifiers/auth_notifier.dart';
import 'package:ufc_delivery_app/providers/auth_provider.dart';
import 'package:ufc_delivery_app/screens/app_update/app_update.dart';
import 'package:ufc_delivery_app/screens/app_update/update_dailog.dart';
import 'package:ufc_delivery_app/screens/order_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends ConsumerState<SignInPage> {
  Timer? _timer;
  bool isTimerActive = false;
  bool isTimerStarted = false;
  int _secondsRemaining = 60;
  String _phoneNumber = '';
  final TextEditingController _phoneController =
      TextEditingController(text: '+966');
  final TextEditingController _otpController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();

    Future(() => checkForUpdate());
  }

  Future<void> _sendOtp(BuildContext context, WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);
    _phoneNumber = _phoneController.text.trim();
    if (_phoneNumber.startsWith('+')) {
      _phoneNumber = _phoneNumber.replaceFirst('+', '');
    }
    _phoneNumber = _phoneNumber.replaceAll(' ', '');
    if (_phoneController.text.length < 14) {
      CustomSnackbar.show(context, "Invalid phone number".tr());
    } else {
      try {
        final message = await authNotifier.requestOtp(_phoneNumber);
        if (!context.mounted) return;
        CustomSnackbar.show(context, message);
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }
  }

  Future<void> checkForUpdate() async {
    final updateFuture = AppUpdate.init();
    await LoadingDialog.show(context, updateFuture);
    if (AppUpdate.updateStatus() == UpdateStatus.updated) {
      _autoLogin();
    } else {
      final mandatory = AppUpdate.updateStatus() == UpdateStatus.critical;
      if (mounted) {
        await showDialog(
          barrierDismissible: !mandatory,
          context: context,
          builder: (context) => UpdateDialog(mandatory: mandatory),
        );
      }
      _autoLogin();
    }
  }

  Future<void> _autoLogin() async {
    final authNotifier = ref.read(authProvider.notifier);

    // Call the autoLogin method from the AuthNotifier
    await authNotifier.autoLogin();
    final authState = ref.read(authProvider);
    // If authenticated, navigate to the home page or wherever needed
    if (authState.isAuthenticated) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderPage()),
      ); // Navigate to home page
    }
  }

  Future<void> _verifyOtp(BuildContext context, WidgetRef ref) async {
    if (!isTimerActive || _secondsRemaining <= 0) {
      CustomSnackbar.show(
          context, "Time expired. Please request a new OTP.".tr());

      return;
    }

    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.verifyOtp(_phoneNumber, _otpController.text);
  }

  void _startTimer() {
    setState(() {
      isTimerActive = true;
      _secondsRemaining = 60;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isTimerActive = false;
          });
        }
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp(BuildContext context, WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);
    _otpController.clear();
    _startTimer();
    try {
      final message = await authNotifier.resendOtp(_phoneNumber);
      if (!context.mounted) return;
      CustomSnackbar.show(context, message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  void dispose() {
    _otpController.dispose();
    _phoneController.dispose();

    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    double deviceWidth = MediaQuery.of(context).size.width;
    double containerWidth = (deviceWidth - 80) / 5.5;

    if (authState.isOtpSent && !isTimerStarted) {
      _startTimer();
      isTimerStarted =
          true; // Set flag to true to prevent re-starting the timer
    }
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Check for errors in the state
      if ((next.errorMessage ?? '').isNotEmpty) {
        if (next.errorType == AuthErrorType.verifyOtp) {
          CustomSnackbar.show(
            context,
            AppConfig.isProduction
                ? 'Error during OTP verification'.tr()
                : next.errorMessage ?? 'Error during OTP verification'.tr(),
          );
        } else if (next.errorType == AuthErrorType.resendOtp) {
          CustomSnackbar.show(
            context,
            AppConfig.isProduction
                ? "Error during OTP resend".tr()
                : next.errorMessage ?? "Error during OTP resend".tr(),
          );
        } else {
          CustomSnackbar.show(
            context,
            AppConfig.isProduction
                ? "An error occurred".tr()
                : next.errorMessage ?? "An error occurred".tr(),
          );
        }
      } else if (next.isAuthenticated) {
        CustomSnackbar.show(context, "${'Welcome'.tr()}!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderPage()),
        );
      }
    });

    return Scaffold(
      body: FocusScope(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/signin_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              if (authState.isOtpSent) ...[
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      authNotifier.restToSendOtp();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                )
              ],
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Padding(
                        padding: const EdgeInsets.only(top: 125),
                        child: SizedBox(
                          height: 163.0,
                          width: 138.0,
                          child: Image.asset(
                            'assets/images/main_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      if (!authState.isOtpSent) ...[
                        /// send otp screen
                        SizedBox(height: 50),
                        phoneFieldWidget(),
                        const SizedBox(height: 25),
                        sendOtpButton(context),
                      ] else // OTP screen
                        Column(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            otpPinFieldWidget(containerWidth),
                            const SizedBox(height: 10),
                            (isTimerActive)
                                ? codeTimingWidget()
                                : resendOtpButton(context),
                            const SizedBox(height: 25),
                            verifyOtpButton(context),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (authState.isLoading)
                Stack(
                  children: [
                    // Dimmed background
                    Opacity(
                      opacity: 0.5,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.black,
                      ),
                    ),
                    // Loading Indicator
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// phone field
  Widget phoneFieldWidget() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 62.0,
        child: TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: AppFonts.smallSigninTextStyle.copyWith(color: whiteTextColors),
          decoration: InputDecoration(
            labelText: 'Phone Number'.tr(),
            labelStyle:
                AppFonts.signinTextStyle.copyWith(color: whiteTextColors),
            filled: true,
            fillColor: signinFieldColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            // Remove any spaces from the input
            String formattedValue = value.replaceAll(' ', '');

            // Ensure the input starts with +966 and has a space after it
            if (!formattedValue.startsWith('+966')) {
              formattedValue = '+966';
            } else if (formattedValue.length > 4 && formattedValue[4] != ' ') {
              formattedValue = '+966 ${formattedValue.substring(4)}';
            }

            if (formattedValue.length > 14) {
              formattedValue = formattedValue.substring(0, 14);
            }

            if (formattedValue.length <= 14) {
              _phoneController.text = formattedValue;

              _phoneController.selection = TextSelection.fromPosition(
                TextPosition(
                    offset: formattedValue.length > 14
                        ? 14
                        : formattedValue.length),
              );
            }
          },
        ),
      ),
    );
  }

  /// send otp button
  Widget sendOtpButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _sendOtp(context, ref),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: swipeBtnBgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Sign in',
            style: AppFonts.boldTextStyle.copyWith(
              color: whiteTextColors,
            ),
          ),
        ),
      ),
    );
  }

  /// OTP FIELD
  Widget otpPinFieldWidget(double containerWidth) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: 4,
        autofocus: true,
        controller: _otpController,
        pinAnimationType: PinAnimationType.none,
        defaultPinTheme: PinTheme(
          width: containerWidth,
          height: containerWidth,
          textStyle: AppFonts.otpInputTextStyle.copyWith(
            color: whiteTextColors,
          ),
          decoration: BoxDecoration(
            color: signinFieldColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: containerWidth,
          height: containerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  /// code timer
  Widget codeTimingWidget() {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Code will expire in ',
            style: AppFonts.otpTimerTextStyle.copyWith(
              color: whiteTextColors,
            ),
          ),
          TextSpan(
            text: _formatTime(_secondsRemaining),
            style: AppFonts.otpTextStyle.copyWith(
              color: whiteTextColors,
            ),
          ),
          TextSpan(
            text: ' seconds.',
            style: AppFonts.otpTimerTextStyle.copyWith(
              color: whiteTextColors,
            ),
          ),
        ],
      ),
    );
  }

  /// resend otp button and text
  Widget resendOtpButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code?",
          style: AppFonts.otpTimerTextStyle.copyWith(color: whiteTextColors),
        ),
        TextButton(
          onPressed: () => resendOtp(context, ref),
          child: Text(
            "Resend",
            style: AppFonts.otpTextStyle.copyWith(
              color: whiteTextColors,
            ),
          ),
        ),
      ],
    );
  }

  /// verify otp BUTTON
  Widget verifyOtpButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _verifyOtp(context, ref),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: swipeBtnBgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Verify'.tr(),
            style: AppFonts.boldTextStyle.copyWith(color: whiteTextColors),
          ),
        ),
      ),
    );
  }
}
