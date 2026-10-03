import 'package:bus_booking/core/utils/custom_divider.dart';
import 'package:bus_booking/features/booking/presentation/pages/bookings_confirmation_page.dart';
import 'package:bus_booking/features/booking/presentation/widgets/fare_breakup.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_dialoges.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';

import '../widgets/booking_details_widget.dart';
import '../widgets/cancel_payment_widget.dart';
import '../widgets/payment_methods_widget.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/booking_bloc.dart';

class MakePaymentPage extends StatefulWidget {
  static const String routeName = '/makePaymentPage';
  final MakePaymentPageArguments args;
  const MakePaymentPage({super.key, required this.args});

  @override
  State<MakePaymentPage> createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    BookingBloc().paymentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc()
        ..add(GetDirectionEvent())
        ..add(GetPaymentGatewaysEvent())
        ..add(PaymentDurationEvent(
            duration: int.parse(
                widget.args.bookingData.journeyUser.data.paymentDuration))),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          final bookingBloc = context.read<BookingBloc>();
           if (state.status ==  BookingStatus.showJourneyDetails) {
            bookingBloc.add(BookingUpdateEvent());
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: BookingDetailsWidget(args: widget.args),
                );
              },
            );
          } else if (state.status ==  BookingStatus.paymentSuccess) {
            bookingBloc.add(BookingUpdateEvent());
            Navigator.pushNamed(
              context,
              BookingsConfirmationPage.routeName,
              arguments: widget.args,
            );
          } else if (state.status ==  BookingStatus.paymentFailure) {
            bookingBloc.add(BookingUpdateEvent());
            showDialog(
              context: context,
              builder: (_) {
                return CustomSingleButtonDialoge(
                  title: AppLocalizations.of(context)!.failure,
                  content: AppLocalizations.of(context)!.ticketsNotConfirmed,
                  btnName: AppLocalizations.of(context)!.tryAgain,
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          } else if (state.status ==  BookingStatus.paymentTimeExpired) {
            bookingBloc.add(BookingUpdateEvent());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PopScope(
                  canPop: false,
                  child: CustomSingleButtonDialoge(
                    title: AppLocalizations.of(context)!.expired,
                    content: AppLocalizations.of(context)!.timeDurationExpired,
                    btnName: AppLocalizations.of(context)!.back,
                    onTap: () {
                      bookingBloc.paymentTimer?.cancel();
                      bookingBloc.paymentStream?.cancel();
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    },
                  ),
                );
              },
            );
          } else if (state.status ==  BookingStatus.showCancelPayment) {
            bookingBloc.add(BookingUpdateEvent());
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: CancelPaymentWidget(args: widget.args),
                );
              },
            );
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final bookingBloc = context.read<BookingBloc>();
            if (state.status ==  BookingStatus.loading){
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: size.height,
                width: size.width,
                child: const Loader());
            } else {
              return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (!didPop) {
                    bookingBloc.add(ShowCancelPaymentEvent());
                  }
                },
                child: Directionality(
                  textDirection: state.textDirection == 'rtl'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Scaffold(
                    appBar: CustomAppBar(
                      centerTitle: true,
                      backgroundColor: AppColors.primary,
                      title:
                          '${AppLocalizations.of(context)!.pay} ${widget.args.bookingData.calculatedbill.data.totalAmount}',
                      automaticallyImplyLeading: true,
                      onBackTap: () {
                        bookingBloc.add(ShowCancelPaymentEvent());
                      },
                    ),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: size.width * 0.05),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.red
                                        .withAlpha((256 * 0.3).toInt())),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .remainingTimeForPayment,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColors.red),
                                      ),
                                      MyText(
                                        text: formatDuration(
                                            state.timerDuration),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 24),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .reviewBooking,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                          InkWell(
                                            onTap: () {
                                              bookingBloc.add(
                                                  ShowJourneyDetailsEvent());
                                            },
                                            child: MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .viewDetails,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.blue)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.width * 0.02),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .selectedSeats,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 16,
                                                          color: Theme.of(
                                                                  context)
                                                              .dividerColor)),
                                              MyText(
                                                  text: widget
                                                      .args
                                                      .bookingData
                                                      .journeyUser
                                                      .data
                                                      .passengerCount,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 16)),
                                            ],
                                          ),
                                          SizedBox(height: size.width * 0.03),
                                          Row(
                                            children: [
                                              MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .passengerDetails,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 16)),
                                            ],
                                          ),
                                          SizedBox(height: size.width * 0.04),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .name,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          fontSize: 16,
                                                        )),
                                              ),
                                              Flexible(
                                                child: MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .seatNo,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          fontSize: 16,
                                                        )),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.width * 0.01),
                                          ListView.builder(
                                            itemCount: widget
                                                .args
                                                .bookingData
                                                .journeyUser
                                                .data
                                                .journeyPassengerDetail
                                                .data
                                                .length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final passenger = widget
                                                  .args
                                                  .bookingData
                                                  .journeyUser
                                                  .data
                                                  .journeyPassengerDetail
                                                  .data
                                                  .elementAt(index);
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: MyText(
                                                          text: passenger.name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor)),
                                                    ),
                                                    Flexible(
                                                      child: MyText(
                                                          text:
                                                              passenger.seatNo,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                bottom: size.width * 0.025),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Theme.of(context)
                                                            .dividerColor
                                                            .withAlpha((0.2 *
                                                                    255)
                                                                .toInt())))),
                                          ),
                                          SizedBox(height: size.width * 0.04),
                                          Row(
                                            children: [
                                              MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .fareBreakup,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 16)),
                                            ],
                                          ),
                                          SizedBox(height: size.width * 0.02),
                                          FareBreakup(
                                            text: AppLocalizations.of(context)!
                                                .baseprice,
                                            price: widget
                                                    .args
                                                    .bookingData
                                                    .calculatedbill
                                                    .data
                                                    .requestedCurrencySymbol +
                                                widget
                                                    .args
                                                    .bookingData
                                                    .journeyUser
                                                    .data
                                                    .ticketFare,
                                            showBorder: false,
                                          ),
                                          FareBreakup(
                                            text: AppLocalizations.of(context)!
                                                .serviceTax,
                                            price: widget
                                                    .args
                                                    .bookingData
                                                    .calculatedbill
                                                    .data
                                                    .requestedCurrencySymbol +
                                                double.parse(widget
                                                        .args
                                                        .bookingData
                                                        .calculatedbill
                                                        .data
                                                        .serviceTax
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            showBorder: false,
                                          ),
                                          if (widget
                                                  .args
                                                  .bookingData
                                                  .calculatedbill
                                                  .data
                                                  .promoDiscount
                                                  .isNotEmpty &&
                                              widget
                                                      .args
                                                      .bookingData
                                                      .calculatedbill
                                                      .data
                                                      .promoDiscount !=
                                                  '0' &&
                                              widget
                                                      .args
                                                      .bookingData
                                                      .calculatedbill
                                                      .data
                                                      .promoDiscount !=
                                                  '0.0' &&
                                              widget
                                                  .args
                                                  .bookingData
                                                  .calculatedbill
                                                  .data
                                                  .promoDiscount
                                                  .trim()
                                                  .isNotEmpty)
                                            FareBreakup(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .promo,
                                              price:
                                                  '-${widget.args.bookingData.calculatedbill.data.requestedCurrencySymbol}'
                                                  '${double.parse(widget.args.bookingData.calculatedbill.data.promoDiscount.toString()).toStringAsFixed(2)}',
                                              showBorder: false,
                                              pricecolor: AppColors.red,
                                            ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 15, top: 15),
                                            child: HorizontalDotDividerWidget(
                                                length: 28,
                                                color: AppColors.greyHintColor),
                                          ),
                                          FareBreakup(
                                            text: AppLocalizations.of(context)!
                                                .totalPrice,
                                            price: widget
                                                    .args
                                                    .bookingData
                                                    .calculatedbill
                                                    .data
                                                    .requestedCurrencySymbol +
                                                double.parse(widget
                                                        .args
                                                        .bookingData
                                                        .calculatedbill
                                                        .data
                                                        .totalAmount
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            showBorder: false,
                                            fntweight: FontWeight.bold,
                                          ),
                                          SizedBox(height: size.width * 0.05),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PaymentMethodsWidget(
                                  args: widget.args, bookingBloc: bookingBloc),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            }
          },
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
