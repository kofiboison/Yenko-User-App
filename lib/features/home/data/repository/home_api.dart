import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';

class HomeApi {
  Future getUserDetailsApi({String? requestId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.userDetails,
        queryParams: (requestId != null) ? {"current_ride": requestId} : null,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getSearchPlaces({String? search}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.searchPlaces,
        queryParams: (search != null) ? {"search": search} : null,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // get popular routes
  Future getPopularRoutesApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.popularRoutes,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }


}
