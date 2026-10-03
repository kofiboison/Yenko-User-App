import 'dart:io';

import 'package:bus_booking/core/network/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_divider.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../../../../application/acc_bloc.dart';

class ReferralPage extends StatelessWidget {
  static const String routeName = '/ReferralPage';

  final ReferralArguments args;

  const ReferralPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          final accBloc = context.read<AccBloc>();
          if (state.status == AccStatus.logOut) {
            accBloc.add(AccUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          // final accBloc = context.read<AccBloc>();
          return Directionality(
            textDirection: state.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                surfaceTintColor: Theme.of(context).primaryColor,
                iconTheme: const IconThemeData(color: AppColors.white),
                title: MyText(
                    text: AppLocalizations.of(context)!.referAndEarn,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.white)),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          SizedBox(
                            width: size.width,
                            height: size.width * 0.7,
                            child: Column(
                              children: [
                                Container(
                                  height: size.width * 0.5,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(height: size.width * 0.2)
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: size.width * 0.03,
                            child: Container(
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.secondary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .referNow,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 24,
                                              color: AppColors.white),
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                    MyText(
                                      text:
                                          args.userData.referralComissionString,
                                      maxLines: 4,
                                      textAlign: TextAlign.center,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 12,
                                              color: AppColors.white),
                                    ),
                                    SizedBox(height: size.width * 0.04),
                                    Container(
                                      height: size.width * 0.1,
                                      width: size.width * 0.7,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color:
                                                Theme.of(context).dividerColor),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(
                                              text: args.userData.refferalCode,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: args.userData
                                                        .refferalCode));
                                                context.showSnackBar(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    message: AppLocalizations
                                                            .of(context)!
                                                        .referralCodeCopied);
                                              },
                                              child: Icon(
                                                Icons.content_paste_rounded,
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomDivider(
                            width: size.width * 0.33,
                            height: 1,
                          ),
                          MyText(
                              text: AppLocalizations.of(context)!.or,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).dividerColor,
                                    fontSize: 12,
                                  )),
                          CustomDivider(
                            width: size.width * 0.33,
                            height: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.05),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                shareToFacebook(AppLocalizations.of(context)!
                                    .refferalInviteText
                                    .replaceAll(
                                        '****', args.userData.refferalCode)
                                    .replaceAll('**', AppConstants.title));
                              },
                              child: Image.asset(AppImages.facebook,
                                  height: size.width * 0.15),
                            ),
                            InkWell(
                              onTap: () {
                                shareToTwitter(AppLocalizations.of(context)!
                                    .refferalInviteText
                                    .replaceAll(
                                        '****', args.userData.refferalCode)
                                    .replaceAll('**', AppConstants.title));
                              },
                              child: Image.asset(AppImages.twitter,
                                  height: size.width * 0.15),
                            ),
                            InkWell(
                              onTap: () {
                                shareToWhatsApp(AppLocalizations.of(context)!
                                    .refferalInviteText
                                    .replaceAll(
                                        '****', args.userData.refferalCode)
                                    .replaceAll('**', AppConstants.title));
                              },
                              child: Image.asset(AppImages.whatsapp,
                                  height: size.width * 0.15),
                            ),
                            InkWell(
                              onTap: () async {
                                await Share.share(AppLocalizations.of(context)!
                                    .refferalInviteText
                                    .replaceAll(
                                        '****', args.userData.refferalCode)
                                    .replaceAll('**', AppConstants.title));
                              },
                              child: Image.asset(AppImages.more,
                                  height: size.width * 0.15),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.2)
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> shareToWhatsApp(String text) async {
    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      launchAppOrStore(
        schemeUrl: 'whatsapp://',
        androidStoreUrl:
            'https://play.google.com/store/apps/details?id=com.whatsapp',
        iosStoreUrl:
            'https://apps.apple.com/app/whatsapp-messenger/id310633997',
      );
      throw 'Could not launch WhatsApp';
    }
  }

  Future<void> shareToFacebook(String text) async {
    final url = Uri.parse(
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      launchAppOrStore(
        schemeUrl: 'fb://',
        androidStoreUrl:
            'https://play.google.com/store/apps/details?id=com.facebook.katana',
        iosStoreUrl: 'https://apps.apple.com/app/facebook/id284882215',
      );
      throw 'Could not launch Facebook';
    }
  }

  Future<void> shareToTwitter(String text) async {
    final url = Uri.parse(
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      launchAppOrStore(
        schemeUrl: 'twitter://',
        androidStoreUrl:
            'https://play.google.com/store/apps/details?id=com.twitter.android',
        iosStoreUrl: 'https://apps.apple.com/app/twitter/id333903271',
      );
      throw 'Could not launch Twitter';
    }
  }

  Future<void> launchAppOrStore({
    required String schemeUrl,
    required String androidStoreUrl,
    required String iosStoreUrl,
  }) async {
    final uri = Uri.parse(schemeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final storeUrl = Platform.isAndroid ? androidStoreUrl : iosStoreUrl;
      final storeUri = Uri.parse(storeUrl);
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    }
  }
}
