import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class Custombutton extends StatelessWidget {
  String text;
  Color? buttonColor;
  void Function() onPressed; /// علشان أخلي الزرار يستقبل Function من بره، وده بيسمحلي أعيد استخدام نفس الزرار في أماكن مختلفة مع وظائف مختلفة
  Custombutton({
    required this.onPressed,
    super.key,
    required this.text,  this.buttonColor,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 17,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 1,
              color: ColorManager.buttonColor,
          ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
            text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
    );
  }
}