part of 'auth_bloc.dart';

abstract class AuthEvent {}

class GetDirectionEvent extends AuthEvent {}

class CountryGetEvent extends AuthEvent {}

class AuthUpdateEvent extends AuthEvent {}

class EmailorMobileOnChangeEvent extends AuthEvent {
  final String value;

  EmailorMobileOnChangeEvent({required this.value});
}

// Verify

class GetCommonModuleEvent extends AuthEvent {}

class VerifyUserEvent extends AuthEvent {}

class ShowPasswordIconEvent extends AuthEvent {
  final bool showPassword;

  ShowPasswordIconEvent({required this.showPassword});
}

class OTPOnChangeEvent extends AuthEvent {}

class VerifyTimerEvent extends AuthEvent {
  final int duration;

  VerifyTimerEvent({
    required this.duration,
  });
}

class SignInWithOTPEvent extends AuthEvent {
  final bool isOtpVerify;
  final bool isLoginByEmail;
  final bool isForgotPassword;
  final String mobileOrEmail;
  final String countryCode;
  final BuildContext context;

  SignInWithOTPEvent(
      {required this.isOtpVerify,
      required this.isLoginByEmail,
      required this.isForgotPassword,
      required this.mobileOrEmail,
      required this.countryCode,
      required this.context});
}

class ConfirmOrVerifyOTPEvent extends AuthEvent {
  final bool isUserExist;
  final bool isLoginByEmail;
  final bool isOtpVerify;
  final bool isForgotPasswordVerify;
  final String mobileOrEmail;
  final String otp;
  final String password;
  final String firebaseVerificationId;
  final BuildContext context;

  ConfirmOrVerifyOTPEvent({
    required this.isUserExist,
    required this.isLoginByEmail,
    required this.isOtpVerify,
    required this.isForgotPasswordVerify,
    required this.mobileOrEmail,
    required this.otp,
    required this.password,
    required this.firebaseVerificationId,
    required this.context,
  });
}

// Register
class RegisterUserEvent extends AuthEvent {
  final String userName;
  final String mobileNumber;
  final String emailAddress;
  final String password;
  final String age;
  final String countryCode;
  final String gender;
  final String profileImage;
  final BuildContext context;

  RegisterUserEvent({
    required this.userName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.password,
    required this.age,
    required this.countryCode,
    required this.gender,
    required this.profileImage,
    required this.context,
  });
}

class RegisterPageInitEvent extends AuthEvent {
  final RegisterPageArguments arg;

  RegisterPageInitEvent({required this.arg});
}

class ImageUpdateEvent extends AuthEvent {
  final ImageSource source;

  ImageUpdateEvent({required this.source});
}

class ReferralEvent extends AuthEvent {
  final String referralCode;
  final BuildContext context;

  ReferralEvent({required this.referralCode, required this.context});
}

// Login

class LoginUserEvent extends AuthEvent {
  final String emailOrMobile;
  final String otp;
  final String password;
  final bool isOtpLogin;
  final bool isLoginByEmail;
  final BuildContext context;
  LoginUserEvent({
    required this.emailOrMobile,
    required this.otp,
    required this.password,
    required this.isOtpLogin,
    required this.isLoginByEmail,
    required this.context,
  });
}

// Update Password

class UpdatePasswordEvent extends AuthEvent {
  final String emailOrMobile;
  final String password;
  final bool isLoginByEmail;
  final BuildContext context;
  UpdatePasswordEvent({
    required this.emailOrMobile,
    required this.password,
    required this.isLoginByEmail,
    required this.context,
  });
}

class UpdateGenderEvent extends AuthEvent {
  final bool? isGenderSelected;
  final String selectedGender;

  UpdateGenderEvent({required this.isGenderSelected, required this.selectedGender});
}

class CheckOtpVerifyEvent extends AuthEvent {
  final bool isOtpVerify;

  CheckOtpVerifyEvent({required this.isOtpVerify});
}

class CountryDataUpdateEvent extends AuthEvent {
  final String dialCode;
  final String flagImage;
  final int dialMaxLength;

  CountryDataUpdateEvent({required this.dialCode, required this.flagImage, required this.dialMaxLength});

}

class FirebaseCredentialUpdateEvent extends AuthEvent {
  final PhoneAuthCredential credential;

  FirebaseCredentialUpdateEvent({required this.credential});
}

class FirebaseVerifyUpdateEvent extends AuthEvent {
  final String verificationId;
  final int? resendToken;

  FirebaseVerifyUpdateEvent({required this.verificationId, required this.resendToken});

}