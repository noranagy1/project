import 'package:flutter/material.dart';
class Customfield extends StatefulWidget {
  String? label;
  String? hint;
  int? lines;
  TextEditingController controller;
  TextInputType keyboardType;
  bool isObscured;
  String? Function(String?) validator; /// ال validator عبارة عن function بتاخد النص اللي اتكتب ولو فيه خطأ بترجع رسالة خطأ، ولو صح بترجع null
  Customfield({
    this.lines,
     this.label,
    this.hint,
    required this.validator,
    super.key,
    this.isObscured = false,
    required this.keyboardType,
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
      maxLines: widget.isObscured == true ? 1 : widget.lines ?? 1,
      cursorHeight: 20,
      decoration: InputDecoration(
        fillColor:  Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        labelText: widget.label,
        hintText: widget.hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: widget.isObscured ? IconButton( /// ده شرط بيقرر يظهر العين ولا لأ
          icon: Icon(
            color: Colors.grey,
            passwordToggle
                ?Icons.visibility_rounded
                :Icons.visibility_off_rounded, /// شكل العين بيتغير حسب حالة الباسورد
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