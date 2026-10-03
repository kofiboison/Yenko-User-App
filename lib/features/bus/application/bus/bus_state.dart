part of 'bus_bloc.dart';

// abstract class BusState {}

// final class BusInitialState extends BusState {}

// final class BusUpdateState extends BusState {}

// final class LogoutState extends BusState {}

// final class BusLoadingStartState extends BusState {}

// final class BusLoadingStopState extends BusState {}

enum BusStatus {
  initial,
  loadingStart,
  loadingStop,
  loaded,
  error,
  logOut,
  update,
  updatedFilterBusType,
}

class BusState extends Equatable {
  final BusStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final bool loadMore;
  final bool? isRightSideDriverSeat;
  final BusSeatDetailModelData? selectedBus;
  final BoardingpointsData? selectedBordingPoint;
  final StoppointsData? selectedDropPoint;
  final SearchBusListPagination? searchBusListPagination;
  final JourneyFilterModel? journeyFilterModel;
  final String fromId;
  final String toId;
  final String selectedDate;
  final String fromCity;
  final String promoErrorText;
  final String fromShortCode;
  final String toCity;
  final String boardingId;
  final String toShortCode;
  final String showDate;
  final String totalAmount;
  final String selectedBoardingPointId;
  final String selectedDropPointId;
  final List<DateTime> allDates;
  final List<String> selectedSeatNo;
  final List<BusData> busList;
  final List<SeatLayoutData> selectedSeats;
  final List<SeatLayoutData> seatLayoutsLowerLeft;
  final List<SeatLayoutData> seatLayoutsLowerRight;
  final List<SeatLayoutData> seatLayoutsUpperLeft;
  final List<SeatLayoutData> seatLayoutsUpperRight;

  const BusState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.loadMore,
    required this.isRightSideDriverSeat,
    required this.selectedBus,
    required this.selectedBordingPoint,
    required this.selectedDropPoint,
    required this.searchBusListPagination,
    required this.journeyFilterModel,
    required this.fromId,
    required this.toId,
    required this.selectedDate,
    required this.fromCity,
    required this.promoErrorText,
    required this.fromShortCode,
    required this.toCity,
    required this.boardingId,
    required this.toShortCode,
    required this.showDate,
    required this.totalAmount,
    required this.selectedBoardingPointId,
    required this.selectedDropPointId,
    required this.allDates,
    required this.selectedSeatNo,
    required this.busList,
    required this.selectedSeats,
    required this.seatLayoutsLowerLeft,
    required this.seatLayoutsLowerRight,
    required this.seatLayoutsUpperLeft,
    required this.seatLayoutsUpperRight,
  });

  static BusState initial() => const BusState(
        status: BusStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        loadMore: false,
        isRightSideDriverSeat: null,
        selectedBus: null,
        selectedBordingPoint: null,
        selectedDropPoint: null,
        searchBusListPagination: null,
        journeyFilterModel: null,
        fromId: '',
        toId: '',
        selectedDate: '',
        fromCity: '',
        promoErrorText: '',
        fromShortCode: '',
        toCity: '',
        boardingId: '',
        toShortCode: '',
        showDate: '',
        totalAmount: '',
        selectedBoardingPointId: '',
        selectedDropPointId: '',
        allDates: [],
        selectedSeatNo: [],
        busList: [],
        selectedSeats: [],
        seatLayoutsLowerLeft: [],
        seatLayoutsLowerRight: [],
        seatLayoutsUpperLeft: [],
        seatLayoutsUpperRight: [],
      );

  BusState copyWith({
    BusStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    bool? loadMore,
    bool? isRightSideDriverSeat,
    BusSeatDetailModelData? selectedBus,
    BoardingpointsData? selectedBordingPoint,
    StoppointsData? selectedDropPoint,
    SearchBusListPagination? searchBusListPagination,
    JourneyFilterModel? journeyFilterModel,
    String? fromId,
    String? toId,
    String? selectedDate,
    String? fromCity,
    String? promoErrorText,
    String? fromShortCode,
    String? toCity,
    String? boardingId,
    String? toShortCode,
    String? showDate,
    String? totalAmount,
    String? selectedBoardingPointId,
    String? selectedDropPointId,
    List<DateTime>? allDates,
    List<String>? selectedSeatNo,
    List<BusData>? busList,
    List<SeatLayoutData>? selectedSeats,
    List<SeatLayoutData>? seatLayoutsLowerLeft,
    List<SeatLayoutData>? seatLayoutsLowerRight,
    List<SeatLayoutData>? seatLayoutsUpperLeft,
    List<SeatLayoutData>? seatLayoutsUpperRight,
  }) =>
      BusState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        loadMore: loadMore ?? this.loadMore,
        isRightSideDriverSeat:
            isRightSideDriverSeat ?? this.isRightSideDriverSeat,
        selectedBus: selectedBus ?? this.selectedBus,
        selectedBordingPoint: selectedBordingPoint ?? this.selectedBordingPoint,
        selectedDropPoint: selectedDropPoint ?? this.selectedDropPoint,
        searchBusListPagination:
            searchBusListPagination ?? this.searchBusListPagination,
        journeyFilterModel: journeyFilterModel ?? this.journeyFilterModel,
        fromId: fromId ?? this.fromId,
        toId: toId ?? this.toId,
        selectedDate: selectedDate ?? this.selectedDate,
        fromCity: fromCity ?? this.fromCity,
        promoErrorText: promoErrorText ?? this.promoErrorText,
        fromShortCode: fromShortCode ?? this.fromShortCode,
        toCity: toCity ?? this.toCity,
        boardingId: boardingId ?? this.boardingId,
        toShortCode: toShortCode ?? this.toShortCode,
        showDate: showDate ?? this.showDate,
        totalAmount: totalAmount ?? this.totalAmount,
        selectedBoardingPointId:
            selectedBoardingPointId ?? this.selectedBoardingPointId,
        selectedDropPointId: selectedDropPointId ?? this.selectedDropPointId,
        allDates: allDates ?? this.allDates,
        selectedSeatNo: selectedSeatNo ?? this.selectedSeatNo,
        busList: busList ?? this.busList,
        selectedSeats: selectedSeats ?? this.selectedSeats,
        seatLayoutsLowerLeft: seatLayoutsLowerLeft ?? this.seatLayoutsLowerLeft,
        seatLayoutsLowerRight:
            seatLayoutsLowerRight ?? this.seatLayoutsLowerRight,
        seatLayoutsUpperLeft: seatLayoutsUpperLeft ?? this.seatLayoutsUpperLeft,
        seatLayoutsUpperRight:
            seatLayoutsUpperRight ?? this.seatLayoutsUpperRight,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        loadMore,
        if (isRightSideDriverSeat != null) isRightSideDriverSeat!,
        if (selectedBus != null) selectedBus!,
        if (selectedBordingPoint != null) selectedBordingPoint!,
        if (selectedDropPoint != null) selectedDropPoint!,
        if (searchBusListPagination != null) searchBusListPagination!,
        if (journeyFilterModel != null) journeyFilterModel!,
        fromId,
        toId,
        selectedDate,
        fromCity,
        promoErrorText,
        fromShortCode,
        toCity,
        boardingId,
        toShortCode,
        showDate,
        totalAmount,
        selectedBoardingPointId,
        selectedDropPointId,
        allDates,
        selectedSeatNo,
        busList,
        selectedSeats,
        seatLayoutsLowerLeft,
        seatLayoutsLowerRight,
        seatLayoutsUpperLeft,
        seatLayoutsUpperRight,
      ];
}
