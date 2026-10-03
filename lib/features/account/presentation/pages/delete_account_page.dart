import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../application/acc_bloc.dart';

class DeleteAccount extends StatelessWidget {
  static const String routeName = '/deleteAccount';

  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          // final accBloc = context.read<AccBloc>();
          return Directionality(
            textDirection: state.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: PopScope(
              canPop: false,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.width * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.deleteAccount,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                      Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 16),
                        child: MyText(
                          text: AppLocalizations.of(context)!
                              .deleteAccountPageContent
                              .replaceAll('***', '30')
                              .replaceAll('**', '24'),maxLines: 8,
                        ),
                      ),
                      SizedBox(height: size.width * 0.1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomButton(
                          buttonName: AppLocalizations.of(context)!.okay,
                          width: size.width,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, AuthPage.routeName, (route) => false);
                          },
                        ),
                      ),
                      SizedBox(height: size.width * 0.1)
                    ],
                  ),
                ),
              )),
            ),
          );
        }),
      ),
    );
  }
}
