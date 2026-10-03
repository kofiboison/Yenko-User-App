import 'package:bus_booking/features/home/presentation/widgets/bus_tracking_card.dart';
import 'package:bus_booking/features/home/presentation/widgets/popular_recent_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_booking/features/account/presentation/pages/account_page.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../bus/presentation/pages/search_bus_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../application/home_bloc.dart';
import '../widgets/promos_widget.dart';
import '../widgets/search_card_widget.dart';
import '../../../booking/presentation/pages/make_payment.dart';
import 'package:bus_booking/features/account/domain/models/booking_history_model.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';
  final bool showRatingDialog;
  final BookingHistoryData? booking;

  const HomePage({super.key, this.showRatingDialog = false, this.booking});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(GetPopularRoutesEvent())
        ..add(GetUserDetailsEvent(isFirstCall: true)),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          final homeBloc = context.read<HomeBloc>();
          if (state is LogoutState) {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is UpdateZoneLocationState) {
            context.read<LoaderBloc>().add(UpdateUserLocationEvent());
          } else if (state is PaymentPendingState) {
            Navigator.pushNamed(context, MakePaymentPage.routeName,
                arguments: MakePaymentPageArguments(
                    bookingData: state.bookingData, userData: state.userData));
          } else if (state is SearchBusState) {
            Navigator.pushNamed(
              context,
              SearchBusPage.routeName,
              arguments: SearchBusPageArguments(
                selectDate: homeBloc.pickedDate,
                fromCity: homeBloc.fromCity,
                fromId: homeBloc.fromId,
                toCity: homeBloc.toCity,
                toId: homeBloc.toId,
                fromShortCode: homeBloc.fromShortCode,
                toShortCode: homeBloc.toShortCode,
                userData: homeBloc.userData!,
              ),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final homeBloc = context.read<HomeBloc>();
            return PopScope(
              canPop: true,
              child: Directionality(
                textDirection: homeBloc.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).primaryColor,
                    surfaceTintColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    iconTheme: const IconThemeData(color: AppColors.white),
                    toolbarHeight: size.width * 0.20,
                    flexibleSpace: Padding(
                      padding: EdgeInsets.only(
                        top: size.width * 0.16,
                        left: 28,
                        right: 28,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text:
                                    "${AppLocalizations.of(context)!.hello}, ${homeBloc.userData?.name.trim().isNotEmpty == true ? homeBloc.userData!.name : ""}",

                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                              ),
                              MyText(
                                text: AppLocalizations.of(context)!.bookYourBus,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (homeBloc.userData != null) {
                                Navigator.pushNamed(
                                  context,
                                  AccountPage.routeName,
                                  arguments: AccountPageArguments(
                                    userData: homeBloc.userData!,
                                  ),
                                ).then(
                                  (value) {
                                    if (!context.mounted) return;
                                    homeBloc.add(GetDirectionEvent());
                                  },
                                );
                              }
                            },
                            child: Icon(
                              Icons.menu,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              SizedBox(
                                width: size.width,
                                height: size.width * 0.82,
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.width * 0.5,
                                      color: Theme.of(context).primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                    ),
                                    SizedBox(height: size.width * 0.2),
                                  ],
                                ),
                              ),
                              const SearchCardWidget(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LiveTrackingWidget(homeBloc: homeBloc),
                          PopularRouteWidget(homeBloc: homeBloc),
                          SizedBox(height: size.width * 0.05),
                          if (context.read<HomeBloc>().userData != null)
                            PromosWidget(homeBloc: homeBloc),
                          SizedBox(height: size.width * 0.2),
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
}
