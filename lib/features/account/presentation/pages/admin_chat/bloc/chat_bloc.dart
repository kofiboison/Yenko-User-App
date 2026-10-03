import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../di/locator.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../application/usecase/acc_usecases.dart';
import '../../../../domain/models/admin_chat_model.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ScrollController scrollController = ScrollController();
  StreamSubscription<DatabaseEvent>? chatStream;
  ScrollController chatScrollController = ScrollController();

  ChatBloc() : super(ChatState.initial()) {
    on<ChatUpdateEvent>((event, emit) =>
        emit(state.copyWith(status: ChatStatus.update, isLoading: false)));
    on<LoadMoreUpdateEvent>(
        (event, emit) => emit(state.copyWith(loadMore: event.loadMore)));
    on<AdminChatListUpdateEvent>(
        (event, emit) => emit(state.copyWith(adminChatList: event.chats)));
    on<UnSeenCountUpdateEvent>(
        (event, emit) => emit(state.copyWith(unSeenChatCount: event.count)));

    //Admin chat
    on<ChatGetDirectionEvent>(chatGetDirection);
    on<SendAdminMessageEvent>(sendAdminChat);
    on<GetAdminChatHistoryListEvent>(_getAdminChatHistoryList);
    on<AdminMessageSeenEvent>(_adminMessageSeenDetail);
    on<AdminChatInitEvent>(
      (event, emit) {
        emit(state.copyWith(userData: event.arg.userData));
        add(GetAdminChatHistoryListEvent());
      },
    );
  }

//Get Direction
  Future<void> chatGetDirection(
      ChatGetDirectionEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(
        status: ChatStatus.loaded,
        languageCode: languageCode,
        textDirection: textDirection));
  }

  //admin chat
  FutureOr<void> sendAdminChat(
      SendAdminMessageEvent event, Emitter<ChatState> emit) async {
    final data = await serviceLocator<AccUsecase>().sendAdminMessages(
        newChat: event.newChat, message: event.message, chatId: event.chatId);
    data.fold(
      (error) {
        emit(state.copyWith(status: ChatStatus.error));
        showToast(message: error.message ?? "");
      },
      (success) {
        List<ChatData>? chatList = [];
        chatList.add(ChatData(
            message: success.data.message,
            conversationId: success.data.conversationId,
            senderId: state.userData!.id.toString(),
            senderType: success.data.senderType,
            count: success.data.count,
            newChat: success.data.newChat,
            createdAt: success.data.createdAt,
            messageSuccess: success.data.messageSuccess,
            userTimezone: success.data.userTimezone));
        emit(state.copyWith(
            adminChatList: chatList,
            chatId: success.data.conversationId,
            isNewChat: 0));

        if (chatList.isNotEmpty && chatStream == null) {
          streamAdminchat();
        }
        emit(state.copyWith(
            status: ChatStatus.sendAdminMessageSuccess, unSeenChatCount: '0'));
      },
    );
  }

  FutureOr<void> _getAdminChatHistoryList(
      GetAdminChatHistoryListEvent event, Emitter<ChatState> emit) async {
    final data = await serviceLocator<AccUsecase>().getAdminChatHistoryDetail();
    data.fold(
      (error) {
        emit(state.copyWith(status: ChatStatus.error));
        showToast(message: error.message ?? "");
      },
      (success) {
        emit(
            state.copyWith(adminChatList: [], isNewChat: success.data.newChat));
        int count = success.data.count;
        List<ChatData>? chatList = [];
        for (var i = 0; i < success.data.conversation.length; i++) {
          chatList.add(ChatData(
              message: success.data.conversation[i].content,
              conversationId: success.data.conversation[i].conversationId,
              senderId: success.data.conversation[i].senderId.toString(),
              senderType: success.data.conversation[i].senderType.toString(),
              count: count,
              newChat: '0',
              createdAt: success.data.conversation[i].createdAt,
              messageSuccess: 'Data inserted successfully',
              userTimezone: success.data.conversation[i].userTimezone));
        }
        emit(state.copyWith(
            adminChatList: chatList, chatId: success.data.conversationId));
        if (state.adminChatList.isNotEmpty && chatStream == null) {
          streamAdminchat();
        }
        emit(state.copyWith(unSeenChatCount: '0'));
      },
    );
  }

  streamAdminchat() async {
    if (chatStream != null) {
      chatStream?.cancel();
      chatStream = null;
    }
    chatStream = FirebaseDatabase.instance
        .ref()
        .child(
            'conversation/${(state.adminChatList.length > 2) ? (state.userData != null) ? state.userData!.conversationId : state.chatId : state.chatId}')
        .onValue
        .listen((event) async {
      var value = Map<String, dynamic>.from(
          jsonDecode(jsonEncode(event.snapshot.value)));
      if (state.userData != null) {
        if ((((state.adminChatList.isNotEmpty &&
                    state.adminChatList.last.message !=
                        value['message'].toString())) &&
                value['sender_id'].toString() !=
                    state.userData!.id.toString()) ||
            (value['sender_id'].toString() != state.userData!.id.toString() &&
                state.adminChatList.isEmpty)) {
          List<ChatData> chats = state.adminChatList;
          chats.add(ChatData.fromJson(value));
          add(AdminChatListUpdateEvent(chats: chats));
        }
      }
      value.clear();
      if (state.adminChatList.isNotEmpty) {
        add(UnSeenCountUpdateEvent(
            count: state.adminChatList[state.adminChatList.length - 1].count
                .toString()));
        if (state.unSeenChatCount == 'null') {
          add(UnSeenCountUpdateEvent(count: '0'));
        }
      }
    });
  }

  FutureOr<void> _adminMessageSeenDetail(
      AdminMessageSeenEvent event, Emitter<ChatState> emit) async {
    final data = await serviceLocator<AccUsecase>()
        .adminMessageSeenDetail(event.chatId!);
    data.fold(
      (error) {
        emit(state.copyWith(status: ChatStatus.adminMessageSeenFailure));
      },
      (success) {
        emit(state.copyWith(status: ChatStatus.adminMessageSeenSuccess));
      },
    );
  }
}
