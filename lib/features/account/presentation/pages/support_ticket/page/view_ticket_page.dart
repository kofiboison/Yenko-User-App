import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../bloc/support_bloc.dart';
import '../widgets/reply_ticket_widget.dart';
import '../widgets/support_reply_message_list.dart';
import '../widgets/view_ticket_card.dart';

class ViewTicketPage extends StatelessWidget {
  static const String routeName = '/viewTicketPage';
  final ViewTicketPageArguments args;
  const ViewTicketPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc()..add(ViewTicketEvent(id: args.id)),
      child: BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {},
        child: BlocBuilder<SupportBloc, SupportState>(
          builder: (context, state) {
            final supportBloc = context.read<SupportBloc>();
            return Directionality(
              textDirection: state.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: CustomAppBar(
                  title:
                      "${AppLocalizations.of(context)!.viewTicket} ${args.ticketId}",
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (state.supportTicketData != null) ...[
                          SizedBox(height: size.width * 0.05),
                          BlocProvider.value(
                            value: supportBloc,
                            child: ViewTicketCard(
                              ticketData: state.supportTicketData!,
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          BlocProvider.value(
                            value: supportBloc,
                            child: const SupportReplyMessageList(),
                          ),
                          SizedBox(height: size.width * 0.05),
                          BlocProvider.value(
                            value: supportBloc,
                            child: ReplyContainer(
                              id: args.id,
                            ),
                          ),
                          SizedBox(height: size.width * 0.1),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
