import 'dart:convert';

TicketBookingModel ticketBookingModelFromJson(String str) => TicketBookingModel.fromJson(json.decode(str));

String ticketBookingModelToJson(TicketBookingModel data) => json.encode(data.toJson());

class TicketBookingModel {
    bool success;
    BookingJourneyUser journeyUser;
    BookingCalculatedbill calculatedbill;

    TicketBookingModel({
        required this.success,
        required this.journeyUser,
        required this.calculatedbill,
    });

    factory TicketBookingModel.fromJson(Map<String, dynamic> json) => TicketBookingModel(
        success: json["success"],
        journeyUser: BookingJourneyUser.fromJson(json["journeyUser"]),
        calculatedbill: BookingCalculatedbill.fromJson(json["calculated_bill"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "journeyUser": journeyUser.toJson(),
        "calculatedbill": calculatedbill.toJson(),
    };
}

class BookingCalculatedbill {
    CalculatedbillData data;

    BookingCalculatedbill({
        required this.data,
    });

    factory BookingCalculatedbill.fromJson(Map<String, dynamic> json) => BookingCalculatedbill(
        data: CalculatedbillData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class CalculatedbillData {
    String journeyId;
    String userId;
    String adminCommisionFromUser;
    String adminCommisionFromCompany;
    String totalAdminCommision;
    String companyTicketAmount;
    String requestedCurrencyCode;
    String requestedCurrencySymbol;
    String serviceTaxPercentage;
    String serviceTax;
    String journeyUserId;
    String ticketNumber;
    String totalAmount;
    String promoDiscount;
    String updatedAt;
    String createdAt;
    String id;

    CalculatedbillData({
        required this.journeyId,
        required this.userId,
        required this.adminCommisionFromUser,
        required this.adminCommisionFromCompany,
        required this.totalAdminCommision,
        required this.companyTicketAmount,
        required this.requestedCurrencyCode,
        required this.requestedCurrencySymbol,
        required this.serviceTaxPercentage,
        required this.serviceTax,
        required this.journeyUserId,
        required this.ticketNumber,
        required this.totalAmount,
        required this.promoDiscount,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory CalculatedbillData.fromJson(Map<String, dynamic> json) => CalculatedbillData(
        journeyId: json["journey_id"]?.toString() ?? '',
        userId: json["user_id"]?.toString() ?? '',
        adminCommisionFromUser: json["admin_commision_from_user"]?.toString() ?? '',
        adminCommisionFromCompany: json["admin_commision_from_company"]?.toString() ?? '',
        totalAdminCommision: json["total_admin_commision"]?.toString() ?? '',
        companyTicketAmount: json["company_ticket_amount"]?.toString() ?? '',
        requestedCurrencyCode: json["requested_currency_code"]?.toString() ?? '',
        requestedCurrencySymbol: json["requested_currency_symbol"]?.toString() ?? '',
        serviceTaxPercentage: json["service_tax_percentage"]?.toString() ?? '',
        serviceTax: json["service_tax"]?.toString() ?? '',
        journeyUserId: json["journey_user_id"]?.toString() ?? '',
        ticketNumber: json["ticket_number"]?.toString() ?? '',
        totalAmount: json["total_amount"]?.toString() ?? '',
        promoDiscount: json["promo_discount"]?.toString() ?? '',
        updatedAt:json["updated_at"]?.toString() ?? '',
        createdAt: json["created_at"]?.toString() ?? '',
        id: json["id"]?.toString() ?? '',
    );

    Map<String, dynamic> toJson() => {
        "journey_id": journeyId,
        "user_id": userId,
        "admin_commision_from_user": adminCommisionFromUser,
        "admin_commision_from_company": adminCommisionFromCompany,
        "total_admin_commision": totalAdminCommision,
        "company_ticket_amount": companyTicketAmount,
        "requested_currency_code": requestedCurrencyCode,
        "requested_currency_symbol": requestedCurrencySymbol,
        "service_tax_percentage": serviceTaxPercentage,
        "service_tax": serviceTax,
        "journey_user_id": journeyUserId,
        "ticket_number": ticketNumber,
        "total_amount": totalAmount,
        "promo_discount": promoDiscount,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
    };
}

class BookingJourneyUser {
    JourneyUserData data;

    BookingJourneyUser({
        required this.data,
    });

    factory BookingJourneyUser.fromJson(Map<String, dynamic> json) => BookingJourneyUser(
        data: JourneyUserData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class JourneyUserData {
   String id;
    String journeyId;
    String userId;
    String bookingUserName;
    String isCancelled;
    String isCompleted;
    String cancelledAt;
    String cancelledBy;
    String ticketNumber;
    String boardingId;
    String dropId;
    String boardingAddress;
    String dropAddress;
    String isPaid;
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
    String company;
    String seatType;
    String mobile;
    String email;
    String userRated;
    String rating;
    String ticketFare;
    bool isTripStarted;
    String passengerCount;
    JourneyBoardingPoints journeyBoardingPoints;
    JourneyDropPoints journeyDropPoints;
    String paymentDuration;
    String userTravelDuration;
    JourneyPassengerDetail journeyPassengerDetail;

    JourneyUserData({
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
        required this.company,
        required this.seatType,
        required this.mobile,
        required this.email,
        required this.userRated,
        required this.rating,
        required this.ticketFare,
        required this.isTripStarted,
        required this.passengerCount,
        required this.journeyBoardingPoints,
        required this.journeyDropPoints,
        required this.paymentDuration,
        required this.userTravelDuration,
        required this.journeyPassengerDetail,
    });

    factory JourneyUserData.fromJson(Map<String, dynamic> json) => JourneyUserData(
        id: json["id"]?.toString() ?? '0',
        journeyId: json["journey_id"]?.toString() ?? '0',
        userId: json["user_id"]?.toString() ?? '0',
        bookingUserName: json["booking_user_name"]?.toString() ?? '',
        isCancelled: json["is_cancelled"]?.toString() ?? '',
        isCompleted: json["is_completed"]?.toString() ?? '',
        cancelledAt: json["cancelled_at"]?.toString() ?? '',
        cancelledBy: json["cancelled_by"]?.toString() ?? '',
        ticketNumber: json["ticket_number"]?.toString() ?? '',
        boardingId: json["boarding_id"]?.toString() ?? '',
        dropId: json["drop_id"]?.toString() ?? '',
        boardingAddress: json["boarding_address"]?.toString() ?? '',
        dropAddress: json["drop_address"]?.toString() ?? '',
        isPaid: json["is_paid"]?.toString() ?? '0',
        travelDuration: json["travel_duration"]?.toString() ?? '',
        departureTime: json["departure_time"]?.toString() ?? '',
        arraivalTime: json["arraival_time"]?.toString() ?? '',
        departureDate: json["departure_date"]?.toString() ?? '',
        arraivalDate: json["arraival_date"]?.toString() ?? '',
        fromCity: json["from_city"]?.toString() ?? '',
        toCity: json["to_city"]?.toString() ?? '',
        fromCityCode: json["from_city_code"]?.toString() ?? '',
        toCityCode: json["to_city_code"]?.toString() ?? '',
        busModel: json["bus_model"]?.toString() ?? '',
        seatType: json["seat_type"]?.toString() ?? '',
        company: json["company"]?.toString() ?? '',
        mobile: json["mobile"]?.toString() ?? '',
        email: json["email"]?.toString() ?? '',
        userRated: json["user_rated"]?.toString() ?? '',
        rating: json["rating"]?.toString() ?? '',
        ticketFare: json["ticket_fare"]?.toString() ?? '',
        isTripStarted: json["is_trip_started"] ?? false,
        passengerCount: json["passenger_count"]?.toString() ?? '0',
        journeyBoardingPoints: JourneyBoardingPoints.fromJson(json["journey_boarding_points"]),
        journeyDropPoints: JourneyDropPoints.fromJson(json["journey_drop_points"]),
        paymentDuration: json["payment_duration"]?.toString() ?? '1',
        userTravelDuration: json["user_travel_duration"]?.toString() ?? '0',
        journeyPassengerDetail: JourneyPassengerDetail.fromJson(json["journeyPassengerDetail"]),
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
        "company": company,
        "mobile": mobile,
        "email": email,
        "user_rated": userRated,
        "rating": rating,
        "ticket_fare": ticketFare,
        "is_trip_started": isTripStarted,
        "passenger_count": passengerCount,
        "journey_boarding_points": journeyBoardingPoints.toJson(),
        "journey_drop_points": journeyDropPoints.toJson(),
        "payment_duration": paymentDuration,
        "user_travel_duration": userTravelDuration,
        "journeyPassengerDetail": journeyPassengerDetail.toJson(),
    };
}

class JourneyBoardingPoints {
    String id;
    String journeyId;
    String boardingId;
    String boardingTime;
    String createdAt;
    String updatedAt;

    JourneyBoardingPoints({
        required this.id,
        required this.journeyId,
        required this.boardingId,
        required this.boardingTime,
        required this.createdAt,
        required this.updatedAt,
    });

    factory JourneyBoardingPoints.fromJson(Map<String, dynamic> json) => JourneyBoardingPoints(
        id: json["id"]?.toString() ?? '',
        journeyId: json["journey_id"]?.toString() ?? '',
        boardingId: json["boarding_id"]?.toString() ?? '',
        boardingTime: json["boarding_time"]?.toString() ?? '',
        createdAt: json["created_at"]?.toString() ?? '',
        updatedAt: json["updated_at"]?.toString() ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "journey_id": journeyId,
        "boarding_id": boardingId,
        "boarding_time": boardingTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class JourneyDropPoints {
    String id;
    String journeyId;
    String stopId;
    String stopTime;
    String createdAt;
    String updatedAt;

    JourneyDropPoints({
        required this.id,
        required this.journeyId,
        required this.stopId,
        required this.stopTime,
        required this.createdAt,
        required this.updatedAt,
    });

    factory JourneyDropPoints.fromJson(Map<String, dynamic> json) => JourneyDropPoints(
        id: json["id"]?.toString() ?? '',
        journeyId: json["journey_id"]?.toString() ?? '',
        stopId: json["stop_id"]?.toString() ?? '',
        stopTime: json["stop_time"]?.toString() ?? '',
        createdAt: json["created_at"]?.toString() ?? '',
        updatedAt: json["updated_at"]?.toString() ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "journey_id": journeyId,
        "stop_id": stopId,
        "stop_time": stopTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class JourneyPassengerDetail {
    List<JourneyPassengerDetailData> data;

    JourneyPassengerDetail({
        required this.data,
    });

    factory JourneyPassengerDetail.fromJson(Map<String, dynamic> json) => JourneyPassengerDetail(
        data: List<JourneyPassengerDetailData>.from(json["data"].map((x) => JourneyPassengerDetailData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class JourneyPassengerDetailData {
    String id;
    String name;
    String gender;
    String age;
    String seatNo;
    String journeyUserMobile;
    String journeyUserEmail;
    dynamic boardingStatus;

    JourneyPassengerDetailData({
        required this.id,
        required this.name,
        required this.gender,
        required this.age,
        required this.seatNo,
        required this.journeyUserMobile,
        required this.journeyUserEmail,
        required this.boardingStatus,
    });

    factory JourneyPassengerDetailData.fromJson(Map<String, dynamic> json) => JourneyPassengerDetailData(
        id: json["id"]?.toString() ?? '',
        name: json["name"]?.toString() ?? '',
        gender: json["gender"]?.toString() ?? '',
        age: json["age"]?.toString() ?? '',
        seatNo: json["seat_no"]?.toString() ?? '',
        journeyUserMobile: json["journey_user_mobile"]?.toString() ?? '',
        journeyUserEmail: json["journey_user_email"]?.toString() ?? '',
        boardingStatus: json["boarding_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "age": age,
        "seat_no": seatNo,
        "journey_user_mobile": journeyUserMobile,
        "journey_user_email": journeyUserEmail,
        "boarding_status": boardingStatus,
    };
}
