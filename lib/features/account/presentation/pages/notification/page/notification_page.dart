import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../bloc/notification_bloc.dart';
import '../widget/notification_card_widget.dart';
import '../widget/notification_page_shimmer.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = '/notification';

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc()
        ..add(NotificationGetDirectionEvent())
        ..add(NotificationPageInitEvent()),
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          // final notificationBloc = context.read<NotificationBloc>();
        },
        child: BlocBuilder<NotificationBloc, NotificationState>(builder: (context, state) {
          final notificationBloc = context.read<NotificationBloc>();
          return Directionality(
            textDirection: state.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  title: MyText(
                      text: AppLocalizations.of(context)!.notifications,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).primaryColor)),
                  actions: [
                    if (state.notificationDatas
                        .isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext _) {
                                return BlocProvider.value(
                                    value: BlocProvider.of<NotificationBloc>(context),
                                    child: CustomDoubleButtonDialoge(
                                      title: AppLocalizations.of(context)!.clearNotifications,
                                      content:AppLocalizations.of(context)!.clearNotificationtext,
                                      yesBtnName:
                                          AppLocalizations.of(context)!.confirm,
                                      noBtnName:
                                          AppLocalizations.of(context)!.cancel,
                                      yesBtnFunc: () {
                                        notificationBloc.add(ClearAllNotificationsEvent());
                                        Navigator.pop(context);
                                      },
                                      noBtnFunc: () {
                                        Navigator.pop(context);
                                      },
                                    ));
                              },
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.allClear,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    controller: notificationBloc.scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.width * 0.05),
                        if (state.isLoading)
                         const NotificationShimmer(),
                        if (!state.isLoading &&
                            state.notificationDatas.isEmpty)
                          const NotificationNodataWidget(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: SizedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.notificationDatas
                                  .length,
                              itemBuilder: (_, index) {
                                final notification = state.notificationDatas
                                    .elementAt(index);
                                return NotificationCardWidget(
                                    acc: notificationBloc, notification: notification);
                              },
                            ),
                          ),
                        ),
                        if (state.loadMore)
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
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NotificationNodataWidget extends StatelessWidget {
  const NotificationNodataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.noNotifications,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 5),
            MyText(
              text:AppLocalizations.of(context)!.noNotificationAtMoment,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
            MyText(
              text:AppLocalizations.of(context)!.newAlertsText,
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
