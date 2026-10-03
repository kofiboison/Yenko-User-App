import 'dart:convert';

SearchPlacesModel searchPlacesModelFromJson(String str) => SearchPlacesModel.fromJson(json.decode(str));

String searchPlacesModelToJson(SearchPlacesModel data) => json.encode(data.toJson());

class SearchPlacesModel {
    bool success;
    String message;
    SearchPlacesData data;

    SearchPlacesModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SearchPlacesModel.fromJson(Map<String, dynamic> json) => SearchPlacesModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: SearchPlacesData.fromJson(json["data"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class SearchPlacesData {
    int currentPage;
    List<Places> data;
    String firstPageUrl;
    int from;
    int lastPage;
    String lastPageUrl;
    List<Link> links;
    dynamic nextPageUrl;
    String path;
    int perPage;
    dynamic prevPageUrl;
    int to;
    int total;

    SearchPlacesData({
        required this.currentPage,
        required this.data,
        required this.firstPageUrl,
        required this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.links,
        required this.nextPageUrl,
        required this.path,
        required this.perPage,
        required this.prevPageUrl,
        required this.to,
        required this.total,
    });

    factory SearchPlacesData.fromJson(Map<String, dynamic> json) => SearchPlacesData(
        currentPage: json["current_page"] ?? 1,
        data: List<Places>.from((json["data"] ?? []).map((x) => Places.fromJson(x))),
        firstPageUrl: json["first_page_url"] ?? "",
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 1,
        lastPageUrl: json["last_page_url"] ?? "",
        links: List<Link>.from((json["links"] ?? []).map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"] ?? "",
        perPage: json["per_page"] ?? 10,
        prevPageUrl: json["prev_page_url"],
        to: json["to"] ?? 0,
        total: json["total"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Places {
    String id;
    String city;
    String shortCode;
    dynamic landmark;
    dynamic cityLat;
    dynamic cityLng;
    String serviceLocationId;
    dynamic displayOrder;
    int active;
    dynamic stateId;
    String createdAt;
    String updatedAt;
    int? relevance;
    String serviceLocationName;
    List<BoardingPoint>? boardingPoints;
    ServiceLocation serviceLocation;

    Places({
        required this.id,
        required this.city,
        required this.shortCode,
        required this.landmark,
        required this.cityLat,
        required this.cityLng,
        required this.serviceLocationId,
        required this.displayOrder,
        required this.active,
        required this.stateId,
        required this.createdAt,
        required this.updatedAt,
        this.relevance,
        required this.serviceLocationName,
        this.boardingPoints,
        required this.serviceLocation,
    });

    factory Places.fromJson(Map<String, dynamic> json) => Places(
        id: json["id"] ?? "",
        city: json["city"] ?? "",
        shortCode: json["short_code"] ?? "",
        landmark: json["landmark"],
        cityLat: json["city_lat"],
        cityLng: json["city_lng"],
        serviceLocationId: json["service_location_id"] ?? "",
        displayOrder: json["display_order"],
        active: json["active"] ?? 0,
        stateId: json["state_id"],
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
        relevance: json["relevance"],
        serviceLocationName: json["service_location_name"] ?? "",
        boardingPoints: json["boarding_points"] == null ? [] : List<BoardingPoint>.from(json["boarding_points"]!.map((x) => BoardingPoint.fromJson(x))),
        serviceLocation: ServiceLocation.fromJson(json["service_location"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "short_code": shortCode,
        "landmark": landmark,
        "city_lat": cityLat,
        "city_lng": cityLng,
        "service_location_id": serviceLocationId,
        "display_order": displayOrder,
        "active": active,
        "state_id": stateId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "relevance": relevance,
        "service_location_name": serviceLocationName,
        "boarding_points": boardingPoints == null ? [] : List<dynamic>.from(boardingPoints!.map((x) => x.toJson())),
        "service_location": serviceLocation.toJson(),
    };
}

class BoardingPoint {
    String id;
    String boardingAddress;
    String landMark;
    double boardingLat;
    double boardingLng;
    String serviceLocationId;
    String cityId;
    String createdAt;
    String updatedAt;
    String serviceLocationName;
    String cityName;
    ServiceLocation serviceLocations;
    Places city;

    BoardingPoint({
        required this.id,
        required this.boardingAddress,
        required this.landMark,
        required this.boardingLat,
        required this.boardingLng,
        required this.serviceLocationId,
        required this.cityId,
        required this.createdAt,
        required this.updatedAt,
        required this.serviceLocationName,
        required this.cityName,
        required this.serviceLocations,
        required this.city,
    });

    factory BoardingPoint.fromJson(Map<String, dynamic> json) => BoardingPoint(
        id: json["id"] ?? "",
        boardingAddress: json["boarding_address"] ?? "",
        landMark: json["land_mark"] ?? "",
        boardingLat: json["boarding_lat"]?.toDouble() ?? 0.0,
        boardingLng: json["boarding_lng"]?.toDouble() ?? 0.0,
        serviceLocationId: json["service_location_id"] ?? "",
        cityId: json["city_id"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
        serviceLocationName: json["service_location_name"] ?? "",
        cityName: json["city_name"] ?? "",
        serviceLocations: ServiceLocation.fromJson(json["service_locations"] ?? {}),
        city: Places.fromJson(json["city"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "boarding_address": boardingAddress,
        "land_mark": landMark,
        "boarding_lat": boardingLat,
        "boarding_lng": boardingLng,
        "service_location_id": serviceLocationId,
        "city_id": cityId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "service_location_name": serviceLocationName,
        "city_name": cityName,
        "service_locations": serviceLocations.toJson(),
        "city": city.toJson(),
    };
}

class ServiceLocation {
    String id;
    dynamic companyKey;
    String name;
    dynamic translationDataset;
    String currencyName;
    String currencyCode;
    String currencySymbol;
    String currencyPointer;
    String timezone;
    int country;
    dynamic unit;
    dynamic coordinates;
    dynamic lat;
    dynamic lng;
    int active;
    String createdAt;
    String updatedAt;
    dynamic deletedAt;

    ServiceLocation({
        required this.id,
        required this.companyKey,
        required this.name,
        required this.translationDataset,
        required this.currencyName,
        required this.currencyCode,
        required this.currencySymbol,
        required this.currencyPointer,
        required this.timezone,
        required this.country,
        required this.unit,
        required this.coordinates,
        required this.lat,
        required this.lng,
        required this.active,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory ServiceLocation.fromJson(Map<String, dynamic> json) => ServiceLocation(
        id: json["id"] ?? "",
        companyKey: json["company_key"],
        name: json["name"] ?? "",
        translationDataset: json["translation_dataset"],
        currencyName: json["currency_name"] ?? "",
        currencyCode: json["currency_code"] ?? "",
        currencySymbol: json["currency_symbol"] ?? "",
        currencyPointer: json["currency_pointer"] ?? "",
        timezone: json["timezone"] ?? "",
        country: json["country"] ?? 0,
        unit: json["unit"],
        coordinates: json["coordinates"],
        lat: json["lat"],
        lng: json["lng"],
        active: json["active"] ?? 0,
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "company_key": companyKey,
        "name": name,
        "translation_dataset": translationDataset,
        "currency_name": currencyName,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "currency_pointer": currencyPointer,
        "timezone": timezone,
        "country": country,
        "unit": unit,
        "coordinates": coordinates,
        "lat": lat,
        "lng": lng,
        "active": active,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}

class Link {
    String? url;
    String label;
    bool active;

    Link({
        required this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"] ?? "",
        active: json["active"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}
