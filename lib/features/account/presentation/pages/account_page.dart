import 'package:bus_booking/features/account/presentation/pages/admin_chat/page/admin_chat.dart';
import 'package:bus_booking/features/account/presentation/pages/notification/page/notification_page.dart';
import 'package:bus_booking/features/account/presentation/pages/sos/page/sos_page.dart';
import 'package:bus_booking/features/account/presentation/pages/support_ticket/page/support_ticket.dart';
import 'package:bus_booking/features/account/presentation/pages/wallet/page/wallet_page.dart';
import 'package:bus_booking/features/home/domain/models/user_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_dialoges.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../application/acc_bloc.dart';
import '../widgets/custom_navigation_card.dart';
import '../widgets/profile_app_bar.dart';
import 'about/page/about_page.dart';
import 'bookings_history/pages/bookings_history_page.dart';
import 'delete_account_page.dart';
import 'faq/page/faq_page.dart';
import 'refferal/page/refferal_page.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/accountPage';
  final AccountPageArguments arg;

  const AccountPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(AccGetUserDetailsEvent())
        ..add(AccountPageInitEvent(userDetailData: arg.userData)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          final accBloc = context.read<AccBloc>();
          if (state.status ==  AccStatus.logOut) {
            accBloc.add(AccUpdateEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          } else if (state.status ==  AccStatus.deleteAccount) {
            accBloc.add(AccUpdateEvent());
            Navigator.pushNamed(context, DeleteAccount.routeName);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            final accBloc = context.read<AccBloc>();
            return Directionality(
              textDirection: state.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                  appBar: state.userDetail != null
                      ? CustomProfileAppBar(
                          userDetail: state.userDetail!,
                        )
                      : AppBar(),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        spacing: size.width * 0.04,
                        children: [
                          SizedBox(height: size.width * 0.02),
                          CustomCardButton(
                            icon: Icons.book_online,
                            label: AppLocalizations.of(context)!.bookings,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, BookingsHistoryPage.routeName,
                              arguments: BookingsHistoryPageArguments(userData: state.userDetail!));
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.notifications,
                            label: AppLocalizations.of(context)!.notifications,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, NotificationPage.routeName);
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.wallet,
                            label: AppLocalizations.of(context)!.wallet,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, WalletHistoryPage.routeName,
                                      arguments: WalletPageArguments(
                                          userData: state.userDetail!))
                                  .then(
                                (value) {
                                  if (!context.mounted) return;
                                  accBloc.add(AccGetUserDetailsEvent());
                                },
                              );
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.card_giftcard,
                            label: AppLocalizations.of(context)!.referAndEarn,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ReferralPage.routeName,
                                  arguments: ReferralArguments(
                                      userData: arg.userData));
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.language,
                            label: AppLocalizations.of(context)!.changeLanguge,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, ChooseLanguagePage.routeName,
                                      arguments: ChooseLanguageArguments(
                                          isInitialLanguageChange: false))
                                  .then(
                                (value) {
                                  if (!context.mounted) return;
                                  accBloc.add(AccGetDirectionEvent());
                                },
                              );
                            },
                          ),
                          if(state.userDetail != null && state.userDetail!.enableSupportTicketFeature == '1')
                          CustomCardButton(
                            icon: Icons.support_agent_rounded,
                            label: AppLocalizations.of(context)!.supportTicket,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SupportTicketPage.routeName,
                                  arguments: SupportTicketPageArguments(
                                      isFromRequest: false, requestId: ''));
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.sos,
                            label:
                                AppLocalizations.of(context)!.sos.toUpperCase(),
                            onTap: () {
                              accBloc.add(AccGetUserDetailsEvent());
                              Navigator.pushNamed(context, SosPage.routeName)
                                  .then(
                                (value) {
                                  if (!context.mounted) return;
                                  if (value != null) {
                                    final sos = value as List<SOSDatum>;
                                    state.userDetail!
                                        .sos
                                        .data = sos;
                                    accBloc.add(AccUpdateEvent());
                                  }
                                },
                              );
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.question_answer,
                            label: AppLocalizations.of(context)!.faq,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                FaqPage.routeName,
                              );
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.help_outline,
                            label: AppLocalizations.of(context)!.aboutUs,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AboutUsPage.routeName);
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.chat,
                            label: AppLocalizations.of(context)!.chatWithUs,
                            onTap: () {
                              Navigator.pushNamed(context, AdminChat.routeName,
                                  arguments: AdminChatPageArguments(
                                      userData:
                                          state.userDetail!));
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.logout,
                            label: AppLocalizations.of(context)!.logout,
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Theme.of(context).shadowColor,
                                builder: (BuildContext _) {
                                  return BlocProvider.value(
                                    value: BlocProvider.of<AccBloc>(context),
                                    child: CustomDoubleButtonDialoge(
                                      title:
                                          AppLocalizations.of(context)!.logout,
                                      content: AppLocalizations.of(context)!
                                          .logoutContent,
                                      noBtnName:
                                          AppLocalizations.of(context)!.no,
                                      yesBtnName:
                                          AppLocalizations.of(context)!.logout,
                                      yesBtnFunc: () {
                                        accBloc.add(LogoutEvent());
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          CustomCardButton(
                            icon: Icons.delete,
                            label: AppLocalizations.of(context)!.deleteAccount,
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Theme.of(context).shadowColor,
                                builder: (BuildContext _) {
                                  return BlocProvider.value(
                                    value: BlocProvider.of<AccBloc>(context),
                                    child: CustomSingleButtonDialoge(
                                      title:
                                          '${AppLocalizations.of(context)!.deleteAccount} ?',
                                      content: AppLocalizations.of(context)!
                                          .deleteAccountContent,
                                      btnName:
                                          AppLocalizations.of(context)!.delete,
                                      onTap: () {
                                        accBloc .add(DeleteAccountEvent());
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: size.width * 0.04),
                        ],
                      ),
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }
}
