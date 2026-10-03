part of 'chat_bloc.dart';

enum ChatStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  sendAdminMessageSuccess,
  adminMessageSeenSuccess,
  adminMessageSeenFailure,
}

class ChatState extends Equatable {
  final ChatStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final bool loadMore;
  final UserDetail? userData;
  final List<ChatData> adminChatList;
  final dynamic isNewChat;
  final String chatId;
  final String unSeenChatCount;

  const ChatState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.loadMore,
    required this.userData,
    required this.adminChatList,
    required this.isNewChat,
    required this.chatId,
    required this.unSeenChatCount,
  });

  static ChatState initial() => const ChatState(
        status: ChatStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        loadMore:false,
        userData: null,
        adminChatList: [],
        isNewChat: 1,
        chatId:'',
        unSeenChatCount:'0',

      );

  ChatState copyWith({
    ChatStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    bool? loadMore,
    UserDetail? userData,
    List<ChatData>? adminChatList,
    dynamic isNewChat,
    String? chatId,
    String? unSeenChatCount,
  }) =>
      ChatState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        loadMore: loadMore ?? this.loadMore,
        userData: userData ?? this.userData,
        adminChatList: adminChatList ?? this.adminChatList,
        isNewChat:isNewChat ?? this.isNewChat,
        chatId: chatId ?? this.chatId,
        unSeenChatCount:unSeenChatCount ?? this.unSeenChatCount,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        loadMore,
        userData,
        adminChatList.map((e) =>e).hashCode,
        isNewChat,
        chatId,
        unSeenChatCount,
      ];
}
