part of 'filter_bloc.dart';

enum FilterStatus { initial, update }

class FilterState extends Equatable {
  final String textDirection;
  final bool showFilterDetails;
  final FilterStatus status;
  final RangeValues currentRangeValue;
  final List<String> filterSeatType;
  final List<String> filterBusType;
  final List<String> filterBusPartners;
  final List<String> filterAmenities;
  final List<String> filterBordingLandmark;
  final List<String> filterDropLandmark;
  final List<FilterTypes> filterTypes;

  const FilterState({
    required this.status,
    required this.showFilterDetails,
    required this.textDirection,
    required this.currentRangeValue,
    required this.filterSeatType,
    required this.filterBusType,
    required this.filterBusPartners,
    required this.filterAmenities,
    required this.filterBordingLandmark,
    required this.filterDropLandmark,
    required this.filterTypes,
  });

  static FilterState initial() => FilterState(
        status: FilterStatus.initial,
        textDirection: 'ltr',
        showFilterDetails: false,
        currentRangeValue: const RangeValues(100, 5100),
        filterSeatType: [],
        filterBusType: [],
        filterBusPartners: [],
        filterAmenities: [],
        filterBordingLandmark: [],
        filterDropLandmark: [],
        filterTypes: [
          FilterTypes(
              type: 'bus', typeName: 'Ac', typeImage: AppImages.acImage),
          FilterTypes(
              type: 'bus', typeName: 'Non-Ac', typeImage: AppImages.nonAcImage),
          FilterTypes(
              type: 'seat',
              typeName: 'Seater',
              typeImage: AppImages.seaterImage),
          FilterTypes(
              type: 'seat',
              typeName: 'Sleeper',
              typeImage: AppImages.sleeperImage),
          FilterTypes(
              type: 'seat',
              typeName: 'Semi-sleeper',
              typeImage: AppImages.semiSleeper),
        ],
      );

  FilterState copyWith({
    FilterStatus? status,
    String? textDirection,
    bool? showFilterDetails,
    RangeValues? currentRangeValue,
    List<String>? filterSeatType,
    List<String>? filterBusType,
    List<String>? filterBusPartners,
    List<String>? filterAmenities,
    List<String>? filterBordingLandmark,
    List<String>? filterDropLandmark,
    List<FilterTypes>? filterTypes,
  }) =>
      FilterState(
        status: status ?? this.status,
        showFilterDetails: showFilterDetails ?? this.showFilterDetails,
        textDirection: textDirection ?? this.textDirection,
        currentRangeValue: currentRangeValue ?? this.currentRangeValue,
        filterSeatType: filterSeatType ?? this.filterSeatType,
        filterBusType: filterBusType ?? this.filterBusType,
        filterBusPartners: filterBusPartners ?? this.filterBusPartners,
        filterAmenities: filterAmenities ?? this.filterAmenities,
        filterBordingLandmark:
            filterBordingLandmark ?? this.filterBordingLandmark,
        filterDropLandmark: filterDropLandmark ?? this.filterDropLandmark,
        filterTypes: filterTypes ?? this.filterTypes,
      );

  @override
  List get props => [
        status,
        showFilterDetails,
        textDirection,
        currentRangeValue,
        filterSeatType.map((e)=>e).hashCode,
        filterBusType.map((e)=>e).hashCode,
        filterBusPartners.map((e)=>e).hashCode,
        filterAmenities.map((e)=>e).hashCode,
        filterBordingLandmark.map((e)=>e).hashCode,
        filterDropLandmark.map((e)=>e).hashCode,
        filterTypes.map((e)=>e).hashCode,
      ];
}
