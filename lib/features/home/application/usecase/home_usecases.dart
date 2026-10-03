import 'package:bus_booking/features/home/domain/models/popular_routes_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/search_places_model.dart';
import '../../domain/models/user_details_model.dart';
import '../../domain/repositories/home_repo.dart';

class HomeUsecase {
  final HomeRepository _homeRepository;

  const HomeUsecase(this._homeRepository);

  Future<Either<Failure, UserDetailResponseModel>> userDetails(
      {String? requestId}) async {
    return _homeRepository.getUserDetails(requestId: requestId);
  }

  Future<Either<Failure, SearchPlacesModel>> getSearchPlaces(
      {String? search}) async {
    return _homeRepository.getSearchPlaces(search: search);
  }

  Future<Either<Failure, PopularRoutesModel>> getRecentRoutes() async {
    return _homeRepository.getPopularRoutes();
  }
}
