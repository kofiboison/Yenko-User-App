import 'package:bus_booking/features/home/domain/models/popular_routes_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/network.dart';
import '../models/search_places_model.dart';
import '../models/user_details_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserDetailResponseModel>> getUserDetails(
      {String? requestId});

  Future<Either<Failure, SearchPlacesModel>> getSearchPlaces({String? search});

  Future<Either<Failure, PopularRoutesModel>> getPopularRoutes();
}
