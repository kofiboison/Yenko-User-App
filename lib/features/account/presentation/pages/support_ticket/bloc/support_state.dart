part of 'support_bloc.dart';

enum SupportStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  createSupportTicket,
  requestTicketCreatedSuccess,
}

class SupportState extends Equatable {
  final SupportStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final bool isReplyLoading;
  final bool firstLoad;
  final bool loadMore;
  final String? selectedTicketTitle;
  final String? selectedTicketTitleId;
  final String? selectedTicketArea;
  final String? selectedTicketAreaId;
  final SupportTicket? supportTicketData;
  final bool isTicketSheetOpened;
  final List<TicketData> ticketList;
  final List<File> ticketAttachments;
  final List<TicketNamesList> ticketNamesList;
  final List<ServiceLocationData> serviceLocations;
  final List<ReplyMessage> replyMessages;
  final List<Attachment> viewAttachments;

  const SupportState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.isReplyLoading,
    required this.firstLoad,
    required this.loadMore,
    required this.selectedTicketTitle,
    required this.selectedTicketTitleId,
    required this.selectedTicketArea,
    required this.selectedTicketAreaId,
    required this.supportTicketData,
    required this.isTicketSheetOpened,
    required this.ticketList,
    required this.ticketAttachments,
    required this.ticketNamesList,
    required this.serviceLocations,
    required this.replyMessages,
    required this.viewAttachments,
  });

  static SupportState initial() => const SupportState(
        status: SupportStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        isReplyLoading: false,
        firstLoad: true,
        loadMore: false,
        isTicketSheetOpened: false,
        ticketList: [],
        ticketAttachments: [],
        ticketNamesList: [],
        serviceLocations: [],
        selectedTicketTitle: null,
        selectedTicketTitleId: null,
        selectedTicketArea: null,
        selectedTicketAreaId: null,
        supportTicketData: null,
        viewAttachments: [],
        replyMessages: [],
      );

  SupportState copyWith({
    SupportStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    bool? isReplyLoading,
    bool? firstLoad,
    bool? loadMore,
    String? selectedTicketTitle,
    String? selectedTicketTitleId,
    String? selectedTicketArea,
    String? selectedTicketAreaId,
    SupportTicket? supportTicketData,
    bool? isTicketSheetOpened,
    List<TicketData>? ticketList,
    List<File>? ticketAttachments,
    List<TicketNamesList>? ticketNamesList,
    List<ServiceLocationData>? serviceLocations,
    List<ReplyMessage>? replyMessages,
    List<Attachment>? viewAttachments,
  }) =>
      SupportState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        isReplyLoading: isReplyLoading ?? this.isReplyLoading,
        firstLoad: firstLoad ?? this.firstLoad,
        loadMore: loadMore ?? this.loadMore,
        isTicketSheetOpened: isTicketSheetOpened ?? this.isTicketSheetOpened,
        ticketList: ticketList ?? this.ticketList,
        ticketAttachments: ticketAttachments ?? this.ticketAttachments,
        ticketNamesList: ticketNamesList ?? this.ticketNamesList,
        selectedTicketTitle: selectedTicketTitle ?? this.selectedTicketTitle,
        selectedTicketTitleId:
            selectedTicketTitleId ?? this.selectedTicketTitleId,
        selectedTicketArea: selectedTicketArea ?? this.selectedTicketArea,
        selectedTicketAreaId: selectedTicketAreaId ?? this.selectedTicketAreaId,
        supportTicketData: supportTicketData ?? this.supportTicketData,
        serviceLocations: serviceLocations ?? this.serviceLocations,
        replyMessages: replyMessages ?? this.replyMessages,
        viewAttachments: viewAttachments ?? this.viewAttachments,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        isReplyLoading,
        firstLoad,
        loadMore,
        isTicketSheetOpened,
        ticketList.map((e) => e).hashCode,
        ticketAttachments.map((e) => e).hashCode,
        ticketNamesList.map((e) => e).hashCode,
        serviceLocations.map((e) => e).hashCode,
        selectedTicketTitle,
        selectedTicketTitleId,
        selectedTicketArea,
        selectedTicketAreaId,
        supportTicketData,
        replyMessages.map((e) => e).hashCode,
        viewAttachments.map((e) => e).hashCode,
      ];
}
