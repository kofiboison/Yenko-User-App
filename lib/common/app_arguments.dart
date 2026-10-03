import 'package:bus_booking/features/account/domain/models/booking_history_model.dart';

import '../features/account/domain/models/walletpage_model.dart';
import '../features/auth/domain/models/country_list_model.dart';
import '../features/booking/domain/models/ticket_booking_model.dart';
import '../features/bus/domain/models/bus_seat_details_model.dart';
import '../features/home/application/home_bloc.dart';
import '../features/home/domain/models/user_details_model.dart';

// Page arguments for data transfer

class VerifyArguments {
  final String mobileOrEmail;
  final String countryCode;
  final String countryFlag;
  final bool isLoginByEmail;
  final bool isOtpVerify;
  final bool userExist;
  final bool isDemoLogin;
  final List<Country> countryList;
  final int isRefferalEarnings;

  VerifyArguments({
    required this.mobileOrEmail,
    required this.countryCode,
    required this.countryFlag,
    required this.isLoginByEmail,
    required this.isOtpVerify,
    required this.userExist,
    required this.isDemoLogin,
    required this.countryList,
    required this.isRefferalEarnings,
  });
}

class RegisterPageArguments {
  final String emailOrMobile;
  final String contryCode;
  final String countryFlag;
  final bool isLoginByEmail;
  final List<Country> countryList;
  final int isRefferalEarnings;

  RegisterPageArguments({
    required this.isLoginByEmail,
    required this.contryCode,
    required this.countryFlag,
    required this.emailOrMobile,
    required this.countryList,
    required this.isRefferalEarnings,
  });
}

class ForgotPasswordPageArguments {
  final String emailOrMobile;
  final String contryCode;
  final String countryFlag;
  final bool isLoginByEmail;

  ForgotPasswordPageArguments({
    required this.isLoginByEmail,
    required this.contryCode,
    required this.countryFlag,
    required this.emailOrMobile,
  });
}

class UpdatePasswordPageArguments {
  final String emailOrMobile;
  final bool isLoginByEmail;

  UpdatePasswordPageArguments({
    required this.isLoginByEmail,
    required this.emailOrMobile,
  });
}

class AccountPageArguments {
  final UserDetail userData;

  AccountPageArguments({
    required this.userData,
  });
}

class ChooseLanguageArguments {
  final bool isInitialLanguageChange;

  ChooseLanguageArguments({required this.isInitialLanguageChange});
}

class WalletPageArguments {
  final UserDetail userData;

  WalletPageArguments({required this.userData});
}

class WalletPaymentPageArguments {
  final String from;
  final String userId;
  final String requestId;
  final String currencySymbol;
  final String money;
  final List<PaymentGateway> walletPaymentGatways;

  WalletPaymentPageArguments(
      {required this.walletPaymentGatways,
      required this.from,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}

class PaymentGateWayPageArguments {
  final String from;
  final String url;
  final String userId;
  final String requestId;
  final String currencySymbol;
  final String money;

  PaymentGateWayPageArguments(
      {required this.from,
      required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}

class ProfileEditPageArguments {
  final UserDetail? userData;

  ProfileEditPageArguments({required this.userData});
}

class ReferralArguments {
  final UserDetail userData;

  ReferralArguments({required this.userData});
}

class CardListPageArguments {
  final UserDetail userData;

  CardListPageArguments({required this.userData});
}

class AdminChatPageArguments {
  final UserDetail userData;

  AdminChatPageArguments({
    required this.userData,
  });
}

class FaqPageArguments {
  final UserDetail userData;

  FaqPageArguments({required this.userData});
}

class SearchPlacePageArguments {
  final bool isFromPickup;
  final HomeBloc homeBloc;

  SearchPlacePageArguments(
      {required this.isFromPickup, required this.homeBloc});
}

class SearchBusPageArguments {
  final DateTime selectDate;
  final String fromCity;
  final String fromId;
  final String toCity;
  final String toId;
  final String fromShortCode;
  final String toShortCode;
  final UserDetail userData;

  SearchBusPageArguments({
    required this.selectDate,
    required this.fromCity,
    required this.fromId,
    required this.toCity,
    required this.toId,
    required this.fromShortCode,
    required this.toShortCode,
    required this.userData,
  });
}

class ComplaintListPageArguments {
  final String? choosenHistoryId;

  ComplaintListPageArguments({
    this.choosenHistoryId,
  });
}

class SupportTicketPageArguments {
  final bool isFromRequest;
  final String requestId;

  SupportTicketPageArguments(
      {required this.isFromRequest, required this.requestId});
}

class ViewTicketPageArguments {
  final bool isViewTicketPage;
  final String ticketId;
  final String id;

  ViewTicketPageArguments(
      {required this.isViewTicketPage,
      required this.ticketId,
      required this.id});
}

class ComplaintPageArguments {
  final String title;
  final String complaintTitleId;
  final String? selectedHistoryId;

  ComplaintPageArguments(
      {required this.title,
      required this.complaintTitleId,
      this.selectedHistoryId});
}

class SelectSeatPageArguments {
  final String journeyId;
  final String selectedDate;
  final UserDetail userData;
  final String? fromShortCode;
  final String? toShortCode;

  SelectSeatPageArguments({
    required this.journeyId,
    required this.selectedDate,
    required this.userData,
    this.fromShortCode,
    this.toShortCode,
  });
}

class SelectBoardingPageArguments {
  final List<BoardingpointsData> boardingPoints;
  final List<StoppointsData> stopPoints;
  final List<SeatLayoutData> selectedSeats;
  final List<String> selectedSeatNo;
  final String startDate;
  final String endDate;
  final String journeyId;
  final UserDetail userData;

  SelectBoardingPageArguments(
      {required this.boardingPoints,
      required this.stopPoints,
      required this.selectedSeats,
      required this.selectedSeatNo,
      required this.startDate,
      required this.endDate,
      required this.journeyId,
      required this.userData});
}

class PaymentMethodArguments {
  final UserDetail userData;

  PaymentMethodArguments({required this.userData});
}

class PassengerDetailsPageArguments {
  final BoardingpointsData selectedBordingPoint;
  final StoppointsData selectedDropPoint;
  final List<SeatLayoutData> selectedSeats;
  final String journeyId;
  final UserDetail userData;
  final String startDate;
  final String endDate;

  PassengerDetailsPageArguments({
    required this.selectedBordingPoint,
    required this.selectedDropPoint,
    required this.selectedSeats,
    required this.journeyId,
    required this.userData,
    required this.startDate,
    required this.endDate,
  });
}

class MakePaymentPageArguments {
  final TicketBookingModel bookingData;
  final UserDetail userData;

  MakePaymentPageArguments({required this.bookingData, required this.userData});
}

class WithdrawPageArguments {
  final String minWalletAmount;
  final UserDetail userData;

  WithdrawPageArguments(
      {required this.minWalletAmount, required this.userData});
}

class RatingsPageArguments {
  final String journeryId;
  final String ticketNumber;
  final BookingHistoryData booking;
  final int? selectedRatingsIndex;

  RatingsPageArguments(
      {required this.journeryId,
      required this.ticketNumber,
      required this.booking,
      this.selectedRatingsIndex});
}

class LiveTrackingArguments {
  final List<BoardingpointsDatum> boardingPoints;
  final List<StoppointsDatum> stopPoints;
  final String journeyId;
  final String? boardingAddress;
  final String? dropAddress;
  final String? departureTime;
  final String? arraivalTime;
  final String? fromCity;
  final String? toCity;
  final String? arrivalTime;
  final String? departureDate;
  final String? arrivalDate;
  final String? ticketNumber;
  final String? passengerCount;
  final String? travelDuration;
  final String? polyline;

  LiveTrackingArguments({
    required this.boardingPoints,
    required this.stopPoints,
    required this.journeyId,
    this.boardingAddress,
    this.dropAddress,
    this.arraivalTime,
    this.fromCity,
    this.toCity,
    this.departureTime,
    this.arrivalTime,
    this.departureDate,
    this.arrivalDate,
    this.ticketNumber,
    this.passengerCount,
    this.travelDuration,
    this.polyline,
  });
}

class BookingsHistoryPageArguments {
  final UserDetail userData;

  BookingsHistoryPageArguments({required this.userData});
}
