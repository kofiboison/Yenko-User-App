import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../booking/presentation/pages/passenger_details_page.dart';
import '../../application/bus/bus_bloc.dart';

class SelectBoardingDeboardingPage extends StatelessWidget {
  static const String routeName = '/selectBoardingDeboardingPage';
  final SelectBoardingPageArguments args;
  const SelectBoardingDeboardingPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusBloc()..add(GetDirectionEvent()),
      child: BlocListener<BusBloc, BusState>(
        listener: (context, state) async {
          if (state.status == BusStatus.logOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          }
        },
        child: BlocBuilder<BusBloc, BusState>(
          builder: (context, state) {
            final busBloc = context.read<BusBloc>();
            if (state.status == BusStatus.loadingStart) {
              return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: size.height,
                  width: size.width,
                  child: const Loader());
            } else {
              return Directionality(
                textDirection: state.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  appBar: CustomAppBar(
                      title: AppLocalizations.of(context)!
                          .selectBoardingDropPoints),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.width * 0.03),
                          if (args.boardingPoints.isNotEmpty) ...[
                            MyText(
                                text: AppLocalizations.of(context)!
                                    .boardingPoints,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: size.width * 0.02),
                            ListView.builder(
                              itemCount: args.boardingPoints.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  value: args.boardingPoints[index].boardingId,
                                  groupValue: state.selectedBoardingPointId,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    busBloc.add(BoardingUpdateEvent(
                                        pointId: value!,
                                        boardingPoint:
                                            args.boardingPoints[index]));
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: MyText(
                                          text: args.boardingPoints[index]
                                              .boardingLandmark,
                                          maxLines: 2,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          MyText(
                                            text:
                                                '@ ${args.boardingPoints[index].boardingTime}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          MyText(
                                            text: args.startDate,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: MyText(
                                    text: args
                                        .boardingPoints[index].boardingPlace,
                                    maxLines: 5,
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: size.width * 0.03),
                          ],
                          if (args.stopPoints.isNotEmpty) ...[
                            MyText(
                                text: AppLocalizations.of(context)!.dropPoints,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: size.width * 0.02),
                            ListView.builder(
                              itemCount: args.stopPoints.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  value: args.stopPoints[index].stopId,
                                  groupValue: state.selectedDropPointId,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    busBloc.add(BoardingUpdateEvent(
                                        pointId: value!,
                                        stopPoint: args.stopPoints[index]));
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: MyText(
                                          text: args
                                              .stopPoints[index].stopLandmark,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          MyText(
                                            text:
                                                '@ ${args.stopPoints[index].stopTime}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          MyText(
                                            text: args.endDate,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: MyText(
                                    text: args.stopPoints[index].stopAddress,
                                    maxLines: 5,
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: size.width * 0.1),
                          ],
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: CustomButton(
                        buttonName: AppLocalizations.of(context)!.proceed,
                        buttonColor: (state.selectedBordingPoint != null &&
                                state.selectedDropPoint != null)
                            ? null
                            : Theme.of(context).dividerColor,
                        onTap: (state.selectedBordingPoint != null &&
                                state.selectedDropPoint != null)
                            ? () {
                                Navigator.pushNamed(
                                    context, PassengerDetailsPage.routeName,
                                    arguments: PassengerDetailsPageArguments(
                                      selectedBordingPoint:
                                          state.selectedBordingPoint!,
                                      selectedDropPoint:
                                          state.selectedDropPoint!,
                                      selectedSeats: args.selectedSeats,
                                      startDate: args.startDate,
                                      endDate: args.endDate,
                                      journeyId: args.journeyId,
                                      userData: args.userData,
                                    ));
                              }
                            : null,
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
}
