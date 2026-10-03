import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../di/locator.dart';
import '../../../../application/usecase/acc_usecases.dart';
import '../../../../domain/models/service_location_model.dart';
import '../../../../domain/models/ticket_list_model.dart';
import '../../../../domain/models/ticket_names_model.dart';
import '../../../../domain/models/view_ticket_model.dart';

part 'support_event.dart';

part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final profileEditFormKey = GlobalKey<FormState>();
  final paymentKey = GlobalKey();
  List<TextEditingController> bankDetailsTextEditControllers = [];
  ScrollController scrollController = ScrollController();
  TextEditingController supportDescriptionController = TextEditingController();

  SupportBloc() : super(SupportState.initial()) {
    on<SuppotUpdateEvent>((event, emit) =>
        emit(state.copyWith(status: SupportStatus.update, isLoading: false)));
    on<TicketSheetStageUpdateEvent>((event, emit) =>
        emit(state.copyWith(isTicketSheetOpened: event.isTicketSheetOpen,status: SupportStatus.update)));
    // Support Ticket Page
    on<SuppotGetDirectionEvent>(supportGetDirection);
    on<CreateSupportTicketEvent>(createSupportTicket);
    on<MakeTicketSubmitEvent>(makeTicketSubmit);
    on<ViewTicketEvent>(viewTicketData);
    on<AddAttachmentTicketEvent>(addAttachment);
    on<ClearAttachmentEvent>(clearAttachment);
    on<TicketReplyMessageEvent>(ticketMessageReply);
    on<TicketTitleChangeEvent>(assignSelectedTicketValue);
    on<TicketAreaChangeEvent>(assignSelectedTicketArea);
    on<GetTicketListEvent>(getTicketList);
    on<GetServiceLocationEvent>(getServiceLocation);
    on<GetTicketTitleEvent>(supportTicketTitles);
  }

//Get Direction
  Future<void> supportGetDirection(
      SuppotGetDirectionEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(status: SupportStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(
        status: SupportStatus.loaded,
        languageCode: languageCode,
        textDirection: textDirection));
  }

  Future<void> makeTicketSubmit(
      MakeTicketSubmitEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<AccUsecase>().makeTicket(
        titleId: event.titleId,
        description: event.description,
        serviceLocationId: event.serviceLocationId,
        attachments: event.attachement,
        requestId: event.requestId);
    data.fold((error) {
      if (error.statusCode == 401 || error.statusCode == 400) {
          emit(state.copyWith(isLoading: false, status: SupportStatus.logOut));
      } else {
        showToast(message: error.message ?? "");
        emit(state.copyWith(isLoading: false));
      }
    }, (success) {
      showToast(message: success.message.toString());
      emit(state.copyWith(isLoading: false, selectedTicketArea: '',selectedTicketAreaId: '',selectedTicketTitle: '',selectedTicketTitleId: ''));
      if (event.isFromRequest == true) {
        // add(HistoryGetEvent(
        //     historyFilter: 'is_completed=1',
        //     historyIndex: event.index,
        //     pageNumber: event.pageNumber));
        emit(state.copyWith(status: SupportStatus.requestTicketCreatedSuccess));
      } else {
        if (!isClosed) {
          add(GetTicketListEvent(isFromAcc: false));
        }
      }
    });
  }

  Future<void> viewTicketData(
      ViewTicketEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(viewAttachments: []));
    final data =
        await serviceLocator<AccUsecase>().viewTicket(ticketId: event.id);
    data.fold((error) {
      if (error.statusCode == 401 || error.statusCode == 400) {
          emit(state.copyWith(isLoading: false, status: SupportStatus.logOut));
      } else {
        showToast(message: error.message ?? "");
        emit(state.copyWith(isLoading: false));
      }
    }, (success) {
      emit(state.copyWith(
          supportTicketData: success.supportTicket,
          viewAttachments: success.attachment,
          replyMessages: success.replyMessage));
    });
  }

  Future<void> createSupportTicket(
      CreateSupportTicketEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(selectedTicketTitle: '', ticketAttachments: []));
    final data = await serviceLocator<AccUsecase>()
        .supportTicketTitles(isFromRequest: event.isFromRequest);
    data.fold((error) {
      if (error.statusCode == 401 || error.statusCode == 400) {
          emit(state.copyWith(isLoading: false, status: SupportStatus.logOut));
      } else {
        showToast(message: error.message ?? "");
        emit(state.copyWith(isLoading: false,status: SupportStatus.error));
      }
    }, (success) {
      if (success.data.isNotEmpty) {
        emit(state.copyWith(
            status: SupportStatus.createSupportTicket,
            isLoading: false,
            ticketNamesList: success.data));
      }
    });
  }

  FutureOr<void> supportTicketTitles(
      GetTicketTitleEvent event, Emitter<SupportState> emit) async {
    if (state.ticketNamesList.isEmpty) {
      final data = await serviceLocator<AccUsecase>().supportTicketTitles(isFromRequest: event.isFromRequest);
      data.fold(
        (error) {
          if (error.statusCode == 401 || error.statusCode == 400) {
              emit(state.copyWith(isLoading: false, status: SupportStatus.logOut));
          } else {
            showToast(message: error.message ?? "");
            emit(state.copyWith(isLoading: false,status: SupportStatus.error));
          }
        },
        (success) {
          if(event.isFromRequest){
            emit(state.copyWith(status: SupportStatus.createSupportTicket,ticketNamesList: success.data));
          }else{
            emit(state.copyWith(ticketNamesList: success.data));
          }
        },
      );
    }
  }

  FutureOr<void> getServiceLocation(
      GetServiceLocationEvent event, Emitter<SupportState> emit) async {
    if (state.serviceLocations.isEmpty) {
      final data = await serviceLocator<AccUsecase>().getServiceLocation();
      data.fold(
        (error) {
          if (error.statusCode == 401 || error.statusCode == 400) {
              emit(state.copyWith(isLoading: false, status: SupportStatus.logOut));
          } else {
            showToast(message: error.message ?? "");
            emit(state.copyWith(isLoading: false,status: SupportStatus.error));
          }
        },
        (success) {
          emit(state.copyWith(serviceLocations: success.data));
        },
      );
    }
  }

  FutureOr<void> getTicketList(
      GetTicketListEvent event, Emitter<SupportState> emit) async {
    // if (event.isFromAcc == true) {
    //   emit(state.copyWith(status: SupportStatus.loading));
    // }
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<AccUsecase>().getTicketList();
    data.fold(
      (error) {
        if (error.statusCode == 401 || error.statusCode == 400) {
          emit(state.copyWith(isLoading: false, status: SupportStatus.logOut));
        } else {
          showToast(message: error.message ?? "");
          emit(state.copyWith(status: SupportStatus.loaded, isLoading: false));
        }
      },
      (success) {
        emit(state.copyWith(
            status: SupportStatus.loaded,
            isLoading: false,
            ticketList: success.data));
      },
    );
  }

  Future<void> assignSelectedTicketValue(
      TicketTitleChangeEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(
        selectedTicketTitle: event.changedTitle,
        selectedTicketTitleId: event.id));
  }

  Future<void> assignSelectedTicketArea(
      TicketAreaChangeEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(
        selectedTicketArea: event.changedArea, selectedTicketAreaId: event.id));
  }

  Future<void> clearAttachment(
      ClearAttachmentEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(ticketAttachments: []));
  }

  Future<void> addAttachment(
    AddAttachmentTicketEvent event,
    Emitter<SupportState> emit,
  ) async {
    if (state.ticketAttachments.length >= 8) {
      showToast(message: "File Limit Reached");
      return;
    }
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'jpeg', 'png'],
      );
      if (result != null) {
        final allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf', 'doc'];

        final selectedFiles = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();

        final validFiles = <File>[];
        bool hasInvalidFile = false;

        for (var file in selectedFiles) {
          final extension = file.path.split('.').last.toLowerCase();
          if (allowedExtensions.contains(extension)) {
            validFiles.add(file);
          } else {
            hasInvalidFile = true;
          }
        }
        if (hasInvalidFile) {
          showToast(message: "Some files were not supported and skipped.");
        }

        if (validFiles.isNotEmpty) {
          List<File>? attachements = List.of(state.ticketAttachments);
          attachements = [...attachements, ...validFiles].take(8).toList();
          emit(state.copyWith(ticketAttachments: attachements));
        }
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      showToast(message: 'Failed to pick files');
    }
  }

  Future<void> ticketMessageReply(
      TicketReplyMessageEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(isReplyLoading: true));
    final data = await serviceLocator<AccUsecase>()
        .ticketReplyMessage(id: event.id, replyMessage: event.messageText);
    data.fold((error) {
      if (error.statusCode == 401 || error.statusCode == 400) {
          emit(state.copyWith(isReplyLoading: false, status: SupportStatus.logOut));
      } else {
        showToast(message: error.message ?? "");
        emit(state.copyWith(isReplyLoading: false));
      }
    }, (success) {
      emit(state.copyWith(isReplyLoading: false));
      showToast(message: "Message Success Text");
      add(ViewTicketEvent(id: event.id));
    });
  }
}
