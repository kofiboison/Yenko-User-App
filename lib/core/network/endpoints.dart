class ApiEndpoints {
  static String languageList = 'api/v1/translation/list';
  static String countryList = 'api/v1/countries';

  //Update Language
  static String updateLanguage = 'api/v1/user/update-my-lang';

  //update Details
  static String updateUserDetailsButton = 'api/v1/user/profile';
  // Onboarding
  static String onBoarding = 'api/v1/on-boarding';
  static String updateLocation = 'api/v1/user/update-location';
  // Authentication
  static String verifyUser = 'api/v1/user/validate-mobile-for-login';
  static String userLogin = 'api/v1/user/login';
  static String commonModule = 'api/v1/common/modules';
  static String sendMobileOtp = 'api/v1/mobile-otp';
  static String verifyMobileOtp = 'api/v1/validate-otp';
  static String sendEmailOtp = 'api/v1/send-mail-otp';
  static String verifyEmailOtp = 'api/v1/validate-email-otp';
  static String registerUser = 'api/v1/user/register';
  static String referral = 'api/v1/update/user/referral';
  static String updatePassword = 'api/v1/user/update-password';

  // Home
  static String userDetails = 'api/v1/user';

  static String searchPlaces = 'api/v1/journey/list-address';

  //logout
  static String logout = 'api/v1/logout';

  //delete account
  static String deleteAccount = 'api/v1/user/delete-user-account';

  //Faq
  static String faqData = 'api/v1/common/faq/list';

  //booking
  static String getBusList = 'api/v1/journey/list-journeys';
  static String getBusSeatDetailes =
      'api/v1/journey/single-journey?journey_id=';

  //bookingHistory
  static String bookingHistory = 'api/v1/journey/booking-history';
  static String downloadInvoice = 'api/v1/user/download-invoice/';

  //notifications
  static String notification = 'api/v1/notifications/get-notification';
  static String deleteNotification = 'api/v1/notifications/delete-notification';

  // make complaint
  static String makeComplaint = 'api/v1/common/complaint-titles';
  static String makeComplaintButton = 'api/v1/common/make-complaint';

  //sos
  static String addSosContact = 'api/v1/common/sos/store';
  static String deleteSosContact = 'api/v1/common/sos/delete';

  //Support Ticket
  static String ticketTitles = 'api/v1/common/ticket-titles';
  static String makeTicket = 'api/v1/common/make-ticket';
  static String replyTicket = 'api/v1/common/reply-message';
  static String viewTicket = 'api/v1/common/view-ticket';
  static String ticketList = 'api/v1/common/list';
  static String getServiceLocation = 'api/v1/servicelocation';

  //admin chat
  static String sendAdminMessage = 'api/v1/request/user-send-message';
  static String adminChatHistory = 'api/v1/request/user-chat-history';
  static String adminMessageSeen = 'api/v1/request/update-notification-count';

  //wallet
  static String walletHistory = 'api/v1/payment/wallet/history';
  static String transferMoney =
      'api/v1/payment/wallet/transfer-money-from-wallet';
  static String stripCreate = 'api/v1/payment/stripe/create-setup-intent';
  static String stripSavedCardsDetail = 'api/v1/payment/stripe/save-card';
  static String savedCardList = 'api/v1/payment/cards/list';
  static String deleteCardsDetail = 'api/v1/payment/cards/delete/';
  static String stripAddMoneyToWallet =
      'api/v1/payment/stripe/add-money-to-wallet';

  static String makeBooking = 'api/v1/journey/make-booking';

  static String popularRoutes = 'api/v1/journey/popular-route';
  static String paymentGatewayList = 'api/v1/payment/gateway';

  static String journeyFilter = 'api/v1/journey/user-filter';
  static String bookTicketsFromWallet = 'api/v1/journey/pay-from-wallet/';
  static String cancelBookingTickets = 'api/v1/journey/booking-cancel';
  static String cancelPayment = 'api/v1/journey/cancel-unpaid-ticket';

  //promo
  static String promo = 'api/v1/journey/promo-code';

  //withdraw
  static String getWithdrawData = 'api/v1/payment/wallet/withdrawal-requests';
  static String requestWithdraw =
      'api/v1/payment/wallet/request-for-withdrawal';
  static String getBankInfo = 'api/v1/payment/wallet/list/bankinfo';
  static String updateBankInfo = 'api/v1/payment/wallet/update/bankinfo';

  //ratings
  static String userReview = 'api/v1/journey/submit-rating';
}
