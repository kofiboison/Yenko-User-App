import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../common/common.dart';
import '../../../../../../di/locator.dart';
import '../../../../../home/application/usecase/home_usecases.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../application/usecase/acc_usecases.dart';
import '../../../../domain/models/contact_model.dart';

part 'sos_event.dart';

part 'sos_state.dart';

class SosBloc extends Bloc<SosEvent, SosState> {
  ScrollController scrollController = ScrollController();

  SosBloc() : super(SosState.initial()) {
    on<SosUpdateEvent>((event, emit) => emit(state.copyWith(status: SosStatus.update,isLoading:false)));
    on<UpdateSelectContactEvent>((event, emit) => emit(state.copyWith(selectedContact: event.contact)));
    // Sos Page
    on<SosGetDirectionEvent>(sosGetDirection);
    on<SosGetUserDetailsEvent>(getUserDetails);
    on<DeleteContactEvent>(_deletesos);
    on<SelectContactDetailsEvent>(selectContactDetails);
    on<AddContactEvent>(addContactDetails);
    
  }

//Get Direction
  Future<void> sosGetDirection(SosGetDirectionEvent event, Emitter<SosState> emit) async {
    emit(state.copyWith(status: SosStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(status: SosStatus.loaded,languageCode:languageCode,textDirection:textDirection));
  }

   Future<void> getUserDetails(
      SosGetUserDetailsEvent event, Emitter<SosState> emit) async {
    // emit(AccDataLoadingState());
    final data = await serviceLocator<HomeUsecase>().userDetails();
    data.fold((error) {
      printWrapped(error.toString());
    }, (success) {
      emit(state.copyWith(sosData: success.data.sos.data));
    });
  } 

  // Delete sos
  Future<void> _deletesos(
      DeleteContactEvent event, Emitter<SosState> emit) async {
    final data = await serviceLocator<AccUsecase>().deleteSosContact(event.id!);
    data.fold(
      (error) {
        debugPrint(error.toString());
      },
      (success) {
        add(SosGetUserDetailsEvent());
      },
    );
  }

  FutureOr<void> addContactDetails(
      AddContactEvent event, Emitter<SosState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<AccUsecase>()
        .addSosContact(name: event.name, number: event.number);
    data.fold(
      (error) {
        debugPrint(error.toString());
       emit(state.copyWith(isLoading: false));
      },
      (success) {
        emit(state.copyWith(isLoading: false));
        add(SosGetUserDetailsEvent());
      },
    );
  }

  Future<void> selectContactDetails(
      SelectContactDetailsEvent event, Emitter<SosState> emit) async {
    await Permission.contacts.request();
    PermissionStatus status = await Permission.contacts.status;
    if (status.isGranted) {
      emit(state.copyWith(status: SosStatus.loading));
      if (await FlutterContacts.requestPermission()) {
        emit(state.copyWith(isLoading: true));
        List<Contact> contacts =
            await FlutterContacts.getContacts(withProperties: true);
        List<ContactsModel>? cList = [];    
        for (var contact in contacts) {
          for (var phone in contact.phones) {
            cList.add(ContactsModel(
              name: contact.displayName,
              number: phone.number,
            ));
          }
        }
        emit(state.copyWith(contactsList: cList,isLoading: false));
      }

      emit(state.copyWith(status: SosStatus.selectContactDetails));
    } else {
      debugPrint("Permission Denied");
      bool isOpened = await openAppSettings();
      if (isOpened) {
      } else {}
      // emit(GetContactPermissionState());
    }
  }
}