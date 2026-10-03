part of 'home_bloc.dart';

abstract class HomeEvent {}

class UpdateEvent extends HomeEvent {}

class GetDirectionEvent extends HomeEvent {}

class GetUserDetailsEvent extends HomeEvent {
  final bool? isFirstCall;

  GetUserDetailsEvent({this.isFirstCall});
}

class GetSearchPlacesEvent extends HomeEvent {
  final String? searchText;

  GetSearchPlacesEvent({this.searchText});
}

class SelectDateEvent extends HomeEvent {
  final DateTime selectedDate;

  SelectDateEvent({required this.selectedDate});
}

class ToggleNotificationsEvent extends HomeEvent {
  final bool value;
  ToggleNotificationsEvent(this.value);
}

class GetPopularRoutesEvent extends HomeEvent {}

class SelectPopularRouteEvent extends HomeEvent {
  final String fromCityName;
  final String toCityName;
  final String fromCityId;
  final String toCityId;

  SelectPopularRouteEvent({
    required this.fromCityName,
    required this.toCityName,
    required this.fromCityId,
    required this.toCityId,
  });
}

class PopularRoutesEvent extends HomeEvent {
  final PopularRouteData route;

  PopularRoutesEvent({required this.route});
}

class ReplaceBoardingDropEvent extends HomeEvent {}

class GetJourneyList extends HomeEvent {
  final String journeyId;

  GetJourneyList({required this.journeyId});
}

class StartLiveTrackingEvent extends HomeEvent {
  final String journeyId;
  StartLiveTrackingEvent(this.journeyId);
}

class _TrackingDataUpdatedEvent extends HomeEvent {
  final Map<String, dynamic> data;
  _TrackingDataUpdatedEvent(this.data);
}

class PolylineEvent extends HomeEvent {
  final String? encodedPolyline;
  PolylineEvent({this.encodedPolyline});
}

class UpdateVsyncEvent extends HomeEvent {
  final dynamic vsync;

  UpdateVsyncEvent({required this.vsync});
}

class UpdatePolyLineEvent extends HomeEvent {
  final String polyString;

  UpdatePolyLineEvent({required this.polyString});
}

class UpdateMarkersEvent extends HomeEvent {
  final List<LatLng> boardingLatLng;
  final List<LatLng> stopLatLng;

  UpdateMarkersEvent({required this.boardingLatLng,required this.stopLatLng});
}
