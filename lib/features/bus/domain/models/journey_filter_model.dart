
import 'dart:convert';

JourneyFilterModel journeyFilterModelFromJson(String str) => JourneyFilterModel.fromJson(json.decode(str));

String journeyFilterModelToJson(JourneyFilterModel data) => json.encode(data.toJson());

class JourneyFilterModel {
    bool success;
    List<String> seatType;
    List<String> busType;
    List<Point> boardingPoints;
    List<Point> dropPoints;
    List<String> busCompanies;
    List<Amenity> amenities;
    String lowPrice;
    String highPrice;

    JourneyFilterModel({
        required this.success,
        required this.seatType,
        required this.busType,
        required this.boardingPoints,
        required this.dropPoints,
        required this.busCompanies,
        required this.amenities,
        required this.lowPrice,
        required this.highPrice,
    });

    factory JourneyFilterModel.fromJson(Map<String, dynamic> json) => JourneyFilterModel(
        success: json["success"],
        seatType: List<String>.from(json["seat_type"].map((x) => x)),
        busType: List<String>.from(json["bus_type"].map((x) => x)),
        boardingPoints: List<Point>.from(json["boardingPoints"].map((x) => Point.fromJson(x))),
        dropPoints: List<Point>.from(json["dropPoints"].map((x) => Point.fromJson(x))),
        busCompanies: List<String>.from(json["busCompanies"].map((x) => x)),
        amenities: List<Amenity>.from(json["amenities"].map((x) => Amenity.fromJson(x))),
        lowPrice: json["low_price"],
        highPrice: json["high_price"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "seat_type": List<dynamic>.from(seatType.map((x) => x)),
        "bus_type": List<dynamic>.from(busType.map((x) => x)),
        "boardingPoints": List<dynamic>.from(boardingPoints.map((x) => x.toJson())),
        "dropPoints": List<dynamic>.from(dropPoints.map((x) => x.toJson())),
        "busCompanies": List<dynamic>.from(busCompanies.map((x) => x)),
        "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
        "low_price": lowPrice,
        "high_price": highPrice,
    };
}

class Amenity {
    String id;
    String name;
    String image;
    String createdAt;
    String updatedAt;

    Amenity({
        required this.id,
        required this.name,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
    };
}

class Point {
    String id;
    String boardingAddress;
    String landMark;
    double boardingLat;
    double boardingLng;
    String serviceLocationId;
    String cityId;
    String createdAt;
    String updatedAt;

    Point({
        required this.id,
        required this.boardingAddress,
        required this.landMark,
        required this.boardingLat,
        required this.boardingLng,
        required this.serviceLocationId,
        required this.cityId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Point.fromJson(Map<String, dynamic> json) => Point(
        id: json["id"],
        boardingAddress: json["boarding_address"],
        landMark: json["land_mark"],
        boardingLat: json["boarding_lat"]?.toDouble(),
        boardingLng: json["boarding_lng"]?.toDouble(),
        serviceLocationId: json["service_location_id"],
        cityId: json["city_id"],
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "boarding_address": boardingAddress,
        "land_mark": landMark,
        "boarding_lat": boardingLat,
        "boarding_lng": boardingLng,
        "service_location_id": serviceLocationId,
        "city_id": cityId,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
    };
}

class FilterTypes{
  final String type;
  final String typeName;
  final String typeImage;

  FilterTypes({required this.type,required this.typeName, required this.typeImage});
}