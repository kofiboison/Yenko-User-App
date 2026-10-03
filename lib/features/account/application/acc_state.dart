part of 'acc_bloc.dart';

enum AccStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  deleteAccount,
  bookingUserRatingsSuccess,
}

class AccState extends Equatable {
  final AccStatus status;
  final String textDirection;
  final String languageCode;
  final UserDetail? userDetail;
  final String appVersion;
  final int selectedRatingsIndex;
  final String? message;

  const AccState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.appVersion,
    required this.userDetail,
    required this.selectedRatingsIndex,
    this.message,
  });

  static AccState initial() => const AccState(
        status: AccStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        userDetail: null,
        appVersion: '',
        selectedRatingsIndex: 0,
      );

  AccState copyWith({
    AccStatus? status,
    String? textDirection,
    String? languageCode,
    UserDetail? userDetail,
    String? appVersion,
    int? selectedRatingsIndex,
    String? message,
  }) =>
      AccState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        userDetail: userDetail ?? this.userDetail,
        appVersion: appVersion ?? this.appVersion,
        selectedRatingsIndex: selectedRatingsIndex ?? this.selectedRatingsIndex,
        message: message ?? this.message,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        appVersion,
        userDetail,
        selectedRatingsIndex,
        message,
      ];
}
