import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
/// طريقة سريعة لإظهار رسالة للمستخدم بدون تغيير الشاشة أو فتح AlertDialog
SnackBar customSnack(errorMsg){ /// تاخد رسالة errorMsg وتعمل SnackBar جاهزة بالتصميم اللي حددناه
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
    backgroundColor: Colors.green,
    content: Row(
      children: [
        Icon(CupertinoIcons.info, color: Colors.white),
        Gap(10),
        Expanded(
          child: Text(
            errorMsg,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ));
}