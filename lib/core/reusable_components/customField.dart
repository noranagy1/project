import 'package:flutter/material.dart';
class Customfield extends StatefulWidget {
  String hint;
  Widget prefixIcon;
  TextEditingController controller;
  TextInputType keyboardType;
  bool isObscured;
  String? Function(String?) validator; /// ال validator عبارة عن function بتاخد النص اللي اتكتب ولو فيه خطأ بترجع رسالة خطأ، ولو صح بترجع null
  Customfield({
    required this.validator,
    super.key,
    this.isObscured = false,
    required this.keyboardType,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
  });

  @override
  State<Customfield> createState() => _CustomfieldState();
}

class _CustomfieldState extends State<Customfield> {
  bool passwordToggle = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction, /// السطر ده بيخلي التحقق يظهر بعد ما المستخدم يبدأ يكتب في الحقل
      obscureText: widget.isObscured ? passwordToggle : false,
      cursorHeight: 20,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade900,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade900,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade900,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade900,
          ),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade900,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isObscured ? IconButton( /// ده شرط بيقرر يظهر العين ولا لأ
          icon: Icon(
            passwordToggle
                ?Icons.visibility_off_rounded
                :Icons.visibility_rounded, /// شكل العين بيتغير حسب حالة الباسورد
          ),
          onPressed: () {
            setState(() {
              passwordToggle = ! passwordToggle; /// ! معناها اعكس القيمة
              /// اول حاجة بيبقى الباسورد مخفى لو دوست على العين بيتغير ويبقى واضح لان ! بتغير لو هو صح بتخليه غلط والعكس
            });
          },
          color: Colors.grey.shade900,
        ):null,
      ),
    );
  }
}