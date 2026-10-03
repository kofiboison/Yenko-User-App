
import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../models/passenger_model.dart';
import '../models/promo_model.dart';
import '../models/ticket_booking_model.dart';

abstract class BookingRepository {


  Future<Either<Failure, TicketBookingModel>> bookingApi(
      {required String promoCode,
      required String journeyId,
      required String userId,
      required String boardingId,
      required String dropId,
      required String ticketFare,
      required String mobile,
      required String email,
      required List<Passenger> passengers});

  
  Future<Either<Failure, dynamic>> paymentGateways();
  
  Future<Either<Failure, dynamic>> bookTicketsFromWallet(
      {required String totalAmount, required String journeyUserId});

  Future<Either<Failure, PromoModel>> promoApi({
    required String promoCode,
    required String boardingId,
    required String ticketFare,

  });

  Future<Either<Failure, dynamic>> cancelPaymentApi({
    required String journeyId,
    required String userId,
    required String ticketNumber,
  });    
}
