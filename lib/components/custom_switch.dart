import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
    widget.onChanged(isOn);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: toggleSwitch,
      child: Transform(
        alignment: Alignment.center,
        transform: isOn ? Matrix4.identity() : Matrix4.rotationY(3.14159),
        child: SvgPicture.asset(
          'assets/icons/switch.svg',
          colorFilter: ColorFilter.mode(
            appColors.primaryColor,
            BlendMode.srcIn,
          ),
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}
