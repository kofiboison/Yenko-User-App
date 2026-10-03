import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/common.dart';
import '../../../core/utils/custom_loader.dart';
import '../../../core/utils/custom_snack_bar.dart';
import '../../../di/locator.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/domain/models/walletpage_model.dart';
import '../../bus/domain/models/bus_seat_details_model.dart';
import '../domain/models/passenger_model.dart';
import '../domain/models/promo_model.dart';
import '../domain/models/ticket_booking_model.dart';
import 'usecase/booking_usecases.dart';

part 'booking_event.dart';

part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final formKey = GlobalKey<FormState>();
  Timer? paymentTimer;
  StreamSubscription<DatabaseEvent>? paymentStream;
  String totalAmount = '';

  BookingBloc() : super(BookingState.initial()) {
    // update
    on<BookingUpdateEvent>(
        (event, emit) => emit(state.copyWith(status: BookingStatus.update)));
    on<GenderChangeEvent>((event, emit) =>
        emit(state.copyWith(status: BookingStatus.genderChange)));
    on<ShowJourneyDetailsEvent>((event, emit) =>
        emit(state.copyWith(status: BookingStatus.showJourneyDetails)));
    on<PaymentSuccessEvent>((event, emit) => emit(state.copyWith(
        status: BookingStatus.paymentSuccess, isLoading: false)));
    on<PaymentFailureEvent>((event, emit) => emit(state.copyWith(
        status: BookingStatus.paymentFailure, isLoading: false)));
    on<ShowCancelPaymentEvent>((event, emit) =>
        emit(state.copyWith(status: BookingStatus.showCancelPayment)));
    on<PaymentIndexUpdateEvent>((event, emit) => emit(state.copyWith(
        choosenPaymentIndex: event.choosenPayment,
        isLoading: false,
        isWalletChoose: false)));
    on<BookingWalletChooseEvent>((event, emit) =>
        emit(state.copyWith(isWalletChoose: true, choosenPaymentIndex: null)));
    on<GetDirectionEvent>(getDirection);
    on<PaymentDurationExpiredEvent>((event, emit) => emit(state.copyWith(
        status: BookingStatus.paymentTimeExpired,
        timerDuration: const Duration(seconds: 0))));
    on<PaymentDurationUpdateEvent>(
        (event, emit) => emit(state.copyWith(timerDuration: event.duration)));
    on<PassengerDetailsInitEvent>(passengersInit);
    on<MakeBookingEvent>(bookTickets);
    on<GetPaymentGatewaysEvent>(getPaymentGateways);
    on<ApplyPromoCodeEvent>(_applyPromoCode);
    on<RemovePromoCodeEvent>(_removePromoCode);
    on<PaymentWebViewUrlEvent>(makePayment);
    on<CancelPaymentEvent>(cancelPayment);
    on<PaymentDurationEvent>(paymentDuration);
    on<BookTicketsFromWalletEvent>(bookTicketsFromWalletEvent);
  }

  Future<void> getDirection(
      GetDirectionEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(
      status: BookingStatus.loaded,
      languageCode: languageCode,
      textDirection: textDirection,
    ));
  }

  Future<void> passengersInit(
      PassengerDetailsInitEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(lastPassengerArgs: event.arg));

    if (event.arg.selectedSeats.isNotEmpty) {
      double amount = 0;
      for (var i = 0; i < event.arg.selectedSeats.length; i++) {
        amount += event.arg.selectedSeats[i].price;
      }
      emit(state.copyWith(totalAmount: amount.toStringAsFixed(2)));
    }
  }

  // Future<void> passengersInit(
  //     PassengerDetailsInitEvent event, Emitter<BookingState> emit) async {
  //   emit(state.copyWith(lastPassengerArgs: event.arg));
  //   if (event.arg.selectedSeats.isNotEmpty) {
  //     double amount = 0;
  //     for (var i = 0; i < event.arg.selectedSeats.length; i++) {
  //       amount += event.arg.selectedSeats[i].price;
  //     }

  //     if (state.promoCodeResponse != null) {
  //       final percent = state.promoCodeResponse!.data.discountPercent;
  //       final maxDiscount = state.promoCodeResponse!.data.maximumDiscountAmount;
  //       double discount = amount * percent / 100;
  //       if (discount > maxDiscount) {
  //         discount = maxDiscount.toDouble();
  //       }
  //       amount -= discount;
  //       if (amount < 0) amount = 0;
  //     }
  //     emit(state.copyWith(totalAmount: amount.toStringAsFixed(2)));
  //   }
  // }

  Future<void> bookTickets(
      MakeBookingEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true));
    List<Passenger> passenger = [];
    if (event.passengerNameController.isNotEmpty) {
      for (var i = 0; i < event.passengerNameController.length; i++) {
        passenger.add(Passenger(
            name: event.passengerNameController[i].text,
            age: event.passengerAgeController[i].text,
            gender: event.selectedGender[i],
            deckType: event.selectedSeats[i].deckType,
            seatNo: event.selectedSeats[i].seatNo));
      }
    }
    final data = await serviceLocator<BookingUsecase>().bookingApi(
        promoCode: event.promoCode,
        journeyId: event.journeyId,
        userId: event.userId,
        boardingId: event.boardingId,
        dropId: event.dropId,
        ticketFare: event.ticketFare,
        mobile: event.mobile,
        email: event.email,
        passengers: passenger);
    await data.fold(
      (error) {
        emit(state.copyWith(isLoading: false));
        debugPrint(error.toString());
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BookingStatus.logOut));
        }
      },
      (success) async {
        emit(state.copyWith(isLoading: false));
        if (success.success) {
          emit(state.copyWith(
              status: BookingStatus.bookingSuccess, bookingData: success));
        }
      },
    );
  }

  Future<void> getPaymentGateways(
      GetPaymentGatewaysEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<BookingUsecase>().paymentGateways();
    await data.fold(
      (error) {
        emit(state.copyWith(isLoading: false));
        debugPrint(error.toString());
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BookingStatus.logOut));
        }
      },
      (success) async {
        emit(state.copyWith(
            isLoading: false,
            paymentGatewaysList: List<PaymentGateway>.from(
                success.map((x) => PaymentGateway.fromJson(x)))));
      },
    );
  }

  Future<void> paymentDuration(
      PaymentDurationEvent event, Emitter<BookingState> emit) async {
    final countdownDuration = Duration(minutes: event.duration);
    Duration duration = countdownDuration;
    paymentTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final seconds = duration.inSeconds - 1;
      if (seconds <= 0) {
        paymentTimer?.cancel();
        paymentStream?.cancel();
        add(PaymentDurationExpiredEvent());
      } else {
        duration = Duration(seconds: seconds);
        add(PaymentDurationUpdateEvent(duration: duration));
      }
    });
  }

  Future<void> _applyPromoCode(
      ApplyPromoCodeEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(promoLoading: true));
    final data = await serviceLocator<BookingUsecase>().promoApi(
      promoCode: event.promoCode,
      boardingId: event.boardingId,
      ticketFare: event.ticketfare,
    );
    await data.fold(
      (error) {
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BookingStatus.logOut));
        } else {
          debugPrint(error.toString());
          showToast(message: error.message.toString());
          emit(state.copyWith(promoLoading: false));
        }
      },
      (success) async {
        emit(state.copyWith(promoLoading: false, promoCodeResponse: success));
        // Recalculate total with promo
        showToast(
            message: AppLocalizations.of(navigatorKey.currentState!.context)!
                .promoCodeApplied);
        if (state.lastPassengerArgs != null) {
          await passengersInit(
              PassengerDetailsInitEvent(arg: state.lastPassengerArgs!), emit);
        }
      },
    );
  }

  Future<void> _removePromoCode(
      RemovePromoCodeEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
        status: BookingStatus.promoRemove, promoCodeResponse: null));
    if (state.lastPassengerArgs != null) {
      await passengersInit(
          PassengerDetailsInitEvent(arg: state.lastPassengerArgs!), emit);
    }
  }

  paymentCheckStream({required String ticketId}) {
    if (paymentStream != null) paymentStream?.cancel();
    paymentStream = FirebaseDatabase.instance
        .ref('users/user_$ticketId')
        .onChildChanged
        .handleError((onError) {
      paymentStream?.cancel();
      printWrapped(onError.toString());
    }).listen((DatabaseEvent event) async {
      if (event.snapshot.key.toString() == 'is_paid') {
        if (event.snapshot.value.toString() == '1') {
          paymentTimer?.cancel();
          paymentTimer = null;
          paymentStream?.cancel();
          paymentStream = null;
          add(PaymentSuccessEvent());
        } else {
          add(PaymentFailureEvent());
        }
      }
    });
  }

  Future<void> makePayment(
      PaymentWebViewUrlEvent event, Emitter<BookingState> emit) async {
    String paymentUrl = '';
    paymentUrl =
        '${event.url}?amount=${event.tripFare}&currency=${event.currencySymbol}&user_id=${event.userId.toString()}&journey_id=${event.journeyId.toString()}&drop_id=${event.dropId}&boarding_id=${event.boardingId}&ticket_number=${event.ticketNumber}';

    final Uri uri = Uri.parse(paymentUrl);
    if (await canLaunchUrl(uri)) {
      emit(state.copyWith(isLoading: true));
      paymentCheckStream(ticketId: event.ticketNumber);
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
        const SnackBar(content: Text("Could not open payment page")),
      );
    }
  }

  Future<void> cancelPayment(
      CancelPaymentEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<BookingUsecase>().cancelPaymentApi(
        journeyId: event.journeyId,
        userId: event.userId,
        ticketNumber: event.ticketNumber);
    await data.fold(
      (error) {
        emit(state.copyWith(isLoading: false));
        debugPrint(error.toString());
        showToast(message: error.toString());
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BookingStatus.logOut));
        }
      },
      (success) async {
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  Future<void> bookTicketsFromWalletEvent(
      BookTicketsFromWalletEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<BookingUsecase>().bookTicketsFromWallet(
        journeyUserId: event.userId, totalAmount: event.totalAmount);
    await data.fold(
      (error) {
        emit(state.copyWith(isLoading: false));
        debugPrint(error.toString());
        showToast(message: error.toString());
        if (error.message == 'logout' ||
            error.statusCode == 401 ||
            error.statusCode == 400) {
          emit(state.copyWith(status: BookingStatus.logOut));
        }
      },
      (success) async {
        emit(state.copyWith(isLoading: false));
        if (success["success"]) {
          emit(state.copyWith(status: BookingStatus.paymentSuccess));
        } else {
          showToast(message: success["message"].toString());
        }
      },
    );
  }

  @override
  Future<void> close() {
    paymentTimer?.cancel();
    paymentTimer = null;
    paymentStream?.cancel();
    paymentStream = null;
    return super.close();
  }
}
