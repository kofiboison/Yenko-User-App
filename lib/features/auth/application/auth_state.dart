part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  loginSuccess,
  referralSuccess,
  verifySuccess,
  signInWithDemo,
  newUserRegistered,
  forgotPasswordOTPSend,
  forgotPasswordOTPVerify,
  forgetPasswordUpdateSuccess,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final bool isLoginByEmail;
  final bool isOtpVerify;
  final bool isNewUser;
  final bool showPassword;
  final bool isMobileNumber;
  final bool userExist;
  final bool isFirebaseOtpVerifyEnable;
  final bool? isGenderSelected;
  final int splashIndex;
  final int timerDuration;
  final int dialMaxLength;
  final int isRefferalEarnings;
  final String dialCode;
  final String flagImage;
  final String selectedGender;
  final String profileImage;
  final dynamic firebaseCredentials;
  final String firebaseVerificationId;
  final dynamic firebaseResendToken;
  final List<Country> countries;

  const AuthState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.isLoginByEmail,
    required this.isOtpVerify,
    required this.isNewUser,
    required this.showPassword,
    required this.isMobileNumber,
    required this.userExist,
    required this.isFirebaseOtpVerifyEnable,
    required this.isGenderSelected,
    required this.splashIndex,
    required this.timerDuration,
    required this.dialMaxLength,
    required this.isRefferalEarnings,
    required this.dialCode,
    required this.flagImage,
    required this.selectedGender,
    required this.profileImage,
    required this.firebaseCredentials,
    required this.firebaseVerificationId,
    required this.firebaseResendToken,
    required this.countries,
  });

  static AuthState initial() => const AuthState(
        status: AuthStatus.initial,
        textDirection: 'ltr',
        languageCode: 'EN',
        isLoading: false,
        isLoginByEmail: true,
        isOtpVerify: false,
        isNewUser: false,
        showPassword: false,
        isMobileNumber: false,
        userExist: false,
        isFirebaseOtpVerifyEnable: false,
        splashIndex: 0,
        timerDuration: 0,
        dialMaxLength: 14,
        isRefferalEarnings: 0,
        dialCode: '+233',
        flagImage: '${AppConstants.baseUrl}image/country/flags/GN.png',
        selectedGender: '',
        profileImage: '',
        isGenderSelected: null,
        firebaseCredentials: null,
        firebaseVerificationId: '',
        firebaseResendToken: null,
        countries: [],
      );

  AuthState copyWith({
    AuthStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    bool? isLoginByEmail,
    bool? isOtpVerify,
    bool? isNewUser,
    bool? showPassword,
    bool? isMobileNumber,
    bool? userExist,
    bool? isFirebaseOtpVerifyEnable,
    bool? isGenderSelected,
    int? splashIndex,
    int? timerDuration,
    int? dialMaxLength,
    int? isRefferalEarnings,
    String? dialCode,
    String? flagImage,
    String? selectedGender,
    String? profileImage,
    dynamic firebaseCredentials,
    String? firebaseVerificationId,
    dynamic firebaseResendToken,
    List<Country>? countries,
  }) =>
      AuthState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        isLoginByEmail: isLoginByEmail ?? this.isLoginByEmail,
        isOtpVerify: isOtpVerify ?? this.isOtpVerify,
        isNewUser: isNewUser ?? this.isNewUser,
        showPassword: showPassword ?? this.showPassword,
        isMobileNumber: isMobileNumber ?? this.isMobileNumber,
        userExist: userExist ?? this.userExist,
        isFirebaseOtpVerifyEnable: isFirebaseOtpVerifyEnable ?? this.isFirebaseOtpVerifyEnable,
        splashIndex: splashIndex ?? this.splashIndex,
        timerDuration: timerDuration ?? this.timerDuration,
        dialMaxLength: dialMaxLength ?? this.dialMaxLength,
        isRefferalEarnings: isRefferalEarnings ?? this.isRefferalEarnings,
        dialCode: dialCode ?? this.dialCode,
        flagImage: flagImage ?? this.flagImage,
        selectedGender: selectedGender ?? this.selectedGender,
        isGenderSelected: isGenderSelected ?? this.isGenderSelected,
        profileImage: profileImage ?? this.profileImage,
        firebaseCredentials: firebaseCredentials ?? this.firebaseCredentials,
        firebaseVerificationId: firebaseVerificationId ?? this.firebaseVerificationId,
        firebaseResendToken: firebaseResendToken ?? this.firebaseResendToken,
        countries: countries ?? this.countries,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        isLoginByEmail,
        isOtpVerify,
        isNewUser,
        showPassword,
        isMobileNumber,
        userExist,
        isFirebaseOtpVerifyEnable,
        splashIndex,
        timerDuration,
        dialMaxLength,
        isRefferalEarnings,
        dialCode,
        flagImage,
        selectedGender,
        isGenderSelected,
        profileImage,
        firebaseCredentials,
        firebaseVerificationId,
        firebaseResendToken,
        countries.map((e) => e).hashCode,
      ];
}
