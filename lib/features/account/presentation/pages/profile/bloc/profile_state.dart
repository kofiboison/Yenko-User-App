part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  openBottomSheet,
  userDetailUpdate,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final UserDetail? userData;
  final String profileImage;
  final String selectedGender;
  final List<Map<String, Object>> genderOptions;

  const ProfileState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.userData,
    required this.selectedGender,
    required this.genderOptions,
    required this.profileImage,
  });

  static ProfileState initial() => const ProfileState(
        status: ProfileStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        userData: null,
        selectedGender: '',
        profileImage: '',
        genderOptions: [
          {
            'label': 'M',
            'icon': Icons.male,
            'value': 'male',
          },
          {
            'label': 'F',
            'icon': Icons.female,
            'value': 'female',
          },
        ],
      );

  ProfileState copyWith({
    ProfileStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    UserDetail? userData,
    String? selectedGender,
    List<Map<String, Object>>? genderOptions,
    String? profileImage,

  }) =>
      ProfileState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        userData: userData ?? this.userData,
        selectedGender: selectedGender ?? this.selectedGender,
        genderOptions: genderOptions ?? this.genderOptions,
        profileImage: profileImage ?? this.profileImage,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        userData,
        selectedGender,
        genderOptions,
        profileImage,
      ];
}
