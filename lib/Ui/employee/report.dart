import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_project/design/AppColor.dart';
class Report extends StatelessWidget {
  const Report({
    super.key,
    required this.image,
    required this.date,
    this.timeIn,
    this.timeOut,
    this.abasence,
  });

  final String image;
  final String date;
  final String? timeIn;
  final String? timeOut;
  final String? abasence;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Lottie.asset(image, width: 40, height: 40),
                Text(
                  date,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),

            Row(
              children: [
                if (abasence != null)
                  Text(
                    abasence!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                if (timeIn != null && timeOut != null) ...[
                  Text(
                    timeIn!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColor.gray,
                    size: 15,
                  ),
                  Text(
                    timeOut!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],

              ],
            ),
          ],
        ),
        Divider(
          color: AppColor.softGray,
          thickness: 1,
          indent: 15,
          endIndent: 15,
        ),
      ],
    );
  }
}