import 'dart:convert';

UserDetailResponseModel userDetailResponseModelFromJson(String str) =>
    UserDetailResponseModel.fromJson(json.decode(str));

String userDetailResponseModelToJson(UserDetailResponseModel data) =>
    json.encode(data.toJson());

class UserDetailResponseModel {
  bool success;
  UserDetail data;

  UserDetailResponseModel({
    required this.success,
    required this.data,
  });

  factory UserDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      UserDetailResponseModel(
        success: json["success"],
        data: UserDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class UserDetail {
  int id;
  String name;
  String gender;
  String lastName;
  String username;
  String email;
  String mobile;
  String profilePicture;
  int active;
  int emailConfirmed;
  int mobileConfirmed;
  String lastKnownIp;
  String lastLoginAt;
  String rating;
  String noOfRatings;
  String refferalCode;
  String currencyCode;
  String currencySymbol;
  String currencyPointer;
  String countryCode;
  String fcmToken;
  String authorizationCode;
  String enableSupportTicketFeature;
  String enableModulesForApplications;
  String contactUsMobile1;
  String contactUsMobile2;
  String contactUsLink;
  String showWalletMoneyTransferFeatureOnMobileApp;
  String showBankInfoFeatureOnMobileApp;
  String showWalletFeatureOnMobileApp;
  String referralComissionString;
  String enableCountryRestrictOnMap;
  String conversationId;
  String mapType;
  bool usersBankInfo;
  String amountRefundInXDays;
  SOS sos;
  dynamic bannerImage;
  Wallet? wallet;
  String maxDays;
  JourneyUser? journeyUser;
  Calculatedbill? calculatedbill;
  UpcomingjourneyUser? upcomingjourneyUser;
  Boardingpoints? boardingpoints;
  Stoppoints? stoppoints;

  UserDetail({
    required this.id,
    required this.name,
    required this.gender,
    required this.lastName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.profilePicture,
    required this.active,
    required this.emailConfirmed,
    required this.mobileConfirmed,
    required this.lastKnownIp,
    required this.lastLoginAt,
    required this.rating,
    required this.noOfRatings,
    required this.refferalCode,
    required this.currencyCode,
    required this.currencySymbol,
    required this.currencyPointer,
    required this.countryCode,
    required this.fcmToken,
    required this.authorizationCode,
    required this.enableSupportTicketFeature,
    required this.enableModulesForApplications,
    required this.contactUsMobile1,
    required this.contactUsMobile2,
    required this.contactUsLink,
    required this.showWalletMoneyTransferFeatureOnMobileApp,
    required this.showBankInfoFeatureOnMobileApp,
    required this.showWalletFeatureOnMobileApp,
    required this.referralComissionString,
    required this.enableCountryRestrictOnMap,
    required this.conversationId,
    required this.mapType,
    required this.usersBankInfo,
    required this.amountRefundInXDays,
    required this.sos,
    required this.bannerImage,
    this.wallet,
    this.journeyUser,
    required this.maxDays,
    required this.calculatedbill,
    required this.upcomingjourneyUser,
    required this.boardingpoints,
    required this.stoppoints,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        gender: json["gender"] ?? '',
        lastName: json["last_name"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
        active: json["active"] ?? 0,
        emailConfirmed: json["email_confirmed"] ?? 0,
        mobileConfirmed: json["mobile_confirmed"] ?? 0,
        lastKnownIp: json["last_known_ip"] ?? '',
        lastLoginAt: json["last_login_at"] ?? '',
        rating: json["rating"]?.toString() ?? '',
        noOfRatings: json["no_of_ratings"]?.toString() ?? '',
        refferalCode: json["refferal_code"]?.toString() ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencySymbol: json["currency_symbol"] ?? '',
        currencyPointer: json["currency_pointer"] ?? '',
        countryCode: json["country_code"] ?? '',
        fcmToken: json["fcm_token"] ?? '',
        authorizationCode: json["authorization_code"] ?? '',
        enableSupportTicketFeature: json["enable_support_ticket_feature"] ?? '',
        enableModulesForApplications:
            json["enable_modules_for_applications"] ?? '',
        contactUsMobile1: json["contact_us_mobile1"] ?? '',
        contactUsMobile2: json["contact_us_mobile2"] ?? '',
        contactUsLink: json["contact_us_link"],
        showWalletMoneyTransferFeatureOnMobileApp:
            json["show_wallet_money_transfer_feature_on_mobile_app"] ?? '',
        showBankInfoFeatureOnMobileApp:
            json["show_bank_info_feature_on_mobile_app"] ?? '',
        showWalletFeatureOnMobileApp:
            json["show_wallet_feature_on_mobile_app"] ?? '',
        referralComissionString: json["referral_comission_string"] ?? '',
        enableCountryRestrictOnMap:
            json["enable_country_restrict_on_map"] ?? '',
        conversationId: json["conversation_id"] ?? '',
        mapType: json["map_type"] ?? '',
        usersBankInfo: json["users_bank_info"] ?? bool,
        amountRefundInXDays: json["amount_refund_in_x_days"] ?? '',
        sos: SOS.fromJson(json["sos"]),
        bannerImage: (json["bannerImage"] != null)
            ? BannerImage.fromJson(json["bannerImage"])
            : null,
        wallet:
            (json["wallet"] != null) ? Wallet.fromJson(json["wallet"]) : null,
        maxDays: json["maximum_number_of_days_allowed_user_for_search"] ?? '1',
        journeyUser: (json["journeyUser"] != null)
            ? JourneyUser.fromJson(json["journeyUser"])
            : null,
        calculatedbill: (json["calculatedbill"] != null)
            ? Calculatedbill.fromJson(json["calculatedbill"])
            : null,
        upcomingjourneyUser: (json["upcomingjourneyUser"] != null)
            ? UpcomingjourneyUser.fromJson(json["upcomingjourneyUser"])
            : null,
        boardingpoints: (json["boardingpoints"] != null)
            ? Boardingpoints.fromJson(json["boardingpoints"])
            : null,
        stoppoints: (json["stoppoints"] != null)
            ? Stoppoints.fromJson(json["stoppoints"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "last_name": lastName,
        "username": username,
        "email": email,
        "mobile": mobile,
        "profile_picture": profilePicture,
        "active": active,
        "email_confirmed": emailConfirmed,
        "mobile_confirmed": mobileConfirmed,
        "last_known_ip": lastKnownIp,
        "last_login_at": lastLoginAt,
        "rating": rating,
        "no_of_ratings": noOfRatings,
        "refferal_code": refferalCode,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "currency_pointer": currencyPointer,
        "country_code": countryCode,
        "fcm_token": fcmToken,
        "authorization_code": authorizationCode,
        "enable_support_ticket_feature": enableSupportTicketFeature,
        "enable_modules_for_applications": enableModulesForApplications,
        "contact_us_mobile1": contactUsMobile1,
        "contact_us_mobile2": contactUsMobile2,
        "contact_us_link": contactUsLink,
        "show_wallet_money_transfer_feature_on_mobile_app":
            showWalletMoneyTransferFeatureOnMobileApp,
        "show_bank_info_feature_on_mobile_app": showBankInfoFeatureOnMobileApp,
        "show_wallet_feature_on_mobile_app": showWalletFeatureOnMobileApp,
        "referral_comission_string": referralComissionString,
        "enable_country_restrict_on_map": enableCountryRestrictOnMap,
        "conversation_id": conversationId,
        "map_type": mapType,
        "users_bank_info": usersBankInfo,
        "amount_refund_in_x_days": amountRefundInXDays,
        "sos": sos.toJson(),
        "bannerImage": (bannerImage != null) ? bannerImage.toJson() : 'null',
        "wallet": wallet?.toJson(),
        "journeyUser": journeyUser?.toJson(),
        "calculatedbill": calculatedbill?.toJson(),
        "boardingpoints": boardingpoints?.toJson(),
        "stoppoints": stoppoints?.toJson(),
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
  String boardingDate;
  String boardingId;
  String boardingTime;
  String boardingDateTime;
  String boardingPlace;
  String boardingLandmark;
  String arriveAt;
  bool isTripStarted;
  JourneyUser? journeyUser;
  int arrivalStatus;
  double boardingLat;
  double boardingLng;

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
    required this.journeyUser,
    required this.arriveAt,
    required this.boardingDateTime
  });

  factory BoardingpointsDatum.fromJson(Map<String, dynamic> json) =>
      BoardingpointsDatum(
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
        journeyUser: json["users"] != null ? JourneyUser.fromJson(json["users"]) : null,
        arriveAt: json["arrive_at"]?.toString() ?? '',
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
        "users": journeyUser?.toJson(),
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
  JourneyUser? journeyUser;

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
    required this.journeyUser,
  });

  factory StoppointsDatum.fromJson(Map<String, dynamic> json) =>
      StoppointsDatum(
        id: json["id"],
        stopId: json["stop_id"],
        stopTime: json["stop_time"],
        stopDate: json["stop_date"],
        arrivalStatus: json["arrival_status"],
        stopAddress: json["stop_address"],
        stopLandmark: json["stop_landmark"],
        stopLat: json["stop_lat"]?.toDouble(),
        stopLng: json["stop_lng"]?.toDouble(),
        isTripStarted: json["is_trip_started"],
        journeyUser: json["users"]!=null ? JourneyUser.fromJson(json["users"]) : null,
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
        "users": journeyUser?.toJson(),
      };
}

class Calculatedbill {
  CalculatedbillData data;

  Calculatedbill({
    required this.data,
  });

  factory Calculatedbill.fromJson(Map<String, dynamic> json) => Calculatedbill(
        data: CalculatedbillData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class CalculatedbillData {
  String id;
  String journeyId;
  String journeyUserId;
  String userId;
  String adminCommisionFromUser;
  String adminCommisionFromCompany;
  String totalAdminCommision;
  String companyTicketAmount;
  String requestedCurrencyCode;
  String requestedCurrencySymbol;
  String serviceTaxPercentage;
  String serviceTax;
  String ticketNumber;
  String promoDiscount;
  String totalAmount;
  String createdAt;
  String updatedAt;

  CalculatedbillData({
    required this.id,
    required this.journeyId,
    required this.journeyUserId,
    required this.userId,
    required this.adminCommisionFromUser,
    required this.adminCommisionFromCompany,
    required this.totalAdminCommision,
    required this.companyTicketAmount,
    required this.requestedCurrencyCode,
    required this.requestedCurrencySymbol,
    required this.serviceTaxPercentage,
    required this.serviceTax,
    required this.ticketNumber,
    required this.promoDiscount,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalculatedbillData.fromJson(Map<String, dynamic> json) =>
      CalculatedbillData(
        id: json["id"]?.toString() ?? '',
        journeyId: json["journey_id"]?.toString() ?? '',
        journeyUserId: json["journey_user_id"]?.toString() ?? '',
        userId: json["user_id"]?.toString() ?? '',
        adminCommisionFromUser:
            json["admin_commision_from_user"]?.toString() ?? '',
        adminCommisionFromCompany:
            json["admin_commision_from_company"]?.toString() ?? '',
        totalAdminCommision: json["total_admin_commision"]?.toString() ?? '',
        companyTicketAmount: json["company_ticket_amount"]?.toString() ?? '',
        requestedCurrencyCode:
            json["requested_currency_code"]?.toString() ?? '',
        requestedCurrencySymbol:
            json["requested_currency_symbol"]?.toString() ?? '',
        serviceTaxPercentage: json["service_tax_percentage"]?.toString() ?? '',
        serviceTax: json["service_tax"]?.toString() ?? '',
        ticketNumber: json["ticket_number"]?.toString() ?? '',
        promoDiscount: json["promo_discount"]?.toString() ?? '',
        totalAmount: json["total_amount"]?.toString() ?? '',
        createdAt: json["created_at"]?.toString() ?? '',
        updatedAt: json["updated_at"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "journey_id": journeyId,
        "journey_user_id": journeyUserId,
        "user_id": userId,
        "admin_commision_from_user": adminCommisionFromUser,
        "admin_commision_from_company": adminCommisionFromCompany,
        "total_admin_commision": totalAdminCommision,
        "company_ticket_amount": companyTicketAmount,
        "requested_currency_code": requestedCurrencyCode,
        "requested_currency_symbol": requestedCurrencySymbol,
        "service_tax_percentage": serviceTaxPercentage,
        "service_tax": serviceTax,
        "ticket_number": ticketNumber,
        "promo_discount": promoDiscount,
        "total_amount": totalAmount,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class JourneyUser {
  List<JourneyUserData> data;

  JourneyUser({
    required this.data,
  });

  factory JourneyUser.fromJson(Map<String, dynamic> json) => JourneyUser(
        data: List<JourneyUserData>.from(
            json["data"].map((x) => JourneyUserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
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
  String requestedCurrencySymbol;

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
    required this.requestedCurrencySymbol,
  });

  factory JourneyUserData.fromJson(Map<String, dynamic> json) =>
      JourneyUserData(
        id: json["id"]?.toString() ?? '0',
        journeyId: json["journey_id"]?.toString() ?? '0',
        userId: json["user_id"]?.toString() ?? '0',
        bookingUserName: json["booking_user_name"]?.toString() ?? '',
        isCancelled: json["is_cancelled"]?.toString() ?? '0',
        isCompleted: json["is_completed"]?.toString() ?? '0',
        cancelledAt: json["cancelled_at"]?.toString() ?? '',
        cancelledBy: json["cancelled_by"]?.toString() ?? '',
        ticketNumber: json["ticket_number"]?.toString() ?? '',
        boardingId: json["boarding_id"]?.toString() ?? '0',
        dropId: json["drop_id"]?.toString() ?? '0',
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
        userRated: json["user_rated"]?.toString() ?? '0',
        rating: json["rating"]?.toString() ?? '0',
        ticketFare: json["ticket_fare"]?.toString() ?? '0',
        isTripStarted: json["is_trip_started"] ?? false,
        passengerCount: json["passenger_count"]?.toString() ?? '0',
        journeyBoardingPoints:
            JourneyBoardingPoints.fromJson(json["journey_boarding_points"]),
        journeyDropPoints:
            JourneyDropPoints.fromJson(json["journey_drop_points"]),
        paymentDuration: json["payment_duration"]?.toString() ?? '0',
        userTravelDuration: json["user_travel_duration"]?.toString() ?? '0',
        journeyPassengerDetail:
            JourneyPassengerDetail.fromJson(json["journeyPassengerDetail"]),
        requestedCurrencySymbol: json["requested_currency_symbol"] ?? '',
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
        "is_paid": isPaid.toString(),
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
        "payment_duration": paymentDuration.toString(),
        "user_travel_duration": userTravelDuration.toString(),
        "journeyPassengerDetail": journeyPassengerDetail.toJson(),
      };
}

class UpcomingjourneyUser {
  UpcomingjourneyUserData data;

  UpcomingjourneyUser({
    required this.data,
  });

  factory UpcomingjourneyUser.fromJson(Map<String, dynamic> json) =>
      UpcomingjourneyUser(
        data: UpcomingjourneyUserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class UpcomingjourneyUserData {
  String id;
  String journeyId;
  String userId;
  String bookingUserName;
  String isCancelled;
  String isCompleted;
  dynamic cancelledAt;
  dynamic cancelledBy;
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
  String busBrand;
  String company;
  String mobile;
  String email;
  String userRated;
  String rating;
  String seatType;
  String ticketFare;
  bool isTripStarted;
  String passengerCount;
  JourneyBoardingPoints journeyBoardingPoints;
  JourneyDropPoints journeyDropPoints;
  String paymentDuration;
  String userTravelDuration;
  String requestedCurrencySymbol;
  bool supportTicketExists;
  BannerImage journeyPassengerDetail;
  String polyLine;

  UpcomingjourneyUserData({
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
    required this.busBrand,
    required this.company,
    required this.mobile,
    required this.email,
    required this.userRated,
    required this.rating,
    required this.seatType,
    required this.ticketFare,
    required this.isTripStarted,
    required this.passengerCount,
    required this.journeyBoardingPoints,
    required this.journeyDropPoints,
    required this.paymentDuration,
    required this.userTravelDuration,
    required this.requestedCurrencySymbol,
    required this.supportTicketExists,
    required this.journeyPassengerDetail,
    required this.polyLine,
  });

  factory UpcomingjourneyUserData.fromJson(Map<String, dynamic> json) =>
      UpcomingjourneyUserData(
        id: json["id"]?.toString() ?? '0',
        journeyId: json["journey_id"]?.toString() ?? '0',
        userId: json["user_id"]?.toString() ?? '0',
        bookingUserName: json["booking_user_name"]?.toString() ?? '',
        isCancelled: json["is_cancelled"]?.toString() ?? '0',
        isCompleted: json["is_completed"]?.toString() ?? '0',
        cancelledAt: json["cancelled_at"]?.toString() ?? '',
        cancelledBy: json["cancelled_by"]?.toString() ?? '',
        ticketNumber: json["ticket_number"]?.toString() ?? '',
        boardingId: json["boarding_id"]?.toString() ?? '0',
        dropId: json["drop_id"]?.toString() ?? '0',
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
        busBrand: json["bus_brand"]?.toString() ?? '',
        company: json["company"]?.toString() ?? '',
        mobile: json["mobile"]?.toString() ?? '',
        email: json["email"]?.toString() ?? '',
        userRated: json["user_rated"]?.toString() ?? '0',
        rating: json["rating"]?.toString() ?? '0',
        seatType: json["seat_type"]?.toString() ?? '0',
        ticketFare: json["ticket_fare"]?.toString() ?? '0',
        isTripStarted: json["is_trip_started"] ?? false,
        passengerCount: json["passenger_count"]?.toString() ?? '0',
        journeyBoardingPoints:
            JourneyBoardingPoints.fromJson(json["journey_boarding_points"]),
        journeyDropPoints:
            JourneyDropPoints.fromJson(json["journey_drop_points"]),
        paymentDuration: json["payment_duration"]?.toString() ?? '0',
        userTravelDuration: json["user_travel_duration"]?.toString() ?? '0',
        requestedCurrencySymbol: json["requested_currency_symbol"] ?? '',
        supportTicketExists: json["support_ticket_exists"],
        journeyPassengerDetail:
            BannerImage.fromJson(json["journeyPassengerDetail"]),
        polyLine: json["poly_line"]?.toString() ?? '',
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
        "bus_brand": busBrand,
        "company": company,
        "mobile": mobile,
        "email": email,
        "user_rated": userRated,
        "rating": rating,
        "seat_type": seatType,
        "ticket_fare": ticketFare,
        "is_trip_started": isTripStarted,
        "passenger_count": passengerCount,
        "journey_boarding_points": journeyBoardingPoints.toJson(),
        "journey_drop_points": journeyDropPoints.toJson(),
        "payment_duration": paymentDuration,
        "user_travel_duration": userTravelDuration,
        "requested_currency_symbol": requestedCurrencySymbol,
        "support_ticket_exists": supportTicketExists,
        "journeyPassengerDetail": journeyPassengerDetail.toJson(),
        "poly_line": polyLine,
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

  factory JourneyBoardingPoints.fromJson(Map<String, dynamic> json) =>
      JourneyBoardingPoints(
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

  factory JourneyDropPoints.fromJson(Map<String, dynamic> json) =>
      JourneyDropPoints(
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

  factory JourneyPassengerDetail.fromJson(Map<String, dynamic> json) =>
      JourneyPassengerDetail(
        data: List<JourneyPassengerDetailData>.from(
            json["data"].map((x) => JourneyPassengerDetailData.fromJson(x))),
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

  factory JourneyPassengerDetailData.fromJson(Map<String, dynamic> json) =>
      JourneyPassengerDetailData(
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

class Wallet {
  WalletData data;

  Wallet({
    required this.data,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        data: WalletData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class WalletData {
  String id;
  int userId;
  double amountAdded;
  double amountBalance;
  double amountSpent;
  String currencySymbol;
  String currencyCode;
  String createdAt;
  String updatedAt;

  WalletData({
    required this.id,
    required this.userId,
    required this.amountAdded,
    required this.amountBalance,
    required this.amountSpent,
    required this.currencySymbol,
    required this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        id: json["id"] ?? '',
        userId: json["user_id"] ?? 0,
        amountAdded: json["amount_added"]?.toDouble() ?? 0.0,
        amountBalance: json["amount_balance"]?.toDouble() ?? 0.0,
        amountSpent: json["amount_spent"]?.toDouble() ?? 0.0,
        currencySymbol: json["currency_symbol"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "amount_added": amountAdded,
        "amount_balance": amountBalance,
        "amount_spent": amountSpent,
        "currency_symbol": currencySymbol,
        "currency_code": currencyCode,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class SOS {
  List<SOSDatum> data;

  SOS({
    required this.data,
  });

  factory SOS.fromJson(Map<String, dynamic> json) => SOS(
        data: json["data"] != []
            ? List<SOSDatum>.from(json["data"].map((x) => SOSDatum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BannerImage {
  List<BannerImageData> data;

  BannerImage({
    required this.data,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) => BannerImage(
        data: List<BannerImageData>.from(
            json["data"].map((x) => BannerImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BannerImageData {
  String image;

  BannerImageData({
    required this.image,
  });

  factory BannerImageData.fromJson(Map<String, dynamic> json) =>
      BannerImageData(
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}

class SOSDatum {
  String? id;
  String? name;
  String? number;
  String? userType;
  bool? status;

  SOSDatum({
    this.id,
    this.name,
    this.number,
    this.userType,
    this.status,
  });

  factory SOSDatum.fromJson(Map<String, dynamic> json) => SOSDatum(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        number: json["number"] ?? '',
        userType: json["user_type"] ?? '',
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number": number,
        "user_type": userType,
        "status": status,
      };
}
