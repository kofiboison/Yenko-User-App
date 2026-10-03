import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../bloc/chat_bloc.dart';
import '../widget/chat_history_widget.dart';

class AdminChat extends StatefulWidget {
  static const String routeName = '/adminchat';
  final AdminChatPageArguments arg;

  const AdminChat({super.key, required this.arg});

  @override
  State<AdminChat> createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  TextEditingController adminchatText = TextEditingController();

  @override
  void dispose() {
    adminchatText.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(AdminChatInitEvent(arg: widget.arg)),
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          final chatBloc = context.read<ChatBloc>();
          if (state.status == ChatStatus.sendAdminMessageSuccess) {
            chatBloc.add(ChatUpdateEvent());
            chatBloc.add(GetAdminChatHistoryListEvent());
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
          final chatBloc = context.read<ChatBloc>();
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              title: MyText(
                  text: AppLocalizations.of(context)!.adminChat,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColor)),
            ),
            body: SingleChildScrollView(
              controller: chatBloc.scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ChatHistoryWidget(
                        chatBloc: chatBloc,
                        adminChatList: state.adminChatList),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB(
                  10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
              child: SafeArea(
                child: Container(
                  width: size.width * 0.9,
                  margin: EdgeInsets.only(bottom: size.width * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkGrey, width: 1.2),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.7,
                          child: TextField(
                            controller: adminchatText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.typeAmessage,
                            ),
                            minLines: 1,
                            maxLines: 4,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (adminchatText
                                .text
                                .isNotEmpty) {
                              chatBloc.add(
                                    SendAdminMessageEvent(
                                      newChat: state
                                              .adminChatList
                                              .isEmpty
                                          ? '0'
                                          : '1',
                                      message: adminchatText
                                          .text,
                                      chatId: state
                                              .adminChatList
                                              .isEmpty
                                          ? ""
                                          : state
                                              .adminChatList[0]
                                              .conversationId,
                                    ),
                                  );
                              adminchatText.clear();
                            }
                          },
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
