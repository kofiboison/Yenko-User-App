import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../domain/models/journey_filter_model.dart';

part 'filter_event.dart';
part 'filter_state.dart';


class FilterBloc extends Bloc<FilterEvent, FilterState> {
  
  FilterBloc() : super(FilterState.initial()) {
    // update
    on<BusUpdateEvent>((event, emit) => emit(state));
    on<FilterInitEvent>(filterInit);
    on<GetDirectionEvent>(getDirection);
    on<RangeValueUpdateEvent>(updateRange);
    on<FilterSeatUpdateEvent>(seatUpdate);
    on<FilterBusTypeUpdateEvent>(busTypeUpdate);
    on<FilterBusPartnerUpdateEvent>(busPartnerUpdate);
    on<FilterAmenitiesUpdateEvent>(amenityUpdate);
    on<FilterBoardingUpdateEvent>(boardingUpdate);
    on<FilterStopUpdateEvent>(stopUpdate);
    on<ShowFilterDetailsEvent>(showFilterDetails);

  }

  Future<void> getDirection(
      GetDirectionEvent event, Emitter<FilterState> emit) async {
    emit(state.copyWith(
    textDirection: await AppSharedPreference.getLanguageDirection()));
    emit(state.copyWith(status: FilterStatus.update));
  }
  
  Future<void> filterInit(FilterInitEvent event, Emitter<FilterState> emit)async{
    if (event.journeyFilter!=null&&event.journeyFilter!.lowPrice.isNotEmpty &&
        event.journeyFilter!.highPrice.isNotEmpty) {
      emit(state.copyWith(
      currentRangeValue : RangeValues(
          double.parse(event.journeyFilter!.lowPrice),
          double.parse(event.journeyFilter!.highPrice))
      ));    
    }else{
      emit(state.copyWith(
      currentRangeValue : const RangeValues(100, 5100)
      )); 
    }
  }

  Future<void> updateRange(RangeValueUpdateEvent event, Emitter<FilterState> emit)async{
    emit(state.copyWith(currentRangeValue: event.value));
  }

  Future<void> seatUpdate(FilterSeatUpdateEvent event, Emitter<FilterState> emit)async{
    emit(state.copyWith(filterSeatType: event.seatType));
  }

  Future<void> busTypeUpdate(FilterBusTypeUpdateEvent event, Emitter<FilterState> emit)async{
    if (event.busType == 'Ac' &&
        state.filterBusType.contains('1')) {
      state.filterBusType.removeWhere(
          (element) => element == '1');
    } else if (event.busType == 'Non-Ac' &&
        state.filterBusType.contains('0')) {
      state.filterBusType.removeWhere(
          (element) => element == '0');
    } else {
      if (event.busType == 'Ac') {
        state.filterBusType.add('1');
      } else if (event.busType == 'Non-Ac') {
        state.filterBusType.add('0');
      }
    }
    emit(state.copyWith(filterBusType: state.filterBusType, status: FilterStatus.update));
  }

  Future<void> busPartnerUpdate(FilterBusPartnerUpdateEvent event, Emitter<FilterState> emit)async{
    List<String> fPartners = state.filterBusPartners;
    if (fPartners
        .contains(event.busPartner)) {
      fPartners.removeWhere(
          (element) =>
              element == event.busPartner);
    } else {
      fPartners
          .add(event.busPartner);
    }
    emit(state.copyWith(filterBusPartners: List.from(fPartners)));
  }

  Future<void> amenityUpdate(FilterAmenitiesUpdateEvent event, Emitter<FilterState> emit)async{
    if (state.filterAmenities
        .contains(event.amenity)) {
      state.filterAmenities.removeWhere(
          (element) =>
              element == event.amenity);
    } else {
      state.filterAmenities
          .add(event.amenity);
    }
    emit(state.copyWith(filterAmenities: state.filterAmenities));
  }

  Future<void> boardingUpdate(FilterBoardingUpdateEvent event, Emitter<FilterState> emit)async{
    if (state.filterBordingLandmark
        .contains(event.boarding)) {
      state.filterBordingLandmark
          .removeWhere((element) =>
              element == event.boarding);
    } else {
      state.filterBordingLandmark
          .add(event.boarding);
    }
    emit(state.copyWith(filterBordingLandmark: state.filterBordingLandmark));
  }

  Future<void> stopUpdate(FilterStopUpdateEvent event, Emitter<FilterState> emit)async{
    if (state.filterDropLandmark
        .contains(event.stopPoint)) {
      state.filterDropLandmark.removeWhere(
          (element) =>
              element == event.stopPoint);
    } else {
      state.filterDropLandmark
          .add(event.stopPoint);
    }
    emit(state.copyWith(filterDropLandmark: state.filterDropLandmark));
  }

  Future<void> showFilterDetails(ShowFilterDetailsEvent event, Emitter<FilterState> emit)async{
    emit(state.copyWith(showFilterDetails: event.showFilterDetails));
  }
  
}
