import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../application/bus/bus_bloc.dart';
import '../widgets/boarding_detail_widget.dart';
import '../widgets/seat_layout_widget.dart';
import 'select_boarding_deboarding.dart';

class SelectSeatPage extends StatelessWidget {
  static const String routeName = '/selectSeatPage';
  final SelectSeatPageArguments args;
  const SelectSeatPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusBloc()
        ..add(GetDirectionEvent())
        ..add(SeatPageInitEvent(arg: args)),
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
            // final busBloc = context.read<BusBloc>();
            if (state.status == BusStatus.loadingStart) {
              return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: size.height,
                  width: size.width,
                  child: const Loader());
            } else {
              return (state.selectedBus != null)
                  ? Directionality(
                      textDirection: state.textDirection == 'rtl'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Scaffold(
                        appBar: CustomAppBar(
                            title: state.selectedBus!.busCompanyName),
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              boardingDetailWidget(context, state),
                              SizedBox(height: size.width * 0.03),
                              const SeatLayoutWidget()
                            ],
                          ),
                        ),
                        bottomNavigationBar: (state.selectedSeats.isNotEmpty)
                            ? Container(
                                width: size.width,
                                color: AppColors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.5,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                              children: [
                                                if (state.selectedSeats.any(
                                                    (e) =>
                                                        e.seatType ==
                                                        'sleeper'))
                                                  MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .sleeper,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontSize: 14,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                  ),
                                                if (state.selectedSeats.any(
                                                    (e) =>
                                                        e.seatType == 'seater'))
                                                  MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .seater,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontSize: 14,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                  ),
                                                if (state.selectedSeats.any(
                                                    (e) =>
                                                        e.seatType ==
                                                        'semi-sleeper'))
                                                  MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .semiSleeper,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontSize: 14,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                  ),
                                              ],
                                            ),
                                            Wrap(
                                              children: List.generate(
                                                state.selectedSeats.length,
                                                (index) {
                                                  return MyText(
                                                    text:
                                                        '${state.selectedSeats[index].seatNo},',
                                                    maxLines: 2,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      CustomButton(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              SelectBoardingDeboardingPage
                                                  .routeName,
                                              arguments:
                                                  SelectBoardingPageArguments(
                                                boardingPoints: state
                                                    .selectedBus!
                                                    .boardingpoints
                                                    .data,
                                                stopPoints: state.selectedBus!
                                                    .stoppoints.data,
                                                selectedSeats:
                                                    state.selectedSeats,
                                                selectedSeatNo:
                                                    state.selectedSeatNo,
                                                startDate: intl.DateFormat(
                                                        'MMMM d')
                                                    .format(DateTime.parse(state
                                                        .selectedBus!
                                                        .depatureAtDate))
                                                    .toString(),
                                                endDate:
                                                    intl.DateFormat('MMMM d')
                                                        .format(DateTime.parse(
                                                            state.selectedBus!
                                                                .arrivedAtDate))
                                                        .toString(),
                                                journeyId: args.journeyId,
                                                userData: args.userData,
                                              ));
                                        },
                                        width: size.width * 0.4,
                                        buttonName:
                                            AppLocalizations.of(context)!
                                                .confirm,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : null,
                      ),
                    )
                  : Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      height: size.height,
                      width: size.width,
                      child: const Loader());
            }
          },
        ),
      ),
    );
  }

  Widget boardingDetailWidget(BuildContext context, BusState state) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: size.width * 0.4,
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BoardingDetailWidget(
                        fromTitle1: state.selectedBus!.depatureAtTime,
                        title1FontSize: 12,
                        title1Color: AppColors.white,
                        fromTitle2: state.fromShortCode,
                        title2FontSize: 18,
                        title2Color: AppColors.white,
                        toTitle1: state.selectedBus!.arrivedAtTime,
                        toTitle2: state.toShortCode,
                        travelHours: state.selectedBus!.duration,
                        dividerLength: 4,
                        dividerColor: Theme.of(context).dividerColor,
                      ),
                      SizedBox(height: size.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: args.selectedDate,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.white,
                                  fontSize: 12,
                                ),
                          ),
                          Row(
                            children: [
                              MyText(
                                text: state.selectedBus!.rating,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.white,
                                      fontSize: 12,
                                    ),
                              ),
                              const Icon(Icons.star_rounded,
                                  color: AppColors.goldenColor)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: size.width * 0.1),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.width * 0.03),
            ],
          ),
        ),
        Positioned(
          child: Container(
            height: size.width * 0.1,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    offset: const Offset(0, 8),
                    blurRadius: 5,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: size.width * 0.03),
                  Container(
                    height: size.width * 0.05,
                    width: size.width * 0.05,
                    decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  SizedBox(width: size.width * 0.02),
                  MyText(
                    text: AppLocalizations.of(context)!.booked,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Container(
                    height: size.width * 0.05,
                    width: size.width * 0.05,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.green,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  SizedBox(width: size.width * 0.02),
                  MyText(
                    text: AppLocalizations.of(context)!.available,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Container(
                    height: size.width * 0.05,
                    width: size.width * 0.05,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.pink,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  SizedBox(width: size.width * 0.02),
                  MyText(
                    text: AppLocalizations.of(context)!.female,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  SizedBox(width: size.width * 0.03),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
