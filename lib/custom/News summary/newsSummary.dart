import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_project/design/AppColor.dart';

class NewsSummary extends StatelessWidget {
  const NewsSummary({
    super.key,
    this.image,
    this.lottie,
    required this.title,
    required this.description,
    required this.date,
    required this.description2,
    required this.date2,
  });

  final String? image;
  final String title;
  final String description;
  final String date;
  final String? lottie;
  final String description2;
  final String date2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.royalBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (image != null)
                  Image.asset(image!, width: 70, height: 70)
                else
                  if (lottie != null)
                    Lottie.asset(lottie!, width: 40, height: 40),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColor.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColor.white),
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColor.softGray),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: AppColor.gray,
            thickness: 1,
            width: 20,
            indent: 15,
            endIndent: 15,
          ),

          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColor.white),
                ),
                Text(
                  description2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColor.softGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}