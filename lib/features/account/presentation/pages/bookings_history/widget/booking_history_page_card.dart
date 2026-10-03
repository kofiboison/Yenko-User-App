import 'package:bus_booking/common/app_colors.dart';
import 'package:bus_booking/features/account/domain/models/booking_history_model.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/utils/custom_text.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../bloc/history_bloc.dart';
import 'booking_history_details_page.dart';

class BookingHistoryCardWidget extends StatelessWidget {
  final HistoryBloc historyBloc;
  final BookingHistoryData bookingHistory;
  const BookingHistoryCardWidget(
      {super.key, required this.historyBloc, required this.bookingHistory});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: historyBloc,
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: '${bookingHistory.company} ',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                              ),
                              MyText(
                                text: '${bookingHistory.vehicleNumber} ',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text:
                                    '${bookingHistory.fromCity} to ${bookingHistory.toCity}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: bookingHistory.isCancelled == 1
                                      ? Colors.red.shade100
                                      : bookingHistory.isCompleted == 1
                                          ? Colors.green.shade100
                                          : bookingHistory.isTripStarted == true
                                              ? Colors.blue.shade100
                                              : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: MyText(
                                  text: bookingHistory.isCancelled == 1
                                      ? AppLocalizations.of(context)!.cancelled
                                      : bookingHistory.isCompleted == 1
                                          ? AppLocalizations.of(context)!
                                              .completed
                                          : bookingHistory.isTripStarted == true
                                              ? AppLocalizations.of(context)!
                                                  .ongoing
                                              : AppLocalizations.of(context)!
                                                  .upcoming,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: bookingHistory.isCancelled == 1
                                            ? Colors.red
                                            : bookingHistory.isCompleted == 1
                                                ? Colors.green
                                                : bookingHistory
                                                            .isTripStarted ==
                                                        true
                                                    ? Colors.blue
                                                    : Colors.orange,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.width * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MyText(
                                    text:
                                        '${bookingHistory.departureDate} | ${bookingHistory.departureTime}',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  MyText(
                                    text:
                                        '${bookingHistory.arraivalDate} | ${bookingHistory.arraivalTime}',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Dash(
                                  direction: Axis.horizontal,
                                  length: constraints.maxWidth,
                                  dashLength: 4,
                                  dashColor: Colors.grey.shade400,
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text:
                                        '${AppLocalizations.of(context)!.ticket} ${bookingHistory.ticketNumber}',
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  MyText(
                                    text:
                                        '${AppLocalizations.of(context)!.fare} ${bookingHistory.requestedCurrencySymbol} ${bookingHistory.journeyBill.data.first.totalAmount}',
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookingHistoryDetailsPage(
                                              booking: bookingHistory,userData: state.userData!,history: historyBloc),
                                    ),
                                  ).then(
                                    (value) {
                                      historyBloc.add(BookingTypeChangeEvent(
                                          bookingTypeIndex:
                                              state.selectedHistoryType));
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.viewDetails,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_ios_rounded,
                                        size: 14),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
