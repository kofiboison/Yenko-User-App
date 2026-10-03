

import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../models/bus_list_model.dart';
import '../models/bus_seat_details_model.dart';
import '../models/journey_filter_model.dart';

abstract class BusRepository {

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
  });

  Future<Either<Failure, BusSeatDetailModel>> getBusSeatDetails(
      {required String journeyId});


  Future<Either<Failure, JourneyFilterModel>> journeyFilters(
      {required String fromCityId, required String toCityId});
}
