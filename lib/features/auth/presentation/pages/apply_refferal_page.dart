import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/auth_bloc.dart';

class ApplyRefferalPage extends StatefulWidget {
  static const String routeName = '/refferalPage';
  const ApplyRefferalPage({super.key});

  @override
  State<ApplyRefferalPage> createState() => _ApplyRefferalPageState();
}

class _ApplyRefferalPageState extends State<ApplyRefferalPage> {
  TextEditingController rReferralCodeController = TextEditingController();

  @override
  void dispose() {
    rReferralCodeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(GetDirectionEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final authBloc = context.read<AuthBloc>();
          if (state.status == AuthStatus.referralSuccess) {
            authBloc.add(AuthUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final authBloc = context.read<AuthBloc>();
            return Directionality(
              textDirection: state.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.width * 0.1),
                        MyText(
                            text: AppLocalizations.of(context)!.applyRefferal,
                            textStyle: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: AppColors.black,
                                )),
                        SizedBox(height: size.width * 0.1),
                        CustomTextField(
                          controller: rReferralCodeController,
                          filled: true,
                          hintText:
                              AppLocalizations.of(context)!.enterRefferalCode,
                        ),
                        SizedBox(height: size.width * 0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              buttonName: AppLocalizations.of(context)!.skip,
                              width: size.width * 0.4,
                              onTap: () {
                                authBloc.add(ReferralEvent(
                                    referralCode:
                                        AppLocalizations.of(context)!.skip,
                                    context: context));
                              },
                            ),
                            CustomButton(
                              buttonName: AppLocalizations.of(context)!.apply,
                              isLoader: state.isLoading,
                              width: size.width * 0.4,
                              onTap: () {
                                authBloc.add(ReferralEvent(
                                    referralCode: rReferralCodeController
                                        .text,
                                    context: context));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: size.width * 0.05),
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
