import 'dart:async';
import 'package:bus_booking/core/utils/custom_loader.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../di/locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/bus_list_model.dart';
import '../../domain/models/bus_seat_details_model.dart';
import '../../domain/models/journey_filter_model.dart';
import '../usecase/bus_usecases.dart';

part 'bus_event.dart';
part 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  final formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  BusBloc() : super(BusState.initial()) {
    // update
    on<BusUpdateEvent>((event, emit) => emit(state));
    on<GetDirectionEvent>(getDirection);
    // bus list
    on<GetBusListEvent>(getBusesList);
    on<SeatPageInitEvent>(seatPageInit);
    on<SearchBusInitEvent>(searchBusInit);
    on<GetFilterBusesEvent>(filterBuses);
    on<JourneyFilterEvent>(journeyFilters);
    on<SearchBusPageScrollListenerEvent>(searchBusPageScrollListener);
    on<DateUpdateEvent>(dateUpdate);
    on<BoardingUpdateEvent>(pointUpdate);
    on<SelectSeatEvent>(selectSeats);

  }

  Future<void> getDirection(
      GetDirectionEvent event, Emitter<BusState> emit) async {
      emit(state.copyWith(status: BusStatus.loadingStart));
    final code = await AppSharedPreference.getSelectedLanguageCode();
    final direction = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(languageCode: code,textDirection: direction));
    emit(state.copyWith(status: BusStatus.loaded));
  }

  Future<void> searchBusInit(
      SearchBusInitEvent event, Emitter<BusState> emit) async {
    emit(state.copyWith(
      fromId:event.arg.fromId,
      toId : event.arg.toId,
      showDate : DateFormat('MMMM d').format(event.arg.selectDate).toString(),
      selectedDate :
          DateFormat('dd/MM/yyyy').format(event.arg.selectDate).toString(),
      allDates : await generateDates(int.parse(event.arg.userData.maxDays))));
    
    // scrollController.addListener(searchBusPageScrollListener);
    add(SearchBusPageScrollListenerEvent());
    add(GetBusListEvent(
        fromId: event.arg.fromId,
        toId: event.arg.toId,
        date: DateFormat('dd/MM/yyyy').format(event.arg.selectDate).toString(),
        page: 1));
    add(JourneyFilterEvent(
        fromCityId: event.arg.fromId, toCityId: event.arg.toId));
  }

  Future generateDates(int maxDays) async {
    final List<DateTime> dates = [];
    DateTime current = DateTime.now();
    DateTime end = DateTime.now().add(Duration(days: maxDays - 1));

    while (!current.isAfter(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  Future searchBusPageScrollListener(
    SearchBusPageScrollListenerEvent event, Emitter<BusState> emit
  )async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !state.isLoading &&
        !state.loadMore) {
      if (state.searchBusListPagination != null &&
          state.searchBusListPagination!.pagination.currentPage <
              state.searchBusListPagination!.pagination.totalPages) {
        emit(state.copyWith(loadMore:true));
        // add(BusUpdateEvent());
        add(GetBusListEvent(
            fromId: state.fromId,
            toId: state.toId,
            date: state.selectedDate,
            page: state.searchBusListPagination!.pagination.currentPage + 1));
      } else {
        if (state.searchBusListPagination!.pagination.currentPage ==
            state.searchBusListPagination!.pagination.totalPages) {
          emit(state.copyWith(loadMore:false));
          // add(BusUpdateEvent());
        }
      }
    }
    },);
    
  }

  Future<void> seatPageInit(
      SeatPageInitEvent event, Emitter<BusState> emit) async {
    emit(state.copyWith(status: BusStatus.loadingStart));
    final data = await serviceLocator<BusUsecase>()
        .getBusSeatDetails(journeyId: event.arg.journeyId);
    await data.fold(
      (error) {
        emit(state.copyWith(status: BusStatus.loadingStop));
        debugPrint(error.toString());
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BusStatus.logOut));
        } else {
          showToast(message: error.message.toString());
          emit(state.copyWith(status: BusStatus.update));
        }
      },
      (success) async {
        emit(state.copyWith(
          selectedBus: success.data,
          fromShortCode : event.arg.fromShortCode?.isNotEmpty == true
              ? event.arg.fromShortCode!
              : (success.data.fromCityShortCode.isNotEmpty
                  ? success.data.fromCityShortCode
                  : success.data.fromCity.split(' ').first.toUpperCase()),
          toShortCode : event.arg.toShortCode?.isNotEmpty == true
              ? event.arg.toShortCode!
              : (success.data.toCityShortCode.isNotEmpty
                  ? success.data.toCityShortCode
                  : success.data.toCity.split(' ').first.toUpperCase())        
          ));
          

          if (success.data.bus.data.seatLayout.data.isNotEmpty) {
            List<SeatLayoutData> lLeft = [];
            List<SeatLayoutData> lRight = [];
            List<SeatLayoutData> uLeft = [];
            List<SeatLayoutData> uRight = [];
            for (var i = 0;
                i < success.data.bus.data.seatLayout.data.length;
                i++) {
              if (success.data.bus.data.seatLayout.data[i].position == 'left') {
                if (success.data.bus.data.seatLayout.data[i].seatType !=
                    'driver') {
                  lLeft.add(success.data.bus.data.seatLayout.data[i]);
                } else {
                  emit(state.copyWith(isRightSideDriverSeat: false));
                }
              } else if (success.data.bus.data.seatLayout.data[i].position ==
                  'right') {
                if (success.data.bus.data.seatLayout.data[i].seatType !=
                    'driver') {
                  lRight.add(success.data.bus.data.seatLayout.data[i]);
                } else {
                  emit(state.copyWith(isRightSideDriverSeat: true));
                }
              } else if (success.data.bus.data.seatLayout.data[i].position ==
                  'upper_left') {
                uLeft.add(success.data.bus.data.seatLayout.data[i]);
              } else if (success.data.bus.data.seatLayout.data[i].position ==
                  'upper_right') {
                uRight.add(success.data.bus.data.seatLayout.data[i]);
              }
            }

            emit(state.copyWith(
              seatLayoutsLowerLeft: lLeft,
              seatLayoutsLowerRight: lRight,
              seatLayoutsUpperLeft: uLeft,
              seatLayoutsUpperRight: uRight
            ));
          }
        emit(state.copyWith(status: BusStatus.loadingStop));
      },
    );
  }

  Future<void> filterBuses(
      GetFilterBusesEvent event, Emitter<BusState> emit) async {
    add(GetBusListEvent(
      fromId: state.fromId,
      toId: state.toId,
      date: state.selectedDate,
      page: 1,
      seatType: event.filterSeatType,
      boardingPoints: event.filterBordingLandmark,
      dropPoints: event.filterDropLandmark,
      busType: event.filterBusType,
      amenities: event.filterAmenities,
      busPartners: event.filterBusPartners,
      maxPrice: event.currentRangeValue != null ? [
        event.currentRangeValue!.start.toStringAsFixed(0),
        event.currentRangeValue!.end.toStringAsFixed(0)
      ].toString() : null,
    ));
  }

  Future<void> getBusesList(
      GetBusListEvent event, Emitter<BusState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<BusUsecase>().getBusList(
      fromCityId: event.fromId,
      toCityId: event.toId,
      date: event.date,
      page: event.page,
      seatType: event.seatType,
      boardingPoints: event.boardingPoints,
      dropPoints: event.dropPoints,
      busType: event.busType,
      amenities: event.amenities,
      busPartners: event.busPartners,
      maxPrice: event.maxPrice,
    );
    await data.fold(
      (error) {
        emit(state.copyWith(isLoading: false));
        debugPrint(error.toString());
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BusStatus.logOut));
        } else {
          emit(state.copyWith(status: BusStatus.update));
        }
      },
      (success) async {
        List<BusData> list = state.busList;
        emit(state.copyWith(isLoading: false,loadMore: false));
        if (event.page == 1) {
          list = success.data;
        } else {
          list.addAll(success.data);
        }
        emit(state.copyWith(
          busList: list,
          searchBusListPagination: success.meta));
      },
    );
  }

Future<void> journeyFilters(
      JourneyFilterEvent event, Emitter<BusState> emit) async {
    emit(state.copyWith(status: BusStatus.loadingStart));
    final data = await serviceLocator<BusUsecase>()
        .journeyFilters(fromCityId: event.fromCityId, toCityId: event.toCityId);
    await data.fold(
      (error) {
        debugPrint(error.toString());
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BusStatus.logOut));
        } else {
          emit(state.copyWith(status: BusStatus.loadingStop));
        }
      },
      (success) async {
        emit(state.copyWith(status: BusStatus.loadingStop));
        emit(state.copyWith(status: BusStatus.loaded));
        emit(state.copyWith(journeyFilterModel: success));
      },
    );
  }

  Future<void> dateUpdate(DateUpdateEvent event, Emitter<BusState> emit)async{
    emit(state.copyWith(showDate: event.showDate,selectedDate: event.selectedDate));
  }

  Future<void> pointUpdate(BoardingUpdateEvent event, Emitter<BusState> emit)async{
    if(event.boardingPoint !=null){
      emit(state.copyWith(selectedBoardingPointId: event.pointId,selectedBordingPoint: event.boardingPoint));
    }
    if(event.stopPoint !=null){
      emit(state.copyWith(selectedDropPointId: event.pointId,selectedDropPoint: event.stopPoint));
    }
  }

  Future<void> selectSeats(SelectSeatEvent event, Emitter<BusState> emit)async{
    List<SeatLayoutData> eventSeats = List.of(state.selectedSeats);
    List<String> eventSeatNos = List.of(state.selectedSeatNo);

    if (!state.selectedSeatNo
        .contains(event.seatNo)) {
      if (state.selectedSeats.length <
          event.maxSeatsCanBook) {
        if (event.seat.isAvailable) {
          eventSeatNos.add(event.seatNo);
          eventSeats.add(event.seat);
        }
      } else {
        showToast(
            message:
                '${AppLocalizations.of(navigatorKey.currentState!.context)!.youCanBook} ${event.maxSeatsCanBook} ${AppLocalizations.of(navigatorKey.currentState!.context)!.seatsOnly}');
      }
    } else {
      eventSeatNos.remove(event.seatNo);
      eventSeats.remove(event.seat);
    }
    emit(state.copyWith(selectedSeatNo: eventSeatNos as List<String>?,selectedSeats: eventSeats as List<SeatLayoutData>?));
  }

}
