import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../bloc/wallet_bloc.dart';

class WalletTransferMoneyWidget extends StatefulWidget {
  final WalletPageArguments arg;
  const WalletTransferMoneyWidget(
      {super.key, required this.arg});

  @override
  State<WalletTransferMoneyWidget> createState() =>
      _WalletTransferMoneyWidgetState();
}

class _WalletTransferMoneyWidgetState extends State<WalletTransferMoneyWidget> {

  TextEditingController transferPhonenumber = TextEditingController();
  TextEditingController transferAmount = TextEditingController();
  @override
  void initState() {
    transferAmount.clear();
    transferPhonenumber.clear();
    super.initState();
  }

  @override
  void dispose() {
    transferAmount.dispose();
    transferPhonenumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        final walletBloc = context.read<WalletBloc>();
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.05),
                    topRight: Radius.circular(size.width * 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 1,
                    blurRadius: 1,
                  )
                ]),
            width: size.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(size.width * 0.05, size.width * 0.05,
                  size.width * 0.05, MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).disabledColor,
                          width: 1.2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 1.2,
                        style: BorderStyle.solid,
                      )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 1.2,
                        style: BorderStyle.solid,
                      )),
                    ),
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    value: state.dropdownValue,
                    onChanged: (String? newValue) {
                      walletBloc.add(TransferMoneySelectedEvent(
                          selectedTransferAmountMenuItem: newValue!));
                    },
                    items: [
                      DropdownMenuItem(
                          value: "user",
                          child: MyText(
                              text: AppLocalizations.of(context)!.user)),
                    ],
                  ),
                  TextFormField(
                    controller: transferAmount,
                    style: Theme.of(context).textTheme.bodyMedium,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.enterAmountHere,
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).disabledColor,
                          width: 1.2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      prefixIcon: SizedBox(
                          height: size.width * 0.1,
                          width: size.width * 0.08,
                          child: Center(
                              child: MyText(
                                  text: widget.arg.userData.currencySymbol))),
                      prefixIconConstraints: BoxConstraints(
                        maxWidth: size.width * 0.08,
                        maxHeight: size.width * 0.1,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 1.2,
                        style: BorderStyle.solid,
                      )),
                    ),
                  ),
                  TextFormField(
                    controller: transferPhonenumber,
                    style: Theme.of(context).textTheme.bodyMedium,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.enterMobileNumber,
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 1.2,
                        style: BorderStyle.solid,
                      )),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 1.2,
                        style: BorderStyle.solid,
                      )),
                      prefixIcon: SizedBox(
                          height: size.width * 0.1,
                          width: size.width * 0.08,
                          child: Center(
                              child: MyText(
                                  text: widget.arg.userData.countryCode))),
                      prefixIconConstraints: BoxConstraints(
                        maxWidth: size.width * 0.08,
                        maxHeight: size.width * 0.1,
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        height: size.width * 0.11,
                        width: size.width * 0.425,
                        buttonName: AppLocalizations.of(context)!.cancel,
                        isBorder: true,
                        buttonColor: Theme.of(context).scaffoldBackgroundColor,
                        textColor: Theme.of(context).primaryColor,
                        textSize: state.languageCode == 'fr' ? 14 : 16,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      CustomButton(
                        height: size.width * 0.11,
                        width: size.width * 0.425,
                        buttonName: AppLocalizations.of(context)!.transferMoney,
                        textSize: state.languageCode == 'fr' ? 14 : 16,
                        isLoader: state.isLoading,
                        onTap: () {
                          if (transferAmount.text == '' ||
                              transferPhonenumber.text == '') {
                          } else {
                            walletBloc.add(MoneyTransferedEvent(
                                transferAmount: transferAmount.text,
                                role: state.dropdownValue,
                                transferMobile: transferPhonenumber.text));
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
