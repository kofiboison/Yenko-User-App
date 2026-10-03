import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';

class BusApi {

  Future getBusList({
    required String fromCityId,
    required String toCityId,
    required String date,
    required int page,
    List? seatType,
    List? boardingPoints,
    List? dropPoints,
    List? busType,
    List? amenities,
    List? busPartners,
    String? maxPrice,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.getBusList,
        queryParams: {
          "from": fromCityId,
          "to": toCityId,
          "date": date,
          "page": page,
          if (seatType != null && seatType.isNotEmpty) "seat_type[]": seatType,
          if (busType != null && busType.isNotEmpty) "bus_type[]": busType,
          if (amenities != null && amenities.isNotEmpty)
            "amenities[]": amenities,
          if (boardingPoints != null && boardingPoints.isNotEmpty)
            "boarding_points[]": boardingPoints,
          if (dropPoints != null && dropPoints.isNotEmpty)
            "stop_points[]": dropPoints,
          if (busPartners != null && busPartners.isNotEmpty)
            "buses[]": busPartners,
          if (maxPrice != null && maxPrice.isNotEmpty) "range": maxPrice
        },
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getBusSeatDetails({required String journeyId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.getBusSeatDetailes,
        queryParams: {"journey_id": journeyId},
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }


  Future journeyFilterApi(
      {required String fromCityId, required String toCityId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl()
          .get(ApiEndpoints.journeyFilter, queryParams: {
        'from_city_id': fromCityId,
        'to_city_id': toCityId
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
}
