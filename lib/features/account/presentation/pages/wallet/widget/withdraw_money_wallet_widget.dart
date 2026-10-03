import 'package:bus_booking/core/network/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../bloc/wallet_bloc.dart';

class WithdrawMoneyWalletWidget extends StatefulWidget {
  final WalletBloc wallet;
  final String minWalletAmount;
  final UserDetail userData;
  const WithdrawMoneyWalletWidget(
      {super.key, required this.wallet, required this.minWalletAmount,required this.userData});

  @override
  State<WithdrawMoneyWalletWidget> createState() => _WithdrawMoneyWalletWidgetState();
}

class _WithdrawMoneyWalletWidgetState extends State<WithdrawMoneyWalletWidget> {
  TextEditingController withdrawAmountController = TextEditingController();

@override
void dispose() {
  withdrawAmountController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: widget.wallet,
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          final walletBloc = context.read<WalletBloc>();
          return Container(
            padding: MediaQuery.viewInsetsOf(context),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor),
            child: Container(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: size.width * 0.128,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1.2,
                            color: Theme.of(context).disabledColor)),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.15,
                          height: size.width * 0.128,
                          decoration: BoxDecoration(
                              borderRadius:
                                  (state.textDirection ==
                                          'ltr')
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        )
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12)),
                              color: Theme.of(context).scaffoldBackgroundColor),
                          alignment: Alignment.center,
                          child:
                              MyText(text: widget.userData.currencySymbol.toString()),
                        ),
                        SizedBox(width: size.width * 0.05),
                        Container(
                          height: size.width * 0.128,
                          width: size.width * 0.6,
                          alignment: Alignment.center,
                          child: TextField(
                            controller:withdrawAmountController,
                            onChanged: (value) {
                              walletBloc.add(AddMoneyUpdateEvent(addMoney: int.parse(value)));   
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    AppLocalizations.of(context)!.enterAmount),
                            maxLines: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          withdrawAmountController
                              .text = double.parse(widget.minWalletAmount).toString();
                          walletBloc.add(AddMoneyUpdateEvent(addMoney: double.parse(widget.minWalletAmount)));     
                        },
                        child: Container(
                          height: size.width * 0.11,
                          width: size.width * 0.17,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).disabledColor,
                                  width: 1.2),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(6)),
                          alignment: Alignment.center,
                          child: MyText(
                              text:
                                  '${widget.userData.currencySymbol.toString()} ${double.parse(widget.minWalletAmount)}'),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      InkWell(
                        onTap: () {
                          withdrawAmountController
                                  .text =
                              (double.parse(widget.minWalletAmount) * 2).toString();
                          walletBloc.add(AddMoneyUpdateEvent(addMoney: double.parse(widget.minWalletAmount) * 2));     
                        },
                        child: Container(
                          height: size.width * 0.11,
                          width: size.width * 0.17,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).disabledColor,
                                  width: 1.2),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(6)),
                          alignment: Alignment.center,
                          child: MyText(
                              text:
                                  '${widget.userData.currencySymbol.toString()} ${double.parse(widget.minWalletAmount) * 2}'),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      InkWell(
                        onTap: () {
                          withdrawAmountController
                                  .text =
                              (double.parse(widget.minWalletAmount) * 3).toString();
                           walletBloc.add(AddMoneyUpdateEvent(addMoney: double.parse(widget.minWalletAmount) * 3));  
                        },
                        child: Container(
                          height: size.width * 0.11,
                          width: size.width * 0.17,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).disabledColor,
                                  width: 1.2),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(6)),
                          alignment: Alignment.center,
                          child: MyText(
                              text:
                                  '${widget.userData.currencySymbol.toString()} ${double.parse(widget.minWalletAmount) * 3}'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: size.width * 0.11,
                          width: size.width * 0.425,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.2),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                          alignment: Alignment.center,
                          child: MyText(
                            text: AppLocalizations.of(context)!.cancel,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (withdrawAmountController
                                  .text
                                  .isNotEmpty &&
                              double.parse(state.withdrawResponse!
                                      .walletBalance) >=
                                  double.parse(withdrawAmountController
                                      .text)) {
                            walletBloc.add(RequestWithdrawEvent(
                                amount: withdrawAmountController
                                    .text));
                          } else {
                            context.showSnackBar(
                                color: AppColors.red,
                                message: AppLocalizations.of(context)!
                                    .insufficientWithdraw);
                          }
                        },
                        child: Container(
                          height: size.width * 0.11,
                          width: size.width * 0.425,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          alignment: Alignment.center,
                          child: MyText(
                            text: AppLocalizations.of(context)!.withdraw,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
