part of 'acc_bloc.dart';

abstract class AccEvent {}

class AccGetDirectionEvent extends AccEvent {}

class GetAppInfoEvent extends AccEvent {}

class AccUpdateEvent extends AccEvent {}

class AccGetUserDetailsEvent extends AccEvent {}

class AccountPageInitEvent extends AccEvent {
  final UserDetail userDetailData;
  AccountPageInitEvent({required this.userDetailData});
}

class LogoutEvent extends AccEvent {}

class DeleteAccountEvent extends AccEvent {}

class UserRatingsEvent extends AccEvent {
  final String ticketNumber;
  final String ratings;
  final String feedBack;
  final String journeyId;

  UserRatingsEvent(
      {required this.ticketNumber,
      required this.ratings,
      required this.feedBack,
      required this.journeyId});
}

class RatingsSelectEvent extends AccEvent {
  final int selectedIndex;

  RatingsSelectEvent({required this.selectedIndex});
}
