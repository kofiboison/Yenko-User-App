part of 'history_bloc.dart';

enum HistoryStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  bookingCancelSuccess,
  invoiceDownloading,
  invoiceDownloadSuccess,
  invoiceDownloadError,
}

class HistoryState extends Equatable {
  final HistoryStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final bool loadMore;
  final bool firstLoad;
  final List<BookingHistoryData> historyList;
  final int selectedHistoryType;
  final int? selectedRatingsIndex;
  final UserDetail? userData;

  const HistoryState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.firstLoad,
    required this.loadMore,
    required this.historyList,
    required this.selectedHistoryType,
    required this.selectedRatingsIndex,
    required this.userData,
  });

  static HistoryState initial() => const HistoryState(
        status: HistoryStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        firstLoad: true,
        loadMore: false,
        historyList: [],
        selectedHistoryType: 1,
        selectedRatingsIndex: 0,
        userData: null,
      );

  HistoryState copyWith({
    HistoryStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    bool? loadMore,
    bool? firstLoad,
    List<BookingHistoryData>? historyList,
    int? selectedHistoryType,
    int? selectedRatingsIndex,
    UserDetail? userData,
  }) =>
      HistoryState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        loadMore: loadMore ?? this.loadMore,
        firstLoad: firstLoad ?? this.firstLoad,
        historyList: historyList ?? this.historyList,
        selectedHistoryType: selectedHistoryType ?? this.selectedHistoryType,
        selectedRatingsIndex: selectedRatingsIndex ?? this.selectedRatingsIndex,
        userData: userData ?? this.userData,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        loadMore,
        firstLoad,
        historyList.map((e) => e).hashCode,
        selectedHistoryType,
        selectedRatingsIndex,
        userData
      ];
}
