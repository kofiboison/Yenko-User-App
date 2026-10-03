part of 'booking_bloc.dart';

abstract class BookingEvent {}

class BookingUpdateEvent extends BookingEvent {}

class GetDirectionEvent extends BookingEvent {}

class PassengerDetailsInitEvent extends BookingEvent {
  final PassengerDetailsPageArguments arg;

  PassengerDetailsInitEvent({required this.arg});
}

class ApplyPromoCodeEvent extends BookingEvent {
  final String promoCode;
  final String boardingId;
  final String ticketfare;
  ApplyPromoCodeEvent({required this.promoCode, required this.boardingId,required this.ticketfare});
}

class PaymentSuccessEvent extends BookingEvent {}

class PaymentFailureEvent extends BookingEvent {}

class PaymentDurationExpiredEvent extends BookingEvent {}

class PaymentDurationUpdateEvent extends BookingEvent {
  final Duration duration;

  PaymentDurationUpdateEvent({required this.duration});
}

class RemovePromoCodeEvent extends BookingEvent {}

class MakeBookingEvent extends BookingEvent {
  final String journeyId;
  final String userId;
  final String boardingId;
  final String dropId;
  final String ticketFare;
  final String mobile;
  final String email;
  final List<SeatLayoutData> selectedSeats;
  final String promoCode;
  final List<TextEditingController> passengerNameController;
  final List<TextEditingController> passengerAgeController;
  final List<String> selectedGender;

  MakeBookingEvent({
    required this.journeyId,
    required this.userId,
    required this.boardingId,
    required this.dropId,
    required this.ticketFare,
    required this.selectedSeats,
    required this.mobile,
    required this.email,
    required this.promoCode,
    required this.passengerNameController,
    required this.passengerAgeController,
    required this.selectedGender,
  });
}

class GetPaymentGatewaysEvent extends BookingEvent {}

class PaymentDurationEvent extends BookingEvent {
  final int duration;

  PaymentDurationEvent({required this.duration});
}

class ShowCancelPaymentEvent extends BookingEvent {}

class CancelPaymentEvent extends BookingEvent {
  final String journeyId;
  final String userId;
  final String ticketNumber;

  CancelPaymentEvent(
      {required this.journeyId,
      required this.userId,
      required this.ticketNumber});
}

class ShowJourneyDetailsEvent extends BookingEvent {}

class PaymentWebViewUrlEvent extends BookingEvent {
  final String url;
  final String userId;
  final String journeyId;
  final String dropId;
  final String boardingId;
  final String ticketNumber;
  final String currencySymbol;
  final String tripFare;

  PaymentWebViewUrlEvent(
      {required this.url,
      required this.userId,
      required this.journeyId,
      required this.dropId,
      required this.boardingId,
      required this.ticketNumber,
      required this.currencySymbol,
      required this.tripFare});
}

class BookTicketsFromWalletEvent extends BookingEvent {
  final String userId;
  final String totalAmount;

  BookTicketsFromWalletEvent({required this.userId, required this.totalAmount});
}

class PaymentIndexUpdateEvent extends BookingEvent {
  final int? choosenPayment;

  PaymentIndexUpdateEvent({required this.choosenPayment});
}

class GenderChangeEvent extends BookingEvent {}

class BookingWalletChooseEvent extends BookingEvent {}
