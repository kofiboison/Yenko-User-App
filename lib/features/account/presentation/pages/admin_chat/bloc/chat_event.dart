part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ChatGetDirectionEvent extends ChatEvent {}

class ChatUpdateEvent extends ChatEvent {}

class LoadMoreUpdateEvent extends ChatEvent {
  final bool loadMore;

  LoadMoreUpdateEvent({required this.loadMore});

}

class SendAdminMessageEvent extends ChatEvent {
  final String newChat;
  final String message;
  final String chatId;

  SendAdminMessageEvent({
    required this.newChat,
    required this.message,
    required this.chatId,
  });
}

class GetAdminChatHistoryListEvent extends ChatEvent {}

class AdminChatInitEvent extends ChatEvent {
  final AdminChatPageArguments arg;

  AdminChatInitEvent({required this.arg});
}

class AdminMessageSeenEvent extends ChatEvent {
  final String? chatId;

  AdminMessageSeenEvent({required this.chatId});
}

class AdminChatListUpdateEvent extends ChatEvent {
  final List<ChatData> chats;

  AdminChatListUpdateEvent({required this.chats});
}

class UnSeenCountUpdateEvent extends ChatEvent {
  final String count;

  UnSeenCountUpdateEvent({required this.count});
}