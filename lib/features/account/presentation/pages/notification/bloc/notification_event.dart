part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class NotificationGetDirectionEvent extends NotificationEvent {}

class NotificationUpdateEvent extends NotificationEvent {}


class NotificationGetEvent extends NotificationEvent {
  final int? pageNumber;

  NotificationGetEvent({this.pageNumber});
}

class DeleteNotificationEvent extends NotificationEvent {
  final String id;

  DeleteNotificationEvent({required this.id});
}

class ClearAllNotificationsEvent extends NotificationEvent {}

class NotificationPageInitEvent extends NotificationEvent {}

class NotificationPageScrollListenerEvent extends NotificationEvent {}

class LoadMoreUpdateEvent extends NotificationEvent {
  final bool loadMore;

  LoadMoreUpdateEvent({required this.loadMore});

}