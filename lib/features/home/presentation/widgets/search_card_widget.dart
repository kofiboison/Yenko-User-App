import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../bus/presentation/pages/search_bus_page.dart';
import '../../application/home_bloc.dart';
import '../pages/search_place_page.dart';

class SearchCardWidget extends StatelessWidget {
  const SearchCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();
        return Positioned(
          top: size.width * 0.1,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .hintColor
                        .withAlpha((0.1 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                // border: Border.all(
                //   width: 0.5,
                //   // color: Theme.of(context).primaryColor,
                // ),
                borderRadius: BorderRadius.circular(12),
              ),
              width: size.width * 0.86,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).hintColor,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 15),
                              child: InkWell(
                                onTap: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    SearchPlacePage.routeName,
                                    arguments: SearchPlacePageArguments(
                                        isFromPickup: true, homeBloc: homeBloc),
                                  );
                                  if (result == true) {
                                    homeBloc.add(UpdateEvent());
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(),
                                  child: Row(
                                    children: [
                                      const Icon(CupertinoIcons.location,
                                          size: 20),
                                      SizedBox(width: size.width * 0.04),
                                      Expanded(
                                        child: MyText(
                                          text: homeBloc.fromAddressController
                                                  .text.isNotEmpty
                                              ? homeBloc
                                                  .fromAddressController.text
                                              : AppLocalizations.of(context)!
                                                  .from,
                                          maxLines: 1,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: (homeBloc
                                                        .fromAddressController
                                                        .text
                                                        .isNotEmpty)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .hintColor,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Theme.of(context).hintColor,
                              indent: 8,
                              endIndent: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 15),
                              child: InkWell(
                                onTap: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    SearchPlacePage.routeName,
                                    arguments: SearchPlacePageArguments(
                                        isFromPickup: false,
                                        homeBloc: homeBloc),
                                  );
                                  if (result == true) {
                                    homeBloc.add(UpdateEvent());
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 20),
                                      SizedBox(width: size.width * 0.04),
                                      Expanded(
                                        child: MyText(
                                          text: homeBloc.toAddressController
                                                  .text.isNotEmpty
                                              ? homeBloc
                                                  .toAddressController.text
                                              : AppLocalizations.of(context)!
                                                  .to,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: (homeBloc
                                                        .toAddressController
                                                        .text
                                                        .isNotEmpty)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .hintColor,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        right: Directionality.of(context) == TextDirection.ltr
                            ? 0
                            : null,
                        left: Directionality.of(context) == TextDirection.rtl
                            ? 0
                            : null,
                        child: InkWell(
                          onTap: () {
                            homeBloc.add(ReplaceBoardingDropEvent());
                          },
                          child: Container(
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: const Center(
                              child: Icon(Icons.sync, color: AppColors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).hintColor,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    child: InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(
                            days: int.parse(context
                                    .read<HomeBloc>()
                                    .userData!
                                    .maxDays) -
                                1,
                          )),
                        );
                        if (picked != null) {
                          homeBloc.add(SelectDateEvent(selectedDate: picked));
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.date_range_outlined, size: 20),
                          SizedBox(width: size.width * 0.04),
                          Expanded(
                            child: MyText(
                              text: homeBloc.dateController.text.isEmpty
                                  ? 'Select Date'
                                  : homeBloc.dateController.text,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        (homeBloc.dateController.text.isEmpty)
                                            ? Theme.of(context).hintColor
                                            : Theme.of(context).primaryColor,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.07),
                  CustomButton(
                    width: size.width * 0.8,
                    buttonName: AppLocalizations.of(context)!.search,
                    onTap: () {
                      if (homeBloc.fromId.isNotEmpty &&
                          homeBloc.toId.isNotEmpty) {
                        Navigator.pushNamed(context, SearchBusPage.routeName,
                                arguments: SearchBusPageArguments(
                                    selectDate: homeBloc.pickedDate,
                                    fromCity: homeBloc.fromCity,
                                    toCity: homeBloc.toCity,
                                    fromId: homeBloc.fromId,
                                    toId: homeBloc.toId,
                                    fromShortCode: homeBloc.fromShortCode,
                                    toShortCode: homeBloc.toShortCode,
                                    userData: homeBloc.userData!))
                            .then(
                          (value) {
                            // homeBloc.fromAddressController.clear();
                            // homeBloc.toAddressController.clear();
                            // homeBloc.fromId = '';
                            // homeBloc.toId = '';
                            // homeBloc.pickedDate = DateTime.now();
                            // homeBloc.add(UpdateEvent());
                          },
                        );
                      } else {
                        showToast(
                            message:
                                AppLocalizations.of(context)!.selectTheCity);
                      }
                    },
                  ),
                  SizedBox(height: size.width * 0.01),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
