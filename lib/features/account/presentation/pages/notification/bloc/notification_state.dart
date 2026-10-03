part of 'notification_bloc.dart';

enum NotificationStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final bool loadMore;
  final List<NotificationData> notificationDatas;
  final NotificationPagination? notificationPaginations;

  const NotificationState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.loadMore,
    required this.notificationDatas,
    required this.notificationPaginations,
  });

  static NotificationState initial() => const NotificationState(
        status: NotificationStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        loadMore:false,
        notificationDatas: [],
        notificationPaginations: null,
      );

  NotificationState copyWith({
    NotificationStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    bool? loadMore,
    List<NotificationData>? notificationDatas,
    NotificationPagination? notificationPaginations,
  }) =>
      NotificationState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        loadMore: loadMore ?? this.loadMore,
        notificationDatas: notificationDatas ?? this.notificationDatas,
        notificationPaginations: notificationPaginations ?? this.notificationPaginations,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        loadMore,
        notificationDatas.map((e) => e).hashCode,
        notificationPaginations,
      ];
}
