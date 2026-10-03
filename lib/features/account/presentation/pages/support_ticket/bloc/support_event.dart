part of 'support_bloc.dart';

abstract class SupportEvent {}

class SuppotGetDirectionEvent extends SupportEvent {}

class SuppotUpdateEvent extends SupportEvent {}

class GetServiceLocationEvent extends SupportEvent {}

class GetTicketListEvent extends SupportEvent {
  final bool isFromAcc;

  GetTicketListEvent({required this.isFromAcc});
}

class ViewTicketEvent extends SupportEvent {
  final String id;
  ViewTicketEvent({required this.id});
}

class TicketTitleChangeEvent extends SupportEvent {
  final String changedTitle;
  final String id;
  TicketTitleChangeEvent({required this.changedTitle, required this.id});
}

class ClearAttachmentEvent extends SupportEvent {}

class MakeTicketSubmitEvent extends SupportEvent {
  final String serviceLocationId;
  final String titleId;
  final String description;
  final List<File> attachement;
  final String requestId;
  final bool isFromRequest;
  final int? index;
  final int? pageNumber;

  MakeTicketSubmitEvent(
      {required this.serviceLocationId,
      required this.titleId,
      required this.description,
      required this.attachement,
      required this.requestId,
      required this.isFromRequest,
      this.index,
      this.pageNumber});
}

class TicketReplyMessageEvent extends SupportEvent {
  final BuildContext context;
  final String messageText;
  final String id;

  TicketReplyMessageEvent(
      {required this.messageText, required this.id, required this.context});
}

class AddAttachmentTicketEvent extends SupportEvent {
  final BuildContext context;

  AddAttachmentTicketEvent({required this.context});
}

class TicketAreaChangeEvent extends SupportEvent {
  final String changedArea;
  final String id;
  TicketAreaChangeEvent({required this.changedArea, required this.id});
}

class CreateSupportTicketEvent extends SupportEvent {
  final bool isFromRequest;
  final String requestId;
  final int? index;
  final int? pageNumber;
  CreateSupportTicketEvent(
      {required this.isFromRequest,
      required this.requestId,
      this.index,
      this.pageNumber});
}

class TicketSheetStageUpdateEvent extends SupportEvent {
  final bool isTicketSheetOpen;

  TicketSheetStageUpdateEvent({required this.isTicketSheetOpen});
}

class GetTicketTitleEvent extends SupportEvent {
  final bool isFromRequest;

  GetTicketTitleEvent({required this.isFromRequest});
}
