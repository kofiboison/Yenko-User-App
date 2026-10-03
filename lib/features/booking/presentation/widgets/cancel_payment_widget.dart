import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

class CancelPaymentWidget extends StatelessWidget {
  final MakePaymentPageArguments args;
  const CancelPaymentWidget({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final bookingBloc = context.read<BookingBloc>();
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
                      text: AppLocalizations.of(context)!.cancelBooking,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
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
                  text: AppLocalizations.of(context)!.cancelBookingText,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
                SizedBox(height: size.width * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      buttonName: AppLocalizations.of(context)!.cancelBooking,
                      width: size.width * 0.4,
                      borderRadius: 5,
                      isBorder: true,
                      textSize: 14,
                      textColor: AppColors.primary,
                      buttonColor: AppColors.white,
                      onTap: () {
                        bookingBloc.paymentTimer?.cancel();
                        bookingBloc.paymentStream?.cancel();
                        bookingBloc.add(CancelPaymentEvent(
                            journeyId:
                                args.bookingData.journeyUser.data.journeyId,
                            userId: args.bookingData.journeyUser.data.userId,
                            ticketNumber: args
                                .bookingData.journeyUser.data.ticketNumber));
                        // int i = 0;
                        // Navigator.popUntil(context, (route) => i++ == 2);
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      },
                    ),
                    CustomButton(
                      buttonName: AppLocalizations.of(context)!.back,
                      borderRadius: 5,
                      width: size.width * 0.4,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
