import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../common/common.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/passenger_model.dart';
import '../../domain/models/promo_model.dart';
import '../../domain/models/ticket_booking_model.dart';
import '../../domain/repositories/booking_repo.dart';
import '../repository/booking_api.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApi _bookingApi;

  BookingRepositoryImpl(this._bookingApi);

  @override
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
    TicketBookingModel bookingResponse;
    try {
      Response response = await _bookingApi.bookingApi(
          promoCode: promoCode,
          journeyId: journeyId,
          userId: userId,
          boardingId: boardingId,
          dropId: dropId,
          ticketFare: ticketFare,
          mobile: mobile,
          email: email,
          passengers: passengers);
      printWrapped('Booking Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(
              message: 'logout', statusCode: response.statusCode));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          bookingResponse = TicketBookingModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      printWrapped(e.toString());
      return Left(InPutDataFailure(message: e.message));
    } catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(bookingResponse);
  }

  @override
  Future<Either<Failure, dynamic>> paymentGateways() async {
    dynamic paymentGatewayResponse;
    try {
      Response response = await _bookingApi.paymentGatewaysApi();
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(
              message: 'logout', statusCode: response.statusCode));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          paymentGatewayResponse = response.data["data"];
        }
      }
    } on FetchDataException catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      printWrapped(e.toString());
      return Left(InPutDataFailure(message: e.message));
    } catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(paymentGatewayResponse);
  }

  @override
  Future<Either<Failure, dynamic>> bookTicketsFromWallet(
      {required String totalAmount, required String journeyUserId}) async {
    dynamic bookingResponse;
    try {
      Response response = await _bookingApi.bookTicketsFromWallet(
          totalAmount: totalAmount, journeyUserId: journeyUserId);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(
              message: 'logout', statusCode: response.statusCode));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          bookingResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      printWrapped(e.toString());
      return Left(InPutDataFailure(message: e.message));
    } catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(bookingResponse);
  }

  @override
  Future<Either<Failure, PromoModel>> promoApi({
    required String promoCode,
    required String boardingId,
    required String ticketFare,
  }) async {
    PromoModel promoResponse;
    try {
      Response response = await _bookingApi.promoApi(
        promoCode: promoCode,
        boardingId: boardingId,
        ticketFare: ticketFare,
      );
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(
              message: 'logout', statusCode: response.statusCode));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          promoResponse = PromoModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      printWrapped(e.toString());
      return Left(InPutDataFailure(message: e.message));
    } catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(promoResponse);
  }

  @override
  Future<Either<Failure, dynamic>> cancelPaymentApi({
    required String journeyId,
    required String userId,
    required String ticketNumber,
  }) async {
    dynamic paymentResponse;
    try {
      Response response = await _bookingApi.cancelPaymentApi(
          journeyId: journeyId, userId: userId, ticketNumber: ticketNumber);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(
              message: 'logout', statusCode: response.statusCode));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          paymentResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      printWrapped(e.toString());
      return Left(InPutDataFailure(message: e.message));
    } catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(paymentResponse);
  }
}
