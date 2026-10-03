// ignore_for_file: use_build_context_synchronously

import 'package:bus_booking/core/utils/custom_appbar.dart';
import 'package:bus_booking/core/utils/custom_snack_bar.dart';
import 'package:bus_booking/features/account/application/acc_bloc.dart';
import 'package:bus_booking/features/auth/presentation/pages/auth_page.dart';
import 'package:bus_booking/features/home/presentation/pages/home_page.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';

class RatingsPage extends StatefulWidget {
  static const String routeName = '/ratingsPage';
  final RatingsPageArguments arg;

  const RatingsPage({super.key, required this.arg});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  TextEditingController feedBackController = TextEditingController();
  @override
  void dispose() {
    feedBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
        create: (context) => AccBloc()
          ..add(RatingsSelectEvent(
              selectedIndex: widget.arg.selectedRatingsIndex ?? 0)),
        child: BlocListener<AccBloc, AccState>(
          listener: (context, state) async {
            if (state.status == AccStatus.bookingUserRatingsSuccess) {
              if (state.message != null && state.message!.isNotEmpty) {
                showToast(message: state.message!);
              }
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            } else if (state.status == AccStatus.logOut) {
              if (state.message != null && state.message!.isNotEmpty) {
                // showToast(message: state.message!);
              }
              await AppSharedPreference.setLoginStatus(false);
              Navigator.pushNamedAndRemoveUntil(
                  context, AuthPage.routeName, (route) => false);
            }
          },
          child: BlocBuilder<AccBloc, AccState>(
            builder: (context, state) {
              return Scaffold(
                appBar: CustomAppBar(
                  title: "Rate us",
                  automaticallyImplyLeading: true,
                  onBackTap: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: size.width * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: MyText(
                                text:
                                    "${AppLocalizations.of(context)!.helpUsImprove} * ${widget.arg.booking.company}\n${AppLocalizations.of(context)!.pleaseRateYourRide}"
                                        .replaceAll(
                                            '*', widget.arg.booking.company),
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: size.width * 0.03),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                // color: AppColors.grey,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyText(
                                  text:
                                      "${widget.arg.booking.fromCity} → ${widget.arg.booking.toCity}",
                                  maxLines: 5,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            SizedBox(height: size.width * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          width: size.width * 0.7,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyText(
                                                text:
                                                    "${AppLocalizations.of(context)!.ticketNumber}: ${widget.arg.booking.ticketNumber}",
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                      SizedBox(height: size.width * 0.01),
                                      const Divider(
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                      SizedBox(height: size.width * 0.01),
                                      MyText(
                                          text: AppLocalizations.of(context)!
                                              .giveRatings,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                              )),
                                      SizedBox(height: size.width * 0.01),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          5,
                                          (index) {
                                            return InkWell(
                                              onTap: () {
                                                context.read<AccBloc>().add(
                                                    RatingsSelectEvent(
                                                        selectedIndex:
                                                            index + 1));
                                              },
                                              child: Icon(
                                                (index + 1 <=
                                                            state
                                                                .selectedRatingsIndex &&
                                                        state.selectedRatingsIndex !=
                                                            0)
                                                    ? Icons.star
                                                    : Icons
                                                        .star_border_outlined,
                                                color: (index + 1 <=
                                                            state
                                                                .selectedRatingsIndex &&
                                                        state.selectedRatingsIndex !=
                                                            0)
                                                    ? AppColors.goldenColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                size: 30,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: size.width * 0.05),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.width * 0.05),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .leavefeedback,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        )),
                              ),
                            ),
                            SizedBox(height: size.width * 0.03),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomTextField(
                                controller: feedBackController,
                                filled: true,
                                hintText: AppLocalizations.of(context)!
                                    .leavefeedbackOptional,
                                maxLine: 5,
                              ),
                            ),
                            SizedBox(height: size.width * 0.1),
                            Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: CustomButton(
                                    width: size.width,
                                    buttonColor: Theme.of(context).primaryColor,
                                    buttonName:
                                        AppLocalizations.of(context)!.submit,
                                    onTap: () {
                                      if (state.selectedRatingsIndex > 0) {
                                        context.read<AccBloc>().add(
                                              UserRatingsEvent(
                                                  // requestId: arg.requestId,
                                                  ratings:
                                                      '${state.selectedRatingsIndex}',
                                                  feedBack:
                                                      feedBackController.text,
                                                  ticketNumber:
                                                      widget.arg.ticketNumber,
                                                  journeyId:
                                                      widget.arg.journeryId),
                                            );
                                      } else {
                                        showToast(
                                          message: AppLocalizations.of(context)!
                                              .pleaseGiveRatings,
                                        );
                                      }
                                    },
                                  )),
                            ),
                            SizedBox(height: size.width * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
