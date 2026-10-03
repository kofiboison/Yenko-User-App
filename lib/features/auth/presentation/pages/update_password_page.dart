import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/auth_bloc.dart';
import 'auth_page.dart';

class UpdatePasswordPage extends StatefulWidget {
  static const String routeName = '/updatePasswordPage';
  final UpdatePasswordPageArguments arg;
  const UpdatePasswordPage({super.key, required this.arg});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  TextEditingController rPasswordController = TextEditingController();

  @override
  void dispose() {
    rPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(GetDirectionEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // final authBloc = context.read<AuthBloc>();
          if (state.status == AuthStatus.forgetPasswordUpdateSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
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
                            key: authBloc.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.width * 0.05),
                                Center(
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .forgetPassword,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                  ),
                                ),
                                SizedBox(height: size.width * 0.1),
                                Center(
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .enterNewPassword,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                MyText(
                                  text: AppLocalizations.of(context)!.password,
                                  textStyle: const TextStyle(
                                      fontSize: 12),
                                ),
                                SizedBox(height: size.width * 0.02),
                                buildPasswordField(context, size,state,authBloc),
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
        buttonName: AppLocalizations.of(context)!.change,
        borderRadius: 10,
        height: MediaQuery.of(context).size.height * 0.06,
        isLoader: state.isLoading,
        onTap: () {
          if (authBloc.formKey.currentState!.validate()) {
            authBloc.add(
                  UpdatePasswordEvent(
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    password: rPasswordController.text,
                    emailOrMobile: widget.arg.emailOrMobile,
                    context: context,
                  ),
                );
          }
        },
      ),
    );
  }

  Widget buildPasswordField(BuildContext context, Size size,AuthState state,AuthBloc authBloc) {
    return CustomTextField(
      controller: rPasswordController,
      filled: true,
      obscureText: !state.showPassword,
      hintText: AppLocalizations.of(context)!.enterYourPassword,
      suffixConstraints: BoxConstraints(maxWidth: size.width * 0.2),
      suffixIcon: InkWell(
        onTap: () {
          authBloc.add(ShowPasswordIconEvent(
              showPassword: state.showPassword));
        },
        child: !state.showPassword
            ? const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.darkGrey,
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.visibility,
                  color: AppColors.darkGrey,
                ),
              ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.enterPassword;
        } else if (value.length < 8) {
          return AppLocalizations.of(context)!.minPassRequired;
        } else {
          return null;
        }
      },
    );
  }
}
