import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/passenger_model.dart';

class BookingApi {
  Future bookingApi(
      {required String promoCode,
      required String journeyId,
      required String userId,
      required String boardingId,
      required String dropId,
      required String ticketFare,
      required String mobile,
      required String email,
      required List<Passenger> passengers}) async {
    try {
      final token = await AppSharedPreference.getToken();
      printWrapped('============== ${jsonEncode(passengers)}');
      Response response = await DioProviderImpl().post(ApiEndpoints.makeBooking,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            "promo_code": promoCode,
            "journey_id": journeyId,
            "user_id": userId,
            "boarding_id": boardingId,
            "drop_id": dropId,
            "ticket_fare": ticketFare,
            "mobile": mobile,
            "email": email,
            "passenger": jsonEncode(passengers)
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future paymentGatewaysApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl()
          .get(ApiEndpoints.paymentGatewayList, headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      });
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future bookTicketsFromWallet(
      {required String totalAmount, required String journeyUserId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl()
          .post('${ApiEndpoints.bookTicketsFromWallet}$journeyUserId', body: {
        "total_fare": totalAmount
      }, headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      });
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future promoApi({
    required String promoCode,
    required String boardingId,
    required String ticketFare,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(ApiEndpoints.promo,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            "promo_code": promoCode,
            "boarding_id": boardingId,
            "ticket_fare": ticketFare,
          }));
      debugPrint('Promo API response: $response');
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future cancelPaymentApi({
    required String journeyId,
    required String userId,
    required String ticketNumber,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.cancelPayment,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            "journey_id": journeyId,
            "user_id": userId,
            "ticket_number": ticketNumber
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
