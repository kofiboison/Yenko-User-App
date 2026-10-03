import 'package:bus_booking/core/utils/custom_button.dart';
import 'package:bus_booking/core/utils/custom_snack_bar.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/core/utils/custom_textfield.dart';
import 'package:bus_booking/features/account/domain/models/service_location_model.dart';
import 'package:bus_booking/features/account/domain/models/ticket_names_model.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../bloc/support_bloc.dart';

class CreateTicketSheet extends StatelessWidget {
  final SupportBloc support;
  final List<TicketNamesList> ticketNamesList;
  final String requestId;
  final bool isFromReuest;
  final int? index;
  final int? historyPagenumber;

  const CreateTicketSheet(
      {super.key,
      required this.support,
      required this.ticketNamesList,
      required this.requestId,
      required this.isFromReuest,
      this.index,
      this.historyPagenumber});

  @override
  Widget build(BuildContext context) {
    // TextEditingController supportDescriptionController =
    //     TextEditingController();

    return BlocProvider.value(
      value: support,
      child: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          final supportBloc = context.read<SupportBloc>();
          ServiceLocationData? selectedValue;
          TicketNamesList? selectedTitle;
          try {
            selectedValue = state.serviceLocations.firstWhere(
              (e) => e.name == state.selectedTicketArea,
            );
          } catch (_) {
            selectedValue = null;
          }

          try {
            selectedTitle = state.ticketNamesList
                .firstWhere((e) => e.title == state.selectedTicketTitle);
          } catch (_) {
            selectedTitle = null;
          }

          try {
            selectedTitle = state.ticketNamesList
                .firstWhere((e) => e.title == state.selectedTicketTitle);
          } catch (_) {
            selectedTitle = null;
          }

          if (state.ticketNamesList.isEmpty || state.serviceLocations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Container(
              width: size.width,
              padding: EdgeInsets.only(
                  left: size.width * 0.03,
                  right: size.width * 0.03,
                  top: size.height * 0.02,
                  bottom: size.height * 0.02),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: size.width * 0.04,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.createTicket,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Column(
                      children: [
                        Row(children: [
                          InkWell(
                            child: RichText(
                              text: TextSpan(
                                  text: AppLocalizations.of(context)!.title,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                  children: [
                                    const TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold))
                                  ]),
                            ),
                          ),
                        ]),
                        SizedBox(height: size.width * 0.03),
                        DropdownButtonFormField<TicketNamesList>(
                          focusColor: Theme.of(context).dividerColor,
                          dropdownColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          value: selectedTitle,
                          items: state.ticketNamesList
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: SizedBox(
                                      width: size.width * 0.8,
                                      child: MyText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        text: e.title,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (selected) {
                            if (selected != null) {
                              supportBloc.add(
                                TicketTitleChangeEvent(
                                  changedTitle: selected.title,
                                  id: selected.id,
                                ),
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.selectTitle,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: Theme.of(context).primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).hintColor,
                              width: 1.2,
                              style: BorderStyle.solid,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).disabledColor,
                              width: 1.2,
                              style: BorderStyle.solid,
                            )),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                        ),
                        SizedBox(height: size.width * 0.03),
                        Row(children: [
                          RichText(
                            text: TextSpan(
                                text: AppLocalizations.of(context)!.selectArea,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                                children: [
                                  const TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ]),
                        SizedBox(
                          height: size.width * 0.03,
                        ),
                        DropdownButtonFormField<ServiceLocationData>(
                          focusColor: Theme.of(context).dividerColor,
                          dropdownColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          value: selectedValue,
                          items: state.serviceLocations.map(
                            (e) {
                              return DropdownMenuItem<ServiceLocationData>(
                                value: e,
                                child: MyText(text: e.name),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              supportBloc.add(
                                TicketAreaChangeEvent(
                                  changedArea: value.name,
                                  id: value.id,
                                ),
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.selectArea,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 1.2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 1.2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.03,
                        ),
                        Row(children: [
                          RichText(
                            text: TextSpan(
                                text: AppLocalizations.of(context)!.description,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                                children: [
                                  const TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ]),
                        SizedBox(
                          height: size.width * 0.03,
                        ),
                        CustomTextField(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          controller: supportBloc.supportDescriptionController,
                          hintText:
                              AppLocalizations.of(context)!.enterDescription,
                          maxLine: 4,
                        ),
                        SizedBox(
                          height: size.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.attachments,
                              textStyle: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18),
                            ),
                            if (state.ticketAttachments.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  supportBloc.add(AddAttachmentTicketEvent(
                                      context: context));
                                },
                                child: MyText(
                                  text:
                                      "+ ${AppLocalizations.of(context)!.addMore}",
                                  textStyle: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                              )
                          ],
                        ),
                        InkWell(
                          onTap: state.ticketAttachments.length == 1
                              ? null
                              : () {
                                  supportBloc.add(AddAttachmentTicketEvent(
                                      context: context));
                                },
                          child: Stack(
                            children: [
                              Container(
                                height: size.height * 0.06,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor,
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10),
                                    state.ticketAttachments.isEmpty
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .uploadMaxFile,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .fileFormat,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .disabledColor),
                                              ),
                                            ],
                                          )
                                        : MyText(
                                            text:
                                                '${state.ticketAttachments.length} ${AppLocalizations.of(context)!.filesUploaded}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                  ],
                                ),
                              ),
                              if (state.ticketAttachments.isNotEmpty)
                                Positioned(
                                  right: 8,
                                  top: 12,
                                  child: InkWell(
                                    onTap: () {
                                      supportBloc.add(ClearAttachmentEvent());
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: AppColors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.width * 0.05),
                        Center(
                          child: CustomButton(
                            buttonName:
                                AppLocalizations.of(context)!.createTicket,
                            onTap: () {
                              if ((state.selectedTicketTitleId != null &&
                                      state
                                          .selectedTicketTitleId!.isNotEmpty) &&
                                  (state.selectedTicketAreaId != null &&
                                      state.selectedTicketAreaId!.isNotEmpty) &&
                                  supportBloc.supportDescriptionController.text
                                      .isNotEmpty) {
                                supportBloc.add(
                                  MakeTicketSubmitEvent(
                                      description: supportBloc
                                          .supportDescriptionController.text,
                                      titleId: state.selectedTicketTitleId!,
                                      serviceLocationId:
                                          state.selectedTicketAreaId!,
                                      attachement: state.ticketAttachments,
                                      requestId: requestId,
                                      isFromRequest: isFromReuest,
                                      index: index,
                                      pageNumber: historyPagenumber),
                                );
                                Navigator.pop(context, true);
                                supportBloc.add(ClearAttachmentEvent());
                              } else {
                                showToast(
                                    message: AppLocalizations.of(context)!
                                        .fillRequiredField);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
