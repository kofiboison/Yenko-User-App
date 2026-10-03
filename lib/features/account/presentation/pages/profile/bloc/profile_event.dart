part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileGetDirectionEvent extends ProfileEvent {}

class ProfileUpdateEvent extends ProfileEvent {
  final ProfileStatus? status;

  ProfileUpdateEvent({this.status});
}

class ProfileEditInitEvent extends ProfileEvent {
  final UserDetail userDetailData;
  ProfileEditInitEvent({required this.userDetailData});
}

class GenderSelectedEvent extends ProfileEvent {
  final String gender;
  GenderSelectedEvent(this.gender);
}


class UpdateUserDetailsEvent extends ProfileEvent {
  final String name;
  final String email;
  final String gender;
  final String profileImage;

  UpdateUserDetailsEvent({
    required this.name,
    required this.email,
    required this.gender,
    required this.profileImage,
  });
}

class UpdateImageEvent extends ProfileEvent {
  final String name;
  final String email;
  final String gender;
  final ImageSource source;

  UpdateImageEvent({
    required this.name,
    required this.email,
    required this.gender,
    required this.source,
  });
}
