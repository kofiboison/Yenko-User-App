import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:bus_booking/features/bus/domain/models/bus_seat_details_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math.dart' as vector;

import '../../../common/common.dart';
import '../../../core/utils/custom_debouncer.dart';
import '../../../di/locator.dart';
import '../../booking/domain/models/ticket_booking_model.dart';
import '../domain/models/popular_routes_model.dart';
import '../domain/models/search_places_model.dart';
import '../domain/models/user_details_model.dart';
import 'usecase/home_usecases.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final formKey = GlobalKey<FormState>();
  String textDirection = 'ltr';
  String languageCode = '';
  bool isLoading = false;
  bool loadMore = false;
  bool sendNotifications = false;

  UserDetail? userData;
  SearchPlacesModel? searchPlaces;
  BusSeatDetailModelData? busSeatDetailModelData;
  GoogleMapController? googleMapController;

  List<PopularRoutesModel> popularRoutes = [];
  StreamSubscription<DatabaseEvent>? trackingStream;

  TextEditingController fromAddressController = TextEditingController();
  TextEditingController toAddressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String fromId = '';
  String toId = '';
  String selectedDate = '';
  String fromCity = '';
  String promoErrorText = '';
  String fromShortCode = '';
  String toCity = '';
  String boardingId = "";
  String toShortCode = '';
  String showDate = '';
  String totalAmount = '';
  String dialCode = '+233';
  String flagImage = '${AppConstants.baseUrl}image/country/flags/GN.png';
  int bannerIndex = 0;

  DateTime pickedDate = DateTime.now();
  final debouncer = Debouncer(milliseconds: 1000);

  ScrollController scrollController = ScrollController();

  PopularRoutesModel? popularRoutesModel;

  BitmapDescriptor? busIcon;
  LatLng? busLocation;
  double? busHeading;

  final StreamController<LatLng> _busLocationController = StreamController<LatLng>.broadcast();
  Stream<LatLng> get busLocationStream => _busLocationController.stream;

  List<Marker> markers = [];
  Set<Polyline> polylines = {};
  dynamic vsync;
  Animation<double>? _animation;
  AnimationController? animationController;

  List<Map<String, dynamic>> firebaseBoardingPoints = [];
  List<Map<String, dynamic>> firebaseStoppingPoints = [];
  Set<String> reachedPointIds = {};
  LatLngBounds? bound;

  HomeBloc() : super(HomeInitialState()) {
    // update
    on<UpdateEvent>((event, emit) => emit(HomeUpdateState()));
    on<UpdateMarkersEvent>(updateMarkers);
    on<UpdateVsyncEvent>((event, emit) {
      vsync = event.vsync;
      emit(HomeUpdateState());
    });
    on<UpdatePolyLineEvent>(updatePolyline);
    on<GetDirectionEvent>(getDirection);
    // HomePage
    on<GetUserDetailsEvent>(getUserDetails);
    on<GetSearchPlacesEvent>(getSearchPlaces);
    on<SelectDateEvent>(selectDate);
    on<ToggleNotificationsEvent>(toggleNotification);
    on<PopularRoutesEvent>(_popularRoutes);
    on<GetPopularRoutesEvent>(_getPopularRoutes);
    on<ReplaceBoardingDropEvent>(replacePoints);
    on<StartLiveTrackingEvent>(_onStartLiveTracking);
    on<_TrackingDataUpdatedEvent>(_onTrackingDataUpdated);

    //polyline
    loadBusIcon();
  }

  Future<void> loadBusIcon() async {
    if (busIcon != null) return;

    try {
      busIcon = await BitmapDescriptor.asset(const ImageConfiguration(size: Size(25, 40)), AppImages.bus);
    } catch (e) {
      debugPrint('Failed to load custom bus icon: $e');
      busIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  // polyline
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polylineCoordinates.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return polylineCoordinates;
  }

  Future<BitmapDescriptor> createNumberMarker(String number) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(120, 120);
    final paint = Paint()..color = Colors.blue;
    final radius = 50.0;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: number,
        style: const TextStyle(
          fontSize: 50,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<Set<Marker>> buildNumberMarkers(
      {required List<LatLng> bordingPoints, required List<LatLng> dropPoints}) async {
    final markers = <Marker>{};
    // final icon = await createNumberMarker('${i + 1}');
    if (bordingPoints.isNotEmpty) {
      for (int i = 0; i < bordingPoints.length; i++) {
        markers.add(Marker(
          markerId: MarkerId('boarding_$i'),
          position: bordingPoints[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Boarding ${i + 1}'),
        ));
      }
    }
    if (dropPoints.isNotEmpty) {
      for (int i = 0; i < dropPoints.length; i++) {
        markers.add(Marker(
          markerId: MarkerId('drop_$i'),
          position: dropPoints[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Drop ${i + 1}'),
        ));
      }
    }
    return markers;
  }

  Future<void> getDirection(GetDirectionEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingStartState());
    languageCode = await AppSharedPreference.getSelectedLanguageCode();
    textDirection = await AppSharedPreference.getLanguageDirection();
    emit(HomeLoadingStopState());
  }

  Future<void> toggleNotification(ToggleNotificationsEvent event, Emitter<HomeState> emit) async {
    sendNotifications = event.value;
    emit(HomeUpdateState());
  }

  // UserDetails
  FutureOr<void> getUserDetails(GetUserDetailsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingStartState());
    textDirection = await AppSharedPreference.getLanguageDirection();
    final data = await serviceLocator<HomeUsecase>().userDetails();
    await data.fold(
      (error) {
        debugPrint(error.toString());
        if (error.message == 'logout' || error.statusCode == 401 || error.statusCode == 400) {
          emit(LogoutState());
        } else {
          emit(HomeLoadingStopState());
        }
      },
      (success) async {
        userData = success.data;
        if (event.isFirstCall != null && event.isFirstCall!) {
          emit(UpdateZoneLocationState());

          if (userData != null && userData!.calculatedbill != null && userData!.journeyUser != null) {
            emit(PaymentPendingState(
                userData: userData!,
                bookingData: TicketBookingModel(
                    success: true,
                    journeyUser: BookingJourneyUser.fromJson(userData!.journeyUser!.toJson()),
                    calculatedbill: BookingCalculatedbill.fromJson(userData!.calculatedbill!.toJson()))));
          }
        }
        emit(HomeUpdateState());
      },
    );
  }

  FutureOr<void> getSearchPlaces(GetSearchPlacesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingStartState());
    final data = await serviceLocator<HomeUsecase>().getSearchPlaces(search: event.searchText);
    await data.fold(
      (error) {
        debugPrint(error.toString());
        if (error.message == 'logout' || error.statusCode == 401 || error.statusCode == 400) {
          emit(LogoutState());
        } else {
          emit(HomeLoadingStopState());
        }
      },
      (success) async {
        searchPlaces = success;
        emit(HomeUpdateState());
      },
    );
  }

  FutureOr<void> selectDate(SelectDateEvent event, Emitter<HomeState> emit) async {
    final day = event.selectedDate.day.toString().padLeft(2, '0');
    final month = event.selectedDate.month.toString().padLeft(2, '0');
    final year = event.selectedDate.year;
    final formattedDate = '$day/$month/$year';
    dateController.text = formattedDate;
    pickedDate = event.selectedDate;
    emit(HomeUpdateState());
  }

  Future<void> _popularRoutes(PopularRoutesEvent event, Emitter<HomeState> emit) async {
    final route = event.route;

    fromAddressController.text = route.fromCityName;
    toAddressController.text = route.toCityName;
    pickedDate = DateTime.now();
    dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);

    fromId = route.fromCity.toString();
    toId = route.toCity.toString();
    fromCity = route.fromCityName;
    toCity = route.toCityName;
    fromShortCode = route.fromShortCode;
    toShortCode = route.toShortCode;

    selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

    emit(HomeUpdateState());
    emit(SearchBusState());
  }

  Future<void> _getPopularRoutes(GetPopularRoutesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingStartState());
    final data = await serviceLocator<HomeUsecase>().getRecentRoutes();
    await data.fold(
      (error) {
        debugPrint(error.toString());
        if (error.message == 'logout' || error.statusCode == 401 || error.statusCode == 400) {
          emit(LogoutState());
        } else {
          emit(HomeLoadingStopState());
        }
      },
      (success) async {
        popularRoutesModel = success;
        emit(HomeUpdateState());
      },
    );
  }

  /// Live Tracking - start listening
  Future<void> _onStartLiveTracking(StartLiveTrackingEvent event, Emitter<HomeState> emit) async {
    debugPrint("Journey ID ${event.journeyId}");

    await trackingStream?.cancel();
    trackingStream =
        FirebaseDatabase.instance.ref('request/${event.journeyId}').onValue.listen((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        final rawData = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        add(_TrackingDataUpdatedEvent(rawData));
      }
    });
  }

  void _onTrackingDataUpdated(
    _TrackingDataUpdatedEvent event,
    Emitter<HomeState> emit,
  ) {
    debugPrint("Raw Firebase Data: ${event.data}");

    final rawBoardingPoints = event.data['boarding_points'];
    final rawStoppingPoints = event.data['drop_points'];
    final boardingPoints = <Map<String, dynamic>>[];
    final stoppingPoints = <Map<String, dynamic>>[];
    final reachedIds = <String>{};

    bool shouldEndTracking = false;

    // boarding points
    if (rawBoardingPoints is List) {
      for (var point in rawBoardingPoints) {
        if (point == null) continue;
        final p = Map<String, dynamic>.from(point as Map);
        final boardingId = p["boarding_id"]?.toString() ?? "";
        final reachedTime = p["reached_time"]?.toString() ?? "";

        boardingPoints.add({
          "boarding_id": boardingId,
          "boarding_lat": p["boarding_lat"] ?? 0,
          "boarding_lng": p["boarding_lng"] ?? 0,
          "boarding_time": p["boarding_time"] ?? "",
          "boarding_landmark": p["boarding_landmark"] ?? "",
          "reached_time": reachedTime,
          "delay_time": p["delay_time"] ?? "",
        });

        if (reachedTime.isNotEmpty) {
          reachedIds.add(boardingId);
        }
      }
    } else if (rawBoardingPoints is Map) {
      rawBoardingPoints.forEach((key, value) {
        final p = Map<String, dynamic>.from(value as Map);
        final boardingId = p["boarding_id"]?.toString() ?? "";
        final reachedTime = p["reached_time"]?.toString() ?? "";

        boardingPoints.add({
          "boarding_id": boardingId,
          "boarding_lat": p["boarding_lat"] ?? 0,
          "boarding_lng": p["boarding_lng"] ?? 0,
          "boarding_time": p["boarding_time"] ?? "",
          "boarding_landmark": p["boarding_landmark"] ?? "",
          "reached_time": reachedTime,
          "delay_time": p["delay_time"] ?? "",
        });

        if (reachedTime.isNotEmpty) {
          reachedIds.add(boardingId);
        }
      });
    }

    // stopping points
    if (rawStoppingPoints is List) {
      // Check if last stop point has reached_time
      if (rawStoppingPoints.isNotEmpty) {
        final lastPoint = rawStoppingPoints.last;
        if (lastPoint != null) {
          final p = Map<String, dynamic>.from(lastPoint as Map);
          final reachedTime = p["reached_time"]?.toString() ?? "";
          if (reachedTime.isNotEmpty) {
            shouldEndTracking = true;
            reachedIds.add('destination');
          }
        }
      }

      for (var point in rawStoppingPoints) {
        if (point == null) continue;
        final p = Map<String, dynamic>.from(point as Map);
        final stopId = p["stop_id"]?.toString() ?? "";
        final reachedTime = p["reached_time"]?.toString() ?? "";

        stoppingPoints.add({
          "stop_id": stopId,
          "stop_lat": p["stop_lat"] ?? 0,
          "stop_lng": p["stop_lng"] ?? 0,
          "stop_time": p["stop_time"] ?? "",
          "stop_landmark": p["stop_landmark"] ?? "",
          "reached_time": reachedTime,
          "delay_time": p["delay_time"] ?? "",
        });

        if (reachedTime.isNotEmpty) {
          reachedIds.add(stopId);
        }
      }
    } else if (rawStoppingPoints is Map) {
      // Get the last key to check if destination is reached
      if (rawStoppingPoints.isNotEmpty) {
        final lastKey = rawStoppingPoints.keys.last;
        final lastPoint = rawStoppingPoints[lastKey];
        if (lastPoint != null) {
          final p = Map<String, dynamic>.from(lastPoint as Map);
          final reachedTime = p["reached_time"]?.toString() ?? "";
          if (reachedTime.isNotEmpty) {
            shouldEndTracking = true;
            reachedIds.add('destination');
          }
        }
      }

      rawStoppingPoints.forEach((key, value) {
        final p = Map<String, dynamic>.from(value as Map);
        final stopId = p["stop_id"]?.toString() ?? "";
        final reachedTime = p["reached_time"]?.toString() ?? "";

        stoppingPoints.add({
          "stop_id": stopId,
          "stop_lat": p["stop_lat"] ?? 0,
          "stop_lng": p["stop_lng"] ?? 0,
          "stop_time": p["stop_time"] ?? "",
          "stop_landmark": p["stop_landmark"] ?? "",
          "reached_time": reachedTime,
          "delay_time": p["delay_time"] ?? "",
        });

        if (reachedTime.isNotEmpty) {
          reachedIds.add(stopId);
        }
      });
    }

    // Process bus location
    if (event.data.containsKey('location')) {
      final loc = Map<String, dynamic>.from(event.data['location']);
      final lat = double.tryParse(loc['lat'].toString()) ?? 0.0;
      final lng = double.tryParse(loc['lng'].toString()) ?? 0.0;

      if (lat != 0.0 && lng != 0.0) {
        // Calculate heading if we have a previous location
        if (busLocation != null) {
          final prevLocation = busLocation!;
          final dx = lng - prevLocation.longitude;
          final dy = lat - prevLocation.latitude;
          busHeading = (math.atan2(dy, dx) * 180 / math.pi) + 90;
        }

        if (vsync != null) {
          animationController = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 1500));
          animateCar(busLocation!.latitude, busLocation!.longitude, lat, lng, vsync, animationController, 'bus_marker',
              busIcon);
        }

        busLocation = LatLng(lat, lng);

        _busLocationController.add(busLocation!);

        emit(BusLocationUpdatedState(
          busLocation: busLocation!,
          heading: busHeading,
        ));
      }
    }
    firebaseBoardingPoints = boardingPoints;
    firebaseStoppingPoints = stoppingPoints;
    reachedPointIds = reachedIds;
    emit(LiveTrackingUpdatedState(
      shouldEndTracking: shouldEndTracking,
    ));

    if (shouldEndTracking) {
      trackingStream?.cancel();
    }
  }

  Future<void> replacePoints(ReplaceBoardingDropEvent event, Emitter<HomeState> emit) async {
    final val1 = fromCity;
    final val2 = toCity;

    final val3 = fromId;
    final val4 = toId;

    final val5 = fromAddressController.text;
    final val6 = toAddressController.text;

    final val7 = fromShortCode;
    final val8 = toShortCode;

    fromCity = val2;
    toCity = val1;
    fromId = val4;
    toId = val3;
    fromAddressController.text = val6;
    toAddressController.text = val5;
    fromShortCode = val8;
    toShortCode = val7;

    emit(HomeUpdateState());
  }

  Future<void> updateMarkers(UpdateMarkersEvent event, Emitter<HomeState> emit) async {
    if (event.boardingLatLng.isNotEmpty) {
      for (int i = 0; i < event.boardingLatLng.length; i++) {
        markers.add(Marker(
          markerId: MarkerId('boarding_$i'),
          position: event.boardingLatLng[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Boarding ${i + 1}'),
        ));
      }
    }
    if (event.stopLatLng.isNotEmpty) {
      for (int i = 0; i < event.stopLatLng.length; i++) {
        markers.add(Marker(
          markerId: MarkerId('drop_$i'),
          position: event.stopLatLng[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Drop ${i + 1}'),
        ));
      }
    }
    if (busLocation != null && busIcon != null) {
      markers.add(Marker(
        markerId: const MarkerId('bus_marker'),
        position: busLocation!,
        icon: busIcon!,
        flat: true,
        rotation: 0.0,
      ));
    }
    emit(HomeUpdateState());
  }

  Future<void> updatePolyline(UpdatePolyLineEvent event, Emitter<HomeState> emit) async {
    if (event.polyString.isNotEmpty) {
      final poly = decodePolyline(event.polyString);

      polylines.add(Polyline(
        polylineId: const PolylineId('journey_polyline'),
        points: poly,
        color: Colors.blue,
        width: 4,
      ));
      emit(HomeUpdateState());
    }
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();

    double lng = (begin.longitude - end.longitude).abs();

    if (lat != 0 && lat != 0.0 && lng != 0 && lng != 0.0) {
      if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
        return vector.degrees(math.atan(lng / lat));
      } else if (begin.latitude >= end.latitude && begin.longitude < end.longitude) {
        return (90 - vector.degrees(math.atan(lng / lat))) + 90;
      } else if (begin.latitude >= end.latitude && begin.longitude >= end.longitude) {
        return vector.degrees(math.atan(lng / lat)) + 180;
      } else if (begin.latitude < end.latitude && begin.longitude >= end.longitude) {
        return (90 - vector.degrees(math.atan(lng / lat))) + 270;
      }
    }

    return 0.0;
  }

  animateCar(
    double fromLat, //Starting latitude

    double fromLong, //Starting longitude

    double toLat, //Ending latitude

    double toLong, //Ending longitude

    TickerProvider provider, //Ticker provider of the widget. This is used for animation

    dynamic controller, //Google map controller of our widget

    markerid,
    icon,
  ) async {
    double? bearing;
    dynamic carMarker;

    if (googleMapController != null) {
      googleMapController!.animateCamera(CameraUpdate.newLatLng(LatLng(toLat, toLong)));
    }

    carMarker = Marker(
        markerId: MarkerId(markerid),
        position: LatLng(fromLat, fromLong),
        icon: icon,
        rotation: 0.0,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        draggable: false);

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController!)
      ..addListener(() async {
        markers.removeWhere((element) => element.markerId == MarkerId(markerid.toString()));

        final v = _animation!.value;

        double lat = v * toLat + (1 - v) * fromLat;
        double lng = v * toLong + (1 - v) * fromLong;

        LatLng newPos = LatLng(lat, lng);

        //New marker location

        bearing = getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));
        carMarker = Marker(
            markerId: MarkerId(markerid),
            position: newPos,
            icon: icon,
            rotation: bearing ?? 0.0,
            anchor: const Offset(0.5, 0.5),
            flat: true,
            draggable: false);

        markers.add(carMarker);
        add(UpdateEvent());
      });

    //Starting the animation
    await animationController!.forward();
    animationController = null;
  }

  @override
  Future<void> close() {
    fromAddressController.dispose();
    toAddressController.dispose();
    dateController.dispose();
    searchController.dispose();
    trackingStream?.cancel();
    _busLocationController.close();
    animationController?.dispose();
    _animation = null;
    return super.close();
  }
}
