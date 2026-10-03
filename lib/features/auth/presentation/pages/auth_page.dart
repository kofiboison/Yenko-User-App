import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../application/auth_bloc.dart';

import '../widgets/auth_body_widget.dart';
import 'verify_page.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = '/authPage';
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return builderList(size);
  }

  Widget builderList(Size size) {
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(CountryGetEvent())
        ..add(GetCommonModuleEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final authBloc = context.read<AuthBloc>();
          if (state.status == AuthStatus.verifySuccess) {
            authBloc.add(AuthUpdateEvent());
            Navigator.pushNamed(
              context,
              VerifyPage.routeName,
              arguments: VerifyArguments(
                mobileOrEmail:
                    context.read<AuthBloc>().emailOrMobileController.text,
                countryCode: state.dialCode,
                countryFlag: state.flagImage,
                isLoginByEmail: state.isLoginByEmail,
                userExist: state.userExist,
                countryList: state.countries,
                isOtpVerify: state.userExist ? false : true,
                isDemoLogin: false,
                isRefferalEarnings: state.isRefferalEarnings,
              ),
            );
          } else if (state.status == AuthStatus.signInWithDemo) {
            authBloc.add(AuthUpdateEvent());
            Navigator.pushNamed(
              context,
              VerifyPage.routeName,
              arguments: VerifyArguments(
                mobileOrEmail:
                    context.read<AuthBloc>().emailOrMobileController.text,
                countryCode: state.dialCode,
                countryFlag: state.flagImage,
                isLoginByEmail: state.isLoginByEmail,
                userExist: false,
                countryList: state.countries,
                isOtpVerify: true,
                isDemoLogin: true,
                isRefferalEarnings: state.isRefferalEarnings,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final authBloc = context.read<AuthBloc>();
            return PopScope(
              canPop: false,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  authBloc.formKey.currentState!.reset();
                },
                child: Directionality(
                  textDirection: state.textDirection == 'rtl'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: AuthBodyWidget(auth:authBloc),
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
