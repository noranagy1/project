import 'package:flutter/material.dart';
class Custombutton extends StatelessWidget {
  String text;
  void Function() onPressed; /// علشان أخلي الزرار يستقبل Function من بره، وده بيسمحلي أعيد استخدام نفس الزرار في أماكن مختلفة مع وظائف مختلفة
  Custombutton({
    required this.onPressed,
    super.key,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
            text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
    );
  }
}