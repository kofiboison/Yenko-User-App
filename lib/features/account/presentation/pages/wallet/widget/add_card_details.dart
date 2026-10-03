import 'package:bus_booking/core/utils/custom_button.dart';
import 'package:bus_booking/core/utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../bloc/wallet_bloc.dart';

Widget addCardDetails(BuildContext context, Size size) {
  return BlocBuilder<WalletBloc, WalletState>(
    builder: (context, state) {
      final walletBloc = context.read<WalletBloc>();
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 16.0,
                right: 16,
                bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.width * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.enterCardDetails,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.width * 0.05),
                CardFormField(
                  controller: state.cardFormEditController,
                  enablePostalCode: true,
                  onCardChanged: (card) {
                    if (card != null && card.complete) {
                      walletBloc.add(OnCardChangeEvent(card: card));
                    }
                  },
                  style: CardFormStyle(
                    borderRadius: 2,
                    borderWidth: 0,
                    fontSize: 14,
                    textColor: Theme.of(context).primaryColorDark,
                    textErrorColor: AppColors.errorLight,
                    placeholderColor: Theme.of(context).disabledColor,
                    cursorColor: Theme.of(context).primaryColor,
                  ),
                ),
                CustomButton(
                  width: size.width,
                  buttonName: AppLocalizations.of(context)!.saveCard,
                  isLoader: state.isLoading,
                  onTap: () {
                    if (state.cardDetails != null &&
                        state.cardDetails!.complete == true) {
                      walletBloc.add(AddCardDetailsEvent(context: context,userDetail: state.userDetail!));
                    } else {
                      showToast(
                          message:
                              AppLocalizations.of(context)!.enterCredentials);
                    }
                  },
                ),
                SizedBox(height: size.width * 0.1),
              ],
            ),
          ),
        ),
      );
    },
  );
}
