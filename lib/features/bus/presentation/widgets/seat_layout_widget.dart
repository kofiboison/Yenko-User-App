import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/bus/bus_bloc.dart';
import '../../domain/models/bus_seat_details_model.dart';
import 'seat_type_widget.dart';

class SeatLayoutWidget extends StatelessWidget {
  const SeatLayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusBloc, BusState>(
      builder: (context, state) {
        // final busBloc = context.read<BusBloc>();
        return SizedBox(
          child: Column(
            children: [
              SizedBox(height: size.width * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // LOWER DECK
                      seatLayouts(
                        context: context,
                        state: state,
                        isLowerDeck: true,
                        leftRowLength: state.selectedBus!.bus.data.leftRows,
                        leftColumnLength:
                            state.selectedBus!.bus.data.lowerLeftColumns,
                        rightRowLength:
                            state.selectedBus!.bus.data.rightRows,
                        rightColumnLength:
                            state.selectedBus!.bus.data.lowerRightColumns,
                        leftSideSeats: state.seatLayoutsLowerLeft,
                        rightSideSeats: state.seatLayoutsLowerRight,
                        maxSeatsCanBook: int.parse(state
                            .selectedBus!.maximumNumberOfSeatsUserCanBook),
                      ),
                      SizedBox(width: size.width * 0.05),
                      // UPPER DECK
                      if (state.selectedBus!.upperDeckAvailable)
                        seatLayouts(
                          context: context,
                          state: state,
                          isLowerDeck: false,
                          leftRowLength:
                              state.selectedBus!.bus.data.upperLeftRows,
                          leftColumnLength:
                              state.selectedBus!.bus.data.upperLeftColumns,
                          rightRowLength:
                              state.selectedBus!.bus.data.upperRightRows,
                          rightColumnLength:
                              state.selectedBus!.bus.data.upperRightColumns,
                          leftSideSeats: state.seatLayoutsUpperLeft,
                          rightSideSeats: state.seatLayoutsUpperRight,
                          maxSeatsCanBook: int.parse(state
                              .selectedBus!.maximumNumberOfSeatsUserCanBook),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.width * 0.05),
            ],
          ),
        );
      },
    );
  }
}

Widget seatLayouts(
    {required BuildContext context,
    required bool isLowerDeck,
    required int leftRowLength,
    required int leftColumnLength,
    required BusState state,
    required List<SeatLayoutData> leftSideSeats,
    required List<SeatLayoutData> rightSideSeats,
    required int rightRowLength,
    required int rightColumnLength,
    required int maxSeatsCanBook}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        child: Directionality(
          textDirection: (state.isRightSideDriverSeat != null &&
                  state.isRightSideDriverSeat!)
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: isLowerDeck
                      ? AppLocalizations.of(context)!.lowerDeck
                      : AppLocalizations.of(context)!.upperDeck,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                      ),
                ),
                if (isLowerDeck)
                  Image.asset(AppImages.driverImage, height: size.width * 0.1),
                if (!isLowerDeck) SizedBox(height: size.width * 0.1),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: size.width * 0.03),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left Side
              SizedBox(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  leftColumnLength,
                  (index) {
                    List<List<SeatLayoutData>> rows = [];
                    for (int i = 0;
                        i < leftSideSeats.length;
                        i += leftRowLength) {
                      rows.add(leftSideSeats.sublist(
                          i,
                          (i + leftRowLength) > leftSideSeats.length
                              ? leftSideSeats.length
                              : i + leftRowLength));
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        leftRowLength,
                        (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: InkWell(
                                onTap: () {
                                  context.read<BusBloc>().add(
                                    SelectSeatEvent(seatNo: rows[index][i].seatNo, seat: rows[index][i],maxSeatsCanBook:maxSeatsCanBook)
                                  );
                                },
                                child: (rows[index][i].seatType == 'seater' ||
                                        rows[index][i].seatType ==
                                            'semi-sleeper')
                                    ? SeaterWidget(
                                        borderColor: rows[index][i].isAvailable
                                            ? rows[index][i]
                                                    .isAvailableForFemale
                                                ? AppColors.pink
                                                : rows[index][i]
                                                        .isAvailableForMale
                                                    ? AppColors.naviBlue
                                                    : AppColors.green
                                            : rows[index][i].bookedByFemale
                                                ? AppColors.pink
                                                : rows[index][i].bookedByMale
                                                    ? AppColors.naviBlue
                                                    : null,
                                        fillColor: !rows[index][i].isAvailable
                                            ? AppColors.grey
                                            : state.selectedSeatNo.contains(
                                                    rows[index][i].seatNo)
                                                ? AppColors.primary
                                                : null,
                                        price: rows[index][i].price,
                                        currencySymbol: state
                                            .selectedBus?.currencySymbol,
                                        seatType: rows[index][i].seatType)
                                    : SleeperWidget(
                                        borderColor: rows[index][i].isAvailable
                                            ? rows[index][i]
                                                    .isAvailableForFemale
                                                ? AppColors.pink
                                                : rows[index][i]
                                                        .isAvailableForMale
                                                    ? AppColors.naviBlue
                                                    : AppColors.green
                                            : rows[index][i].bookedByFemale
                                                ? AppColors.pink
                                                : rows[index][i].bookedByMale
                                                    ? AppColors.naviBlue
                                                    : null,
                                        fillColor: !rows[index][i].isAvailable
                                            ? AppColors.grey
                                            : state.selectedSeatNo.contains(
                                                    rows[index][i].seatNo)
                                                ? AppColors.primary
                                                : null,
                                        price: rows[index][i].price,
                                        currencySymbol: state
                                            .selectedBus?.currencySymbol,
                                        seatType: rows[index][i].seatType)),
                          );
                        },
                      ),
                    );
                  },
                ),
              )),
              SizedBox(width: size.width * 0.03),
              // Right Side
              SizedBox(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  rightColumnLength,
                  (index) {
                    List<List<SeatLayoutData>> rows = [];
                    for (int i = 0;
                        i < rightSideSeats.length;
                        i += rightRowLength) {
                      rows.add(rightSideSeats.sublist(
                          i,
                          (i + rightRowLength) > rightSideSeats.length
                              ? rightSideSeats.length
                              : i + rightRowLength));
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        rightRowLength,
                        (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: InkWell(
                                onTap: () {
                                  context.read<BusBloc>().add(
                                    SelectSeatEvent(seatNo: rows[index][i].seatNo, seat: rows[index][i],maxSeatsCanBook:maxSeatsCanBook)
                                  );
                                  // if (!state.selectedSeatNo
                                  //     .contains(rows[index][i].seatNo)) {
                                  //   if (state.selectedSeats.length <
                                  //       maxSeatsCanBook) {
                                  //     if (rows[index][i].isAvailable) {
                                  //       state.selectedSeatNo
                                  //           .add(rows[index][i].seatNo);
                                  //       state.selectedSeats
                                  //           .add(rows[index][i]);
                                  //     }
                                  //   } else {
                                  //     showToast(
                                  //         message:
                                  //             '${AppLocalizations.of(context)!.youCanBook} $maxSeatsCanBook ${AppLocalizations.of(context)!.seatsOnly}');
                                  //   }
                                  // } else {
                                  //   state.selectedSeatNo
                                  //       .remove(rows[index][i].seatNo);
                                  //   state.selectedSeats
                                  //       .remove(rows[index][i]);
                                  // }
                                },
                                child: (rows[index][i].seatType == 'seater' ||
                                        rows[index][i].seatType ==
                                            'semi-sleeper')
                                    ? SeaterWidget(
                                        borderColor: rows[index][i].isAvailable
                                            ? rows[index][i]
                                                    .isAvailableForFemale
                                                ? AppColors.pink
                                                : rows[index][i]
                                                        .isAvailableForMale
                                                    ? AppColors.naviBlue
                                                    : AppColors.green
                                            : rows[index][i].bookedByFemale
                                                ? AppColors.pink
                                                : rows[index][i].bookedByMale
                                                    ? AppColors.naviBlue
                                                    : null,
                                        fillColor: !rows[index][i].isAvailable
                                            ? AppColors.grey
                                            : state.selectedSeatNo.contains(
                                                    rows[index][i].seatNo)
                                                ? AppColors.primary
                                                : null,
                                        price: rows[index][i].price,
                                        currencySymbol: state
                                            .selectedBus?.currencySymbol,
                                        seatType: rows[index][i].seatType)
                                    : SleeperWidget(
                                        borderColor: rows[index][i].isAvailable
                                            ? rows[index][i]
                                                    .isAvailableForFemale
                                                ? AppColors.pink
                                                : rows[index][i]
                                                        .isAvailableForMale
                                                    ? AppColors.naviBlue
                                                    : AppColors.green
                                            : rows[index][i].bookedByFemale
                                                ? AppColors.pink
                                                : rows[index][i].bookedByMale
                                                    ? AppColors.naviBlue
                                                    : null,
                                        fillColor: !rows[index][i].isAvailable
                                            ? AppColors.grey
                                            : state.selectedSeatNo.contains(
                                                    rows[index][i].seatNo)
                                                ? AppColors.primary
                                                : null,
                                        price: rows[index][i].price,
                                        currencySymbol: state
                                            .selectedBus?.currencySymbol,
                                        seatType: rows[index][i].seatType)),
                          );
                        },
                      ),
                    );
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    ],
  );
}
