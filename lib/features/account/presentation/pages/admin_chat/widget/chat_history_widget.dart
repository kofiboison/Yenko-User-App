import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../domain/models/admin_chat_model.dart';
import '../bloc/chat_bloc.dart';

class ChatHistoryWidget extends StatelessWidget {
  final ChatBloc chatBloc;
  final List<ChatData> adminChatList;
  const ChatHistoryWidget(
      {super.key, required this.chatBloc, required this.adminChatList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: chatBloc,
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final chatBloc = context.read<ChatBloc>();
          return adminChatList.isNotEmpty
              ? ListView.builder(
                  itemCount: adminChatList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      chatBloc.scrollController.animateTo(
                          chatBloc
                              .scrollController
                              .position
                              .maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    });
                    return (state.userData != null)
                        ? Container(
                            padding: EdgeInsets.only(top: size.width * 0.01),
                            width: size.width * 0.9,
                            alignment: (adminChatList[index].senderId ==
                                    state
                                        .userData!
                                        .id
                                        .toString())
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment:
                                  (adminChatList[index].senderId ==
                                          state
                                              .userData!
                                              .id
                                              .toString())
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                (adminChatList[index].senderId ==
                                        state
                                            .userData!
                                            .id
                                            .toString())
                                    ? Card(
                                        elevation: 5,
                                        child: Container(
                                          width: size.width * 0.5,
                                          padding:
                                              EdgeInsets.all(size.width * 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: (adminChatList[index]
                                                            .senderId ==
                                                        state
                                                            .userData!
                                                            .id
                                                            .toString())
                                                    ? Radius.circular(
                                                        size.width * 0.02)
                                                    : const Radius.circular(0),
                                                topRight: (adminChatList[index]
                                                            .senderId ==
                                                        state
                                                            .userData!
                                                            .id
                                                            .toString())
                                                    ? const Radius.circular(0)
                                                    : Radius.circular(
                                                        size.width * 0.02),
                                                bottomRight: Radius.circular(
                                                    size.width * 0.02),
                                                bottomLeft: Radius.circular(
                                                    size.width * 0.02),
                                              ),
                                              color: (adminChatList[index]
                                                          .senderId ==
                                                      state
                                                          .userData!
                                                          .id
                                                          .toString())
                                                  ? (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark)
                                                      ? const Color(0xffE7EDEF)
                                                      : AppColors.black
                                                  : const Color(0xffE7EDEF)),
                                          child: MyText(
                                            text: adminChatList[index].message,
                                            overflow: TextOverflow.visible,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    // color: AppColors.white
                                                    color: (adminChatList[index]
                                                                .senderId ==
                                                            state
                                                                .userData!
                                                                .id
                                                                .toString())
                                                        ? (Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark)
                                                            ? AppColors.black
                                                            : AppColors.white
                                                        : AppColors.black),
                                          ),
                                        ),
                                      )
                                    : Card(
                                        elevation: 5,
                                        shadowColor:
                                            Theme.of(context).shadowColor,
                                        child: Container(
                                          width: size.width * 0.5,
                                          padding:
                                              EdgeInsets.all(size.width * 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(0),
                                                topRight: Radius.circular(
                                                    size.width * 0.024),
                                                bottomRight: Radius.circular(
                                                    size.width * 0.024),
                                                bottomLeft: Radius.circular(
                                                    size.width * 0.024),
                                              ),
                                              color: (adminChatList[index]
                                                          .senderId ==
                                                      state.userData!
                                                          .id
                                                          .toString())
                                                  ? (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark)
                                                      ? const Color(0xffE7EDEF)
                                                      : AppColors.black
                                                  : const Color(0xffE7EDEF)),
                                          child: MyText(
                                            text: adminChatList[index].message,
                                            overflow: TextOverflow.visible,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: (adminChatList[index]
                                                                .senderId ==
                                                            state
                                                                .userData!
                                                                .id
                                                                .toString())
                                                        ? (Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark)
                                                            ? AppColors.black
                                                            : AppColors.white
                                                        : AppColors.black),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: size.width * 0.01),
                                MyText(
                                  text: adminChatList[index].userTimezone,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color:
                                              Theme.of(context).dividerColor),
                                ),
                              ],
                            ),
                          )
                        : const Loader();
                  },
                )
              : const SizedBox();
        },
      ),
    );
  }
}
