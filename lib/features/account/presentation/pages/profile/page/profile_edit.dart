import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../bloc/profile_bloc.dart';
import '../widget/gender_select_widget.dart';

class ProfileEditPage extends StatefulWidget {
  static const String routeName = 'profileEditPage';
  final ProfileEditPageArguments arg;
  const ProfileEditPage({super.key, required this.arg});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.arg.userData!.name;
    mobileNumberController.text = widget.arg.userData!.mobile;
    emailController.text = widget.arg.userData!.email;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()
        ..add(ProfileGetDirectionEvent())
        ..add(ProfileEditInitEvent(userDetailData: widget.arg.userData!))
        ..add(GenderSelectedEvent(widget.arg.userData!.gender)),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) async {
            final profileBloc = context.read<ProfileBloc>();
          if (state.status == ProfileStatus.openBottomSheet) {
            profileBloc.add(ProfileUpdateEvent());
            showModalBottomSheet(
              context: context,
              builder: (_) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Theme.of(context)
                            .primaryColorDark
                            .withAlpha((0.5 * 255).toInt()),
                      ),
                      title: MyText(
                        text: AppLocalizations.of(context)!.cameraText,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withAlpha((0.5 * 255).toInt())),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _updateProfileImage(profileBloc, ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        size: 20,
                        color: Theme.of(context)
                            .primaryColorDark
                            .withAlpha((0.5 * 255).toInt()),
                      ),
                      title: MyText(
                        text: AppLocalizations.of(context)!.galleryText,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withAlpha((0.5 * 255).toInt())),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _updateProfileImage(profileBloc, ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state.status == ProfileStatus.userDetailUpdate) {
            profileBloc.add(ProfileUpdateEvent());
            Navigator.pop(context, state.userData);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: MyText(
                      text: AppLocalizations.of(context)!
                          .successfullyUpdatedText)),
            );
          } else if (state.status == ProfileStatus.logOut) {
            profileBloc.add(ProfileUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          final profileBloc = context.read<ProfileBloc>();
          if (state.status == ProfileStatus.loading){
            return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: size.height,
                width: size.width,
                child: const Loader());
          } else { 
            return Directionality(
            textDirection: state.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: widget.arg.userData != null
                ? Scaffold(
                    body: Form(
                      key: profileBloc.profileEditFormKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: size.height * 0.21,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                ),
                                Positioned(
                                  top: size.width * 0.35,
                                  left: size.width * 0.38,
                                  child: GestureDetector(
                                    onTap: () {
                                      profileBloc.add(ProfileUpdateEvent(status: ProfileStatus.openBottomSheet));
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          widget.arg.userData!.profilePicture),
                                      radius: size.width * 0.10,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 15,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: size.width * 0.18,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(
                                            context, state.userData);
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: size.width * 0.18,
                                  left: size.width * 0.38,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!.profile,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          fontSize: 20,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.06),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size.width * 0.1),
                                  MyText(
                                    text: AppLocalizations.of(context)!.name,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                  SizedBox(height: size.width * 0.02),
                                  buildUserNameField(context, profileBloc),
                                  SizedBox(height: size.width * 0.02),
                                  MyText(
                                    text: AppLocalizations.of(context)!.mobile,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                  SizedBox(height: size.width * 0.02),
                                  buildMobileField(context, profileBloc),
                                  SizedBox(height: size.width * 0.02),
                                  MyText(
                                    text: AppLocalizations.of(context)!.email,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                  SizedBox(height: size.width * 0.02),
                                  buildEmailField(context, profileBloc),
                                  SizedBox(height: size.width * 0.02),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.43,
                                        child: MyText(
                                          text: AppLocalizations.of(context)!
                                              .gender,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.01),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: size.width * 0.4,
                                          child: const GenderSelector()),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.03),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottomNavigationBar: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: CustomButton(
                        width: size.width * 0.9,
                        buttonName: AppLocalizations.of(context)!.update,
                        onTap: () {
                          {
                            profileBloc.add(UpdateUserDetailsEvent(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              gender: state.selectedGender,
                              profileImage:
                                  state.profileImage.isEmpty
                                      ? ""
                                      : state.profileImage,
                            ));
                          }
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
          );
          }
        }),
      ),
    );
  }

  Widget buildEmailField(BuildContext context, ProfileBloc profileBloc) {
    return CustomTextField(
      controller: emailController,
      hintText: widget.arg.userData!.email,
      filled: true,
      fillColor: AppColors.white,
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

  Widget buildUserNameField(BuildContext context, ProfileBloc profileBloc) {
    return CustomTextField(
      controller: nameController,
      filled: true,
      fillColor: AppColors.white,
      hintText: widget.arg.userData!.name,
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.enterYourName;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildMobileField(BuildContext context, ProfileBloc profileBloc) {
    return CustomTextField(
      controller: mobileNumberController,
      filled: true,
      hintText: widget.arg.userData!.mobile,
      enabled: false,
      keyboardType: TextInputType.number,
      prefixConstraints: BoxConstraints(maxWidth: size.width * 0.2),
      validator: (value) {
        if (value!.isNotEmpty && !AppValidation.mobileNumberValidate(value)) {
          return AppLocalizations.of(context)!.notValidPhoneNumber;
        } else if (value.isEmpty) {
          return AppLocalizations.of(context)!.enterMobile;
        } else {
          return null;
        }
      },
    );
  }

  void _updateProfileImage(
    ProfileBloc profileBloc,
    ImageSource source,
  ) {
    profileBloc.add(UpdateImageEvent(
      name: widget.arg.userData!.name,
      email: widget.arg.userData!.email,
      gender: widget.arg.userData!.gender,
      source: source,
    ));
  }
}


