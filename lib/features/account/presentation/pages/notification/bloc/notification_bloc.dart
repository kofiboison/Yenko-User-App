import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../di/locator.dart';
import '../../../../application/usecase/acc_usecases.dart';
import '../../../../domain/models/notifications_model.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  ScrollController scrollController = ScrollController();

  NotificationBloc() : super(NotificationState.initial()) {
    on<NotificationUpdateEvent>((event, emit) => emit(state.copyWith(status: NotificationStatus.update,isLoading:false)));
    on<LoadMoreUpdateEvent>((event, emit) => emit(state.copyWith(loadMore: event.loadMore)));
    //Notification
    on<NotificationGetDirectionEvent>(notificationGetDirection);
    on<NotificationGetEvent>(_getNotificationList);
    on<ClearAllNotificationsEvent>(_clearAllNotifications);
    on<DeleteNotificationEvent>(_deleteNotification);
    on<NotificationPageInitEvent>(notificationInitEvent);
    on<NotificationPageScrollListenerEvent>(notificationPageScrollListener);
    
  }

//Get Direction
  Future<void> notificationGetDirection(NotificationGetDirectionEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(status: NotificationStatus.loaded,languageCode:languageCode,textDirection:textDirection));
  }

  // Get Notifications
  Future<void> _getNotificationList(
      NotificationGetEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.loading,isLoading: true));
    try {
      final data = await serviceLocator<AccUsecase>()
          .notificationDetails(pageNo: event.pageNumber.toString());
      data.fold(
        (error) {
          showToast(message: error.message ?? "");
          emit(state.copyWith(status: NotificationStatus.loaded,isLoading: false));
        },
        (success) {
          emit(state.copyWith(
            status: NotificationStatus.loaded,
            isLoading: false,
            notificationDatas: success.data,
            notificationPaginations: success.meta));
        },
      );
    } catch (e) {
      showToast(message: e.toString());
    }
  }

  //Clear notification
  Future<void> _clearAllNotifications(
      ClearAllNotificationsEvent event, Emitter<NotificationState> emit) async {
    try {
      for (var value in state.notificationDatas) {
        await _deleteNotificationById(value.id);
      }
      emit(state.copyWith(notificationDatas: []));
      add(NotificationGetEvent());
    } catch (e) {
      showToast(message: e.toString());
    }
  }

  Future<void> notificationInitEvent(
      NotificationPageInitEvent event, Emitter<NotificationState> emit) async {
    add(NotificationGetEvent());
    add(NotificationPageScrollListenerEvent());
  }

  Future<void> notificationPageScrollListener(NotificationPageScrollListenerEvent event, Emitter<NotificationState> emit) async{
   scrollController.addListener(() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !state.isLoading &&
        !state.loadMore) {
      if (state.notificationPaginations != null &&
          state.notificationPaginations!.pagination != null &&
          state.notificationPaginations!.pagination.currentPage <
              state.notificationPaginations!.pagination.totalPages) {
        add(LoadMoreUpdateEvent(loadMore: true));
        add(NotificationGetEvent());
      } else {
        if (state.notificationPaginations!.pagination.currentPage ==
            state.notificationPaginations!.pagination.totalPages) {
          add(LoadMoreUpdateEvent(loadMore: false));
        }
      }
    }
   },);
  }

  // Delete notification
  Future<void> _deleteNotification(
      DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await _deleteNotificationById(event.id);
      List<NotificationData>? lnotifications = List.of(state.notificationDatas);
      lnotifications.removeWhere((value) => value.id == event.id);
      emit(state.copyWith(notificationDatas: lnotifications));
      add(NotificationGetEvent());
    } catch (e) {
      showToast(message: e.toString());
    }
  }

  Future<void> _deleteNotificationById(String id) async {
    try {
      await serviceLocator<AccUsecase>().deleteNotification(id);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }
}