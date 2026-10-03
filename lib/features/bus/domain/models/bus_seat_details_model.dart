
import 'dart:convert';

BusSeatDetailModel busSeatDetailModelFromJson(String str) => BusSeatDetailModel.fromJson(json.decode(str));

String busSeatDetailModelToJson(BusSeatDetailModel data) => json.encode(data.toJson());

class BusSeatDetailModel {
    bool success;
    String message;
    BusSeatDetailModelData data;

    BusSeatDetailModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory BusSeatDetailModel.fromJson(Map<String, dynamic> json) => BusSeatDetailModel(
        success: json["success"]?? false,
        message: json["message"]?? '',
        data: BusSeatDetailModelData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class BusSeatDetailModelData {
    String id;
    String serviceLocationId;
    String fleetId;
    int isCompleted;
    dynamic completedAt;
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
    String busCompanyName;
    String rating;
    int availableSeats;
    String currencySymbol;
    String duration;
    double lowPrice;
    int isTripStarted;
    String maximumNumberOfSeatsUserCanBook;
    bool upperDeckAvailable;
    String fromCityShortCode;
    String toCityShortCode;
    Bus bus;
    Boardingpoints boardingpoints;
    Stoppoints stoppoints;

    BusSeatDetailModelData({
        required this.id,
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
        required this.fromCityShortCode,
        required this.toCityShortCode,
        required this.busCompanyName,
        required this.rating,
        required this.availableSeats,
        required this.currencySymbol,
        required this.duration,
        required this.lowPrice,
        required this.isTripStarted,
        required this.maximumNumberOfSeatsUserCanBook,
        required this.upperDeckAvailable,
        required this.bus,
        required this.boardingpoints,
        required this.stoppoints,
    });

    factory BusSeatDetailModelData.fromJson(Map<String, dynamic> json) => BusSeatDetailModelData(
        id: json["id"]??'',
        serviceLocationId: json["service_location_id"]??'',
        fleetId: json["fleet_id"]??'',
        isCompleted: json["is_completed"] ?? 0,
        completedAt: json["completed_at"]??'',
        isTripStart: json["is_trip_start"]??0,
        startedAt: json["started_at"]??'',
        depatureAt: json["depature_at"]??'',
        arrivedAt: json["arrived_at"]??'',
        depatureAtDate: json["depature_at_date"]??'',
        arrivedAtDate: json["arrived_at_date"]??'',
        depatureAtTime: json["depature_at_time"]??'',
        arrivedAtTime: json["arrived_at_time"]??'',
        seaterPrice: json["seater_price"]?.toDouble() ?? 0.0,
        sleeperPrice: json["sleeper_price"]?.toDouble() ?? 0.0,
        semiSleeperPrice: json["semi_sleeper_price"]?.toDouble() ?? 0.0,
        upperSeaterPrice: json["upper_seater_price"]?.toDouble() ?? 0.0,
        upperSleeperPrice: json["upper_sleeper_price"]?.toDouble() ?? 0.0,
        upperSemiSleeperPrice: json["upper_semi_sleeper_price"]?.toDouble() ?? 0.0,
        fromCityId: json["from_city_id"]??'',
        toCityId: json["to_city_id"]??'',
        fromCity: json["from_city"]??'',
        toCity: json["to_city"]??'',
        busCompanyName: json["bus_company_name"]??'',
        rating: json["rating"]?.toString()??'',
        availableSeats: json["available_seats"]??0,
        currencySymbol: json["currency_symbol"]??'',
        duration: json["duration"]??'',
        lowPrice: json["low_price"]?.toDouble() ?? 0.0,
        isTripStarted: json["is_trip_started"] ?? 0,
        maximumNumberOfSeatsUserCanBook: json["maximum_number_of_seats_user_can_book"] ?? '',
        upperDeckAvailable: json["upper_deck_available"] ?? false,
        fromCityShortCode: json["from_city_short_code"] ?? '',
        toCityShortCode: json["to_city_short_code"] ?? '',
        bus: Bus.fromJson(json["bus"]),
        boardingpoints: Boardingpoints.fromJson(json["boardingpoints"]),
        stoppoints: Stoppoints.fromJson(json["stoppoints"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_location_id": serviceLocationId,
        "fleet_id": fleetId,
        "is_completed": isCompleted,
        "completed_at": completedAt,
        "is_trip_start": isTripStart,
        "started_at": startedAt,
        "depature_at": depatureAt,
        "arrived_at": arrivedAt,
        "depature_at_date": depatureAtDate,
        "arrived_at_date": arrivedAtDate,
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
        "from_city_short_code": fromCityShortCode,
        "to_city_short_code": toCityShortCode,
        "bus_company_name": busCompanyName,
        "rating": rating,
        "available_seats": availableSeats,
        "currency_symbol": currencySymbol,
        "duration": duration,
        "low_price": lowPrice,
        "is_trip_started": isTripStarted,
        "maximum_number_of_seats_user_can_book": maximumNumberOfSeatsUserCanBook,
        "upper_deck_available": upperDeckAvailable,
        "bus": bus.toJson(),
        "boardingpoints": boardingpoints.toJson(),
        "stoppoints": stoppoints.toJson(),
    };
}

class BoardingpointsData {
    String boardingId;
    String boardingTime;
    String boardingPlace;
    String boardingLandmark;
    bool isTripStarted;
    Boardingpoints? users;

    BoardingpointsData({
        required this.boardingId,
        required this.boardingTime,
        required this.boardingPlace,
        required this.boardingLandmark,
        required this.isTripStarted,
        this.users,
    });

    factory BoardingpointsData.fromJson(Map<String, dynamic> json) => BoardingpointsData(
        boardingId: json["boarding_id"]??'',
        boardingTime: json["boarding_time"]??'',
        boardingPlace: json["boarding_place"]??'',
        boardingLandmark: json["boarding_landmark"]??'',
        isTripStarted: json["is_trip_started"]??false,
        users: json["users"] != null ? Boardingpoints.fromJson(json["users"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "boarding_id": boardingId,
        "boarding_time": boardingTime,
        "boarding_place": boardingPlace,
        "boarding_landmark": boardingLandmark,
        "is_trip_started": isTripStarted,
        "users": users?.toJson() ?? '',
    };
}

class Boardingpoints {
    List<BoardingpointsData> data;

    Boardingpoints({
        required this.data,
    });

    factory Boardingpoints.fromJson(Map<String, dynamic> json) => Boardingpoints(
        data: List<BoardingpointsData>.from(json["data"].map((x) => BoardingpointsData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Bus {
    BusSeatLayoutData data;

    Bus({
        required this.data,
    });

    factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        data: BusSeatLayoutData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class BusSeatLayoutData {
    String id;
    String ownerId;
    String brand;
    String image;
    String model;
    String licenseNumber;
    dynamic permissionNumber;
    int active;
    int lowerLeftColumns;
    int lowerRightColumns;
    int leftRows;
    int rightRows;
    int upperLeftRows;
    int upperRightRows;
    int upperLeftColumns;
    int upperRightColumns;
    int totalBackSeats;
    String seatType;
    dynamic busType;
    List<dynamic> layoutType;
    String isAcAvailable;
    List<String> busImage;
    SeatLayout seatLayout;

    BusSeatLayoutData({
        required this.id,
        required this.ownerId,
        required this.brand,
        required this.image,
        required this.model,
        required this.licenseNumber,
        required this.permissionNumber,
        required this.active,
        required this.lowerLeftColumns,
        required this.lowerRightColumns,
        required this.leftRows,
        required this.rightRows,
        required this.upperLeftRows,
        required this.upperRightRows,
        required this.upperLeftColumns,
        required this.upperRightColumns,
        required this.totalBackSeats,
        required this.seatType,
        required this.busType,
        required this.layoutType,
        required this.isAcAvailable,
        required this.busImage,
        required this.seatLayout,
    });

    factory BusSeatLayoutData.fromJson(Map<String, dynamic> json) => BusSeatLayoutData(
        id: json["id"]??'',
        ownerId: json["owner_id"]??'',
        brand: json["brand"]??'',
        image: json["image"]??'',
        model: json["model"]??'',
        licenseNumber: json["license_number"]??'',
        permissionNumber: json["permission_number"],
        active: json["active"]??0,
        lowerLeftColumns: json["lower_left_columns"]??0,
        lowerRightColumns: json["lower_right_columns"]??0,
        leftRows: json["left_rows"]??0,
        rightRows: json["right_rows"]??0,
        upperLeftRows: json["upper_left_rows"]??0,
        upperRightRows: json["upper_right_rows"]??0,
        upperLeftColumns: json["upper_left_columns"]??0,
        upperRightColumns: json["upper_right_columns"]??0,
        totalBackSeats: json["total_back_seats"]??0,
        seatType: json["seat_type"]??'',
        busType: json["bus_type"],
        layoutType: List<dynamic>.from(json["layout_type"].map((x) => x)),
        isAcAvailable: json["is_ac_available"]??'0',
        busImage: List<String>.from(json["bus_image"].map((x) => x)),
        seatLayout: SeatLayout.fromJson(json["seatLayout"]),
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
        "lower_left_columns": lowerLeftColumns,
        "lower_right_columns": lowerRightColumns,
        "left_rows": leftRows,
        "right_rows": rightRows,
        "upper_left_rows": upperLeftRows,
        "upper_right_rows": upperRightRows,
        "upper_left_columns": upperLeftColumns,
        "upper_right_columns":upperRightColumns,
        "total_back_seats": totalBackSeats,
        "seat_type": seatType,
        "bus_type": busType,
        "layout_type": List<dynamic>.from(layoutType.map((x) => x)),
        "is_ac_available": isAcAvailable,
        "bus_image": List<dynamic>.from(busImage.map((x) => x)),
        "seatLayout": seatLayout.toJson(),
    };
}

class SeatLayout {
    List<SeatLayoutData> data;

    SeatLayout({
        required this.data,
    });

    factory SeatLayout.fromJson(Map<String, dynamic> json) => SeatLayout(
        data: List<SeatLayoutData>.from(json["data"].map((x) => SeatLayoutData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class SeatLayoutData {
    String id;
    String fleetId;
    String position;
    String seatNo;
    String seatType;
    String deckType;
    int noSeat;
    bool isAvailable;
    bool bookedByMale;
    bool isAvailableForMale;
    bool bookedByFemale;
    bool isAvailableForFemale;
    double price;

    SeatLayoutData({
        required this.id,
        required this.fleetId,
        required this.position,
        required this.seatNo,
        required this.seatType,
        required this.deckType,
        required this.noSeat,
        required this.isAvailable,
        required this.bookedByMale,
        required this.isAvailableForMale,
        required this.bookedByFemale,
        required this.isAvailableForFemale,
        required this.price,
    });

    factory SeatLayoutData.fromJson(Map<String, dynamic> json) => SeatLayoutData(
        id: json["id"]??'',
        fleetId: json["fleet_id"]??'',
        position: json["position"]??'',
        seatNo: json["seat_no"]??'',
        seatType: json["seat_type"]??'',
        deckType: json["deck_type"] ??'',
        noSeat: json["no_seat"] ?? 0,
        isAvailable: json["is_available"] ?? false,
        bookedByMale: json["booked_by_male"] ?? false,
        isAvailableForMale: json["is_available_for_male"] ?? false,
        bookedByFemale: json["booked_by_female"] ?? false,
        isAvailableForFemale: json["is_available_for_female"] ?? false,
        price: json["price"]?.toDouble() ?? 0.0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fleet_id": fleetId,
        "position": position,
        "seat_no": seatNo,
        "seat_type": seatType,
        "deck_type": deckType,
        "no_seat": noSeat,
        "is_available": isAvailable,
        "booked_by_male": bookedByMale,
        "is_available_for_male": isAvailableForMale,
        "booked_by_female": bookedByFemale,
        "is_available_for_female": isAvailableForFemale,
        "price": price
    };
}

class Stoppoints {
    List<StoppointsData> data;

    Stoppoints({
        required this.data,
    });

    factory Stoppoints.fromJson(Map<String, dynamic> json) => Stoppoints(
        data: List<StoppointsData>.from(json["data"].map((x) => StoppointsData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class StoppointsData {
    String id;
    String stopId;
    String stopTime;
    String stopAddress;
    String stopLandmark;

    StoppointsData({
        required this.id,
        required this.stopId,
        required this.stopTime,
        required this.stopAddress,
        required this.stopLandmark,
    });

    factory StoppointsData.fromJson(Map<String, dynamic> json) => StoppointsData(
        id: json["id"]??'',
        stopId: json["stop_id"]??'',
        stopTime: json["stop_time"]??'',
        stopAddress: json["stop_address"]??'',
        stopLandmark: json["stop_landmark"]??'',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "stop_id": stopId,
        "stop_time": stopTime,
        "stop_address": stopAddress,
        "stop_landmark": stopLandmark,
    };
}

