import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../../domain/models/passenger_model.dart';
import '../../domain/models/promo_model.dart';
import '../../domain/models/ticket_booking_model.dart';
import '../../domain/repositories/booking_repo.dart';

class BookingUsecase {
  final BookingRepository _bookingRepository;

  const BookingUsecase(this._bookingRepository);

  Future<Either<Failure, TicketBookingModel>> bookingApi(
      {required String promoCode,
      required String journeyId,
      required String userId,
      required String boardingId,
      required String dropId,
      required String ticketFare,
      required String mobile,
      required String email,
      required List<Passenger> passengers}) async {
    return _bookingRepository.bookingApi(
        promoCode: promoCode,
        journeyId: journeyId,
        userId: userId,
        boardingId: boardingId,
        dropId: dropId,
        ticketFare: ticketFare,
        mobile: mobile,
        email: email,
        passengers: passengers);
  }

  Future<Either<Failure, dynamic>> bookTicketsFromWallet(
      {required String totalAmount, required String journeyUserId}) async {
    return _bookingRepository.bookTicketsFromWallet(
        totalAmount: totalAmount, journeyUserId: journeyUserId);
  }

  Future<Either<Failure, PromoModel>> promoApi({
    required String promoCode,
    required String boardingId,
    required String ticketFare,
  }) async {
    return _bookingRepository.promoApi(
        promoCode: promoCode, boardingId: boardingId, ticketFare: ticketFare);
  }

  Future<Either<Failure, dynamic>> cancelPaymentApi({
    required String journeyId,
    required String userId,
    required String ticketNumber,
  }) async {
    return _bookingRepository.cancelPaymentApi(
        journeyId: journeyId, userId: userId, ticketNumber: ticketNumber);
  }

  Future<Either<Failure, dynamic>> paymentGateways() async {
    return _bookingRepository.paymentGateways();
  }
}
