// ignore_for_file: use_build_context_synchronously

import 'package:bus_booking/core/utils/custom_loader.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../bloc/support_bloc.dart';
import '../widgets/create_ticket_sheet.dart';
import '../widgets/support_empty_widget.dart';
import '../widgets/ticket_card.dart';

class SupportTicketPage extends StatelessWidget {
  static const String routeName = '/supportTicketPage';
  final SupportTicketPageArguments args;

  const SupportTicketPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc()
        ..add(GetServiceLocationEvent())
        ..add(SuppotGetDirectionEvent())
        ..add(GetTicketTitleEvent(isFromRequest: args.isFromRequest))
        ..add(GetTicketListEvent(isFromAcc: args.isFromRequest)),
      child: BlocListener<SupportBloc, SupportState>(
        listener: (context, state) async {
          final supportBloc = context.read<SupportBloc>();
          if (state.status == SupportStatus.logOut) {
            supportBloc.add(SuppotUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if(state.status == SupportStatus.requestTicketCreatedSuccess){
            Navigator.pop(context,true);
          } else if (state.status == SupportStatus.createSupportTicket) {
            if (state.isTicketSheetOpened) return;
            supportBloc
                .add(TicketSheetStageUpdateEvent(isTicketSheetOpen: true));
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              isDismissible: true,
              context: context,
              builder: (cont) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: CreateTicketSheet(
                    requestId: args.requestId,
                    support: supportBloc,
                    ticketNamesList: state.ticketNamesList,
                    isFromReuest: args.isFromRequest,
                  ),
                );
              },
            ).then((value) {
              if (value != null && value) {
                // if (context.mounted) {
                //   CustomLoader.loader(context);
                // }
              }
            }).whenComplete(() {
              if (context.mounted) {
                supportBloc
                    .add(TicketSheetStageUpdateEvent(isTicketSheetOpen: false));
              }
            });
          }
        },
        child: BlocBuilder<SupportBloc, SupportState>(
          builder: (context, state) {
            final supportBloc = context.read<SupportBloc>();
            if (state.status == SupportStatus.loading) {
              return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: size.height,
                  width: size.width,
                  child: const Loader());
            } else {
              return Directionality(
                textDirection: state.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    title: MyText(
                        text: AppLocalizations.of(context)!.supportTicket,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: size.width * 0.05),
                          if (state.ticketList.isNotEmpty) ...[
                            SizedBox(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return TicketCard(
                                      ticketData: state.ticketList[index],
                                      isFromViewPage: false,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: size.width * 0.04);
                                  },
                                  itemCount: state.ticketList.length),
                            ),
                            SizedBox(height: size.height * 0.1)
                          ],
                          if (state.ticketList.isEmpty && !state.isLoading)
                            const SupportEmptyWidget()
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    shape: const CircleBorder(),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      context
                          .read<SupportBloc>()
                          .supportDescriptionController
                          .text = '';
                      showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        isDismissible: true,
                        context: context,
                        builder: (cont) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: CreateTicketSheet(
                              requestId: args.requestId,
                              support: supportBloc,
                              ticketNamesList: state.ticketNamesList,
                              isFromReuest: args.isFromRequest,
                            ),
                          );
                        },
                      );
                      // supportBloc.add(CreateSupportTicketEvent(
                      //     requestId: args.requestId,
                      //     isFromRequest: args.isFromRequest));
                    },
                    child: Icon(
                      Icons.add,
                      size: size.width * 0.09,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
