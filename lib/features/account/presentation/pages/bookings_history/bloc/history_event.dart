part of 'history_bloc.dart';

abstract class HistoryEvent {}

class HistoryGetDirectionEvent extends HistoryEvent {}

class HistoryUpdateEvent extends HistoryEvent {}

class LoadMoreUpdateEvent extends HistoryEvent {
  final bool loadMore;

  LoadMoreUpdateEvent({required this.loadMore});
}

class BookingsPageInitEvent extends HistoryEvent {
  final BookingsHistoryPageArguments arg;

  BookingsPageInitEvent({required this.arg});
}

class BookingTypeChangeEvent extends HistoryEvent {
  final int bookingTypeIndex;

  BookingTypeChangeEvent({required this.bookingTypeIndex});
}

class BoookingsGetEvent extends HistoryEvent {
  final String bookingFilter;
  final int? pageNumber;
  final int? bookingIndex;
  final bool? isFrom;

  BoookingsGetEvent(
      {required this.bookingFilter,
      this.pageNumber,
      this.bookingIndex,
      this.isFrom});
}

class BookingCancelEvent extends HistoryEvent {
  final String journeyId;
  final String userId;
  final String ticketNumber;

  BookingCancelEvent(
      {required this.journeyId,
      required this.userId,
      required this.ticketNumber});
}

class RatingsSelectEvent extends HistoryEvent {
  final int selectedIndex;

  RatingsSelectEvent({required this.selectedIndex});
}

class DownloadInvoiceEvent extends HistoryEvent {
  final String journeyId;

  DownloadInvoiceEvent({required this.journeyId});
}
