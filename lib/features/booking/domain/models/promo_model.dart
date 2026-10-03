// To parse this JSON data, do
//
//     final promoModel = promoModelFromJson(jsonString);

import 'dart:convert';

PromoModel promoModelFromJson(String str) =>
    PromoModel.fromJson(json.decode(str));

String promoModelToJson(PromoModel data) => json.encode(data.toJson());

class PromoModel {
  bool success;
  String message;
  Data data;

  PromoModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

class Data {
  int discountAmount;
  int ticketFare;

  Data({
    required this.discountAmount,
    required this.ticketFare,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        discountAmount: json["discount_amount"],
        ticketFare: json["ticket_fare"],
      );
}
