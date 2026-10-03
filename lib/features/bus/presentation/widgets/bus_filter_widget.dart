import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/bus/bus_bloc.dart';
import '../../application/filter/filter_bloc.dart';

class BusFilterWidget extends StatelessWidget {
  final BusBloc busBloc;
  final BusState busState;
  const BusFilterWidget(
      {super.key, required this.busBloc, required this.busState});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterBloc()
        ..add(FilterInitEvent(journeyFilter: busState.journeyFilterModel)),
      child: BlocBuilder<FilterBloc, FilterState>(builder: (context, state) {
        final filterBloc = context.read<FilterBloc>();
        return state.showFilterDetails
            ? showFilterDetails(context: context, state: state)
            : bottomFiltertypes(state: state,context: context,filterBloc: filterBloc);
      }),
    );
  }

  Widget bottomFiltertypes(
      {required FilterState state,required BuildContext context,required FilterBloc filterBloc}) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.8,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    state.filterTypes.length,
                    (index) {
                      final filter = state.filterTypes.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            if (filter.type == 'bus') {
                              if (filter.typeName == 'Ac' &&
                                  state.filterBusType.contains('1')) {
                                state.filterBusType
                                    .removeWhere((element) => element == '1');
                              } else if (filter.typeName == 'Non-Ac' &&
                                  state.filterBusType.contains('0')) {
                                state.filterBusType
                                    .removeWhere((element) => element == '0');
                              } else {
                                if (filter.typeName == 'Ac') {
                                  state.filterBusType.add('1');
                                } else if (filter.typeName == 'Non-Ac') {
                                  state.filterBusType.add('0');
                                }
                              }
                            } else if (filter.type == 'seat') {
                              if (state.filterSeatType
                                  .contains(filter.typeName)) {
                                state.filterSeatType.removeWhere(
                                    (element) => element == filter.typeName);
                              } else {
                                state.filterSeatType.add(filter.typeName);
                              }
                            }
                            busBloc.add(GetFilterBusesEvent(
                                filterSeatType: state.filterSeatType,
                                filterBusType: state.filterBusType));
                          },
                          child: Container(
                            height: size.width * 0.13,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                                color: ((filter.type == 'seat' &&
                                            state.filterSeatType
                                                .contains(filter.typeName)) ||
                                        (filter.type == 'bus' &&
                                            state.filterBusType.contains(
                                                (filter.typeName == 'Ac')
                                                    ? '1'
                                                    : '0')))
                                    ? AppColors.primary
                                    : AppColors.grey,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(filter.typeImage,
                                    height: size.width * 0.08,
                                    color: ((filter.type == 'seat' &&
                                                state.filterSeatType.contains(
                                                    filter.typeName)) ||
                                            (filter.type == 'bus' &&
                                                state.filterBusType.contains(
                                                    (filter.typeName == 'Ac')
                                                        ? '1'
                                                        : '0')))
                                        ? AppColors.white
                                        : null),
                                MyText(
                                  text: filter.typeName,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontSize: 10,
                                          color: ((filter.type == 'seat' &&
                                                      state.filterSeatType
                                                          .contains(filter
                                                              .typeName)) ||
                                                  (filter.type == 'bus' &&
                                                      state.filterBusType
                                                          .contains(
                                                              (filter.typeName ==
                                                                      'Ac')
                                                                  ? '1'
                                                                  : '0')))
                                              ? AppColors.white
                                              : null),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                filterBloc.add(ShowFilterDetailsEvent(showFilterDetails: true));
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  BlocBuilder<FilterBloc, FilterState>(
                    bloc: filterBloc,
                    builder: (context, state) {
                      return Container(
                          height: size.width * 0.13,
                          width: size.width * 0.13,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                              child: Icon(Icons.tune_outlined,
                                  color: AppColors.white, size: 20)));
                    },
                  ),
                  if (state.filterSeatType.isNotEmpty ||
                      state.filterBusType.isNotEmpty ||
                      state.filterAmenities.isNotEmpty ||
                      state.filterBordingLandmark.isNotEmpty ||
                      state.filterDropLandmark.isNotEmpty ||
                      state.filterBusPartners.isNotEmpty ||
                      (busState.journeyFilterModel != null &&
                          ((busState.journeyFilterModel!.lowPrice.isNotEmpty &&
                                  (state.currentRangeValue.start !=
                                      double.parse(busState
                                          .journeyFilterModel!.lowPrice))) ||
                              (busState.journeyFilterModel!.highPrice
                                      .isNotEmpty &&
                                  (state.currentRangeValue.end !=
                                      double.parse(busState
                                          .journeyFilterModel!.highPrice))))))
                    Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                          color: AppColors.red, shape: BoxShape.circle),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showFilterDetails(
      {required BuildContext context, required FilterState state}) {
    final filterBloc = context.read<FilterBloc>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: (busState.journeyFilterModel != null)
          ? Padding(
              padding: EdgeInsets.fromLTRB(16, size.width * 0.1, 16, 16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                  text: AppLocalizations.of(context)!.filter,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge),
                              InkWell(
                                  onTap: () {
                                    busBloc.add(GetFilterBusesEvent());
                                    // Navigator.pop(context);
                                    filterBloc.add(ShowFilterDetailsEvent(
                                        showFilterDetails: false));
                                  },
                                  child: const Icon(Icons.cancel_outlined))
                            ],
                          ),
                          SizedBox(height: size.width * 0.03),
                          MyText(
                              text: AppLocalizations.of(context)!.seatType,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          ListView.separated(
                            itemCount:
                                busState.journeyFilterModel!.seatType.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final seat = busState.journeyFilterModel!.seatType
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    if (state.filterSeatType.contains(seat)) {
                                      state.filterSeatType.removeWhere(
                                          (element) => element == seat);
                                    } else {
                                      state.filterSeatType.add(seat);
                                    }
                                    filterBloc.add(FilterSeatUpdateEvent(
                                        seatType: state.filterSeatType));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.width * 0.05,
                                        width: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all()),
                                        child: Center(
                                          child: (state.filterSeatType
                                                      .contains(seat))
                                              ? Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      MyText(
                                          text: seat,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: size.width * 0.03);
                            },
                          ),
                          SizedBox(height: size.width * 0.03),
                          MyText(
                              text: AppLocalizations.of(context)!.busType,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          ListView.separated(
                            itemCount:
                                busState.journeyFilterModel!.busType.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final busType = busState
                                  .journeyFilterModel!.busType
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    filterBloc.add(FilterBusTypeUpdateEvent(
                                        busType: busType));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.width * 0.05,
                                        width: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all()),
                                        child: Center(
                                          child: (state.filterBusType
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains((busType == 'Ac')
                                                      ? '1'
                                                      : '0'))
                                              ? Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      MyText(
                                          text: busType,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: size.width * 0.03);
                            },
                          ),
                          SizedBox(height: size.width * 0.03),
                          MyText(
                              text: AppLocalizations.of(context)!.busPartners,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          ListView.separated(
                            itemCount: busState
                                .journeyFilterModel!.busCompanies.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final busCompany = busState
                                  .journeyFilterModel!.busCompanies
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    filterBloc.add(FilterBusPartnerUpdateEvent(
                                        busPartner: busCompany));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.width * 0.05,
                                        width: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all()),
                                        child: Center(
                                          child: (state.filterBusPartners
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(busCompany
                                                      .toString()
                                                      .toLowerCase()))
                                              ? Container(
                                                  color: AppColors.primary,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      MyText(
                                          text: busCompany,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: size.width * 0.03);
                            },
                          ),
                          SizedBox(height: size.width * 0.03),
                          MyText(
                              text: AppLocalizations.of(context)!.priceRange,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                  text:
                                      '${AppLocalizations.of(context)!.min} ${state.currentRangeValue.start.toStringAsFixed(0)}'),
                              MyText(
                                  text:
                                      '${AppLocalizations.of(context)!.max} ${state.currentRangeValue.end.toStringAsFixed(0)}'),
                            ],
                          ),
                          SizedBox(height: size.width * 0.01),
                          RangeSlider(
                            values: state.currentRangeValue,
                            min: double.parse(
                                busState.journeyFilterModel!.lowPrice.isNotEmpty
                                    ? busState.journeyFilterModel!.lowPrice
                                    : '${state.currentRangeValue.start}'),
                            max: double.parse(busState
                                    .journeyFilterModel!.highPrice.isNotEmpty
                                ? busState.journeyFilterModel!.highPrice
                                : '${state.currentRangeValue.end}'),
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              if (busState.journeyFilterModel != null &&
                                  busState.journeyFilterModel!.lowPrice
                                      .isNotEmpty &&
                                  busState.journeyFilterModel!.highPrice
                                      .isNotEmpty) {
                                filterBloc
                                    .add(RangeValueUpdateEvent(value: value));
                              }
                            },
                          ),
                          MyText(
                              text: AppLocalizations.of(context)!.amenties,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          ListView.separated(
                            itemCount:
                                busState.journeyFilterModel!.amenities.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final amenity = busState
                                  .journeyFilterModel!.amenities
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    filterBloc.add(FilterAmenitiesUpdateEvent(
                                        amenity: amenity.name));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.width * 0.05,
                                        width: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all()),
                                        child: Center(
                                          child: (state.filterAmenities
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(amenity.name
                                                      .toString()
                                                      .toLowerCase()))
                                              ? Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      MyText(
                                          text: amenity.name,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: size.width * 0.03);
                            },
                          ),
                          SizedBox(height: size.width * 0.03),
                          MyText(
                              text:
                                  AppLocalizations.of(context)!.boardingPoints,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          ListView.separated(
                            itemCount: busState
                                .journeyFilterModel!.boardingPoints.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final boarding = busState
                                  .journeyFilterModel!.boardingPoints
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    filterBloc.add(FilterBoardingUpdateEvent(
                                        boarding: boarding.landMark));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.width * 0.05,
                                        width: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all()),
                                        child: Center(
                                          child: (state.filterBordingLandmark
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(boarding.landMark
                                                      .toString()
                                                      .toLowerCase()))
                                              ? Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      MyText(
                                          text: boarding.landMark,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: size.width * 0.03);
                            },
                          ),
                          SizedBox(height: size.width * 0.03),
                          MyText(
                              text: AppLocalizations.of(context)!.dropPoints,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: size.width * 0.03),
                          ListView.separated(
                            itemCount:
                                busState.journeyFilterModel!.dropPoints.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final drop = busState
                                  .journeyFilterModel!.dropPoints
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    filterBloc.add(FilterStopUpdateEvent(
                                        stopPoint: drop.landMark));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.width * 0.05,
                                        width: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all()),
                                        child: Center(
                                          child: (state.filterDropLandmark
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(drop.landMark
                                                      .toString()
                                                      .toLowerCase()))
                                              ? Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      MyText(
                                          text: drop.landMark,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: size.width * 0.03);
                            },
                          ),
                          SizedBox(height: size.width * 0.03),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.01),
                  const Divider(),
                  SizedBox(height: size.width * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        width: size.width * 0.4,
                        isBorder: true,
                        borderRadius: 5,
                        buttonColor: Theme.of(context).scaffoldBackgroundColor,
                        textColor: Theme.of(context).primaryColor,
                        textSize: 15,
                        buttonName: AppLocalizations.of(context)!.clearFilter,
                        onTap: () {
                          state.filterBusPartners.clear();
                          state.filterBusType.clear();
                          state.filterSeatType.clear();
                          state.filterAmenities.clear();
                          state.filterBordingLandmark.clear();
                          state.filterDropLandmark.clear();
                          if (busState.journeyFilterModel != null &&
                              busState
                                  .journeyFilterModel!.lowPrice.isNotEmpty &&
                              busState
                                  .journeyFilterModel!.highPrice.isNotEmpty) {
                            filterBloc.add(RangeValueUpdateEvent(
                                value: RangeValues(
                                    double.parse(
                                        busState.journeyFilterModel!.lowPrice),
                                    double.parse(busState
                                        .journeyFilterModel!.highPrice))));
                          }
                          busBloc.add(GetBusListEvent(
                            fromId: busState.fromId,
                            toId: busState.toId,
                            date: busState.selectedDate,
                            page: 1,
                          ));
                          // Navigator.pop(context);
                          filterBloc.add(
                              ShowFilterDetailsEvent(showFilterDetails: false));
                        },
                      ),
                      CustomButton(
                        width: size.width * 0.4,
                        borderRadius: 5,
                        textSize: 18,
                        buttonName: AppLocalizations.of(context)!.apply,
                        onTap: () {
                          busBloc.add(GetFilterBusesEvent(
                              filterAmenities: state.filterAmenities,
                              filterBordingLandmark:
                                  state.filterBordingLandmark,
                              filterDropLandmark: state.filterDropLandmark,
                              filterBusPartners: state.filterBusPartners,
                              filterBusType: state.filterBusType,
                              filterSeatType: state.filterSeatType,
                              currentRangeValue: state.currentRangeValue));
                          filterBloc.add(
                              ShowFilterDetailsEvent(showFilterDetails: false));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * 0.01),
                  const Divider(),
                  SizedBox(height: size.width * 0.03),
                ],
              ),
            )
          : SizedBox(
              child: Center(
                  child: MyText(
                      text: AppLocalizations.of(context)!.noFiltersAvailable)),
            ),
    );
  }
}
