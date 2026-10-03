part of 'filter_bloc.dart';

abstract class FilterEvent {}

class BusUpdateEvent extends FilterEvent {}

class GetDirectionEvent extends FilterEvent {}

class RangeValueUpdateEvent extends FilterEvent {
  final RangeValues value;

  RangeValueUpdateEvent({required this.value});
}

class FilterSeatUpdateEvent extends FilterEvent {
  final List<String> seatType;

  FilterSeatUpdateEvent({required this.seatType});
}

class FilterBusTypeUpdateEvent extends FilterEvent {
  final String busType;

  FilterBusTypeUpdateEvent({required this.busType});
}

class FilterBusPartnerUpdateEvent extends FilterEvent {
  final String busPartner;

  FilterBusPartnerUpdateEvent({required this.busPartner});
}

class FilterAmenitiesUpdateEvent extends FilterEvent {
  final String amenity;

  FilterAmenitiesUpdateEvent({required this.amenity});
}

class FilterBoardingUpdateEvent extends FilterEvent {
  final String boarding;

  FilterBoardingUpdateEvent({required this.boarding});
}

class FilterStopUpdateEvent extends FilterEvent {
  final String stopPoint;

  FilterStopUpdateEvent({required this.stopPoint});
}

class FilterInitEvent extends FilterEvent {
  final JourneyFilterModel? journeyFilter;

  FilterInitEvent({this.journeyFilter});
}

class ShowFilterDetailsEvent extends FilterEvent {
  final bool showFilterDetails;

  ShowFilterDetailsEvent({required this.showFilterDetails});
}
