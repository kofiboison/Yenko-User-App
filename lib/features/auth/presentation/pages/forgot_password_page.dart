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
import '../../../../l10n/app_localizations.dart';
import '../../application/auth_bloc.dart';
import 'update_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String routeName = '/forgotPasswordPage';
  final ForgotPasswordPageArguments arg;
  const ForgotPasswordPage({super.key, required this.arg});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with 
      SingleTickerProviderStateMixin{
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
      create: (context) => AuthBloc()..add(GetDirectionEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final authBloc = context.read<AuthBloc>();
          if (state.status == AuthStatus.loaded) {
            // CustomLoader.dismiss(context);
            timerCount(context, duration: 60);
            authBloc.add(AuthUpdateEvent());
          } else if (state.status == AuthStatus.forgotPasswordOTPVerify) {
            authBloc.add(AuthUpdateEvent());
            Navigator.pushNamed(context, UpdatePasswordPage.routeName,
                arguments: UpdatePasswordPageArguments(
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    emailOrMobile: widget.arg.emailOrMobile));
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
                  body: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: context.read<AuthBloc>().formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.05),
                                Center(
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .forgetPassword,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: AppColors.black,
                                            fontSize:14),
                                  ),
                                ),
                                SizedBox(height: size.width * 0.1),
                                MyText(
                                  text: AppLocalizations.of(context)!
                                      .otpSendContent,
                                  textAlign: TextAlign.center,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context).disabledColor,
                                      ),
                                  maxLines: 2,
                                ),
                                SizedBox(height: size.width * 0.05),
                                Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      if (!widget.arg.isLoginByEmail)
                                        SizedBox(
                                          height: 20,
                                          width: 30,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                              imageUrl: widget.arg.countryFlag,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: Loader(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Text(""),
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 10),
                                      MyText(text: widget.arg.emailOrMobile),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.width * 0.1),
                                buildPinField(context,authBloc,state),
                                SizedBox(height: size.width * 0.02),
                                SizedBox(height: size.width * 0.1),
                                buildButton(context,state,authBloc),
                                SizedBox(height: size.width * 0.3),
                              ],
                            ),
                          ),
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

  Widget buildButton(BuildContext context,AuthState state,AuthBloc authBloc) {
    return Center(
      child: CustomButton(
        buttonName: AppLocalizations.of(context)!.confirm,
        borderRadius: 10,
        height: MediaQuery.of(context).size.height * 0.06,
        isLoader: state.isLoading,
        onTap: () {
          authBloc.add(
                ConfirmOrVerifyOTPEvent(
                  isUserExist: true,
                  isLoginByEmail: widget.arg.isLoginByEmail,
                  isOtpVerify: true,
                  isForgotPasswordVerify: true,
                  mobileOrEmail: widget.arg.emailOrMobile,
                  otp: context.read<AuthBloc>().otpController.text,
                  password: '',
                  firebaseVerificationId:
                      state.firebaseVerificationId,
                  context: context,
                ),
              );
        },
      ),
    );
  }

  Widget buildPinField(BuildContext context,AuthBloc authBloc,AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.enterOtp,
          textStyle: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 10),
        PinCodeTextField(
          appContext: context,
          controller: context.read<AuthBloc>().otpController,
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
                      context.read<AuthBloc>().add(
                            SignInWithOTPEvent(
                              isOtpVerify: true,
                              isForgotPassword: true,
                              countryCode: widget.arg.contryCode,
                              mobileOrEmail: widget.arg.emailOrMobile,
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
                        ? Theme.of(context).disabledColor
                        : AppColors.zompColor,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
