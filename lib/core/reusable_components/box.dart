import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Box extends StatefulWidget {
  final String imagePath;
  final String title;
  final Color? imageColor;
  final bool hasSwitch;
  final VoidCallback? onButtonTap;
  const Box({
    this.onButtonTap,
    this.hasSwitch = false,
    this.imageColor,
    super.key,
    required this.imagePath,
    required this.title,
  });
  @override
  State<Box> createState() => _BoxState();
}
class _BoxState extends State<Box> {
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.gradientStart,
              ColorManager.gradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: ColorManager.gradientEnd.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Image.asset(
              widget.imagePath,
              color: widget.imageColor,
              height: 80,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 7),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Spacer(),
        widget.hasSwitch
            ? Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOn ? context.l10n.open : context.l10n.close,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 30,
                height: 36,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: CupertinoSwitch(
                    value: isOn,
                    onChanged: (value) {
                      setState(() {
                        isOn = value;
                      });
                    },
                    thumbColor: Colors.white,
                    trackColor:  Colors.white.withOpacity(0.4),
                    activeColor: Colors.white.withOpacity(0.4),
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: 150,
            height: 50,
          ),
        ),
          ],
        ),
      ),
      onTap: widget.onButtonTap,
    );
  }
}