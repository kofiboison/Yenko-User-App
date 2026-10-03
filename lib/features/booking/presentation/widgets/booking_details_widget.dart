import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

class BookingDetailsWidget extends StatelessWidget {
  final MakePaymentPageArguments args;
  const BookingDetailsWidget({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.bookingDetails,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.cancel_outlined))
                  ],
                ),
                SizedBox(height: size.width * 0.03),
                MyText(
                  text: args.bookingData.journeyUser.data.company,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                MyText(
                  text:
                      '${args.bookingData.journeyUser.data.busModel} - ${args.bookingData.journeyUser.data.seatType}',
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: size.width * 0.03),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MyText(
                                text: DateFormat('h:mm a').format(DateTime.parse(args.bookingData.journeyUser.data
                                    .journeyBoardingPoints.boardingTime)).toString(),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              MyText(
                                text: args.bookingData.journeyUser.data
                                    .departureDate,
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(width: size.width * 0.03),
                          SizedBox(
                            width: size.width * 0.7,
                            child: MyText(
                              text: args.bookingData.journeyUser.data
                                  .boardingAddress,
                              maxLines: 5,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Dash(
                              direction: Axis.vertical,
                              length: size.width * 0.25,
                              dashLength: 6,
                              dashColor: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MyText(
                                text: DateFormat('h:mm a').format(DateTime.parse(args.bookingData.journeyUser.data
                                    .journeyDropPoints.stopTime)).toString(),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              MyText(
                                text: args.bookingData.journeyUser.data
                                    .arraivalDate,
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(width: size.width * 0.03),
                          SizedBox(
                            width: size.width * 0.7,
                            child: MyText(
                              text: args
                                  .bookingData.journeyUser.data.dropAddress,
                              maxLines: 5,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width * 0.01),
                const Divider(),
                SizedBox(height: size.width * 0.01),
                MyText(
                  text: AppLocalizations.of(context)!.ticketSentTo,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.width * 0.03),
                MyText(
                  text: args.bookingData.journeyUser.data.email,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: size.width * 0.03),
                MyText(
                  text: args.bookingData.journeyUser.data.mobile,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: size.width * 0.2),
              ],
            ),
          ),
        );
      },
    );
  }
}
