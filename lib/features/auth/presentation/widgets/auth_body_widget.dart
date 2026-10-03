import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/functions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../application/auth_bloc.dart';
import 'auth_select_country_widget.dart';

class AuthBodyWidget extends StatelessWidget {
  final AuthBloc auth;
  const AuthBodyWidget({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: auth,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final authBloc = context.read<AuthBloc>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ChooseLanguagePage.routeName,
                              arguments: ChooseLanguageArguments(
                                  isInitialLanguageChange: false),
                            ).then(
                              (value) {
                                if (!context.mounted) return;
                                context.read<AuthBloc>()
                                    .add(GetDirectionEvent());
                              },
                            );
                          },
                          child: Row(
                            children: [
                              MyText(
                                  text: state.languageCode
                                      .toUpperCase(),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                              Icon(Icons.language_outlined,
                                  color: Theme.of(context).primaryColor),
                              Icon(Icons.arrow_drop_down,
                                  color: Theme.of(context).primaryColor),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.1),
                Image.asset(AppImages.logo, height: size.width * 0.3),
                SizedBox(height: size.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: MyText(
                        text:
                            '${AppLocalizations.of(context)!.welcome} to ${AppConstants.title}',
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                      ),
                    ),
                    SizedBox(height: size.width * 0.03),
                    Center(
                      child: MyText(
                          text:
                              '${AppLocalizations.of(context)!.loginUsingMobileNumber} \n${AppLocalizations.of(context)!.toSignIn}',
                          textAlign: TextAlign.center,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor)),
                    ),
                    SizedBox(height: size.width * 0.1),
                    MyText(
                      text:
                          '${AppLocalizations.of(context)!.your} ${AppLocalizations.of(context)!.email}/${AppLocalizations.of(context)!.mobile}',
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 12,
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    SizedBox(height: size.width * 0.02),
                    Form(
                      key: context.read<AuthBloc>().formKey,
                      child: CustomTextField(
                        controller:
                            context.read<AuthBloc>().emailOrMobileController,
                        filled: true,
                        hintText: AppLocalizations.of(context)!
                            .emailAddressOrMobileNumber,
                        prefixConstraints:
                            BoxConstraints(maxWidth: size.width * 0.2),
                        prefixIcon: !state.isLoginByEmail
                            ? Center(
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      context: context,
                                      builder: (cont) {
                                        return AuthSelectCountryWidget(
                                            auth: authBloc,
                                            countries: state.countries);
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 25,
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color:
                                              Theme.of(context).disabledColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: state.flagImage,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: Loader(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                            child: Text(""),
                                          ),
                                        ),
                                      ),
                                      MyText(
                                        text: state.dialCode,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : null,
                        onChange: (value) {
                          context
                              .read<AuthBloc>()
                              .add(EmailorMobileOnChangeEvent(value: value));
                        },
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              !AppValidation.emailValidate(value) &&
                              !AppValidation.mobileNumberValidate(value)) {
                            return AppLocalizations.of(context)!
                                .validEmailMobile;
                          } else if (value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .enterEmailMobile;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: size.width * 0.05),
                  ],
                ),
                const Spacer(),
                Center(
                  child: CustomButton(
                    buttonName: AppLocalizations.of(context)!.continueN,
                    borderRadius: 5,
                    width: size.width,
                    height: size.width * 0.1,
                    textColor: AppColors.white,
                    buttonColor: (context
                            .read<AuthBloc>()
                            .emailOrMobileController
                            .text
                            .isEmpty)
                        ? Theme.of(context)
                            .disabledColor
                            .withAlpha((0.5 * 255).toInt())
                        : null,
                    onTap: () {
                      if (context
                              .read<AuthBloc>()
                              .formKey
                              .currentState!
                              .validate() &&
                          context
                              .read<AuthBloc>()
                              .emailOrMobileController
                              .text
                              .isNotEmpty) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        context.read<AuthBloc>().add(VerifyUserEvent());
                      }
                    },
                  ),
                ),
                SizedBox(height: size.width * 0.05),
                SizedBox(
                  width: size.width,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      MyText(
                        text: '${AppLocalizations.of(context)!.byContinuing} ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.normal),
                      ),
                      InkWell(
                        onTap: () async {
                          openUrl(AppConstants.termsCondition);
                        },
                        child: MyText(
                          text: '${AppLocalizations.of(context)!.terms} ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                      MyText(
                        text: AppLocalizations.of(context)!.and,
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      InkWell(
                        onTap: () async {
                          openUrl(AppConstants.privacyPolicy);
                        },
                        child: MyText(
                          text:
                              '${AppLocalizations.of(context)!.privacyPolicy} ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width * 0.1),
              ],
            ),
          );
        },
      ),
    );
  }
}
