import 'package:bus_booking/core/utils/custom_button.dart';
import 'package:bus_booking/core/utils/custom_snack_bar.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/core/utils/custom_textfield.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../bloc/support_bloc.dart';

class ReplyContainer extends StatelessWidget {
  final String id;

  const ReplyContainer({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController supportMessageReplyController =
        TextEditingController();
    return BlocBuilder<SupportBloc, SupportState>(
      builder: (context, state) {
        final supportBloc = context.read<SupportBloc>();
        return Container(
          height: size.height * 0.25,
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.047),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          width: size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.reply),
                  const SizedBox(width: 8),
                  MyText(
                    text: AppLocalizations.of(context)!.replyText,
                    textStyle:
                        Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.01),
              RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)!.messageText,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  children: const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.width * 0.02),
              Expanded(
                child: CustomTextField(
                  controller: supportMessageReplyController,
                  hintText: AppLocalizations.of(context)!.enterMessage,
                  maxLine: 5,
                ),
              ),
              SizedBox(height: size.width * 0.03),
              Align(
                alignment: Alignment.centerRight,
                child: BlocConsumer<SupportBloc, SupportState>(
                  listener: (cont, state) {},
                  builder: (cont, state) {
                    final isTicketClosed = state.supportTicketData!.status == 3;
                    final isDisabled = (isTicketClosed || state.isReplyLoading);

                    return CustomButton(
                      buttonColor: isDisabled
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).primaryColor,
                      buttonName: AppLocalizations.of(context)!.send,
                      isLoader: state.isReplyLoading,
                      onTap: isDisabled
                          ? null
                          : () {
                              if (supportMessageReplyController
                                  .text.isNotEmpty) {
                                supportBloc.add(
                                  TicketReplyMessageEvent(
                                    context: context,
                                    id: id,
                                    messageText:
                                        supportMessageReplyController.text,
                                  ),
                                );
                                supportMessageReplyController.clear();
                              } else {
                                showToast(
                                    message: AppLocalizations.of(context)!
                                        .filleMessageField);
                              }
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
