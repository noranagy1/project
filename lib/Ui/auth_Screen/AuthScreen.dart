import 'package:flutter/material.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';


import 'LogIn Screen/LoginForm.dart';
import 'RegisterScreen/SignupForm.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
          Image.asset(AppImage.Logo, width: 90, height: 90),
              Text(
               AppLocalizations.of(context)!.get_started,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.create_account,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20),
              Container(
                height: 36,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.softGray,
                  borderRadius: BorderRadius.circular(7),
                ),
                child:TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  indicatorColor: AppColor.white,
                  indicatorWeight: 0.5,
                  labelColor: AppColor.navy,
                  unselectedLabelColor: AppColor.navy,
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.log_in),
                    Tab(text: AppLocalizations.of(context)!.sign_up),
                  ],
                ),
              ),
SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    LoginForm(),
                    SignupForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )

    );
  }
}
