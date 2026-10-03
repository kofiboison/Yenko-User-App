

import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../../domain/models/bus_list_model.dart';
import '../../domain/models/bus_seat_details_model.dart';
import '../../domain/models/journey_filter_model.dart';
import '../../domain/repositories/bus_repo.dart';

class BusUsecase {
  final BusRepository _busRepository;

  const BusUsecase(this._busRepository);

  
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
    return _busRepository.getBusList(
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
  }

  Future<Either<Failure, BusSeatDetailModel>> getBusSeatDetails(
      {required String journeyId}) async {
    return _busRepository.getBusSeatDetails(journeyId: journeyId);
  }
  
  Future<Either<Failure, JourneyFilterModel>> journeyFilters(
      {required String fromCityId, required String toCityId}) async {
    return _busRepository.journeyFilters(
        fromCityId: fromCityId, toCityId: toCityId);
  }
}
