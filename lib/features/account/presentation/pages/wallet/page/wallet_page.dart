import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../bloc/wallet_bloc.dart';
import '../widget/add_money_wallet_widget.dart';
import '../widget/card_list_widget.dart';
import '../widget/wallet_history_list_widget.dart';
import '../widget/wallet_history_shimmer.dart';
import '../widget/wallet_payment_gateway_list_widget.dart';
import '../widget/web_view_page.dart';
import 'withdraw_page.dart';

class WalletHistoryPage extends StatelessWidget {
  static const String routeName = '/walletHistory';
  final WalletPageArguments arg;

  const WalletHistoryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => WalletBloc()..add(WalletPageInitEvent(arg: arg)),
      child: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) async {
          final walletBloc = context.read<WalletBloc>();
          if (state.status ==  WalletStatus.logOut) {
            walletBloc.add(WalletUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          } else if (state.status ==  WalletStatus.moneyTransferedSuccess) {
            walletBloc.add(WalletUpdateEvent());
            Navigator.pop(context);
          } else if (state.status ==  WalletStatus.addMoneyWebViewUrl) {
            walletBloc.add(WalletUpdateEvent());
            Navigator.pushNamed(
              context,
              WebViewPage.routeName,
            );
          } else if (state.status ==  WalletStatus.showPaymentGateway) {
            walletBloc.add(WalletUpdateEvent());
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: true,
                isDismissible: true,
                builder: (_) {
                  return WalletPaymentGatewayListWidget(
                      wallet: walletBloc,
                      walletPaymentGatways: state.walletPaymentGatways);
                });
          } else if (state.status ==  WalletStatus.walletPaymentSuccess) {
              walletBloc.add(WalletUpdateEvent());
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Prevents closing the dialog by tapping outside
                builder: (_) {
                  return AlertDialog(
                    content: SizedBox(
                      height: size.height * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.paymentSuccess,
                            fit: BoxFit.contain,
                            width: size.width * 0.5,
                          ),
                          SizedBox(height: size.width * 0.02),
                          Text(
                            AppLocalizations.of(context)!.paymentSuccess,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.width * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              walletBloc.add(
                                GetWalletHistoryListEvent(pageIndex: 1),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.okay),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if(state.status ==  WalletStatus.walletPaymentFailure) {
              walletBloc.add(WalletUpdateEvent());
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Prevents closing the dialog by tapping outside
                builder: (_) {
                  return AlertDialog(
                    content: SizedBox(
                      height: size.height * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.paymentFail,
                            fit: BoxFit.contain,
                            width: size.width * 0.4,
                          ),
                          SizedBox(height: size.width * 0.02),
                          Text(
                            AppLocalizations.of(context)!.paymentFailed,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.width * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.okay),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          
        },
        child: BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
          final walletBloc = context.read<WalletBloc>();
          if (state.status == WalletStatus.loading){
            return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: size.height,
                width: size.width,
                child: const Loader());
          } else {  
            return Scaffold(
            appBar: const CustomAppBar(
              title: "wallet",
              automaticallyImplyLeading: true,
            ),
            body: RefreshIndicator(
              onRefresh: () {
                Future<void> onrefresh() async {
                  walletBloc.add(GetWalletHistoryListEvent(pageIndex: 1));
                }

                return onrefresh();
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: size.width * 0.03),
                      if (state.showRefresh) ...[
                        InkWell(
                          onTap: () {
                            walletBloc
                                .add(UpdateShowRefreshEvent(showRefresh: false));
                            walletBloc
                                .add(GetWalletHistoryListEvent(pageIndex: 1));
                          },
                          child: Column(
                            children: [
                              const Icon(Icons.refresh_outlined),
                              SizedBox(height: size.width * 0.01),
                              MyText(
                                  text: "Refresh",
                                  textStyle:
                                      Theme.of(context).textTheme.bodySmall!),
                              SizedBox(height: size.width * 0.02),
                            ],
                          ),
                        )
                      ],
                      Padding(
                        padding: EdgeInsets.only(bottom: size.width * 0.12),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.only(
                                top: size.width * 0.05,
                                bottom: size.width * 0.12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: MyText(
                                      text: AppLocalizations.of(context)!.walletBalance,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 16),
                                    ),
                                  ),
                                  if (state.isLoading && !state.loadMore)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: SizedBox(
                                        height: size.width * 0.06,
                                        width: size.width * 0.06,
                                        child: const Loader(
                                            color: AppColors.white),
                                      ),
                                    ),
                                  if (state.walletResponse != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: MyText(
                                            text:
                                                '${state.walletResponse!.walletBalance.toString()} ${state.walletResponse!.currencySymbol.toString()}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 32),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -size.width * 0.05,
                              left: size.width / 3.2 ,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          enableDrag: false,
                                          isDismissible: true,
                                          backgroundColor:
                                              Theme.of(context).shadowColor,
                                          builder: (_) {
                                            return AddMoneyWalletWidget(
                                                wallet: walletBloc,
                                                minWalletAmount: state.walletResponse!
                                                    .minimumAmountAddedToWallet);
                                          });
                                    },
                                    child: Container(
                                      height: size.width * 0.12,
                                      width: size.width * 0.12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: size.width * 0.06,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          WithdrawPage.routeName,
                                          arguments: WithdrawPageArguments(
                                              minWalletAmount: state.walletResponse!
                                                  .minimumAmountAddedToWallet,
                                              userData: arg.userData));
                                    },
                                    child: Container(
                                      height: size.width * 0.12,
                                      width: size.width * 0.12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                        size: size.width * 0.06,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.width * 0.02),
                              if (state.walletResponse != null &&
                                  state.walletResponse!
                                      .enableSaveCard) ...[
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                            context, CardListWidget.routeName,
                                            arguments: PaymentMethodArguments(
                                                userData: state.userDetail!))
                                        .then(
                                      (value) {
                                        if (!context.mounted) return;
                                        walletBloc.add(
                                            GetWalletHistoryListEvent(
                                                pageIndex: 1));
                                      },
                                    );
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(context)!.saveCards,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.white,
                                                ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                            color: AppColors.white,
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(height: size.width * 0.02),
                              ],
                              Row(
                                children: [
                                  MyText(
                                    text:AppLocalizations.of(context)!.recentTransaction,
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
                              if (state.isLoading && state.firstLoad)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      return const ShimmerWalletHistory();
                                    },
                                  ),
                                ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: walletBloc.scrollController,
                                  child: Column(
                                    children: [
                                      WalletHistoryListWidget(
                                        walletHistoryList: state.walletHistoryList,
                                        cont: context,
                                      ),
                                      if (state.walletHistoryList
                                              .isNotEmpty &&
                                          state.loadMore)
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          }
        }),
      ),
    );
  }
}
