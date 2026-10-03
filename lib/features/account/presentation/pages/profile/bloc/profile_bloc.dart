import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bus_booking/core/utils/custom_loader.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../di/locator.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../application/usecase/acc_usecases.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ScrollController scrollController = ScrollController();
  final profileEditFormKey = GlobalKey<FormState>();

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileUpdateEvent>((event, emit) => emit(state.copyWith(status: event.status ?? ProfileStatus.update,isLoading:false)));
    on<GenderSelectedEvent>((event, emit)=>emit(state.copyWith(selectedGender: event.gender)));
    // Profile
    on<ProfileGetDirectionEvent>(profileGetDirection);
    on<ProfileEditInitEvent>(getProfileEdit);
    on<UpdateImageEvent>(_getProfileImage);
    on<UpdateUserDetailsEvent>(updateUserDetails);
  }

//Get Direction
  Future<void> profileGetDirection(ProfileGetDirectionEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(status: ProfileStatus.loaded,languageCode:languageCode,textDirection:textDirection));
  }

  Future<void> getProfileEdit(
      ProfileEditInitEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(userData: event.userDetailData,selectedGender:event.userDetailData.gender));
  }


  Future<void> _getProfileImage(
      UpdateImageEvent event, Emitter<ProfileState> emit) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    if (event.source == ImageSource.camera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else if (event.source == ImageSource.gallery) {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      emit(state.copyWith(profileImage: image.path));
      add(UpdateUserDetailsEvent(
        name: event.name,
        email: event.email,
        gender: event.gender,
        profileImage: image.path,
      ));
    }
  }

   //update user details
  Future<void> updateUserDetails(
      UpdateUserDetailsEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await serviceLocator<AccUsecase>().updateDetailsButton(
      email: event.email,
      name: event.name,
      gender: event.gender,
      profileImage: event.profileImage,
    );
    result.fold(
      (error) {
        emit(state.copyWith(status: ProfileStatus.loaded));
        ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
              SnackBar(content: MyText(text: error.message ?? 'Update failed')),
            );    
        if (error.message == 'logout') {
          emit(state.copyWith(status: ProfileStatus.logOut));
        }
      },
      (success) {
        emit(state.copyWith(
          status: ProfileStatus.userDetailUpdate,
          userData: UserDetail.fromJson(success["data"])));
      },
    );
  }
}