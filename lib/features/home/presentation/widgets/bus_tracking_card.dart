import 'package:bus_booking/features/home/application/home_bloc.dart';
import 'package:bus_booking/features/home/presentation/pages/live_tracking.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';

class LiveTrackingWidget extends StatelessWidget {
  final HomeBloc homeBloc;

  const LiveTrackingWidget({
    super.key,
    required this.homeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeBloc,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final journey = homeBloc.userData?.upcomingjourneyUser?.data;
      
          // Hide widget if trip is completed
          if (journey == null || journey.isCompleted == '1') {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Track your bus",
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
                SizedBox(height: size.width * 0.04),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      LiveTracking.routeName,
                      arguments: LiveTrackingArguments(
                          // boardingAddress:
                          //     journey.boardingpoints.data.first.address,
                          // dropAddress: journey.dropAddress,
                          arraivalTime: journey.arraivalTime,
                          fromCity: journey.fromCity,
                          toCity: journey.toCity,
                          departureTime: journey.departureTime,
                          arrivalTime: journey.arraivalTime,
                          departureDate: journey.departureDate,
                          arrivalDate: journey.arraivalDate,
                          ticketNumber: journey.ticketNumber,
                          passengerCount: journey.passengerCount,
                          travelDuration: journey.travelDuration,
                          journeyId: journey.journeyId,
                          boardingPoints:
                              homeBloc.userData!.boardingpoints!.data,
                          stopPoints: homeBloc.userData!.stoppoints!.data,
                          boardingAddress: journey.boardingAddress,
                          dropAddress: journey.dropAddress,
                          polyline: journey.polyLine),
                    );
                  },
                  child: SizedBox(
                    height: size.width * 0.32,
                    child: Container(
                      width: size.width * 0.87,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .hintColor
                                .withAlpha((0.1 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: AppColors.green
                                          .withAlpha((0.8 * 255).toInt()),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(
                                              text: journey.fromCity,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        MyText(
                                            text:
                                                '${journey.departureDate} | ${journey.departureTime}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .hintColor,
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.width * 0.04),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: AppColors.red
                                          .withAlpha((0.8 * 255).toInt()),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text: journey.toCity,
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MyText(
                                                text:
                                                    '${journey.arraivalDate} | ${journey.arraivalTime}',
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    MyText(
                                        text: journey.ticketNumber,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ],
                                ),
                                (journey.isTripStarted == true)
                                    ? Column(
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 5),
                                            decoration: BoxDecoration(
                                              color: AppColors.green
                                                  .withAlpha(
                                                      (0.2 * 255).toInt()),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: MyText(
                                              text: AppLocalizations.of(
                                                      context)!
                                                  .trackNow,
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.04),
              ],
            ),
          );
        },
      ),
    );
  }
}
