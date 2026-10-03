import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../bloc/wallet_bloc.dart';
import 'add_card_details.dart';

class CardListWidget extends StatelessWidget {
  static const String routeName = '/cardListWidget';
  final PaymentMethodArguments arg;
  const CardListWidget({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc()
        ..add(WalletGetDirectionEvent())
        ..add(PaymentAuthenticationEvent(arg: arg))
        ..add(CardListEvent()),
      child: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) async{
          final accBloc = context.read<WalletBloc>();
          if (state.status == WalletStatus.logOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          } else if (state.status == WalletStatus.saveCardSuccess) {
            Navigator.pop(context);
            accBloc.add(CardListEvent());
          }
        },
        child: BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
          final accBloc = context.read<WalletBloc>();
          return Scaffold(
            appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.saveCards,
                automaticallyImplyLeading: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                        text: AppLocalizations.of(context)!.selectCards,
                        textStyle: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(height: size.width * 0.025),
                    MyText(
                      text: AppLocalizations.of(context)!.cardDisplayText,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 4,
                    ),
                    SizedBox(height: size.width * 0.05),
                    InkWell(
                      onTap: () {
                        accBloc.add(WalletUpdateEvent());
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) {
                            return BlocProvider.value(
                              value: accBloc,
                              child: addCardDetails(context, size),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: size.width,
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1.2,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withAlpha((0.5 * 256).toInt()))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.width * 0.05,
                              width: size.width * 0.05,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor)),
                              alignment: Alignment.center,
                              child: Icon(Icons.add,
                                  size: size.width * 0.04,
                                  color: Theme.of(context).primaryColor),
                            ),
                            SizedBox(
                              width: size.width * 0.025,
                            ),
                            MyText(
                              text: AppLocalizations.of(context)!.addCard,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.savedCardsList.isNotEmpty) ...[
                      SizedBox(height: size.width * 0.05),
                      MyText(
                          text: AppLocalizations.of(context)!.cards,
                          textStyle: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: size.width * 0.05),
                      ListView.separated(
                        itemCount:
                            state.savedCardsList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final card = state.savedCardsList
                              .elementAt(index);
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  width: 0.5,
                                  color: Theme.of(context).primaryColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 2),
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        AppImages.simCard,
                                        height: size.width * 0.1,
                                        width: size.width * 0.1,
                                      ),
                                      (card.cardType
                                              .toLowerCase()
                                              .toString()
                                              .contains('visa'))
                                          ? Image.asset(
                                              AppImages.visa,
                                              height: size.width * 0.1,
                                              width: size.width * 0.2,
                                            )
                                          : (card.cardType
                                                  .toLowerCase()
                                                  .toString()
                                                  .contains('eftpos'))
                                              ? Image.asset(
                                                  AppImages.eftpos,
                                                  height: size.width * 0.1,
                                                  width: size.width * 0.2,
                                                )
                                              : (card.cardType
                                                      .toLowerCase()
                                                      .toString()
                                                      .contains('american'))
                                                  ? Image.asset(
                                                      AppImages.americanExpress,
                                                      height: size.width * 0.1,
                                                      width: size.width * 0.2,
                                                    )
                                                  : (card.cardType
                                                          .toLowerCase()
                                                          .toString()
                                                          .contains('jcb'))
                                                      ? Image.asset(
                                                          AppImages.jcb,
                                                          height:
                                                              size.width * 0.1,
                                                          width:
                                                              size.width * 0.2,
                                                        )
                                                      : (card.cardType
                                                              .toLowerCase()
                                                              .toString()
                                                              .contains(
                                                                  'discover || dinners'))
                                                          ? Image.asset(
                                                              AppImages
                                                                  .discover,
                                                              height:
                                                                  size.width *
                                                                      0.1,
                                                              width:
                                                                  size.width *
                                                                      0.2,
                                                            )
                                                          : Image.asset(
                                                              AppImages.master,
                                                              height:
                                                                  size.width *
                                                                      0.1,
                                                              width:
                                                                  size.width *
                                                                      0.2),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyText(
                                        text:
                                            '**** **** **** ${card.lastNumber}',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontSize: size.width * 0.06,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text: card.validThrough,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (cont) {
                                              return CustomDoubleButtonDialoge(
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .delete,
                                                content: AppLocalizations.of(
                                                        context)!
                                                    .deleteCardConfirmationText,
                                                yesBtnName: AppLocalizations.of(
                                                        context)!
                                                    .yes,
                                                noBtnName: AppLocalizations.of(
                                                        context)!
                                                    .no,
                                                yesBtnFunc: () {
                                                  Navigator.pop(cont);
                                                  accBloc.add(
                                                      DeleteCardEvent(
                                                          cardId: card.id));
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: AppColors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: size.width * 0.02,
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
