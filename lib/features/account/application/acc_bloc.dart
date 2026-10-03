import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../common/common.dart';
import '../../../di/locator.dart';
import '../../home/application/usecase/home_usecases.dart';
import '../../home/domain/models/user_details_model.dart';
import 'usecase/acc_usecases.dart';
part 'acc_event.dart';

part 'acc_state.dart';

class AccBloc extends Bloc<AccEvent, AccState> {
  AccBloc() : super(AccState.initial()) {
    on<AccUpdateEvent>(
        (event, emit) => emit(state.copyWith(status: AccStatus.update)));
    on<AccountPageInitEvent>((event, emit) =>
        emit(state.copyWith(userDetail: event.userDetailData)));
    on<AccGetDirectionEvent>(getDirection);
    on<AccGetUserDetailsEvent>(getUserDetails);

    on<GetAppInfoEvent>(getAppInfo);
    on<LogoutEvent>(logout);
    on<DeleteAccountEvent>(deleteAccount);
    on<UserRatingsEvent>(userRatings);
    on<RatingsSelectEvent>(ratingsSelectEvent);
  }

  Future<void> getAppInfo(GetAppInfoEvent event, Emitter<AccState> emit) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    emit(state.copyWith(appVersion: '$version+$buildNumber'));
  }

  //Get Direction
  Future<void> getDirection(AccEvent event, Emitter<AccState> emit) async {
    emit(state.copyWith(status: AccStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(
        status: AccStatus.loaded,
        languageCode: languageCode,
        textDirection: textDirection));
  }

  Future<void> getUserDetails(
      AccGetUserDetailsEvent event, Emitter<AccState> emit) async {
    final data = await serviceLocator<HomeUsecase>().userDetails();
    data.fold((error) {
      printWrapped(error.toString());
    }, (success) {
      emit(state.copyWith(userDetail: success.data));
    });
  }

  //ratings
  Future<void> userRatings(
      UserRatingsEvent event, Emitter<AccState> emit) async {
    final data = await serviceLocator<AccUsecase>().userReview(
      ticketNumber: event.ticketNumber,
      ratings: event.ratings,
      feedBack: event.feedBack,
      journeyId: event.journeyId,
    );

    data.fold(
      (error) {
        debugPrint(error.toString());
        if (error.message == 'logout') {
          emit(
              state.copyWith(status: AccStatus.logOut, message: error.message));
        } else {
          emit(state.copyWith(status: AccStatus.error, message: error.message));
        }
      },
      (success) {
        emit(state.copyWith(
          status: AccStatus.bookingUserRatingsSuccess,
          message: success['message'],
        ));
      },
    );
  }

  // Reviews
  Future<void> ratingsSelectEvent(
      RatingsSelectEvent event, Emitter<AccState> emit) async {
    emit(state.copyWith(selectedRatingsIndex: event.selectedIndex));
  }

  // Logout
  Future<void> logout(LogoutEvent event, Emitter<AccState> emit) async {
    final data = await serviceLocator<AccUsecase>().logout();
    data.fold(
      (error) {
        printWrapped('Logout error: ${error.toString()}');
        emit(state.copyWith(status: AccStatus.logOut));
      },
      (success) {
        emit(state.copyWith(status: AccStatus.logOut));
      },
    );
  }

  // Delete account
  Future<void> deleteAccount(
      DeleteAccountEvent event, Emitter<AccState> emit) async {
    final deleteResult = await serviceLocator<AccUsecase>().deleteUserAccount();
    deleteResult.fold(
      (error) {
        printWrapped('Delete Account error: ${error.toString()}');
        emit(state.copyWith(status: AccStatus.error));
      },
      (success) {
        emit(state.copyWith(status: AccStatus.deleteAccount));
      },
    );
  }
}
