part of 'sos_bloc.dart';

abstract class SosEvent {}

class SosGetDirectionEvent extends SosEvent {}

class SosUpdateEvent extends SosEvent {}

class SosGetUserDetailsEvent extends SosEvent {}

class SelectContactDetailsEvent extends SosEvent {}

class DeleteContactEvent extends SosEvent {
  final String? id;

  DeleteContactEvent({required this.id});
}

class AddContactEvent extends SosEvent {
  final String name;
  final String number;

  AddContactEvent({required this.name, required this.number});
}

class UpdateSelectContactEvent extends SosEvent {
  final ContactsModel contact;

  UpdateSelectContactEvent({required this.contact});
}