part of 'bus_bloc.dart';

abstract class BusEvent {}

class BusUpdateEvent extends BusEvent {}

class GetDirectionEvent extends BusEvent {}


class SearchBusInitEvent extends BusEvent {
  final SearchBusPageArguments arg;

  SearchBusInitEvent({required this.arg});
}

class SeatPageInitEvent extends BusEvent {
  final SelectSeatPageArguments arg;

  SeatPageInitEvent({required this.arg});
}

class GetFilterBusesEvent extends BusEvent {
  final RangeValues? currentRangeValue;
  final List<String>? filterSeatType;
  final List<String>? filterBusType;
  final List<String>? filterBusPartners;
  final List<String>? filterAmenities;
  final List<String>? filterBordingLandmark;
  final List<String>? filterDropLandmark;

  GetFilterBusesEvent({ this.currentRangeValue,  this.filterSeatType,  this.filterBusType,  this.filterBusPartners,
    this.filterAmenities,  this.filterBordingLandmark,  this.filterDropLandmark});

}

class GetBusListEvent extends BusEvent {
  final String fromId;
  final String toId;
  final String date;
  final int page;
  final List? seatType;
  final List? boardingPoints;
  final List? dropPoints;
  final List? busType;
  final List? amenities;
  final List? busPartners;
  final String? maxPrice;

  GetBusListEvent({
    required this.fromId,
    required this.toId,
    required this.date,
    required this.page,
    this.seatType,
    this.boardingPoints,
    this.dropPoints,
    this.busType,
    this.amenities,
    this.busPartners,
    this.maxPrice,
  });
}


class JourneyFilterEvent extends BusEvent {
  final String fromCityId;
  final String toCityId;

  JourneyFilterEvent({required this.fromCityId, required this.toCityId});
}

class SearchBusPageScrollListenerEvent extends BusEvent {}

class DateUpdateEvent extends BusEvent {
  final String showDate;
  final String selectedDate;

  DateUpdateEvent({required this.showDate, required this.selectedDate});
}

class BoardingUpdateEvent extends BusEvent {
  final String pointId;
  final BoardingpointsData? boardingPoint;
  final StoppointsData? stopPoint;

  BoardingUpdateEvent({required this.pointId, this.boardingPoint, this.stopPoint});
}

class SelectSeatEvent extends BusEvent {
  final String seatNo;
  final SeatLayoutData seat;
  final int maxSeatsCanBook;

  SelectSeatEvent({required this.seatNo, required this.seat,required this.maxSeatsCanBook});
}
