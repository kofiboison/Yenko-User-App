import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../common/common.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/bus_list_model.dart';
import '../../domain/models/bus_seat_details_model.dart';
import '../../domain/models/journey_filter_model.dart';
import '../../domain/repositories/bus_repo.dart';
import '../repository/bus_api.dart';

class BusRepositoryImpl implements BusRepository {
  final BusApi _busApi;

  BusRepositoryImpl(this._busApi);


  @override
  Future<Either<Failure, BusListModel>> getBusList({
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
    BusListModel searchResponse;
    try {
      Response response = await _busApi.getBusList(
          fromCityId: fromCityId,
          toCityId: toCityId,
          date: date,
          page: page,
          seatType: seatType,
          busType: busType,
          boardingPoints: boardingPoints,
          dropPoints: dropPoints,
          amenities: amenities,
          busPartners: busPartners,
          maxPrice: maxPrice);
      printWrapped('Bus List Response : ${response.data}');
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
          searchResponse = BusListModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } catch (e) {
      printWrapped(e.toString());
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(searchResponse);
  }

  @override
  Future<Either<Failure, BusSeatDetailModel>> getBusSeatDetails(
      {required String journeyId}) async {
    BusSeatDetailModel journeyResponse;
    try {
      Response response =
          await _busApi.getBusSeatDetails(journeyId: journeyId);
      printWrapped('Get Bus Response : ${response.data}');
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
          journeyResponse = BusSeatDetailModel.fromJson(response.data);
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

    return Right(journeyResponse);
  }


  @override
  Future<Either<Failure, JourneyFilterModel>> journeyFilters(
      {required String fromCityId, required String toCityId}) async {
    JourneyFilterModel filterResponse;
    try {
      Response response = await _busApi.journeyFilterApi(
          fromCityId: fromCityId, toCityId: toCityId);
      printWrapped('Filter Response : ${response.data}');
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
          filterResponse = JourneyFilterModel.fromJson(response.data);
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

    return Right(filterResponse);
  }
}
