import 'package:bus_booking/core/utils/custom_appbar.dart';
import 'package:bus_booking/core/utils/custom_button.dart';
import 'package:bus_booking/core/utils/custom_divider.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/features/home/presentation/pages/home_page.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../application/booking_bloc.dart';

class BookingsConfirmationPage extends StatefulWidget {
  static const String routeName = '/bookingsConfirmationPage';
  final MakePaymentPageArguments args;

  const BookingsConfirmationPage({super.key, required this.args});

  @override
  State<BookingsConfirmationPage> createState() =>
      _BookingsConfirmationPageState();
}

class _BookingsConfirmationPageState extends State<BookingsConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc()
        ..add(GetDirectionEvent())
        ..add(GetPaymentGatewaysEvent()),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {},
        child:
            BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();
          return PopScope(
            canPop: false,
            child: Directionality(
              textDirection: state.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.bookingsConfirmation,
                  automaticallyImplyLeading: false,
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      width: size.width * 0.86,
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size.width * 0.86 - 32, // Subtract padding
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                            text: widget.args.bookingData
                                                .journeyUser.data.company
                                                .toString(),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                        MyText(
                                            text:
                                                '${AppLocalizations.of(context)!.ticketId}: ${widget.args.bookingData.journeyUser.data.ticketNumber}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                            text:
                                                '${widget.args.bookingData.journeyUser.data.fromCity} (${widget.args.bookingData.journeyUser.data.fromCityCode})',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor)),
                                        const SizedBox(height: 4),
                                        MyText(
                                          text: widget
                                                      .args
                                                      .bookingData
                                                      .journeyUser
                                                      .data
                                                      .departureDate
                                                      .split(' ')
                                                      .length >
                                                  1
                                              ? widget
                                                  .args
                                                  .bookingData
                                                  .journeyUser
                                                  .data
                                                  .departureDate
                                              : '-',
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        MyText(
                                            text: widget.args.bookingData
                                                .journeyUser.data.departureTime,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.directions_bus,
                                          color: Theme.of(context).hintColor),
                                      const SizedBox(height: 4),
                                      MyText(
                                          text:
                                              '${AppLocalizations.of(context)!.duration} ${widget.args.bookingData.journeyUser.data.travelDuration}',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                    ],
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        MyText(
                                            text:
                                                '${widget.args.bookingData.journeyUser.data.toCity} (${widget.args.bookingData.journeyUser.data.toCityCode})',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor)),
                                        const SizedBox(height: 4),
                                        MyText(
                                          text: widget
                                                      .args
                                                      .bookingData
                                                      .journeyUser
                                                      .data
                                                      .arraivalDate
                                                      .split(' ')
                                                      .length >
                                                  1
                                              ? widget.args.bookingData
                                                  .journeyUser.data.arraivalDate
                                              : '-',
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        MyText(
                                            text: widget.args.bookingData
                                                .journeyUser.data.arraivalTime,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .passengers,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor)),
                                  MyText(
                                    text: widget.args.bookingData.journeyUser
                                        .data.passengerCount,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!.seat,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor),
                                  ),
                                  Flexible(
                                    child: MyText(
                                      text: widget.args.bookingData.journeyUser
                                          .data.journeyPassengerDetail.data
                                          .map((e) => e.seatNo)
                                          .join(', '),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: MyText(
                                        text: AppLocalizations.of(context)!
                                            .passesngersNames,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                  ),
                                  Flexible(
                                    child: MyText(
                                        text:
                                            AppLocalizations.of(context)!.seat,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...widget.args.bookingData.journeyUser.data
                                  .journeyPassengerDetail.data
                                  .map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: MyText(
                                                text: e.name,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Flexible(
                                              child: MyText(
                                                text: e.seatNo,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .ticketId,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor)),
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .ticketFare,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: MyText(
                                      text: widget.args.bookingData.journeyUser
                                          .data.ticketNumber,
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: MyText(
                                      text: widget
                                              .args
                                              .bookingData
                                              .calculatedbill
                                              .data
                                              .requestedCurrencySymbol +
                                          widget.args.bookingData.calculatedbill.data.totalAmount
                                              .toString(),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 15, top: 15),
                                child: HorizontalDotDividerWidget(
                                    color: AppColors.greyHintColor),
                              ),
                              MyText(
                                text:
                                    AppLocalizations.of(context)!.ticketStatus,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 48,
                    child: CustomButton(
                      buttonName: AppLocalizations.of(context)!.backToHome,
                      height: size.width * 0.15,
                      width: size.width * 0.85,
                      onTap: () {
                        bookingBloc.paymentTimer?.cancel();
                        bookingBloc.paymentStream?.cancel();
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
