import 'package:bus_booking/core/utils/custom_divider.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/features/account/domain/models/view_ticket_model.dart';
import 'package:bus_booking/features/account/presentation/pages/support_ticket/widgets/attachment_preview_list.dart';
import 'package:bus_booking/features/account/presentation/pages/support_ticket/widgets/ticket_info_item.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../../../common/common.dart';
import '../bloc/support_bloc.dart';

class ViewTicketCard extends StatelessWidget {
  final SupportTicket ticketData;

  const ViewTicketCard({
    super.key,
    required this.ticketData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportBloc, SupportState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.047),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          width: size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .disabledColor
                      .withAlpha((0.07 * 255).toInt()),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: ticketData.user.profilePicture.isNotEmpty
                          ? NetworkImage(ticketData.user.profilePicture)
                          : null,
                    ),
                    SizedBox(width: size.width * 0.04),
                    MyText(
                      text: ticketData.user.name,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    ),
                    Expanded(
                      child: MyText(
                        text: intl.DateFormat('d MMM \nh:mm a')
                            .format(ticketData.createdAt.toLocal())
                            .toString(),
                        textAlign: TextAlign.end,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.ticketId,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).disabledColor),
                            ),
                            MyText(
                              text: " ${ticketData.ticketId}",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                      color:
                                          Theme.of(context).primaryColorDark),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              color: ticketData.status == 1
                                  ? AppColors.blue
                                  : ticketData.status == 2
                                      ? AppColors.orange
                                      : AppColors.red),
                          child: MyText(
                            text: ticketData.status == 1
                                ? AppLocalizations.of(context)!.pending
                                : ticketData.status == 2
                                    ? AppLocalizations.of(context)!.acknowledged
                                    : AppLocalizations.of(context)!.closed,
                            textStyle: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.03),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.title,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).disabledColor),
                        ),
                        SizedBox(
                          width: size.width * 0.75,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: MyText(
                              text: " ${ticketData.ticketTitle.title}",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w500),
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.03),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.description,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).disabledColor),
                        ),
                        SizedBox(
                          width: size.width * 0.62,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: MyText(
                              text: " ${ticketData.description}",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w500),
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TicketInfoItem(
                      title: AppLocalizations.of(context)!.supportType,
                      value: ticketData.supportType,
                    ),
                    SizedBox(width: size.width * 0.03),
                    TicketInfoItem(
                      title: AppLocalizations.of(context)!.assignTo,
                      value: AppLocalizations.of(context)!.notAssigned,
                    ),
                  ],
                ),
              ),
              ticketData.requestId != null
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TicketInfoItem(
                        title: AppLocalizations.of(context)!.requestId,
                        value: ticketData.requestId!,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: size.width * 0.03),
              if (state.viewAttachments
                  .map((e) => e.image)
                  .toList()
                  .isNotEmpty) ...[
                const HorizontalDotDividerWidget(),
                SizedBox(height: size.width * 0.03),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: MyText(
                    text: AppLocalizations.of(context)!.attachments,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),
                SizedBox(height: size.width * 0.03),
                SizedBox(
                  height: size.width * 0.2,
                  width: size.width,
                  child:
                      BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
                    return AttachmentPreviewList(
                      imageUrls:
                          state.viewAttachments.map((e) => e.image).toList(),
                    );
                  }),
                ),
                SizedBox(height: size.width * 0.05),
              ],
            ],
          ),
        );
      },
    );
  }
}
