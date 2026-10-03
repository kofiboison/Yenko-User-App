import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';

class SearchPlacePage extends StatelessWidget {
  static const String routeName = '/searchPlacePage';
  final SearchPlacePageArguments arg;

  const SearchPlacePage({
    super.key,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: arg.homeBloc..add(GetSearchPlacesEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Directionality(
            textDirection: arg.homeBloc.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: MyText(
                    text: AppLocalizations.of(context)!.searchPlaces,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      filled: false,
                      hintText: AppLocalizations.of(context)!.search,
                      prefixIcon: const Icon(CupertinoIcons.location, size: 18),
                      suffixIcon: arg.homeBloc.searchController.text.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                arg.homeBloc.searchController.text = '';
                                arg.homeBloc.add(UpdateEvent());
                              },
                              child:
                                  const Icon(Icons.cancel_outlined, size: 18))
                          : null,
                      controller: arg.homeBloc.searchController,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      onChange: (value) {
                        arg.homeBloc.debouncer.run(() {
                          if (value.isNotEmpty) {
                            arg.homeBloc
                                .add(GetSearchPlacesEvent(searchText: value));
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state is HomeLoadingStartState
                          ? const Center(child: CircularProgressIndicator())
                          : arg.homeBloc.searchPlaces != null
                              ? ListView.builder(
                                  itemCount: arg
                                      .homeBloc.searchPlaces!.data.data.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final place = arg
                                        .homeBloc.searchPlaces!.data.data
                                        .elementAt(index);
                                    final boardingPoints = place.boardingPoints;

                                    final showBoardingPoints =
                                        (boardingPoints != null &&
                                            boardingPoints.isNotEmpty);

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                              CupertinoIcons.location),
                                          title: Text(place.city,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          subtitle: Text(place.shortCode,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          onTap: () {
                                            if (arg.isFromPickup) {
                                              arg.homeBloc.fromAddressController
                                                  .text = place.city;
                                              arg.homeBloc.fromCity =
                                                  place.city;
                                              arg.homeBloc.fromShortCode =
                                                  place.shortCode;
                                              arg.homeBloc.fromId = place.id;
                                            } else {
                                              arg.homeBloc.toAddressController
                                                  .text = place.city;
                                              arg.homeBloc.toCity = place.city;
                                              arg.homeBloc.toShortCode =
                                                  place.shortCode;
                                              arg.homeBloc.toId = place.id;
                                            }
                                            arg.homeBloc.searchController
                                                .clear();
                                            arg.homeBloc.add(UpdateEvent());
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                        if (showBoardingPoints)
                                          ListView.separated(
                                            itemCount: boardingPoints.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final boardingPoint =
                                                  boardingPoints
                                                      .elementAt(index);
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24.0),
                                                child: ListTile(
                                                  leading: const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.grey),
                                                  title: Text(
                                                      boardingPoint
                                                          .boardingAddress
                                                          .trim(),
                                                      style: const TextStyle(
                                                          color: Colors.grey)),
                                                  onTap: () {
                                                    if (arg.isFromPickup) {
                                                      arg
                                                              .homeBloc
                                                              .fromAddressController
                                                              .text =
                                                          boardingPoint
                                                              .boardingAddress
                                                              .trim();
                                                      arg.homeBloc.fromCity =
                                                          place.city;
                                                      arg.homeBloc
                                                              .fromShortCode =
                                                          place.shortCode;
                                                      arg.homeBloc.fromId =
                                                          place.id;
                                                    } else {
                                                      arg
                                                              .homeBloc
                                                              .toAddressController
                                                              .text =
                                                          boardingPoint
                                                              .boardingAddress
                                                              .trim();
                                                      arg.homeBloc.toCity =
                                                          place.city;
                                                      arg.homeBloc.toShortCode =
                                                          place.shortCode;
                                                      arg.homeBloc.toId =
                                                          place.id;
                                                    }
                                                    arg.homeBloc
                                                        .searchController
                                                        .clear();
                                                    arg.homeBloc
                                                        .add(UpdateEvent());
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                  height: size.width * 0.02);
                                            },
                                          )
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .noPlacesFound)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
