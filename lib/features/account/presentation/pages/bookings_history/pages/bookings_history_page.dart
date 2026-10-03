import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../bloc/history_bloc.dart';
import '../widget/booking_history_page_card.dart';
import '../widget/history_card_shimmer.dart';

class BookingsHistoryPage extends StatelessWidget {
  static const String routeName = '/bookingPage';
  final BookingsHistoryPageArguments args;
  const BookingsHistoryPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc()
        ..add(HistoryGetDirectionEvent())
        ..add(BookingsPageInitEvent(arg: args)),
      child: BlocListener<HistoryBloc, HistoryState>(
        listener: (context, state) async {
          final historyBloc = context.read<HistoryBloc>();
          if (state.status == HistoryStatus.logOut) {
            historyBloc.add(HistoryUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          }
        },
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            final historyBloc = context.read<HistoryBloc>();
            return Directionality(
              textDirection: state.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.bookings,
                  automaticallyImplyLeading: true,
                  onBackTap: () {
                    Navigator.of(context).pop();
                    historyBloc.scrollController.dispose();
                  },
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTab(
                                  historyBloc: historyBloc,
                                  state: state,
                                  context: context,
                                  title: AppLocalizations.of(context)!.upcoming,
                                  index: 1,
                                  selectedIndex: state.selectedHistoryType),
                              _buildTab(
                                  historyBloc: historyBloc,
                                  state: state,
                                  context: context,
                                  title: AppLocalizations.of(context)!.ongoing,
                                  index: 3,
                                  selectedIndex: state.selectedHistoryType),
                              _buildTab(
                                  historyBloc: historyBloc,
                                  state: state,
                                  context: context,
                                  title:
                                      AppLocalizations.of(context)!.completed,
                                  index: 0,
                                  selectedIndex: state.selectedHistoryType),
                              _buildTab(
                                  historyBloc: historyBloc,
                                  state: state,
                                  context: context,
                                  title:
                                      AppLocalizations.of(context)!.cancelled,
                                  index: 2,
                                  selectedIndex: state.selectedHistoryType),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: historyBloc.scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state.isLoading && state.firstLoad)
                                const HistoryShimmer(),
                              if (!state.isLoading && state.historyList.isEmpty)
                                const HistoryNodataWidget(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: state.historyList.length,
                                    itemBuilder: (_, index) {
                                      final history =
                                          state.historyList.elementAt(index);
                                      return Column(
                                        children: [
                                          BookingHistoryCardWidget(
                                              historyBloc: historyBloc,
                                              bookingHistory: history),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (state.historyList.isNotEmpty &&
                                  state.loadMore)
                                Center(
                                  child: SizedBox(
                                      height: size.width * 0.08,
                                      width: size.width * 0.08,
                                      child: const CircularProgressIndicator()),
                                ),
                              SizedBox(height: size.width * 0.2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(
      {required HistoryBloc historyBloc,
      required HistoryState state,
      required BuildContext context,
      required String title,
      required int index,
      required int selectedIndex}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (index != selectedIndex && (!state.isLoading && !state.loadMore)) {
            historyBloc.add(BookingTypeChangeEvent(bookingTypeIndex: index));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (index == selectedIndex) ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: MyText(
              text: title,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: (index == selectedIndex) ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryNodataWidget extends StatelessWidget {
  const HistoryNodataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.noBookings,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 5),
            MyText(
              text: AppLocalizations.of(context)!.noBookingsText,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
            MyText(
              text: AppLocalizations.of(context)!.createNewBookings,
              maxLines: 2,
              textAlign: TextAlign.center,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
