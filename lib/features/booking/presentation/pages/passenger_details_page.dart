import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/booking_bloc.dart';
import 'make_payment.dart';

class PassengerDetailsPage extends StatefulWidget {
  static const String routeName = '/passengerDetailsPage';
  final PassengerDetailsPageArguments args;
  const PassengerDetailsPage({super.key, required this.args});

  @override
  State<PassengerDetailsPage> createState() => _PassengerDetailsPageState();
}

class _PassengerDetailsPageState extends State<PassengerDetailsPage> {
  TextEditingController passengerPhoneController = TextEditingController();
  TextEditingController passengerEmailController = TextEditingController();
  TextEditingController applyCouponController = TextEditingController();
  List<TextEditingController> passengerNameController = [];
  List<TextEditingController> passengerAgeController = [];
  List<String> selectedGender = [];

  @override
  void initState() {
    passengerEmailController.text = widget.args.userData.email;
    passengerPhoneController.text = widget.args.userData.mobile;
    super.initState();
  }

  @override
  void dispose() {
    passengerEmailController.dispose();
    passengerPhoneController.dispose();
    applyCouponController.dispose();
    if (passengerNameController.isNotEmpty) {
      for (var element in passengerNameController) {
        element.dispose();
      }
    }
    if (passengerAgeController.isNotEmpty) {
      for (var element in passengerAgeController) {
        element.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc()
        ..add(GetDirectionEvent())
        ..add(PassengerDetailsInitEvent(arg: widget.args)),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.bookingSuccess) {
            Navigator.pushNamed(context, MakePaymentPage.routeName,
                arguments: MakePaymentPageArguments(
                    bookingData: state.bookingData!,
                    userData: widget.args.userData));
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final bookingBloc = context.read<BookingBloc>();
            if (state.status == BookingStatus.loading) {
              return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: size.height,
                  width: size.width,
                  child: const Loader());
            } else {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Directionality(
                  textDirection: state.textDirection == 'rtl'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      surfaceTintColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      iconTheme:
                          IconThemeData(color: Theme.of(context).primaryColor),
                      title: MyText(
                          text: AppLocalizations.of(context)!.passengerDetails,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Theme.of(context).primaryColor)),
                    ),
                    body: SafeArea(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.only(
                              left: size.width * 0.05,
                              right: size.width * 0.05,
                              bottom:
                                  100, // Add bottom padding equal to button height + margin
                            ),
                            child: Form(
                              key: bookingBloc.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size.width * 0.05),
                                  _buildBoardingPoints(context),
                                  SizedBox(height: size.width * 0.05),
                                  _buildPassengerDetailsHeader(context),
                                  SizedBox(height: size.width * 0.03),
                                  _buildPassengerDetails(context, bookingBloc),
                                  SizedBox(height: size.width * 0.05),
                                  _buildPromoDetailsHeader(context),
                                  SizedBox(height: size.width * 0.03),
                                  _buildPromoField(context, bookingBloc),
                                  SizedBox(height: size.width * 0.05),
                                  _buildContactDetailsHeader(context),
                                  SizedBox(height: size.width * 0.03),
                                  _buildEmailField(context, bookingBloc),
                                  SizedBox(height: size.width * 0.03),
                                  _buildPhoneField(context, bookingBloc),
                                  SizedBox(height: size.width * 0.25),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: _buildPaymentButton(
                                context, bookingBloc, state),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBoardingPoints(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.boardingPoints,
          textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: size.width * 0.03),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(size.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationRow(
                context,
                '${widget.args.startDate} @ ${widget.args.selectedBordingPoint.boardingTime}',
                '${widget.args.selectedBordingPoint.boardingPlace} ',
              ),
              SizedBox(height: size.width * 0.03),
              _buildLocationRow(
                context,
                '${widget.args.endDate} @ ${widget.args.selectedDropPoint.stopTime}',
                '${widget.args.selectedDropPoint.stopAddress} ',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context, String time, String place) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.directions_bus,
                color: Theme.of(context).primaryColor, size: 18),
            const SizedBox(width: 8),
            SizedBox(
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: time,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).dividerColor),
                  ),
                  SizedBox(height: size.width * 0.02),
                  MyText(
                    text: place,
                    maxLines: 6,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.edit,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildPassengerDetailsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.passengerDetails,
          textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildPassengerDetails(BuildContext context, BookingBloc bookingBloc) {
    return ListView.separated(
      itemCount: widget.args.selectedSeats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemBuilder: (context, index) {
        if (selectedGender.isEmpty) {
          for (var i = 0; i < widget.args.selectedSeats.length; i++) {
            selectedGender
                .add((widget.args.selectedSeats[i].isAvailableForFemale)
                    ? 'Female'
                    : (widget.args.selectedSeats[i].isAvailableForMale)
                        ? 'Male'
                        : '');
            passengerNameController.add(TextEditingController());
            passengerAgeController.add(TextEditingController());
          }
          bookingBloc.add(BookingUpdateEvent());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text:
                      '${AppLocalizations.of(context)!.passengers} ${index + 1}',
                  textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                ),
                MyText(
                  text: widget.args.selectedSeats[index].seatNo,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.red),
                ),
              ],
            ),
            SizedBox(height: size.width * 0.02),
            MyText(
              text: AppLocalizations.of(context)!.name,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: size.width * 0.02),
            CustomTextField(
              controller: passengerNameController[index],
              hintText: AppLocalizations.of(context)!.enterYourName,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterName;
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: size.width * 0.02),
            MyText(
              text: AppLocalizations.of(context)!.age,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: size.width * 0.02),
            CustomTextField(
              controller: passengerAgeController[index],
              hintText: AppLocalizations.of(context)!.enterAge,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterAge;
                }
                final age = int.tryParse(value);
                if (age == null) {
                  return AppLocalizations.of(context)!.invalidAge;
                } else if (age < 1) {
                  return 'age >= 1 year';
                } else if (age > 120) {
                  return AppLocalizations.of(context)!.invalidAge;
                }
                return null;
              },
            ),
            SizedBox(height: size.width * 0.03),
            MyText(
              text: AppLocalizations.of(context)!.gender,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: size.width * 0.02),
            SizedBox(
              height: size.width * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (!widget
                            .args.selectedSeats[index].isAvailableForFemale) {
                          selectedGender[index] = 'Male';
                          bookingBloc.add(GenderChangeEvent());
                        } else {
                          showToast(
                              message: AppLocalizations.of(context)!
                                  .femalePassengerOnlyText);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: (widget.args.selectedSeats[index]
                                    .isAvailableForFemale)
                                ? AppColors.grey
                                : null,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: (widget.args.selectedSeats[index]
                                        .isAvailableForFemale)
                                    ? AppColors.grey
                                    : Theme.of(context).dividerColor)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: AppLocalizations.of(context)!.male,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: (widget.args.selectedSeats[index]
                                                .isAvailableForFemale)
                                            ? AppColors.darkGrey
                                            : Theme.of(context).primaryColor),
                              ),
                              Radio(
                                  value: 'Male',
                                  groupValue: selectedGender[index],
                                  onChanged: (value) {
                                    if (!widget.args.selectedSeats[index]
                                        .isAvailableForFemale) {
                                      selectedGender[index] = 'Male';
                                      bookingBloc.add(GenderChangeEvent());
                                    } else {
                                      showToast(
                                          message:
                                              'This seat only available for Female passenger');
                                    }
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (!widget
                            .args.selectedSeats[index].isAvailableForMale) {
                          selectedGender[index] = 'Female';
                          bookingBloc.add(GenderChangeEvent());
                        } else {
                          showToast(
                              message: AppLocalizations.of(context)!
                                  .malePassengerOnlyText);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: (widget.args.selectedSeats[index]
                                    .isAvailableForMale)
                                ? AppColors.grey
                                : null,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: (widget.args.selectedSeats[index]
                                        .isAvailableForMale)
                                    ? AppColors.grey
                                    : Theme.of(context).dividerColor)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: AppLocalizations.of(context)!.female,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: (widget.args.selectedSeats[index]
                                                .isAvailableForMale)
                                            ? AppColors.darkGrey
                                            : Theme.of(context).primaryColor),
                              ),
                              Radio(
                                  value: 'Female',
                                  groupValue: selectedGender[index],
                                  onChanged: (value) {
                                    if (!widget.args.selectedSeats[index]
                                        .isAvailableForMale) {
                                      selectedGender[index] = 'Female';
                                      bookingBloc.add(GenderChangeEvent());
                                    } else {
                                      showToast(
                                          message: AppLocalizations.of(context)!
                                              .male);
                                    }
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: size.width * 0.05);
      },
    );
  }

  Widget _buildContactDetailsHeader(BuildContext context) {
    return MyText(
      text: AppLocalizations.of(context)!.contactDetails,
      textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildEmailField(BuildContext context, BookingBloc bookingBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.email,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: size.width * 0.02),
        CustomTextField(
          controller: passengerEmailController,
          hintText: AppLocalizations.of(context)!.enterEmail,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isNotEmpty && !AppValidation.emailValidate(value)) {
              return AppLocalizations.of(context)!.validEmail;
            } else if (value.isEmpty) {
              return AppLocalizations.of(context)!.enterEmail;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context, BookingBloc bookingBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.mobile,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: size.width * 0.02),
        CustomTextField(
          controller: passengerPhoneController,
          filled: true,
          borderRadius: 3,
          hintText: AppLocalizations.of(context)!.enterYourMobile,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isNotEmpty &&
                !AppValidation.mobileNumberValidate(value)) {
              return AppLocalizations.of(context)!.validMobile;
            } else if (value.isEmpty) {
              return AppLocalizations.of(context)!.enterMobile;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget _buildPromoDetailsHeader(BuildContext context) {
    return MyText(
      text: AppLocalizations.of(context)!.promoCode,
      textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildPromoField(BuildContext context, BookingBloc bookingBloc) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.promo,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: size.width * 0.02),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: applyCouponController,
                    hintText: AppLocalizations.of(context)!.enterpromoCode,
                    enabled: state.promoCodeResponse == null,
                  ),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  onTap: () {
                    if (applyCouponController.text.isEmpty) {
                      showToast(
                          message: AppLocalizations.of(context)!
                              .pleaseEnterPromoCode);
                      return;
                    }

                    if (state.promoCodeResponse != null) {
                      showToast(
                          message: AppLocalizations.of(context)!
                              .promoCodeAlreadyApplied);
                      return;
                    }

                    bookingBloc.add(ApplyPromoCodeEvent(
                        promoCode: applyCouponController.text,
                        boardingId: widget.args.selectedBordingPoint.boardingId,
                        ticketfare: state.totalAmount));
                  },
                  isLoader: state.promoLoading,
                  buttonName: state.promoCodeResponse == null
                      ? AppLocalizations.of(context)!.apply
                      : AppLocalizations.of(context)!.applied,
                  textSize: 16,
                  width: 100,
                  height: 30,
                )
              ],
            ),
            if (state.promoCodeResponse != null) ...[
              SizedBox(height: size.width * 0.02),
              Row(
                children: [
                  MyText(
                    text: AppLocalizations.of(context)!.promoAdded,
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      applyCouponController.clear();
                      bookingBloc.add(RemovePromoCodeEvent());
                    },
                    child: MyText(
                      text: AppLocalizations.of(context)!.remove,
                      textStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: AppColors.red,
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPaymentButton(
      BuildContext context, BookingBloc bookingBloc, BookingState state) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: size.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: AppLocalizations.of(context)!.total,
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).disabledColor,
                      ),
                ),
                MyText(
                  text: (state.promoCodeResponse != null)
                      ? state.promoCodeResponse?.data.ticketFare.toString()
                      : state.totalAmount.toString(),
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          CustomButton(
            onTap: () {
              if (bookingBloc.formKey.currentState!.validate() &&
                  !selectedGender.any((element) => element.isEmpty)) {
                bookingBloc.add(MakeBookingEvent(
                  journeyId: widget.args.journeyId,
                  userId: widget.args.userData.id.toString(),
                  boardingId: widget.args.selectedBordingPoint.boardingId,
                  dropId: widget.args.selectedDropPoint.stopId,
                  ticketFare: state.totalAmount,
                  mobile: passengerPhoneController.text,
                  email: passengerEmailController.text,
                  selectedSeats: widget.args.selectedSeats,
                  promoCode: state.promoCodeResponse != null
                      ? applyCouponController.text
                      : '',
                  passengerNameController: passengerNameController,
                  passengerAgeController: passengerAgeController,
                  selectedGender: selectedGender,
                ));
              } else if (selectedGender.any((element) => element.isEmpty)) {
                showToast(
                    message: AppLocalizations.of(context)!.pleaseSelectGender);
              }
            },
            width: size.width * 0.4,
            textSize: 12,
            isLoader: state.isLoading,
            buttonName: AppLocalizations.of(context)!.continueToPay,
          ),
        ],
      ),
    );
  }
}
