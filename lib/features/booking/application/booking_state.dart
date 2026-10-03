part of 'booking_bloc.dart';

enum BookingStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  paymentSuccess,
  paymentFailure,
  paymentTimeExpired,
  showJourneyDetails,
  showCancelPayment,
  bookingSuccess,
  genderChange,
  promoRemove
}


class BookingState extends Equatable {
  final BookingStatus status;
  final String textDirection;
  final String languageCode;
  final String totalAmount;
  final bool isLoading;
  final bool promoLoading;
  final bool loadMore;
  final PassengerDetailsPageArguments? lastPassengerArgs;
  final PromoModel? promoCodeResponse;
  final List<PaymentGateway> paymentGatewaysList;
  final Duration timerDuration;
  final int? choosenPaymentIndex;
  final bool isWalletChoose;
  final TicketBookingModel? bookingData;

  const BookingState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.totalAmount,
    required this.isLoading,
    required this.promoLoading,
    required this.loadMore,
    required this.lastPassengerArgs,
    required this.promoCodeResponse,
    required this.paymentGatewaysList,
    required this.timerDuration,
    required this.choosenPaymentIndex,
    required this.bookingData,
    required this.isWalletChoose,
  });

  static BookingState initial() => const BookingState(
        status: BookingStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        totalAmount: '',
        isLoading: false,
        promoLoading: false,
        loadMore: false,
        lastPassengerArgs: null,
        promoCodeResponse: null,
        paymentGatewaysList: [],
        timerDuration: Duration(),
        choosenPaymentIndex: null,
        bookingData: null,
        isWalletChoose: false,
      );

  BookingState copyWith({
    BookingStatus? status,
    String? textDirection,
    String? languageCode,
    String? totalAmount,
    bool? isLoading,
    bool? promoLoading,
    bool? loadMore,
    PassengerDetailsPageArguments? lastPassengerArgs,
    PromoModel? promoCodeResponse,
    List<PaymentGateway>? paymentGatewaysList,
    Duration? timerDuration,
    int? choosenPaymentIndex,
    TicketBookingModel? bookingData,
    bool? isWalletChoose,
  }) =>
      BookingState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        totalAmount: totalAmount ?? this.totalAmount,
        isLoading: isLoading ?? this.isLoading,
        promoLoading: promoLoading ?? this.promoLoading,
        loadMore: loadMore ?? this.loadMore,
        lastPassengerArgs: lastPassengerArgs ?? this.lastPassengerArgs,
        promoCodeResponse: (status == BookingStatus.promoRemove) ? promoCodeResponse : promoCodeResponse ?? this.promoCodeResponse,
        paymentGatewaysList: paymentGatewaysList ?? this.paymentGatewaysList,
        timerDuration: timerDuration ?? this.timerDuration,
        choosenPaymentIndex: choosenPaymentIndex ?? this.choosenPaymentIndex,
        bookingData: bookingData ?? this.bookingData,
        isWalletChoose: isWalletChoose ?? this.isWalletChoose,
      );

  @override
  List get props => [
    status,
    textDirection,
    languageCode,
    totalAmount,
    isLoading,
    promoLoading,
    loadMore,
    paymentGatewaysList.map((e)=>e).hashCode,
    timerDuration,
    choosenPaymentIndex,
    lastPassengerArgs,
    promoCodeResponse,
    bookingData,
    isWalletChoose
  ];    
}
