import 'package:flutter/material.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';

class ManualAtt extends StatefulWidget {
  const ManualAtt({super.key});

  @override
  State<ManualAtt> createState() => _ManualAttState();
}

class _ManualAttState extends State<ManualAtt> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;

        return CustomScaffold(
          icons: Icon(Icons.arrow_forward_ios, color: AppColor.royalBlue, size: 30),
          onIconPressed: () => Navigator.pop(context),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImage.Logo, width: 227, height: 227),

                Text(
                  AppLocalizations.of(context)!.message,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppColor.white : AppColor.black,
                    fontSize: 24,
                  ),
                ),

                SizedBox(height: 20),

                AppFormField(
                  icon: Icons.search,
                  controller: searchController,
                  hintText: AppLocalizations.of(context)!.enter_id_or_name,
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.attend,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}