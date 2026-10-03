import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

class PaymentMethodsWidget extends StatelessWidget {
  final MakePaymentPageArguments args;
  final BookingBloc bookingBloc;
  const PaymentMethodsWidget(
      {super.key, required this.args, required this.bookingBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bookingBloc,
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.paymentMethods,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.width * 0.05),
              if (args.userData.wallet!.data.amountBalance >=
                  double.parse(
                      args.bookingData.calculatedbill.data.totalAmount))
                Padding(
                  padding: EdgeInsets.only(bottom: size.width * 0.025),
                  child: InkWell(
                    onTap: () {
                      bookingBloc.add(BookingWalletChooseEvent());
                    },
                    child: Container(
                      width: size.width * 0.92,
                      padding: EdgeInsets.all(size.width * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).disabledColor)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.wallet_rounded),
                                    SizedBox(width: size.width * 0.03),
                                    MyText(
                                        text: AppLocalizations.of(context)!
                                            .wallet,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark)),
                                  ],
                                ),
                              ),
                              Container(
                                width: size.width * 0.05,
                                height: size.width * 0.05,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .primaryColorDark)),
                                alignment: Alignment.center,
                                child: Container(
                                  width: size.width * 0.03,
                                  height: size.width * 0.03,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (state.isWalletChoose)
                                          ? Theme.of(context).primaryColorDark
                                          : Colors.transparent),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: size.width * 0.01),
                          if (state.isWalletChoose)
                            CustomButton(
                              onTap: () {
                                bookingBloc.add(BookTicketsFromWalletEvent(
                                    userId:
                                        args.bookingData.journeyUser.data.id,
                                    totalAmount: args.bookingData.calculatedbill
                                        .data.totalAmount));
                              },
                              buttonName:
                                  '${AppLocalizations.of(context)!.pay} ${args.bookingData.calculatedbill.data.requestedCurrencySymbol} ${args.bookingData.calculatedbill.data.totalAmount}',
                              textSize: 15,
                              isLoader: state.isLoading,
                              borderRadius: 10,
                            ),
                          SizedBox(height: size.width * 0.01)
                        ],
                      ),
                    ),
                  ),
                ),
              ListView.builder(
                itemCount: state.paymentGatewaysList.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return (state.paymentGatewaysList[index].enabled == true)
                      ? Padding(
                          padding: EdgeInsets.only(bottom: size.width * 0.025),
                          child: InkWell(
                            onTap: () {
                              bookingBloc.add(PaymentIndexUpdateEvent(choosenPayment: index));
                            },
                            child: Container(
                              width: size.width * 0.9,
                              padding: EdgeInsets.all(size.width * 0.02),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 0.5,
                                      color: Theme.of(context).disabledColor)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            if (state.paymentGatewaysList[index]
                                                .isCard)
                                              (state.paymentGatewaysList[index].image
                                                      .toLowerCase()
                                                      .toString()
                                                      .contains('visa'))
                                                  ? Image.asset(
                                                      AppImages.visa,
                                                      height: size.width * 0.1,
                                                      width: size.width * 0.08,
                                                    )
                                                  : (state.paymentGatewaysList[index].image
                                                          .toLowerCase()
                                                          .toString()
                                                          .contains('eftpos'))
                                                      ? Image.asset(
                                                          AppImages.eftpos,
                                                          height:
                                                              size.width * 0.1,
                                                          width:
                                                              size.width * 0.08,
                                                        )
                                                      : (state.paymentGatewaysList[
                                                                  index]
                                                              .image
                                                              .toLowerCase()
                                                              .toString()
                                                              .contains(
                                                                  'american'))
                                                          ? Image.asset(
                                                              AppImages
                                                                  .americanExpress,
                                                              height:
                                                                  size.width *
                                                                      0.1,
                                                              width:
                                                                  size.width *
                                                                      0.08,
                                                            )
                                                          : (state.paymentGatewaysList[
                                                                      index]
                                                                  .image
                                                                  .toLowerCase()
                                                                  .toString()
                                                                  .contains(
                                                                      'jcb'))
                                                              ? Image.asset(
                                                                  AppImages.jcb,
                                                                  height:
                                                                      size.width *
                                                                          0.1,
                                                                  width:
                                                                      size.width *
                                                                          0.08,
                                                                )
                                                              : (state.paymentGatewaysList[
                                                                          index]
                                                                      .image
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
                                                                      width: size
                                                                              .width *
                                                                          0.08,
                                                                    )
                                                                  : Image.asset(
                                                                      AppImages
                                                                          .master,
                                                                      height: size.width * 0.1,
                                                                      width: size.width * 0.08),
                                            if (!state.paymentGatewaysList[index]
                                                .isCard)
                                              SizedBox(
                                                height: size.width * 0.1,
                                                width: size.width * 0.08,
                                                child: CachedNetworkImage(
                                                  imageUrl: state.paymentGatewaysList[
                                                          index]
                                                      .image,
                                                  fit: BoxFit.contain,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child: Loader(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Center(
                                                    child: Text(""),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(width: size.width * 0.03),
                                            MyText(
                                                text:state.paymentGatewaysList[
                                                            index]
                                                        .isCard
                                                    ? '**** **** **** ${state.paymentGatewaysList[index].gateway}'
                                                    : state.paymentGatewaysList[
                                                            index]
                                                        .gateway
                                                        .toString(),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: size.width * 0.05,
                                        height: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1.5,
                                                color: Theme.of(context)
                                                    .primaryColorDark)),
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: size.width * 0.03,
                                          height: size.width * 0.03,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ((state.choosenPaymentIndex ==
                                                      index)&& !state.isWalletChoose)
                                                  ? Theme.of(context)
                                                      .primaryColorDark
                                                  : Colors.transparent),
                                        ),
                                      )
                                    ],
                                  ),
                                  if ((state.choosenPaymentIndex ==
                                      index) && !state.isWalletChoose) ...[
                                    SizedBox(height: size.width * 0.01),
                                    CustomButton(
                                      onTap: () {
                                        bookingBloc.add(PaymentWebViewUrlEvent(
                                            url: state
                                                .paymentGatewaysList[index].url,
                                            userId: args.bookingData.journeyUser
                                                .data.userId,
                                            journeyId: args.bookingData
                                                .journeyUser.data.journeyId,
                                            dropId: args.bookingData.journeyUser
                                                .data.dropId,
                                            boardingId: args.bookingData
                                                .journeyUser.data.boardingId,
                                            ticketNumber: args.bookingData
                                                .journeyUser.data.ticketNumber,
                                            currencySymbol: args
                                                .bookingData
                                                .calculatedbill
                                                .data
                                                .requestedCurrencySymbol,
                                            tripFare: args
                                                .bookingData
                                                .calculatedbill
                                                .data
                                                .totalAmount));
                                      },
                                      buttonName:
                                          '${AppLocalizations.of(context)!.pay} ${args.bookingData.calculatedbill.data.requestedCurrencySymbol} ${args.bookingData.calculatedbill.data.totalAmount}',
                                      textSize: 15,
                                      isLoader: state.isLoading,
                                      borderRadius: 10,
                                    ),
                                    SizedBox(height: size.width * 0.01)
                                  ]
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
