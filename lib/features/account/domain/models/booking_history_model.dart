// To parse this JSON data, do
//
//     final bookingHistoryModel = bookingHistoryModelFromJson(jsonString);

import 'dart:convert';

BookingHistoryModel bookingHistoryModelFromJson(String str) =>
    BookingHistoryModel.fromJson(json.decode(str));

String bookingHistoryModelToJson(BookingHistoryModel data) =>
    json.encode(data.toJson());

class BookingHistoryModel {
  bool success;
  String message;
  List<BookingHistoryData> data;

  BookingHistoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) =>
      BookingHistoryModel(
        success: json["success"],
        message: json["message"],
        data: List<BookingHistoryData>.from(
            json["data"].map((x) => BookingHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BookingHistoryData {
  String id;
  String journeyId;
  int userId;
  String bookingUserName;
  int isCancelled;
  int isCompleted;
  String cancelledAt;
  String cancelledBy;
  String ticketNumber;
  String boardingId;
  String dropId;
  String boardingAddress;
  String dropAddress;
  int isPaid;
  int ticketFare;
  String travelDuration;
  String departureTime;
  String arraivalTime;
  String departureDate;
  String arraivalDate;
  String fromCity;
  String toCity;
  String fromCityCode;
  String toCityCode;
  String busModel;
  String vehicleNumber;
  dynamic company;
  String mobile;
  String email;
  bool isTripStarted;
  int passengerCount;
  JourneyPassengerDetail journeyPassengerDetail;
  String requestedCurrencySymbol;
  JourneyBill journeyBill;
  Boarding? boarding;
  Stop? stop;
  int refundAmount;
  int userRated;
  int ratings;
  bool supportTicketExists;
  String ticketId;
  int ticketStatus;

  BookingHistoryData({
    required this.id,
    required this.journeyId,
    required this.userId,
    required this.bookingUserName,
    required this.isCancelled,
    required this.isCompleted,
    required this.cancelledAt,
    required this.cancelledBy,
    required this.ticketNumber,
    required this.boardingId,
    required this.dropId,
    required this.boardingAddress,
    required this.dropAddress,
    required this.isPaid,
    required this.ticketFare,
    required this.travelDuration,
    required this.departureTime,
    required this.arraivalTime,
    required this.departureDate,
    required this.arraivalDate,
    required this.fromCity,
    required this.toCity,
    required this.fromCityCode,
    required this.toCityCode,
    required this.busModel,
    required this.vehicleNumber,
    required this.company,
    required this.mobile,
    required this.email,
    required this.isTripStarted,
    required this.passengerCount,
    required this.journeyPassengerDetail,
    required this.requestedCurrencySymbol,
    required this.journeyBill,
    required this.boarding,
    required this.stop,
    required this.refundAmount,
    required this.userRated,
    required this.ratings,
    required this.supportTicketExists,
    required this.ticketId,
    required this.ticketStatus,
  });

  factory BookingHistoryData.fromJson(Map<String, dynamic> json) =>
      BookingHistoryData(
        id: json["id"],
        journeyId: json["journey_id"],
        userId: json["user_id"],
        bookingUserName: json["booking_user_name"],
        isCancelled: json["is_cancelled"],
        isCompleted: json["is_completed"],
        cancelledAt: json["cancelled_at"] ?? '',
        cancelledBy: json["cancelled_by"] ?? '',
        ticketNumber: json["ticket_number"],
        boardingId: json["boarding_id"],
        dropId: json["drop_id"],
        boardingAddress: json["boarding_address"],
        dropAddress: json["drop_address"],
        isPaid: json["is_paid"],
        ticketFare: json["ticket_fare"],
        travelDuration: json["travel_duration"],
        departureTime: json["departure_time"],
        arraivalTime: json["arraival_time"],
        departureDate: json["departure_date"],
        arraivalDate: json["arraival_date"],
        fromCity: json["from_city"],
        toCity: json["to_city"],
        fromCityCode: json["from_city_code"],
        toCityCode: json["to_city_code"],
        busModel: json["bus_model"],
        vehicleNumber: json["vehicle_number_plate"]?.toString() ?? '',
        company: json["company"],
        mobile: json["mobile"],
        email: json["email"],
        isTripStarted: json["is_trip_started"],
        passengerCount: json["passenger_count"],
        journeyPassengerDetail: JourneyPassengerDetail.fromJson(
          json["journeyPassengerDetail"],
        ),
        requestedCurrencySymbol: json["requested_currency_symbol"] ?? '',
        journeyBill: JourneyBill.fromJson(json["journeyBill"]),
        boarding: Boarding.fromJson(json["boarding"]),
        stop: Stop.fromJson(json["stop"]),
        refundAmount: json["refund_amount"],
        userRated: json["user_rated"],
        ratings: json["rating"],
        supportTicketExists: json["support_ticket_exists"] ?? false,
        ticketId: json["ticket_id"] ?? '',
        ticketStatus: json["ticket_status"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "journey_id": journeyId,
        "user_id": userId,
        "booking_user_name": bookingUserName,
        "is_cancelled": isCancelled,
        "is_completed": isCompleted,
        "cancelled_at": cancelledAt,
        "cancelled_by": cancelledBy,
        "ticket_number": ticketNumber,
        "boarding_id": boardingId,
        "drop_id": dropId,
        "boarding_address": boardingAddress,
        "drop_address": dropAddress,
        "is_paid": isPaid,
        "ticket_fare": ticketFare,
        "travel_duration": travelDuration,
        "departure_time": departureTime,
        "arraival_time": arraivalTime,
        "departure_date": departureDate,
        "arraival_date": arraivalDate,
        "from_city": fromCity,
        "to_city": toCity,
        "from_city_code": fromCityCode,
        "to_city_code": toCityCode,
        "bus_model": busModel,
        "vehicle_number_plate": vehicleNumber,
        "company": company,
        "mobile": mobile,
        "email": email,
        "is_trip_started": isTripStarted,
        "passenger_count": passengerCount,
        "journeyPassengerDetail": journeyPassengerDetail.toJson(),
        "journeyBill": journeyBill.toJson(),
        "boarding": boarding?.toJson(),
        "stop": stop?.toJson(),
        "refund_amount": refundAmount,
        "user_rated": userRated,
        "rating": ratings,
      };
}

class Boarding {
  List<BoardingDatum> data;

  Boarding({
    required this.data,
  });

  factory Boarding.fromJson(Map<String, dynamic> json) {
    return Boarding(
      data: json["data"] != null
          ? List<BoardingDatum>.from(
              json["data"].map((x) => BoardingDatum.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BoardingDatum {
  String boardingId;
  String boardingTime;
  String boardingDate;
  String boardingDateTime;
  int arrivalStatus;
  String boardingPlace;
  String boardingLandmark;
  double boardingLat;
  double boardingLng;
  bool isTripStarted;
  String arriveAt;


  BoardingDatum({
    required this.boardingId,
    required this.boardingTime,
    required this.boardingDate,
    required this.boardingDateTime,
    required this.arrivalStatus,
    required this.boardingPlace,
    required this.boardingLandmark,
    required this.boardingLat,
    required this.boardingLng,
    required this.isTripStarted,
    required this.arriveAt,
  });

  factory BoardingDatum.fromJson(Map<String, dynamic> json) => BoardingDatum(
        boardingId: json["boarding_id"],
        boardingTime: json["boarding_time"],
        boardingDate: json["boarding_date"],
        boardingDateTime: json["boarding_date_time"]?.toString() ?? '',
        arrivalStatus: json["arrival_status"],
        boardingPlace: json["boarding_place"],
        boardingLandmark: json["boarding_landmark"],
        boardingLat: json["boarding_lat"]?.toDouble(),
        boardingLng: json["boarding_lng"]?.toDouble(),
        isTripStarted: json["is_trip_started"],
        arriveAt: json["arrive_at"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "boarding_id": boardingId,
        "boarding_time": boardingTime,
        "boarding_date": boardingDate,
        "boarding_date_time": boardingDateTime,
        "arrival_status": arrivalStatus,
        "boarding_place": boardingPlace,
        "boarding_landmark": boardingLandmark,
        "boarding_lat": boardingLat,
        "boarding_lng": boardingLng,
        "is_trip_started": isTripStarted,
      };
}

class Stop {
  List<StopDatum> data;

  Stop({
    required this.data,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      data: json["data"] != null
          ? List<StopDatum>.from(json["data"].map((x) => StopDatum.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StopDatum {
  String id;
  String stopId;
  String stopTime;
  String stopDate;
  String stopDateTime;
  int arrivalStatus;
  String stopAddress;
  String stopLandmark;
  double stopLat;
  double stopLng;
  bool isTripStarted;
  String arriveAt;

  StopDatum({
    required this.id,
    required this.stopId,
    required this.stopTime,
    required this.stopDate,
    required this.stopDateTime,
    required this.arrivalStatus,
    required this.stopAddress,
    required this.stopLandmark,
    required this.stopLat,
    required this.stopLng,
    required this.isTripStarted,
    required this.arriveAt,
  });

  factory StopDatum.fromJson(Map<String, dynamic> json) => StopDatum(
        id: json["id"],
        stopId: json["stop_id"],
        stopTime: json["stop_time"],
        stopDate: json["stop_date"],
        stopDateTime: json["stop_date_time"]?.toString() ?? '',
        arrivalStatus: json["arrival_status"],
        stopAddress: json["stop_address"],
        stopLandmark: json["stop_landmark"],
        stopLat: json["stop_lat"]?.toDouble(),
        stopLng: json["stop_lng"]?.toDouble(),
        isTripStarted: json["is_trip_started"],
         arriveAt: json["arrive_at"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stop_id": stopId,
        "stop_time": stopTime,
        "stop_date": stopDate,
        "stop_date_time": stopDateTime,
        "arrival_status": arrivalStatus,
        "stop_address": stopAddress,
        "stop_landmark": stopLandmark,
        "stop_lat": stopLat,
        "stop_lng": stopLng,
        "is_trip_started": isTripStarted,
      };
}

class JourneyBill {
  List<JourneyBillDatum> data;

  JourneyBill({
    required this.data,
  });

  factory JourneyBill.fromJson(Map<String, dynamic> json) => JourneyBill(
        data: List<JourneyBillDatum>.from(
            json["data"].map((x) => JourneyBillDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class JourneyBillDatum {
  int id;
  String journeyId;
  int userId;
  String journeyUserId;
  String ticketNumber;
  String cancellationFee;
  String isCancelled;
  String serviceTax;
  String serviceTaxPercentage;
  String promoDiscount;
  String adminCommisionFromUser;
  String adminCommisionFromCompany;
  String companyTicketAmount;
  String totalAdminCommision;
  String totalAmount;
  String requestedCurrencySymbol;
  String requestedCurrencyCode;

  JourneyBillDatum({
    required this.id,
    required this.journeyId,
    required this.userId,
    required this.journeyUserId,
    required this.ticketNumber,
    required this.cancellationFee,
    required this.isCancelled,
    required this.serviceTax,
    required this.serviceTaxPercentage,
    required this.promoDiscount,
    required this.adminCommisionFromUser,
    required this.adminCommisionFromCompany,
    required this.companyTicketAmount,
    required this.totalAdminCommision,
    required this.totalAmount,
    required this.requestedCurrencySymbol,
    required this.requestedCurrencyCode,
  });

  factory JourneyBillDatum.fromJson(Map<String, dynamic> json) =>
      JourneyBillDatum(
        id: json["id"],
        journeyId: json["journey_id"]?.toString() ?? '',
        userId: json["user_id"],
        journeyUserId: json["journey_user_id"] ?? '',
        ticketNumber: json["ticket_number"] ?? '',
        cancellationFee: json["cancellation_fee"]?.toString() ?? '',
        isCancelled: json["is_cancelled"]?.toString() ?? '',
        serviceTax: json["service_tax"]?.toString() ?? '',
        serviceTaxPercentage: json["service_tax_percentage"]?.toString() ?? '',
        promoDiscount: json["promo_discount"]?.toString() ?? '',
        adminCommisionFromUser:
            json["admin_commision_from_user"]?.toString() ?? '',
        adminCommisionFromCompany:
            json["admin_commision_from_company"]?.toString() ?? '',
        companyTicketAmount: json["company_ticket_amount"]?.toString() ?? '',
        totalAdminCommision: json["total_admin_commision"]?.toString() ?? '',
        totalAmount: json["total_amount"]?.toString() ?? '',
        requestedCurrencySymbol:
            json["requested_currency_symbol"]?.toString() ?? '',
        requestedCurrencyCode:
            json["requested_currency_code"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "journey_id": journeyId,
        "user_id": userId,
        "journey_user_id": journeyUserId,
        "ticket_number": ticketNumber,
        "cancellation_fee": cancellationFee,
        "is_cancelled": isCancelled,
        "service_tax": serviceTax,
        "service_tax_percentage": serviceTaxPercentage,
        "promo_discount": promoDiscount,
        "admin_commision_from_user": adminCommisionFromUser,
        "admin_commision_from_company": adminCommisionFromCompany,
        "company_ticket_amount": companyTicketAmount,
        "total_admin_commision": totalAdminCommision,
        "total_amount": totalAmount,
        "requested_currency_symbol": requestedCurrencySymbol,
        "requested_currency_code": requestedCurrencyCode,
      };
}

class JourneyPassengerDetail {
  List<dynamic> data;

  JourneyPassengerDetail({
    required this.data,
  });

  factory JourneyPassengerDetail.fromJson(Map<String, dynamic> json) =>
      JourneyPassengerDetail(
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
