import 'dart:convert';

BusListModel busListModelFromJson(String str) =>
    BusListModel.fromJson(json.decode(str));

class BusListModel {
  bool success;
  String message;
  List<BusData> data;
  SearchBusListPagination meta;

  BusListModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory BusListModel.fromJson(Map<String, dynamic> json) => BusListModel(
        success: json["success"],
        message: json["message"],
        data: List<BusData>.from(json["data"].map((x) => BusData.fromJson(x))),
        meta: SearchBusListPagination.fromJson(json["meta"]),
      );
}

class BusData {
  String id;
  String journeyNumber;
  String serviceLocationId;
  String fleetId;
  int isCompleted;
  dynamic completedAt;
  int isCancelled;
  dynamic cancelledAt;
  int isTripStart;
  dynamic startedAt;
  String depatureAt;
  String arrivedAt;
  String depatureAtDate;
  String arrivedAtDate;
  String depatureAtTime;
  String arrivedAtTime;
  double seaterPrice;
  double sleeperPrice;
  double semiSleeperPrice;
  double upperSeaterPrice;
  double upperSleeperPrice;
  double upperSemiSleeperPrice;
  String fromCityId;
  String toCityId;
  String fromCity;
  String toCity;
  String fromCityShortCode;
  String toCityShortCode;
  String busCompanyName;
  String rating;
  String noOfratings;
  int availableSeats;
  String currencySymbol;
  String duration;
  double lowPrice;
  int driverId;
  String driverName;
  int isTripStarted;
  String maximumNumberOfSeatsUserCanBook;
  bool upperDeckAvailable;
  BusDetail bus;
  Boardingpoints boardingpoints;
  Stoppoints stoppoints;
  String cancellationpolicy;

  BusData(
      {required this.id,
      required this.serviceLocationId,
      required this.fleetId,
      required this.isCompleted,
      required this.completedAt,
      required this.isTripStart,
      required this.startedAt,
      required this.depatureAt,
      required this.arrivedAt,
      required this.depatureAtDate,
      required this.arrivedAtDate,
      required this.depatureAtTime,
      required this.arrivedAtTime,
      required this.seaterPrice,
      required this.sleeperPrice,
      required this.semiSleeperPrice,
      required this.upperSeaterPrice,
      required this.upperSleeperPrice,
      required this.upperSemiSleeperPrice,
      required this.fromCityId,
      required this.toCityId,
      required this.fromCity,
      required this.toCity,
      required this.busCompanyName,
      required this.rating,
      required this.noOfratings,
      required this.availableSeats,
      required this.currencySymbol,
      required this.duration,
      required this.lowPrice,
      required this.isTripStarted,
      required this.maximumNumberOfSeatsUserCanBook,
      required this.upperDeckAvailable,
      required this.bus,
      required this.fromCityShortCode,
      required this.toCityShortCode,
      required this.boardingpoints,
      required this.stoppoints,
      required this.driverId,
      required this.driverName,
      required this.isCancelled,
      required this.journeyNumber,
      required this.cancelledAt,
      required this.cancellationpolicy});

  factory BusData.fromJson(Map<String, dynamic> json) => BusData(
        id: json["id"] ?? '',
        serviceLocationId: json["service_location_id"] ?? '',
        fleetId: json["fleet_id"] ?? '',
        isCompleted: json["is_completed"] ?? 0,
        completedAt: json["completed_at"] ?? '',
        isTripStart: json["is_trip_start"] ?? 0,
        startedAt: json["started_at"] ?? 0,
        depatureAt: json["depature_at"].toString(),
        arrivedAt: json["arrived_at"].toString(),
        depatureAtDate: json["depature_at_date"].toString(),
        arrivedAtDate: json["arrived_at_date"].toString(),
        depatureAtTime: json["depature_at_time"] ?? '',
        arrivedAtTime: json["arrived_at_time"] ?? '',
        seaterPrice: json["seater_price"]?.toDouble() ?? 0.0,
        sleeperPrice: json["sleeper_price"]?.toDouble() ?? 0.0,
        semiSleeperPrice: json["semi_sleeper_price"]?.toDouble() ?? 0.0,
        upperSeaterPrice: json["upper_seater_price"]?.toDouble() ?? 0.0,
        upperSleeperPrice: json["upper_sleeper_price"]?.toDouble() ?? 0.0,
        upperSemiSleeperPrice:
            json["upper_semi_sleeper_price"]?.toDouble() ?? 0.0,
        fromCityId: json["from_city_id"] ?? '',
        toCityId: json["to_city_id"] ?? '',
        fromCity: json["from_city"] ?? '',
        toCity: json["to_city"] ?? '',
        busCompanyName: json["bus_company_name"] ?? '',
        rating: json["rating"]?.toString() ?? '0',
        noOfratings: json["no_of_rating"]?.toString() ?? '0',
        availableSeats: json["available_seats"] ?? 0,
        currencySymbol: json["currency_symbol"] ?? '',
        duration: json["duration"] ?? '',
        lowPrice: json["low_price"]?.toDouble() ?? 0.0,
        isTripStarted: json["is_trip_started"] ?? 0,
        maximumNumberOfSeatsUserCanBook:
            json["maximum_number_of_seats_user_can_book"] ?? '',
        upperDeckAvailable: json["upper_deck_available"] ?? false,
        bus: BusDetail.fromJson(json["bus"]),
        fromCityShortCode: json["from_city_short_code"] ?? '',
        toCityShortCode: json["to_city_short_code"] ?? '',
        boardingpoints: Boardingpoints.fromJson(json["boardingpoints"]),
        stoppoints: Stoppoints.fromJson(json["stoppoints"]),
        driverId: json["driver_id"] ?? 0,
        driverName: json["driver_name"] ?? '',
        isCancelled: json["is_cancelled"] ?? 0,
        cancelledAt: json["cancelled_at"]?.toString() ?? '',
        journeyNumber: json["journey_number"]?.toString() ?? '',
        cancellationpolicy: json["cancellationPolicy"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_location_id": serviceLocationId,
        "fleet_id": fleetId,
        "is_completed": isCompleted,
        "completed_at": completedAt,
        "is_trip_start": isTripStart,
        "started_at": startedAt,
        "depature_at": depatureAt.toString(),
        "arrived_at": arrivedAt.toString(),
        "depature_at_date": depatureAtDate.toString(),
        "arrived_at_date": arrivedAtDate.toString(),
        "depature_at_time": depatureAtTime,
        "arrived_at_time": arrivedAtTime,
        "seater_price": seaterPrice,
        "sleeper_price": sleeperPrice,
        "semi_sleeper_price": semiSleeperPrice,
        "upper_seater_price": upperSeaterPrice,
        "upper_sleeper_price": upperSleeperPrice,
        "upper_semi_sleeper_price": upperSemiSleeperPrice,
        "from_city_id": fromCityId,
        "to_city_id": toCityId,
        "from_city": fromCity,
        "to_city": toCity,
        "bus_company_name": busCompanyName,
        "rating": rating,
        "available_seats": availableSeats,
        "currency_symbol": currencySymbol,
        "duration": duration,
        "low_price": lowPrice,
        "is_trip_started": isTripStarted,
        "maximum_number_of_seats_user_can_book":
            maximumNumberOfSeatsUserCanBook,
        "upper_deck_available": upperDeckAvailable,
        "bus": bus.toJson(),
      };
}

class BusDetail {
  BusDetailData data;

  BusDetail({
    required this.data,
  });

  factory BusDetail.fromJson(Map<String, dynamic> json) => BusDetail(
        data: BusDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class BusDetailData {
  String id;
  String ownerId;
  String brand;
  String image;
  String model;
  String licenseNumber;
  dynamic permissionNumber;
  int active;
  int leftColumns;
  int rightColumns;
  int leftRows;
  int rightRows;
  int upperLeftRows;
  int upperRightRows;
  int totalBackSeats;
  String seatType;
  dynamic busType;
  List<dynamic> layoutType;
  String isAcAvailable;
  List<String> busImage;
  Amenities? amenities;

  BusDetailData({
    required this.id,
    required this.ownerId,
    required this.brand,
    required this.image,
    required this.model,
    required this.licenseNumber,
    required this.permissionNumber,
    required this.active,
    required this.leftColumns,
    required this.rightColumns,
    required this.leftRows,
    required this.rightRows,
    required this.upperLeftRows,
    required this.upperRightRows,
    required this.totalBackSeats,
    required this.seatType,
    required this.busType,
    required this.layoutType,
    required this.isAcAvailable,
    required this.busImage,
    required this.amenities,
  });

  factory BusDetailData.fromJson(Map<String, dynamic> json) => BusDetailData(
        id: json["id"] ?? '',
        ownerId: json["owner_id"] ?? '',
        brand: json["brand"] ?? '',
        image: json["image"] ?? '',
        model: json["model"] ?? '',
        licenseNumber: json["license_number"] ?? '',
        permissionNumber: json["permission_number"] ?? '',
        active: json["active"] ?? 0,
        leftColumns: json["left_columns"] ?? 0,
        rightColumns: json["right_columns"] ?? 0,
        leftRows: json["left_rows"] ?? 0,
        rightRows: json["right_rows"] ?? 0,
        upperLeftRows: json["upper_left_rows"] ?? 0,
        upperRightRows: json["upper_right_rows"] ?? 0,
        totalBackSeats: json["total_back_seats"] ?? 0,
        seatType: json["seat_type"] ?? '',
        busType: json["bus_type"] ?? '',
        layoutType: List<dynamic>.from(json["layout_type"].map((x) => x)),
        isAcAvailable: json["is_ac_available"],
        busImage: List<String>.from(json["bus_image"].map((x) => x)),
        amenities: json["amenities"] != null
            ? Amenities.fromJson(json["amenities"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_id": ownerId,
        "brand": brand,
        "image": image,
        "model": model,
        "license_number": licenseNumber,
        "permission_number": permissionNumber,
        "active": active,
        "left_columns": leftColumns,
        "right_columns": rightColumns,
        "left_rows": leftRows,
        "right_rows": rightRows,
        "upper_left_rows": upperLeftRows,
        "upper_right_rows": upperRightRows,
        "total_back_seats": totalBackSeats,
        "seat_type": seatType,
        "bus_type": busType,
        "layout_type": List<dynamic>.from(layoutType.map((x) => x)),
        "is_ac_available": isAcAvailable,
        "bus_image": List<dynamic>.from(busImage.map((x) => x)),
        "amenities": amenities,
      };
}

class Amenities {
  List<AmenitiesDatum> data;

  Amenities({
    required this.data,
  });

  factory Amenities.fromJson(Map<String, dynamic> json) => Amenities(
        data: List<AmenitiesDatum>.from(
            json["data"].map((x) => AmenitiesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AmenitiesDatum {
  String id;
  String name;
  String icon;

  AmenitiesDatum({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory AmenitiesDatum.fromJson(Map<String, dynamic> json) => AmenitiesDatum(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}

class Boardingpoints {
  List<BoardingpointsDatum> data;

  Boardingpoints({
    required this.data,
  });

  factory Boardingpoints.fromJson(Map<String, dynamic> json) => Boardingpoints(
        data: List<BoardingpointsDatum>.from(
            json["data"].map((x) => BoardingpointsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BoardingpointsDatum {
  String boardingId;
  String boardingTime;
  String boardingDate;
  int arrivalStatus;
  String boardingPlace;
  String boardingLandmark;
  double boardingLat;
  double boardingLng;
  bool isTripStarted;

  BoardingpointsDatum({
    required this.boardingId,
    required this.boardingTime,
    required this.boardingDate,
    required this.arrivalStatus,
    required this.boardingPlace,
    required this.boardingLandmark,
    required this.boardingLat,
    required this.boardingLng,
    required this.isTripStarted,
  });

  factory BoardingpointsDatum.fromJson(Map<String, dynamic> json) =>
      BoardingpointsDatum(
        boardingId: json["boarding_id"] ?? '',
        boardingTime: json["boarding_time"] ?? '',
        boardingDate: json["boarding_date"] ?? '',
        arrivalStatus: json["arrival_status"] ?? 0,
        boardingPlace: json["boarding_place"] ?? '',
        boardingLandmark: json["boarding_landmark"] ?? '',
        boardingLat: json["boarding_lat"]?.toDouble() ?? 0.0,
        boardingLng: json["boarding_lng"]?.toDouble() ?? 0.0,
        isTripStarted: json["is_trip_started"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "boarding_id": boardingId,
        "boarding_time": boardingTime,
        "boarding_date": boardingDate,
        "arrival_status": arrivalStatus,
        "boarding_place": boardingPlace,
        "boarding_landmark": boardingLandmark,
        "boarding_lat": boardingLat,
        "boarding_lng": boardingLng,
        "is_trip_started": isTripStarted,
      };
}

class Stoppoints {
  List<StoppointsDatum> data;

  Stoppoints({
    required this.data,
  });

  factory Stoppoints.fromJson(Map<String, dynamic> json) => Stoppoints(
        data: List<StoppointsDatum>.from(
            json["data"].map((x) => StoppointsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StoppointsDatum {
  String id;
  String stopId;
  String stopTime;
  String stopDate;
  int arrivalStatus;
  String stopAddress;
  String stopLandmark;
  double stopLat;
  double stopLng;
  bool isTripStarted;

  StoppointsDatum({
    required this.id,
    required this.stopId,
    required this.stopTime,
    required this.stopDate,
    required this.arrivalStatus,
    required this.stopAddress,
    required this.stopLandmark,
    required this.stopLat,
    required this.stopLng,
    required this.isTripStarted,
  });

  factory StoppointsDatum.fromJson(Map<String, dynamic> json) =>
      StoppointsDatum(
        id: json["id"] ?? '',
        stopId: json["stop_id"] ?? '',
        stopTime: json["stop_time"] ?? '',
        stopDate: json["stop_date"] ?? '',
        arrivalStatus: json["arrival_status"] ?? 0,
        stopAddress: json["stop_address"] ?? '',
        stopLandmark: json["stop_landmark"] ?? '',
        stopLat: json["stop_lat"]?.toDouble() ?? 0.0,
        stopLng: json["stop_lng"]?.toDouble() ?? 0.0,
        isTripStarted: json["is_trip_started"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stop_id": stopId,
        "stop_time": stopTime,
        "stop_date": stopDate,
        "arrival_status": arrivalStatus,
        "stop_address": stopAddress,
        "stop_landmark": stopLandmark,
        "stop_lat": stopLat,
        "stop_lng": stopLng,
        "is_trip_started": isTripStarted,
      };
}

class SearchBusListPagination {
  Pagination pagination;

  SearchBusListPagination({
    required this.pagination,
  });

  factory SearchBusListPagination.fromJson(Map<String, dynamic> json) =>
      SearchBusListPagination(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;
  Links links;

  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.links,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
        links: Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "current_page": currentPage,
        "total_pages": totalPages,
        "links": links.toJson(),
      };
}

class Links {
  Links();

  factory Links.fromJson(Map<String, dynamic> json) => Links();

  Map<String, dynamic> toJson() => {};
}
