part of 'home_bloc.dart';

abstract class HomeState {}

final class HomeInitialState extends HomeState {}

final class HomeUpdateState extends HomeState {}

final class LogoutState extends HomeState {}

final class HomeLoadingStartState extends HomeState {}

final class HomeLoadingStopState extends HomeState {}

final class UpdateZoneLocationState extends HomeState {}

final class PaymentPendingState extends HomeState {
  final TicketBookingModel bookingData;
  final UserDetail userData;

  PaymentPendingState({required this.bookingData, required this.userData});
}

final class SearchBusState extends HomeState {}

class LiveTrackingUpdatedState extends HomeState {
  final bool shouldEndTracking;

  LiveTrackingUpdatedState({
    required this.shouldEndTracking,
  });
}

class BusLocationUpdatedState extends HomeState {
  final LatLng busLocation;
  final double? heading;

  BusLocationUpdatedState({
    required this.busLocation,
    this.heading,
  });
}

class TripEndedState extends HomeState {}

class PolylineLoadedState extends HomeState {
  final Polyline polyline;
  final Set<Marker> markers;
  PolylineLoadedState({required this.polyline, required this.markers});
}

class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState({required this.error});
}
