import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../bloc/wallet_bloc.dart';
import '../widget/wallet_history_shimmer.dart';
import '../widget/withdraw_history_data_widget.dart';
import '../widget/withdraw_money_wallet_widget.dart';

class WithdrawPage extends StatelessWidget {
  static const String routeName = '/withdrawPage';
  final WithdrawPageArguments arg;
  const WithdrawPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => WalletBloc()..add(GetWithdrawInitEvent()),
      child: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) async {
          final walletBloc = context.read<WalletBloc>();
          if (state.status == WalletStatus.logOut) {
            walletBloc.add(WalletUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          }
        },
        child: BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
          final walletBloc = context.read<WalletBloc>();
          if (state.status == WalletStatus.loading) {
            return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: size.height,
                width: size.width,
                child: const Loader());
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.recentWithdrawal,
                automaticallyImplyLeading: true,
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      height: size.height,
                      child: Column(
                        children: [
                          SizedBox(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: size.width * 0.05,
                                  top: size.width * 0.025,
                                  right: size.width * 0.05,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: EdgeInsets.only(
                                              top: size.width * 0.05,
                                            ),
                                            child: Column(
                                              children: [
                                                MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .walletBalance,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color:
                                                                AppColors.white,
                                                            fontSize: 20)),
                                                if (state.isWithdrawLoading &&
                                                    !state.loadMore)
                                                  SizedBox(
                                                    height: size.width * 0.06,
                                                    width: size.width * 0.06,
                                                    child: const Loader(
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                if (state.withdrawResponse !=
                                                    null)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      MyText(
                                                          text:
                                                              '${state.withdrawResponse!.walletBalance.toString()} ${arg.userData.currencySymbol.toString()}',
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayLarge!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white)),
                                                    ],
                                                  ),
                                                SizedBox(
                                                    height: size.width * 0.04),
                                                InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder: (_) {
                                                          return BlocProvider
                                                              .value(
                                                            value: walletBloc,
                                                            child:
                                                                paymentMethod(
                                                                    context,
                                                                    size,
                                                                    walletBloc,
                                                                    false),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            size.width * 0.01,
                                                            size.width * 0.025,
                                                            size.width * 0.01,
                                                            size.width * 0.025),
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(5),
                                                        bottomRight:
                                                            Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: MyText(
                                                        text: AppLocalizations
                                                                .of(context)!
                                                            .updatePaymentMethod,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: size.width,
                              padding: EdgeInsets.all(size.width * 0.05),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .recentWithdrawal,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.025),
                                  if (state.isWithdrawLoading &&
                                      state.firstWithdrawLoad)
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: 8,
                                        itemBuilder: (context, index) {
                                          return const ShimmerWalletHistory();
                                        },
                                      ),
                                    ),
                                  if (state.isWithdrawLoading == false) ...[
                                    Expanded(
                                      child: SingleChildScrollView(
                                        controller: walletBloc.scrollController,
                                        child: Column(
                                          children: [
                                            WithdrawHistoryDataWidget(
                                              withdrawHistoryList:
                                                  state.withdrawData,
                                              cont: context,
                                              userData: arg.userData,
                                            ),
                                            if (state.loadMore)
                                              Center(
                                                child: SizedBox(
                                                    height: size.width * 0.08,
                                                    width: size.width * 0.08,
                                                    child:
                                                        const CircularProgressIndicator()),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CustomButton(
                                        width: size.width * 0.7,
                                        buttonName:
                                            AppLocalizations.of(context)!
                                                .requestWithdraw,
                                        onTap: () {
                                          if (state.bankDetails
                                              .where((e) =>
                                                  e['bank_info']['data']
                                                      .toString() !=
                                                  '[]')
                                              .isNotEmpty) {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (builder) {
                                                  return WithdrawMoneyWalletWidget(
                                                      wallet: walletBloc,
                                                      minWalletAmount:
                                                          arg.minWalletAmount,
                                                      userData: arg.userData);
                                                });
                                          } else {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (_) {
                                                  return BlocProvider.value(
                                                    value: walletBloc,
                                                    child: paymentMethod(
                                                        context,
                                                        size,
                                                        walletBloc,
                                                        true),
                                                  );
                                                });
                                          }
                                        })
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.addBankInfo || (state.editBank))
                      Positioned(
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.05),
                          height: size.height,
                          width: size.width,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Column(
                            children: [
                              SizedBox(
                                width: size.width * 0.9,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyText(
                                      text: state.editBank
                                          ? AppLocalizations.of(context)!
                                              .editBankDetails
                                          : AppLocalizations.of(context)!
                                              .bankDetails,
                                      textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: size.width * 0.08)
                                  ],
                                ),
                              ),
                              SizedBox(height: size.width * 0.05),
                              SizedBox(
                                height: size.height * 0.6,
                                child: SingleChildScrollView(
                                  child: Column(children: [
                                    if (state.choosenBankList.isNotEmpty)
                                      ListView.builder(
                                        itemCount: state.choosenBankList.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                  height: size.width * 0.05),
                                              SizedBox(
                                                width: size.width * 0.9,
                                                child: MyText(
                                                  text: state.choosenBankList[
                                                      index]['placeholder'],
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: size.width * 0.025),
                                              SizedBox(
                                                width: size.width * 0.9,
                                                child: CustomTextField(
                                                  keyboardType:
                                                      state.choosenBankList[
                                                                      index][
                                                                  'input_field_type'] ==
                                                              "text"
                                                          ? TextInputType.text
                                                          : TextInputType
                                                              .number,
                                                  controller: walletBloc
                                                          .bankDetailsTextEditControllers[
                                                      index],
                                                  hintText:
                                                      state.choosenBankList[
                                                          index]['placeholder'],
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark)),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark)),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                  ]),
                                ),
                              ),
                              SizedBox(height: size.width * 0.05),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    buttonColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    width: size.width * 0.4,
                                    textColor: Theme.of(context).primaryColor,
                                    isBorder: true,
                                    buttonName:
                                        AppLocalizations.of(context)!.cancel,
                                    onTap: () {
                                      if (state.editBank) {
                                        walletBloc
                                            .add(EditBankEvent(choosen: null));
                                      } else {
                                        walletBloc
                                            .add(AddBankEvent(choosen: null));
                                      }
                                    },
                                  ),
                                  CustomButton(
                                      width: size.width * 0.4,
                                      buttonName:
                                          AppLocalizations.of(context)!.confirm,
                                      onTap: () {
                                        Map body = {
                                          "method_id": state.choosenBankList[0]
                                              ['method_id'],
                                        };

                                        for (var i = 0;
                                            i < state.choosenBankList.length;
                                            i++) {
                                          if ((state.choosenBankList[i]
                                                              ['is_required']
                                                          .toString() ==
                                                      '1' &&
                                                  walletBloc
                                                      .bankDetailsTextEditControllers[
                                                          i]
                                                      .text
                                                      .isNotEmpty) ||
                                              walletBloc
                                                  .bankDetailsTextEditControllers[
                                                      i]
                                                  .text
                                                  .isNotEmpty) {
                                            body["${state.choosenBankList[i]['input_field_name']}"] =
                                                walletBloc
                                                    .bankDetailsTextEditControllers[
                                                        i]
                                                    .text;
                                          } else if (state.choosenBankList[i]
                                                      ['is_required']
                                                  .toString() ==
                                              '1') {
                                            showToast(
                                                message: AppLocalizations.of(
                                                        context)!
                                                    .enterRequiredField);
                                            return;
                                          }
                                        }
                                        walletBloc.add(
                                            UpdateBankDetailsEvent(body: body));
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget paymentMethod(BuildContext context, Size size, WalletBloc walletBloc,
      bool isFromRequest) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (_, state) {
        return SafeArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: size.width,
            padding: EdgeInsets.all(size.width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.width * 0.9,
                  child: MyText(
                    text: AppLocalizations.of(context)!.paymentMethods,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                ),
                SizedBox(height: size.width * 0.05),
                if (state.bankDetails.isNotEmpty)
                  ListView.builder(
                    itemCount: state.bankDetails.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, i) {
                      final bank = state.bankDetails.elementAt(i);
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (isFromRequest) {
                            walletBloc.add(AddBankEvent(choosen: i));
                          } else {
                            (bank['bank_info']['data'].toString() == '[]')
                                ? walletBloc.add(AddBankEvent(choosen: i))
                                : walletBloc.add(EditBankEvent(choosen: i));
                          }
                        },
                        child: Container(
                          width: size.width * 0.9,
                          margin: EdgeInsets.only(bottom: size.width * 0.025),
                          padding: EdgeInsets.all(
                            size.width * 0.05,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .disabledColor
                                  .withAlpha((0.3 * 255).toInt())),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyText(
                                    text: bank['method_name'],
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark)),
                              ),
                              MyText(
                                  text: (bank['bank_info']['data'].toString() ==
                                          '[]')
                                      ? AppLocalizations.of(context)!.textAdd
                                      : AppLocalizations.of(context)!.textView,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (state.bankDetails.isEmpty)
                 const MyText(text: 'No payment methods enabled') 
              ],
            ),
          ),
        );
      },
    );
  }
}
