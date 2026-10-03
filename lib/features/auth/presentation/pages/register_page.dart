import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/auth_bloc.dart';
import '../widgets/auth_select_country_widget.dart';
import 'apply_refferal_page.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/registerPage';
  final RegisterPageArguments arg;
  const RegisterPage({super.key, required this.arg});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController rUserNameController = TextEditingController();
  TextEditingController rMobileController = TextEditingController();
  TextEditingController rEmailController = TextEditingController();
  TextEditingController rAgeController = TextEditingController();
  TextEditingController rPasswordController = TextEditingController();

  @override
  void initState() {
    if (widget.arg.isLoginByEmail) {
      rEmailController.text = widget.arg.emailOrMobile;
    } else {
      rMobileController.text = widget.arg.emailOrMobile;
    }
    AuthBloc().add(AuthUpdateEvent());
    super.initState();
  }

  @override
  void dispose() {
    rUserNameController.dispose();
    rMobileController.dispose();
    rEmailController.dispose();
    rAgeController.dispose();
    rPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(RegisterPageInitEvent(arg: widget.arg)),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final authBloc = context.read<AuthBloc>();
          if (state.status == AuthStatus.loginSuccess) {
            authBloc.add(AuthUpdateEvent());
            if (widget.arg.isRefferalEarnings == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, ApplyRefferalPage.routeName, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final authBloc = context.read<AuthBloc>();
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Directionality(
                textDirection: state.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: size.width * 0.019),
                          Image.asset(AppImages.logo, height: size.width * 0.3),
                          SizedBox(height: size.width * 0.01),
                          Center(
                            child: MyText(
                              text: AppLocalizations.of(context)!
                                  .enteryInfoToRegister,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Form(
                              key: authBloc.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size.width * 0.04),
                                  buildProfilePick(size, context,state),
                                  SizedBox(height: size.width * 0.1),
                                  MyText(
                                    text: AppLocalizations.of(context)!.name,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                  ),
                                  SizedBox(height: size.width * 0.02),
                                  buildUserNameField(context),
                                  SizedBox(height: size.width * 0.02),
                                  MyText(
                                    text: AppLocalizations.of(context)!.mobile,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                  ),
                                  SizedBox(height: size.width * 0.02),
                                  buildMobileField(context, size,authBloc,state),
                                  SizedBox(height: size.width * 0.02),
                                  MyText(
                                    text: AppLocalizations.of(context)!.email,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                  ),
                                  SizedBox(height: size.width * 0.02),
                                  buildEmailField(context,state),
                                  SizedBox(height: size.width * 0.02),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.45,
                                        child: MyText(
                                          text: AppLocalizations.of(context)!
                                              .gender,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.01),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: size.width * 0.03),
                                      SizedBox(
                                          width: size.width * 0.45,
                                          child: buildGenderChoose(context,state,authBloc)),
                                    ],
                                  ),
                                  MyText(
                                    text:
                                        AppLocalizations.of(context)!.password,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                  ),
                                  SizedBox(height: size.width * 0.02),
                                  buildPasswordField(context, size,state,authBloc),
                                  SizedBox(height: size.width * 0.1),
                                  buildButton(context,state,authBloc),
                                  SizedBox(height: size.width * 0.3),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context,AuthState state,AuthBloc authBloc) {
    return Center(
      child: CustomButton(
        buttonName: AppLocalizations.of(context)!.save,
        borderRadius: 5,
        height: size.height * 0.06,
        width: size.width,
        isLoader: state.isLoading,
        onTap: () {
          if (authBloc.formKey.currentState!.validate() &&
              state.selectedGender.isNotEmpty &&
              !state.isLoading) {
            authBloc.add(RegisterUserEvent(
                userName: rUserNameController.text,
                mobileNumber: rMobileController.text,
                emailAddress: rEmailController.text,
                password: rPasswordController.text,
                age: rAgeController.text,
                countryCode: widget.arg.contryCode,
                gender: state.selectedGender,
                profileImage: state.profileImage,
                context: context));
          }

          if(state.selectedGender.isEmpty){
            showToast(message: AppLocalizations.of(context)!.pleaseSelectGender);
          }
        },
      ),
    );
  }

  Widget buildGenderChoose(BuildContext context,AuthState state,AuthBloc authBloc) {
    return Row(
      children: [
        Column(
          children: [
            InkWell(
              onTap: () {
                authBloc.add(UpdateGenderEvent(selectedGender: 'Male',isGenderSelected:true));
              },
              child: Container(
                height: size.width * 0.1,
                width: size.width * 0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (state.isGenderSelected != null &&
                          state.isGenderSelected!)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).shadowColor,
                ),
                child: Icon(Icons.male,
                    color: (state.isGenderSelected != null &&
                            state.isGenderSelected!)
                        ? AppColors.white
                        : Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(height: size.width * 0.01),
            MyText(
              text: AppLocalizations.of(context)!.m,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            )
          ],
        ),
        SizedBox(width: size.width * 0.03),
        Column(
          children: [
            InkWell(
              onTap: () {
                authBloc.add(UpdateGenderEvent(selectedGender: 'Female',isGenderSelected:false));
              },
              child: Container(
                height: size.width * 0.1,
                width: size.width * 0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (state.isGenderSelected != null &&
                          !state.isGenderSelected!)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).shadowColor,
                ),
                child: Icon(Icons.female,
                    color: (state.isGenderSelected != null &&
                            !state.isGenderSelected!)
                        ? AppColors.white
                        : Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(height: size.width * 0.01),
            MyText(
              text: AppLocalizations.of(context)!.f,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ],
    );
  }

  Widget buildPasswordField(BuildContext context, Size size,AuthState state,AuthBloc authBloc) {
    return CustomTextField(
      controller: rPasswordController,
      filled: true,
      obscureText: !state.showPassword,
      hintText: AppLocalizations.of(context)!.enterYourPassword,
      suffixConstraints: BoxConstraints(maxWidth: size.width * 0.2),
      suffixIcon: InkWell(
        onTap: () {
          authBloc.add(ShowPasswordIconEvent(
              showPassword: state.showPassword));
        },
        child: !state.showPassword
            ? const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.darkGrey,
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.visibility,
                  color: AppColors.darkGrey,
                ),
              ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.enterPassword;
        } else if (value.length < 8) {
          return AppLocalizations.of(context)!.minPassRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildEmailField(BuildContext context,AuthState state) {
    return CustomTextField(
      controller: rEmailController,
      enabled: !state.isLoginByEmail,
      filled: true,
      borderRadius: 3,
      fillColor: state.isLoginByEmail
          ? Theme.of(context).disabledColor.withAlpha((0.1 * 255).toInt())
          : null,
      hintText: AppLocalizations.of(context)!.enterYourEmail,
      validator: (value) {
        if (value!.isNotEmpty && !AppValidation.emailValidate(value)) {
          return AppLocalizations.of(context)!.validEmail;
        } else if (value.isEmpty) {
          return AppLocalizations.of(context)!.enterEmail;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildMobileField(BuildContext context, Size size,AuthBloc authBloc,AuthState state) {
    return CustomTextField(
      controller: rMobileController,
      filled: true,
      borderRadius: 3,
      fillColor: !state.isLoginByEmail
          ? Theme.of(context).disabledColor.withAlpha((0.1 * 255).toInt())
          : null,
      enabled: state.isLoginByEmail,
      hintText: AppLocalizations.of(context)!.enterYourMobile,
      keyboardType: TextInputType.number,
      prefixConstraints: BoxConstraints(maxWidth: size.width * 0.2),
      prefixIcon: Center(
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (cont) {
                return AuthSelectCountryWidget(
                    auth: authBloc, countries: widget.arg.countryList);
              },
            );
          },
          child: Row(
            children: [
              Container(
                height: 20,
                width: 25,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).hintColor,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      state.flagImage,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: (state.flagImage.isEmpty)
                    ? const Center(
                        child: Loader(), // Placeholder loader
                      )
                    : null,
              ),
              MyText(text: state.dialCode),
            ],
          ),
        ),
      ),
      validator: (value) {
        if (value!.isNotEmpty && !AppValidation.mobileNumberValidate(value)) {
          return AppLocalizations.of(context)!.validMobile;
        } else if (value.isEmpty) {
          return AppLocalizations.of(context)!.enterMobile;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildUserNameField(BuildContext context) {
    return CustomTextField(
      controller: rUserNameController,
      filled: true,
      borderRadius: 3,
      hintText: AppLocalizations.of(context)!.enterYourName,
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.enterUserName;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildProfilePick(Size size, BuildContext context,AuthState state) {
    return SafeArea(
      child: Center(
        child: CircleAvatar(
          radius: size.width * 0.11,
          backgroundColor: Theme.of(context).dividerColor,
          backgroundImage: state.profileImage.isNotEmpty
              ? FileImage(File(state.profileImage))
              : const AssetImage(AppImages.defaultProfile),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _showImageSourceSheet(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.black,
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: 15,
                      )),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).splashColor,
      builder: (_) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: MyText(
                  text: AppLocalizations.of(context)!.cameraText,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<AuthBloc>()
                      .add(ImageUpdateEvent(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  size: 20,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: MyText(
                  text: AppLocalizations.of(context)!.galleryText,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<AuthBloc>()
                      .add(ImageUpdateEvent(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAgeField(BuildContext context) {
    return CustomTextField(
      controller: rAgeController,
      filled: true,
      borderRadius: 3,
      fillColor: null,
      hintText: AppLocalizations.of(context)!.enterAge,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && int.parse(value.toString()) < 1) {
          return 'age >= 1 year';
        } else if (value.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterAge;
        } else if (int.parse(value) > 120) {
          return AppLocalizations.of(context)!.invalidAge;
        } else {
          return null;
        }
      },
    );
  }
}
