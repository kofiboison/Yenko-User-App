import 'package:bus_booking/features/account/presentation/pages/ratings/ratings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/account/presentation/pages/about/page/about_page.dart';
import '../features/account/presentation/pages/admin_chat/page/admin_chat.dart';
import '../features/account/presentation/pages/bookings_history/pages/bookings_history_page.dart';
import '../features/account/presentation/pages/delete_account_page.dart';
import '../features/account/presentation/pages/faq/page/faq_page.dart';
import '../core/error/error_page.dart';
import '../features/account/presentation/pages/notification/page/notification_page.dart';
import '../features/account/presentation/pages/profile/page/profile_edit.dart';
import '../features/account/presentation/pages/refferal/page/refferal_page.dart';
import '../features/account/presentation/pages/account_page.dart';
import '../features/account/presentation/pages/sos/page/sos_page.dart';
import '../features/account/presentation/pages/support_ticket/page/support_ticket.dart';
import '../features/account/presentation/pages/support_ticket/page/view_ticket_page.dart';
import '../features/account/presentation/pages/wallet/page/wallet_page.dart';
import '../features/account/presentation/pages/wallet/page/withdraw_page.dart';
import '../features/account/presentation/pages/wallet/widget/card_list_widget.dart';
import '../features/auth/presentation/pages/auth_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/apply_refferal_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/update_password_page.dart';
import '../features/booking/presentation/pages/bookings_confirmation_page.dart';
import '../features/booking/presentation/pages/passenger_details_page.dart';
import '../features/bus/presentation/pages/search_bus_page.dart';
import '../features/bus/presentation/pages/select_boarding_deboarding.dart';
import '../features/bus/presentation/pages/select_seat_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/verify_page.dart';
import '../features/booking/presentation/pages/make_payment.dart';
import '../features/home/presentation/pages/live_tracking.dart';
import '../features/home/presentation/pages/search_place_page.dart';
import '../features/home/application/home_bloc.dart';
import '../features/landing/presentation/page/landing_page.dart';
import '../features/language/presentation/page/choose_language_page.dart';
import '../features/loading/presentation/pages/loader_page.dart';
import 'app_arguments.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings routeSettings) {
    late Route<dynamic> pageRoute;
    Object? arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case LoaderPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const LoaderPage(),
        );
      case LandingPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const LandingPage(),
        );
        break;
      case ChooseLanguagePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              ChooseLanguagePage(arg: arg as ChooseLanguageArguments),
        );
        break;
      case AuthPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const AuthPage(),
        );
        break;
      case VerifyPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => VerifyPage(
            arg: arg as VerifyArguments,
          ),
        );
        break;
      case RegisterPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => RegisterPage(
            arg: arg as RegisterPageArguments,
          ),
        );
        break;
      case ApplyRefferalPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const ApplyRefferalPage(),
        );
        break;
      case ForgotPasswordPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ForgotPasswordPage(
            arg: arg as ForgotPasswordPageArguments,
          ),
        );
        break;
      case UpdatePasswordPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => UpdatePasswordPage(
            arg: arg as UpdatePasswordPageArguments,
          ),
        );
        break;
      case WalletHistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              WalletHistoryPage(arg: arg as WalletPageArguments),
        );
        break;
      case AdminChat.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => AdminChat(arg: arg as AdminChatPageArguments),
        );
        break;
      case HomePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
        break;
      case LiveTracking.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => LiveTracking(
            arg: arg as LiveTrackingArguments,
          ),
        );
        break;
      case SearchPlacePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<HomeBloc>(),
            child: SearchPlacePage(
              arg: arg as SearchPlacePageArguments,
            ),
          ),
        );
        break;
      // animation sliding
      case AccountPage.routeName:
        pageRoute = PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AccountPage(arg: arg as AccountPageArguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final curvedAnimation =
                CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
        break;
      case CardListWidget.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => CardListWidget(
            arg: arg as PaymentMethodArguments,
          ),
        );
        break;
      case ReferralPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ReferralPage(
            args: arg as ReferralArguments,
          ),
        );
        break;
      case ProfileEditPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ProfileEditPage(
            arg: arg as ProfileEditPageArguments,
          ),
        );
        break;
      case FaqPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const FaqPage(),
        );
        break;
      case AboutUsPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const AboutUsPage(),
        );
        break;
      case SosPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const SosPage(),
        );
        break;
      case DeleteAccount.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const DeleteAccount(),
        );
        break;

      case SearchBusPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              SearchBusPage(args: arg as SearchBusPageArguments),
        );
        break;
      case PassengerDetailsPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => PassengerDetailsPage(
            args: arg as PassengerDetailsPageArguments,
          ),
        );
        break;
      case SelectSeatPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              SelectSeatPage(args: arg as SelectSeatPageArguments),
        );
        break;
      case SelectBoardingDeboardingPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => SelectBoardingDeboardingPage(
              args: arg as SelectBoardingPageArguments),
        );
        break;
      case BookingsHistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => BookingsHistoryPage(args: arg as BookingsHistoryPageArguments,),
        );
        break;
      case NotificationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        );
      case BookingsConfirmationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => BookingsConfirmationPage(
            args: arg as MakePaymentPageArguments,
          ),
        );
        break;
      case SupportTicketPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => SupportTicketPage(
            args: arg as SupportTicketPageArguments,
          ),
        );
        break;
      case ViewTicketPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ViewTicketPage(
            args: arg as ViewTicketPageArguments,
          ),
        );
        break;
      case MakePaymentPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => MakePaymentPage(
            args: arg as MakePaymentPageArguments,
          ),
        );
        break;
      case WithdrawPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => WithdrawPage(
            arg: arg as WithdrawPageArguments,
          ),
        );
        break;
      case RatingsPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => RatingsPage(
            arg: arg as RatingsPageArguments,
          ),
        );
      default:
        pageRoute = MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        );
    }
    return pageRoute;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}
