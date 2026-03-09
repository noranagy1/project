import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/utils/app_icons.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/profile_view/widget/setting_dialog.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key,});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 40, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: isDark ? ColorManager.darkCameraIconBg : ColorManager.lightTopIconBg,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: isDark ? const Color(0x263B82F6) : ColorManager.lightTopIconBorder,
                  ),
                ),
                child: const Icon(AppIcons.building, color: ColorManager.blue, size: 20),
              ),
              InkWell(
                onTap: () => showDialog(context: context, builder: (_) => SettingsDialog()),
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? ColorManager.darkProfileBg : ColorManager.lightMenuBg,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
                    ),
                  ),
                  child: Icon(AppIcons.moreVert,
                    color: isDark ? ColorManager.darkIconMuted : ColorManager.lightIconMuted,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: isDark ? ColorManager.darkDivider : ColorManager.lightDivider,
          thickness: 1, height: 1, indent: 20, endIndent: 20,
        ),
      ],
    );
  }
}