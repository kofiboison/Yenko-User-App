import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/features/account/application/acc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/functions.dart';
import '../../../../../../l10n/app_localizations.dart';

class AboutUsPage extends StatelessWidget {
  static const String routeName = '/aboutUsPage';
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetAppInfoEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            // final accBloc = context.read<AccBloc>();
            return Directionality(
              textDirection: state.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  title: MyText(
                      text: AppLocalizations.of(context)!.aboutUs,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).primaryColor)),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.width * 0.05),
                        Image.asset(AppImages.logo),
                        SizedBox(height: size.width * 0.03),
                        SizedBox(height: size.width * 0.1),
                        MyText(
                            text:
                                AppLocalizations.of(context)!.officialDocuments,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500)),
                        SizedBox(height: size.width * 0.05),
                        InkWell(
                          onTap: () {
                            openUrl(AppConstants.termsCondition);
                          },
                          child: Card(
                            color: AppColors.white,
                            surfaceTintColor: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.description_outlined,
                                      color: Theme.of(context).primaryColor),
                                  SizedBox(width: size.width * 0.02),
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .termsAndConditions,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.width * 0.03),
                        InkWell(
                          onTap: () {
                            openUrl(AppConstants.privacyPolicy);
                          },
                          child: Card(
                            color: AppColors.white,
                            surfaceTintColor: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.privacy_tip_outlined,
                                      color: Theme.of(context).primaryColor),
                                  SizedBox(width: size.width * 0.02),
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .privacyPolicy,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.width * 0.03),
                        InkWell(
                          onTap: () {
                            openUrl(AppConstants.officialWebsite);
                          },
                          child: Card(
                            color: AppColors.white,
                            surfaceTintColor: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.link,
                                      color: Theme.of(context).primaryColor),
                                  SizedBox(width: size.width * 0.02),
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .officialWebsite,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.width * 0.03),
                        SizedBox(height: size.width * 0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.route,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: size.width * 0.03),
                            MyText(
                                text:
                                    '${AppLocalizations.of(context)!.version} ${state.appVersion}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: size.width * 0.2)
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
