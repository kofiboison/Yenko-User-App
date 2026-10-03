import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/common.dart';
import '../../../core/utils/custom_snack_bar.dart';
import '../../../di/locator.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/models/country_list_model.dart';
import 'usecases/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final formKey = GlobalKey<FormState>();
  FocusNode textFieldFocus = FocusNode();
  TextEditingController emailOrMobileController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  AuthBloc() : super(AuthState.initial()) {
    on<AuthUpdateEvent>((event, emit) => emit(state.copyWith(status: AuthStatus.update, isLoading: false)));
    on<UpdateGenderEvent>((event, emit) =>
        emit(state.copyWith(isGenderSelected: event.isGenderSelected, selectedGender: event.selectedGender)));
    on<CheckOtpVerifyEvent>((event, emit) => emit(state.copyWith(isOtpVerify: event.isOtpVerify)));
    on<CountryDataUpdateEvent>((event, emit) =>
        emit(state.copyWith(dialCode: event.dialCode, dialMaxLength: event.dialMaxLength, flagImage: event.flagImage)));
    on<FirebaseCredentialUpdateEvent>((event, emit) => emit(state.copyWith(firebaseCredentials: event.credential)));
    on<FirebaseVerifyUpdateEvent>((event, emit) =>
        emit(state.copyWith(firebaseVerificationId: event.verificationId, firebaseResendToken: event.resendToken)));
    // Auth
    on<GetDirectionEvent>(_getDirection);
    on<CountryGetEvent>(_countryList);
    on<EmailorMobileOnChangeEvent>(_emailMobileOnchange);

    // Verify
    on<ShowPasswordIconEvent>(_showPassIconOnChange);
    on<VerifyUserEvent>(_verifyUserDetails);
    on<OTPOnChangeEvent>(_otpOnChange);
    on<GetCommonModuleEvent>(_commonModules);
    on<SignInWithOTPEvent>(_signInWithOTP);
    on<ConfirmOrVerifyOTPEvent>(_confirmOrVerifyOTP);
    on<VerifyTimerEvent>(_timerEvent);

    // Register
    on<RegisterUserEvent>(_registerUser);
    on<RegisterPageInitEvent>(_registerInit);
    on<ImageUpdateEvent>(_getProfileImage);
    on<ReferralEvent>(_getReferralCode);

    // Login
    on<LoginUserEvent>(_loginUser);

    // Update Password
    on<UpdatePasswordEvent>(_updatePassword);
  }

  Future<void> _getDirection(GetDirectionEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final textDirection = await AppSharedPreference.getLanguageDirection();
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    emit(state.copyWith(status: AuthStatus.loaded, textDirection: textDirection, languageCode: languageCode));
  }

  FutureOr<void> _countryList(CountryGetEvent event, Emitter<AuthState> emit) async {
    final data = await serviceLocator<AuthUsecase>().getCountryList();
    data.fold(
      (error) {
        emit(state.copyWith(status: AuthStatus.error));
      },
      (success) {
        Country defaultCountry = success.data.firstWhere((element) => element.datumDefault == true);
        emit(state.copyWith(
            countries: success.data,
            dialCode: defaultCountry.dialCode,
            flagImage: defaultCountry.flag ?? '',
            dialMaxLength: defaultCountry.dialMaxLength));
      },
    );
  }

  Future<void> _emailMobileOnchange(EmailorMobileOnChangeEvent event, Emitter<AuthState> emit) async {
    if (AppValidation.mobileNumberValidate(event.value)) {
      emit(state.copyWith(isLoginByEmail: false));
    } else if (!AppValidation.mobileNumberValidate(event.value)) {
      emit(state.copyWith(isLoginByEmail: true));
    }
  }

  // Verify

  Future<void> _showPassIconOnChange(ShowPasswordIconEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(showPassword: !event.showPassword));
  }

  FutureOr<void> _commonModules(AuthEvent event, Emitter<AuthState> emit) async {
    final data = await serviceLocator<AuthUsecase>().commonModuleCheck();
    data.fold(
      (error) {
        emit(state.copyWith(status: AuthStatus.error));
      },
      (success) async {
        emit(state.copyWith(
            isFirebaseOtpVerifyEnable: success.firebaseOtpEnabled, isRefferalEarnings: success.enableRefferal));
      },
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber, context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        add(FirebaseCredentialUpdateEvent(credential: credential));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
          showToast(message: AppLocalizations.of(context)!.notValidPhoneNumber);
        }
        add(AuthUpdateEvent());
      },
      codeSent: (String verificationId, int? resendToken) async {
        add(FirebaseVerifyUpdateEvent(verificationId: verificationId, resendToken: resendToken));
        add(AuthUpdateEvent());
        showToast(message: AppLocalizations.of(context)!.otpSendTo.replaceAll('***', phoneNumber));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _signInWithOTP(SignInWithOTPEvent event, Emitter<AuthState> emit) async {
    otpController.text = '';
    emit(state.copyWith(isLoading: true, isOtpVerify: event.isOtpVerify));
    bool firebaseEnabled;
    try {
      firebaseEnabled = (await FirebaseDatabase.instance.ref().child('call_FB_OTP').get()).value as bool? ?? false;
    } catch (e) {
      firebaseEnabled = false;
    }

    if (firebaseEnabled == true && !event.isLoginByEmail) {
      if (state.isFirebaseOtpVerifyEnable && !event.isLoginByEmail) {
        if (!event.context.mounted) return;
        await verifyPhoneNumber('${event.countryCode}${event.mobileOrEmail}', event.context);
        await Future.delayed(
          const Duration(seconds: 3),
          () {
            emit(state.copyWith(isLoading: false));
            if (event.isForgotPassword) {
              emit(state.copyWith(status: AuthStatus.forgotPasswordOTPSend));
            }
          },
        );
      } else {
        if (!event.isLoginByEmail) {
          final data = await serviceLocator<AuthUsecase>().sendMobileOtp(
            mobileNumber: event.mobileOrEmail,
            countryCode: event.countryCode,
          );
          data.fold(
            (error) {
              showToast(message: '${error.message}');
              emit(state.copyWith(isLoading: false));
            },
            (success) {
              showToast(message: AppLocalizations.of(event.context)!.otpSendTo.replaceAll('***', event.mobileOrEmail));
              emit(state.copyWith(isLoading: false));
              if (event.isForgotPassword) {
                emit(state.copyWith(status: AuthStatus.forgotPasswordOTPSend));
              }
            },
          );
        }
      }
    } else {
      emit(state.copyWith(isLoading: false));
      textFieldFocus.unfocus();
      if (event.isLoginByEmail) {
        final data = await serviceLocator<AuthUsecase>().sendEmailOtp(emailAddress: event.mobileOrEmail);
        data.fold(
          (error) {
            showToast(message: '${error.message}');
            emit(state.copyWith(isLoading: false));
          },
          (success) {
            showToast(message: AppLocalizations.of(event.context)!.otpSendTo.replaceAll('***', event.mobileOrEmail));
            emit(state.copyWith(isLoading: false));
            if (event.isForgotPassword) {
              emit(state.copyWith(status: AuthStatus.forgotPasswordOTPSend));
            }
          },
        );
      } else {
        if (!event.context.mounted) return;
        RemoteNotification noti = RemoteNotification(
            title: AppLocalizations.of(event.context)!.otpForLogin,
            body: AppLocalizations.of(event.context)!.testOtp.replaceAll('***', '123456'));
        showOtpNotification(noti);
        if (event.isForgotPassword) {
          emit(state.copyWith(status: AuthStatus.forgotPasswordOTPSend));
        }
      }
      emit(state.copyWith(status: AuthStatus.signInWithDemo));
    }
  }

  Future<void> _confirmOrVerifyOTP(ConfirmOrVerifyOTPEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    bool firebaseEnabled;
    try {
      firebaseEnabled = (await FirebaseDatabase.instance.ref().child('call_FB_OTP').get()).value as bool? ?? false;
    } catch (e) {
      firebaseEnabled = false;
    }
    if (event.otp.isNotEmpty) {
      if (firebaseEnabled == true && !event.isLoginByEmail) {
        if (state.isFirebaseOtpVerifyEnable && !event.isLoginByEmail) {
          try {
            PhoneAuthCredential credential =
                PhoneAuthProvider.credential(verificationId: event.firebaseVerificationId, smsCode: event.otp);
            await FirebaseAuth.instance.signInWithCredential(credential);

            if (!event.isForgotPasswordVerify) {
              if (!event.isUserExist) {
                // New User
                emit(state.copyWith(status: AuthStatus.newUserRegistered, isLoading: false));
              } else {
                if (!event.context.mounted) return;
                // Exist User
                add(LoginUserEvent(
                    emailOrMobile: event.mobileOrEmail,
                    otp: event.otp,
                    password: event.password,
                    isOtpLogin: event.isOtpVerify,
                    isLoginByEmail: event.isLoginByEmail,
                    context: event.context));
              }
            } else {
              emit(state.copyWith(status: AuthStatus.forgotPasswordOTPVerify, isLoading: false));
            }
          } on FirebaseAuthException catch (error) {
            debugPrint(error.toString());
            if (error.code == 'invalid-verification-code') {
              otpController.clear();
              emit(state.copyWith(isLoading: false));
              if (!event.context.mounted) return;
              showToast(message: AppLocalizations.of(event.context)!.enterValidOtp);
            } else {
              showToast(message: error.code);
              otpController.clear();
              emit(state.copyWith(isLoading: false));
            }
          }
        } else {
          if (!event.isLoginByEmail) {
            final data = await serviceLocator<AuthUsecase>().verifyMobileOtp(
              mobileNumber: event.mobileOrEmail,
              otp: event.otp,
            );
            data.fold(
              (error) {
                showToast(message: '${error.message}');
                emit(state.copyWith(isLoading: false));
              },
              (success) {
                showToast(message: AppLocalizations.of(event.context)!.verifySuccess);
                emit(state.copyWith(isLoading: false));
                if (!event.isForgotPasswordVerify) {
                  if (!event.isUserExist) {
                    // New User
                    emit(state.copyWith(status: AuthStatus.newUserRegistered));
                  } else {
                    // Exist User
                    add(LoginUserEvent(
                        emailOrMobile: event.mobileOrEmail,
                        otp: event.otp,
                        password: event.password,
                        isOtpLogin: event.isOtpVerify,
                        isLoginByEmail: event.isLoginByEmail,
                        context: event.context));
                  }
                } else {
                  emit(state.copyWith(status: AuthStatus.forgotPasswordOTPVerify));
                }
              },
            );
          }
        }
      } else {
        if (event.isLoginByEmail) {
          final data = await serviceLocator<AuthUsecase>().verifyEmailOtp(
            emailAddress: event.mobileOrEmail,
            otp: event.otp,
          );
          data.fold(
            (error) {
              showToast(message: '${error.message}');
              emit(state.copyWith(isLoading: false));
            },
            (success) {
              showToast(message: AppLocalizations.of(event.context)!.verifySuccess);
              emit(state.copyWith(isLoading: false));
              if (!event.isForgotPasswordVerify) {
                if (!event.isUserExist) {
                  // New User
                  emit(state.copyWith(status: AuthStatus.newUserRegistered));
                } else {
                  // Exist User
                  add(LoginUserEvent(
                      emailOrMobile: event.mobileOrEmail,
                      otp: event.otp,
                      password: event.password,
                      isOtpLogin: event.isOtpVerify,
                      isLoginByEmail: event.isLoginByEmail,
                      context: event.context));
                }
              } else {
                emit(state.copyWith(status: AuthStatus.forgotPasswordOTPVerify));
              }
            },
          );
        } else {
          // DEMO LOGIN
          if (event.isUserExist && event.otp == '123456' && !event.isForgotPasswordVerify) {
            if (!event.context.mounted) return;
            add(LoginUserEvent(
                emailOrMobile: event.mobileOrEmail,
                otp: event.otp,
                password: event.password,
                isOtpLogin: event.isOtpVerify,
                isLoginByEmail: event.isLoginByEmail,
                context: event.context));
          } else if (!event.isUserExist && event.otp == '123456' && !event.isForgotPasswordVerify) {
            emit(state.copyWith(status: AuthStatus.newUserRegistered));
          } else if (event.isUserExist && event.otp == '123456' && event.isForgotPasswordVerify) {
            emit(state.copyWith(status: AuthStatus.forgotPasswordOTPVerify));
          } else {
            otpController.clear();
            emit(state.copyWith(isLoading: false));
            if (!event.context.mounted) return;
            showToast(message: AppLocalizations.of(event.context)!.enterValidOtp);
          }
        }
      }
    } else {
      emit(state.copyWith(isLoading: false));
      if (!event.context.mounted) return;
      showToast(message: AppLocalizations.of(event.context)!.enterOtp);
    }
  }

  Future<void> _otpOnChange(OTPOnChangeEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.update));
  }

  FutureOr<void> _verifyUserDetails(VerifyUserEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<AuthUsecase>()
        .verifyUser(emailOrMobileNumber: emailOrMobileController.text, isLoginByEmail: state.isLoginByEmail);
    data.fold(
      (error) {
        emit(state.copyWith(isLoading: false));
      },
      (success) {
        emit(state.copyWith(status: AuthStatus.verifySuccess, isLoading: false, userExist: success.success));
      },
    );
  }

  Future<void> _timerEvent(VerifyTimerEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(timerDuration: event.duration));
  }

  // Register

  Future<void> _getProfileImage(ImageUpdateEvent event, Emitter<AuthState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: event.source);

    if (image != null) {
      emit(state.copyWith(profileImage: image.path.toString()));
    }
  }

  FutureOr _registerUser(RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, isLoading: true));
    final data = await serviceLocator<AuthUsecase>().userRegister(
      userName: event.userName,
      mobileNumber: event.mobileNumber,
      emailAddress: event.emailAddress,
      password: event.password,
      age: event.age,
      countryCode: event.countryCode,
      gender: event.gender,
      profileImage: event.profileImage,
    );
    data.fold(
      (error) {
        showToast(message: '${error.message}');
        emit(state.copyWith(status: AuthStatus.loaded, isLoading: false));
      },
      (success) async {
        showToast(message: 'Registered Successfully');
        emit(state.copyWith(status: AuthStatus.loginSuccess, isLoading: false));

        await AppSharedPreference.setToken('Bearer ${success.accessToken}');
        await AppSharedPreference.setLoginStatus(true);
      },
    );
  }

  Future<void> _registerInit(RegisterPageInitEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        isLoginByEmail: event.arg.isLoginByEmail,
        countries: event.arg.countryList,
        flagImage: event.arg.countryFlag,
        dialCode: event.arg.contryCode));
  }

  FutureOr _getReferralCode(ReferralEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    if (event.referralCode == 'Skip') {
      emit(state.copyWith(status: AuthStatus.referralSuccess, isLoading: false));
    } else {
      if (event.referralCode.isNotEmpty) {
        final data = await serviceLocator<AuthUsecase>().referralCode(referralCode: event.referralCode);
        data.fold(
          (error) {
            showToast(message: '${error.message}');
            emit(state.copyWith(status: AuthStatus.error, isLoading: false));
          },
          (success) async {
            showToast(message: AppLocalizations.of(event.context)!.welcome);
            emit(state.copyWith(status: AuthStatus.referralSuccess, isLoading: false));
          },
        );
      } else {
        showToast(message: AppLocalizations.of(event.context)!.enterRefferalCode);
      }
    }
  }

  // Login

  FutureOr _loginUser(LoginUserEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, isLoading: true));
    final data = await serviceLocator<AuthUsecase>().userLogin(
      emailOrMobile: event.emailOrMobile,
      otp: event.otp,
      password: event.password,
      isOtpLogin: event.isOtpLogin,
      isLoginByEmail: event.isLoginByEmail,
    );
    data.fold(
      (error) {
        if (error.message != null) {
          showToast(message: error.message!);
        } else {
          if (!event.isOtpLogin) {
            showToast(message: AppLocalizations.of(event.context)!.validPassword);
          } else {
            showToast(message: AppLocalizations.of(event.context)!.enterValidOtp);
          }
        }
        emit(state.copyWith(status: AuthStatus.loaded, isLoading: false));
      },
      (success) async {
        emit(state.copyWith(status: AuthStatus.loginSuccess, isLoading: false));
        showToast(message: AppLocalizations.of(event.context)!.loginSuccess);
        debugPrint('${success.tokenType} ${success.accessToken}');
        await AppSharedPreference.setToken('Bearer ${success.accessToken}');
        await AppSharedPreference.setLoginStatus(true);
      },
    );
  }

  // Update Password
  FutureOr _updatePassword(UpdatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<AuthUsecase>().updatePassword(
        emailOrMobile: event.emailOrMobile, password: event.password, isLoginByEmail: event.isLoginByEmail);
    data.fold(
      (error) {
        showToast(message: '${error.message}');
        emit(state.copyWith(isLoading: false));
      },
      (success) async {
        showToast(message: AppLocalizations.of(event.context)!.passCheck);
        emit(state.copyWith(status: AuthStatus.forgetPasswordUpdateSuccess, isLoading: false));
      },
    );
  }
}
