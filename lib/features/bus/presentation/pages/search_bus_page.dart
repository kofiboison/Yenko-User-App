import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../application/bus/bus_bloc.dart';
import '../widgets/boarding_detail_widget.dart';
import '../widgets/bus_details_widgte.dart';
import '../widgets/bus_filter_widget.dart';
import '../widgets/shimmer/bus_list_shimmer.dart';
import 'select_seat_page.dart';

class SearchBusPage extends StatelessWidget {
  static const String routeName = '/busSearchPage';
  final SearchBusPageArguments args;
  const SearchBusPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusBloc()
        ..add(GetDirectionEvent())
        ..add(SearchBusInitEvent(arg: args)),
      child: BlocListener<BusBloc, BusState>(
        listener: (context, state) async {
          if (state.status == BusStatus.logOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          }
        },
        child: BlocBuilder<BusBloc, BusState>(
          builder: (context, state) {
            final busBloc = context.read<BusBloc>();
             if (state.status == BusStatus.loadingStart){
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: size.height,
                width: size.width,
                child: const Loader());
            } else{
              return Directionality(
                textDirection: state.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  appBar: const CustomAppBar(title: ''),
                  body: Column(
                    children: [
                      boardingDetailWidget(context, busBloc, state),
                      SizedBox(height: size.width * 0.03),
                      if (!state.isLoading && state.busList.isNotEmpty)
                        busDetailListWidget(busBloc, state),
                      if (state.isLoading) const BusListShimmer(),
                      if (!state.isLoading && state.busList.isEmpty)
                        Center(
                            child: SizedBox(
                          height: size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                text: AppLocalizations.of(context)!.noBusesFound,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              SizedBox(height: size.width * 0.03),
                              MyText(
                                text: AppLocalizations.of(context)!.noBusesText,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14,
                                        color: Theme.of(context).dividerColor),
                              )
                            ],
                          ),
                        )),
                      SizedBox(height: size.width * 0.01),
                    ],
                  ),
                  bottomNavigationBar: state.journeyFilterModel !=null 
                    ? BusFilterWidget(busBloc:busBloc,busState: state) : null,
                ),
              );
            }
          },
        ),
      ),
    );
  }


  Widget busDetailListWidget(BusBloc busBloc, BusState state) {
    return Expanded(
      child: ListView.builder(
        controller: busBloc.scrollController,
        itemCount: state.busList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final bus = state.busList.elementAt(index);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SelectSeatPage.routeName,
                  arguments: SelectSeatPageArguments(
                    journeyId: bus.id,
                    selectedDate: state.showDate,
                    userData: args.userData,
                    fromShortCode: bus.fromCityShortCode,
                    toShortCode: bus.toCityShortCode,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: bus.busCompanyName,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (_) {
                                            return BlocProvider.value(
                                                value: busBloc,
                                                child:
                                                    BusDetailsWidget(bus: bus));
                                          },
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        color: AppColors.transparent,
                                        child: MyText(
                                          text: AppLocalizations.of(context)!
                                              .viewDetails,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blue,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                MyText(
                                  text:
                                      '${(bus.bus.data.isAcAvailable == '1') ? AppLocalizations.of(context)!.ac : AppLocalizations.of(context)!.nonAc} • ${bus.bus.data.seatType}',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),
                      BoardingDetailWidget(
                        fromTitle1: bus.depatureAtTime,
                        title1FontSize: 14,
                        title1Color: Theme.of(context).primaryColorDark,
                        fromTitle2: bus.fromCityShortCode,
                        title2FontSize: 14,
                        title2Color: Theme.of(context).dividerColor,
                        toTitle1: bus.arrivedAtTime,
                        toTitle2: bus.toCityShortCode,
                        travelHours: bus.duration,
                        dividerLength: 8,
                        useDottedDivider: true,
                        dividerColor: Theme.of(context).dividerColor,
                      ),
                      SizedBox(height: size.width * 0.02),
                      const Divider(thickness: 0.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.primary
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: AppColors.goldenColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 2),
                                      MyText(
                                        text: bus.rating,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: AppColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              MyText(
                                text: '(${bus.noOfratings})',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).hintColor,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              MyText(
                                text:
                                    '${bus.availableSeats} ${AppLocalizations.of(context)!.seats}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyText(
                                text:
                                    '${bus.currencySymbol}${bus.lowPrice.toStringAsFixed(2)}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget boardingDetailWidget(
      BuildContext context, BusBloc busBloc, BusState state) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            BoardingDetailWidget(
              fromTitle1: args.fromCity.split(' ')[0],
              fromTitle2: args.fromShortCode.toUpperCase(),
              toTitle1: args.toCity.split(' ')[0],
              toTitle2: args.toShortCode.toUpperCase(),
              title1FontSize: 16,
              title2FontSize: 14,
            ),
            SizedBox(height: size.width * 0.05),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  state.allDates.length,
                  (index) {
                    final date = state.allDates[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: InkWell(
                        onTap: () {
                          busBloc.add(DateUpdateEvent(
                              showDate: intl.DateFormat('MMMM d')
                                  .format(date)
                                  .toString(),
                              selectedDate: intl.DateFormat('dd/MM/yyyy')
                                  .format(date)
                                  .toString()));
                          busBloc.add(GetBusListEvent(
                              fromId: args.fromId,
                              toId: args.toId,
                              date: intl.DateFormat('dd/MM/yyyy')
                                  .format(date)
                                  .toString(),
                              page: 1));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: (state.showDate ==
                                      intl.DateFormat('MMMM d')
                                          .format(date)
                                          .toString())
                                  ? const Border(
                                      bottom: BorderSide(
                                      color: AppColors.white,
                                      width: 2,
                                    ))
                                  : null),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                  text: intl.DateFormat('MMMM d').format(date),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: (state.showDate ==
                                                  intl.DateFormat('MMMM d')
                                                      .format(date)
                                                      .toString())
                                              ? FontWeight.bold
                                              : FontWeight.w100,
                                          color: (state.showDate ==
                                                  intl.DateFormat('MMMM d')
                                                      .format(date)
                                                      .toString())
                                              ? AppColors.white
                                              : Theme.of(context).dividerColor),
                                ),
                                SizedBox(height: size.width * 0.01),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
