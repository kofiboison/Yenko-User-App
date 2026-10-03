// To parse this JSON data, do
//
//     final popularRoutesModel = popularRoutesModelFromJson(jsonString);

import 'dart:convert';

PopularRoutesModel popularRoutesModelFromJson(String str) =>
    PopularRoutesModel.fromJson(json.decode(str));

String popularRoutesModelToJson(PopularRoutesModel data) =>
    json.encode(data.toJson());

class PopularRoutesModel {
  bool success;
  String message;
  List<PopularRouteData> data;

  PopularRoutesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PopularRoutesModel.fromJson(Map<String, dynamic> json) =>
      PopularRoutesModel(
        success: json["success"],
        message: json["message"],
        data: List<PopularRouteData>.from(
            json["data"].map((x) => PopularRouteData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PopularRouteData {
  String fromCity;
  String toCity;
  String fromShortCode;
  String toShortCode;
  int bookingCount;
  String fromCityName;
  String toCityName;

  PopularRouteData({
    required this.fromCity,
    required this.toCity,
    required this.fromShortCode,
    required this.toShortCode,
    required this.bookingCount,
    required this.fromCityName,
    required this.toCityName,
  });

  factory PopularRouteData.fromJson(Map<String, dynamic> json) =>
      PopularRouteData(
        fromCity: json["from_city"],
        toCity: json["to_city"],
        fromShortCode: json["from_city_code"],
        toShortCode: json["to_city_code"],
        bookingCount: json["booking_count"],
        fromCityName: json["from_city_name"],
        toCityName: json["to_city_name"],
      );

  Map<String, dynamic> toJson() => {
        "from_city": fromCity,
        "to_city": toCity,
        "from_city_code": fromShortCode,
        "to_city_code": toShortCode,
        "booking_count": bookingCount,
        "from_city_name": fromCityName,
        "to_city_name": toCityName,
      };
}
