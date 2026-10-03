part of 'sos_bloc.dart';

enum SosStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  selectContactDetails,
}

class SosState extends Equatable {
  final SosStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final List<SOSDatum> sosData;
  final List<ContactsModel> contactsList;
  final ContactsModel selectedContact;


  const SosState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.sosData,
    required this.contactsList,
    required this.selectedContact,
  });

  static SosState initial() => SosState(
        status: SosStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        sosData: [],
        contactsList: [],
        selectedContact: ContactsModel(name: '', number: ''),
      );

  SosState copyWith({
    SosStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    List<SOSDatum>? sosData,
    List<ContactsModel>? contactsList,
    ContactsModel? selectedContact, 

  }) =>
      SosState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        sosData: sosData ?? this.sosData,
        contactsList: contactsList ?? this.contactsList,
        selectedContact: selectedContact ?? this.selectedContact,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        sosData.map((e) => e).hashCode,
        contactsList.map((e) => e).hashCode,
        selectedContact,

      ];
}
