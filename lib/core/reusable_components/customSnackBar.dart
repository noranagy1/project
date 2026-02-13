import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
SnackBar customSnack(errorMsg){
return SnackBar(
    padding: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    margin: EdgeInsets.only(
      bottom: 20,
      left: 20,
      right: 20,
    ),
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    clipBehavior: Clip.none,
    backgroundColor: Colors.red,
    content: Row(
      children: [
        Icon(CupertinoIcons.info, color: Colors.white),
        Gap(10),
        Text(
          errorMsg,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ));
}