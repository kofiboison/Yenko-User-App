import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/auth_bloc.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class VerifyPage extends StatefulWidget {
  static const String routeName = '/verifyPage';
  final VerifyArguments arg;
  const VerifyPage({super.key, required this.arg});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  timerCount(BuildContext cont,
      {required int duration, bool? isCloseTimer}) async {
    int count = duration;

    if (isCloseTimer == null) {
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        count--;
        if (count <= 0) {
          timer?.cancel();
        }
        cont.read<AuthBloc>().add(VerifyTimerEvent(duration: count));
      });
    }

    if (isCloseTimer != null && isCloseTimer) {
      timer?.cancel();
      cont.read<AuthBloc>().add(VerifyTimerEvent(duration: 0));
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(GetCommonModuleEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final authBloc = context.read<AuthBloc>();
          if (state.status == AuthStatus.loaded) {
            authBloc.add(AuthUpdateEvent());
            // CustomLoader.dismiss(context);
            if (!widget.arg.userExist && widget.arg.isOtpVerify) {
              authBloc.add(
                    SignInWithOTPEvent(
                      isOtpVerify: widget.arg.isOtpVerify,
                      isForgotPassword: false,
                      mobileOrEmail: widget.arg.mobileOrEmail,
                      countryCode: widget.arg.countryCode,
                      isLoginByEmail: widget.arg.isLoginByEmail,
                      context: context,
                    ),
                  );
              timerCount(context, duration: 60);
            }
          } else if (state.status == AuthStatus.forgotPasswordOTPSend) {
            authBloc.add(AuthUpdateEvent());
            Navigator.pushNamed(
              context,
              ForgotPasswordPage.routeName,
              arguments: ForgotPasswordPageArguments(
                isLoginByEmail: widget.arg.isLoginByEmail,
                contryCode: widget.arg.countryCode,
                countryFlag: widget.arg.countryFlag,
                emailOrMobile: widget.arg.mobileOrEmail,
              ),
            );
          } else if (state.status == AuthStatus.newUserRegistered) {
            authBloc.add(AuthUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, RegisterPage.routeName, (route) => false,
                arguments: RegisterPageArguments(
                  isLoginByEmail: widget.arg.isLoginByEmail,
                  contryCode: widget.arg.countryCode,
                  countryFlag: widget.arg.countryFlag,
                  emailOrMobile: widget.arg.mobileOrEmail,
                  countryList: widget.arg.countryList,
                  isRefferalEarnings: widget.arg.isRefferalEarnings,
                ));
          } else if (state.status == AuthStatus.loginSuccess) {
            authBloc.add(AuthUpdateEvent());    
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final authBloc = context.read<AuthBloc>();
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Directionality(
                textDirection: state.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(height: size.width * 0.2),
                          Image.asset(AppImages.logo, height: size.width * 0.3),
                          SizedBox(height: size.width * 0.02),
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
                          state.isOtpVerify
                              ? MyText(
                                  text: AppLocalizations.of(context)!
                                      .otpSendContent,
                                  textAlign: TextAlign.center,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.greyHintColor,
                                      ),
                                )
                              : MyText(
                                  text: AppLocalizations.of(context)!
                                      .passwordContent,
                                  textAlign: TextAlign.center,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.greyHintColor,
                                      ),
                                  maxLines: 2,
                                ),
                          const SizedBox(height: 5),
                          MyText(
                            text: AppLocalizations.of(context)!
                                .enterVerificationCode,
                            textAlign: TextAlign.center,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (!widget.arg.isLoginByEmail)
                                SizedBox(
                                  height: 20,
                                  width: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.arg.countryFlag,
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
                                ),
                              const SizedBox(width: 10),
                              MyText(
                                text: widget.arg.mobileOrEmail,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.black,
                                    ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.border_color, size: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (widget.arg.userExist &&
                              !state.isOtpVerify)
                            passwordField(context,authBloc,state),
                          if (!widget.arg.userExist ||
                              state.isOtpVerify)
                            buildPinField(context,authBloc,state),
                          const Spacer(),
                          buildLoginButton(context,authBloc,state),
                          SizedBox(height: size.width * 0.1),
                        ],
                      ),
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

  Widget passwordField(BuildContext context, AuthBloc authBloc,AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.password,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
            ),
            InkWell(
              onTap: () {
                authBloc.add(CheckOtpVerifyEvent(isOtpVerify: true));
                authBloc.add(SignInWithOTPEvent(
                      isOtpVerify: true,
                      isForgotPassword: false,
                      countryCode: widget.arg.countryCode,
                      mobileOrEmail: widget.arg.mobileOrEmail,
                      isLoginByEmail: widget.arg.isLoginByEmail,
                      context: context,
                    ));

                timerCount(context, duration: 60);
              },
              child: MyText(
                text: AppLocalizations.of(context)!.signInUsingOtp,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: authBloc.passwordController,
          filled: true,
          obscureText: !state.showPassword,
          hintText: AppLocalizations.of(context)!.enterYourPassword,
          suffixIcon: InkWell(
            onTap: () {
              authBloc.add(ShowPasswordIconEvent(
                  showPassword: state.showPassword));
            },
            child: !state.showPassword
                ? const Icon(
                    Icons.visibility_off_outlined,
                    color: AppColors.darkGrey,
                  )
                : const Icon(
                    Icons.visibility,
                    color: AppColors.darkGrey,
                  ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            authBloc.add(
                  SignInWithOTPEvent(
                    isOtpVerify: true,
                    isForgotPassword: true,
                    mobileOrEmail: widget.arg.mobileOrEmail,
                    countryCode: widget.arg.countryCode,
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    context: context,
                  ),
                );
          },
          child: MyText(
            text: '${AppLocalizations.of(context)!.forgetPassword} ?',
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.greyHintColor,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildPinField(BuildContext context,AuthBloc authBloc,AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              // text: AppLocalizations.of(context)!.enterOtp,
              text: AppLocalizations.of(context)!.oneTimePassword,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
            ),
            if (widget.arg.userExist &&
                state.timerDuration == 0)
              InkWell(
                onTap: () {
                  authBloc.add(CheckOtpVerifyEvent(isOtpVerify: false));
                  timerCount(context, duration: 0, isCloseTimer: true);
                },
                child: MyText(
                  text: AppLocalizations.of(context)!.signInUsingPass,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        PinCodeTextField(
          appContext: context,
          controller: authBloc.otpController,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          length: 6,
          obscureText: false,
          blinkWhenObscuring: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 45,
            fieldWidth: 45,
            activeFillColor: AppColors.white,
            inactiveFillColor: AppColors.white,
            inactiveColor: AppColors.white,
            selectedFillColor: AppColors.white,
            selectedColor: Theme.of(context).disabledColor,
            selectedBorderWidth: 1,
            inactiveBorderWidth: 1,
            activeBorderWidth: 1,
            activeColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          cursorColor: Theme.of(context).dividerColor,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          enablePinAutofill: false,
          autoDisposeControllers: false,
          keyboardType: TextInputType.number,
          boxShadows: const [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
          beforeTextPaste: (_) => false,
          onChanged: (_) => authBloc.add(OTPOnChangeEvent()),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: state.timerDuration != 0
                  ? null
                  : () {
                      authBloc.add(
                            SignInWithOTPEvent(
                              isOtpVerify: true,
                              isForgotPassword: false,
                              countryCode: widget.arg.countryCode,
                              mobileOrEmail: widget.arg.mobileOrEmail,
                              isLoginByEmail: widget.arg.isLoginByEmail,
                              context: context,
                            ),
                          );
                      timerCount(context, duration: 60);
                    },
              child: MyText(
                text: state.timerDuration != 0
                    ? '${AppLocalizations.of(context)!.resendOtp} 00:${state.timerDuration}'
                    : AppLocalizations.of(context)!.resendOtp,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: state.timerDuration != 0
                          ? AppColors.greyHintColor
                          : AppColors.zompColor,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context,AuthBloc authBloc,AuthState state) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return CustomButton(
          borderRadius: 5,
          height: size.height * 0.06,
          width: size.width,
          buttonName: (!widget.arg.userExist)
              ? AppLocalizations.of(context)!.confirm
              : AppLocalizations.of(context)!.login,
          isLoader: state.isLoading,
          onTap: () {
            if (widget.arg.isOtpVerify ||
                state.isOtpVerify) {
              // OTPverify
              authBloc.add(
                    ConfirmOrVerifyOTPEvent(
                      isUserExist: widget.arg.userExist,
                      isLoginByEmail: widget.arg.isLoginByEmail,
                      isOtpVerify: state.isOtpVerify,
                      isForgotPasswordVerify: false,
                      mobileOrEmail: widget.arg.mobileOrEmail,
                      otp: authBloc.otpController.text,
                      password:
                          authBloc.passwordController.text,
                      firebaseVerificationId:
                          state.firebaseVerificationId,
                      context: context,
                    ),
                  );
            } else {
              // PasswordLogin
              authBloc.add(LoginUserEvent(
                    emailOrMobile: widget.arg.mobileOrEmail,
                    otp: authBloc.otpController.text,
                    password: authBloc.passwordController.text,
                    isOtpLogin: state.isOtpVerify,
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    context: context,
                  ));
            }
          },
        );
      },
    );
  }
}
