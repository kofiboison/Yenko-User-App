import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @continueN.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueN;

  /// No description provided for @selectContry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectContry;

  /// No description provided for @emailAddressOrMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Email address or mobile number'**
  String get emailAddressOrMobileNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the'**
  String get byContinuing;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'terms of service'**
  String get terms;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get privacyPolicy;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @validEmailMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email or mobile number'**
  String get validEmailMobile;

  /// No description provided for @enterEmailMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter email or mobile number'**
  String get enterEmailMobile;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @otpSendContent.
  ///
  /// In en, this message translates to:
  /// **'An One Time Password (OTP) has been sent to this number or email'**
  String get otpSendContent;

  /// No description provided for @passwordContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter the password you have set for the number or email below'**
  String get passwordContent;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'CHANGE'**
  String get change;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signInUsingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sign in using OTP'**
  String get signInUsingOtp;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @signInUsingPass.
  ///
  /// In en, this message translates to:
  /// **'Sign in using password'**
  String get signInUsingPass;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterYourMobile;

  /// No description provided for @validMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get validMobile;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get validEmail;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @isThisCorrect.
  ///
  /// In en, this message translates to:
  /// **'Is this correct ? '**
  String get isThisCorrect;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @testOtp.
  ///
  /// In en, this message translates to:
  /// **'Login to your account with test OTP ***'**
  String get testOtp;

  /// No description provided for @minPassRequired.
  ///
  /// In en, this message translates to:
  /// **'minimum 8 characters required'**
  String get minPassRequired;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enterPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @galleryText.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryText;

  /// No description provided for @cameraText.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraText;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @preferNotSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotSay;

  /// No description provided for @enterUserName.
  ///
  /// In en, this message translates to:
  /// **'Please enter user name'**
  String get enterUserName;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get enterMobile;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get enterEmail;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender:'**
  String get gender;

  /// No description provided for @applyRefferal.
  ///
  /// In en, this message translates to:
  /// **'Apply Refferal'**
  String get applyRefferal;

  /// No description provided for @enterRefferalCode.
  ///
  /// In en, this message translates to:
  /// **'Enter refferal code'**
  String get enterRefferalCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @notValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'The provided phone number is not valid'**
  String get notValidPhoneNumber;

  /// No description provided for @otpSendTo.
  ///
  /// In en, this message translates to:
  /// **'OTP send to ***'**
  String get otpSendTo;

  /// No description provided for @otpForLogin.
  ///
  /// In en, this message translates to:
  /// **'Otp for Login'**
  String get otpForLogin;

  /// No description provided for @enterValidOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid OTP'**
  String get enterValidOtp;

  /// No description provided for @verifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Verified Successfully'**
  String get verifySuccess;

  /// No description provided for @validPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid password'**
  String get validPassword;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login Successfully'**
  String get loginSuccess;

  /// No description provided for @passCheck.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get passCheck;

  /// No description provided for @arrowSpeed.
  ///
  /// In en, this message translates to:
  /// **'Arrowspeed'**
  String get arrowSpeed;

  /// No description provided for @bookYourBus.
  ///
  /// In en, this message translates to:
  /// **'Book your bus!'**
  String get bookYourBus;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @yourLastSearch.
  ///
  /// In en, this message translates to:
  /// **'Your Last Search'**
  String get yourLastSearch;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @getAttractivePromos.
  ///
  /// In en, this message translates to:
  /// **'Get attractive promos!'**
  String get getAttractivePromos;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @passengersList.
  ///
  /// In en, this message translates to:
  /// **'Passengers List'**
  String get passengersList;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @referAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referAndEarn;

  /// No description provided for @changeLanguge.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguge;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @offersDetails.
  ///
  /// In en, this message translates to:
  /// **'Offers Details'**
  String get offersDetails;

  /// No description provided for @faqSupport.
  ///
  /// In en, this message translates to:
  /// **'FAQ\'s & Support'**
  String get faqSupport;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, do you want to logout?'**
  String get logoutContent;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountContent.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will erase all personal data. Do you want to proceed?'**
  String get deleteAccountContent;

  /// No description provided for @deleteAccountPageContent.
  ///
  /// In en, this message translates to:
  /// **'We have received your request to delete your account. It will be deactivated within ** hours and permanently deleted after *** days, along with any unused credits, promotions, or rewards.'**
  String get deleteAccountPageContent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @successfullyUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated your details'**
  String get successfullyUpdatedText;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age:'**
  String get age;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @enterYourAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get enterYourAge;

  /// No description provided for @pleaseEnterAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter age'**
  String get pleaseEnterAge;

  /// No description provided for @validAge.
  ///
  /// In en, this message translates to:
  /// **'age >= 1 year'**
  String get validAge;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Success!'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed!'**
  String get paymentFailed;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okay;

  /// No description provided for @cardList.
  ///
  /// In en, this message translates to:
  /// **'Card List'**
  String get cardList;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get cardDetails;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save Card'**
  String get saveCard;

  /// No description provided for @enterTheCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter the card details'**
  String get enterTheCardDetails;

  /// No description provided for @recentTransaction.
  ///
  /// In en, this message translates to:
  /// **'Recent Transaction'**
  String get recentTransaction;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details:'**
  String get paymentDetails;

  /// No description provided for @walletTopUp.
  ///
  /// In en, this message translates to:
  /// **'Wallet top-up'**
  String get walletTopUp;

  /// No description provided for @topUpAmount.
  ///
  /// In en, this message translates to:
  /// **'Top-up Amount'**
  String get topUpAmount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @payWith.
  ///
  /// In en, this message translates to:
  /// **'Pay with:'**
  String get payWith;

  /// No description provided for @creditOrDebitCards.
  ///
  /// In en, this message translates to:
  /// **'Credit or Debit Cards'**
  String get creditOrDebitCards;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// No description provided for @addMoneyContent.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount that should be added to wallet'**
  String get addMoneyContent;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @walletMinimumAmountToAdd.
  ///
  /// In en, this message translates to:
  /// **'Minimum amount to add'**
  String get walletMinimumAmountToAdd;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// No description provided for @referNow.
  ///
  /// In en, this message translates to:
  /// **'Refer now!'**
  String get referNow;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @refferalInviteText.
  ///
  /// In en, this message translates to:
  /// **'**Join me on ! using my invite code **** To make easy your ride'**
  String get refferalInviteText;

  /// No description provided for @yourTopReferals.
  ///
  /// In en, this message translates to:
  /// **'Your top referrals'**
  String get yourTopReferals;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @couldNotFetchLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch location'**
  String get couldNotFetchLocation;

  /// No description provided for @pleaseEnterValidData.
  ///
  /// In en, this message translates to:
  /// **'Please enter the valid data'**
  String get pleaseEnterValidData;

  /// No description provided for @addPassenger.
  ///
  /// In en, this message translates to:
  /// **'Add Passenger'**
  String get addPassenger;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @newN.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newN;

  /// No description provided for @claimOffer.
  ///
  /// In en, this message translates to:
  /// **'Claim Offer'**
  String get claimOffer;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @currentlyNoOffers.
  ///
  /// In en, this message translates to:
  /// **'Currently no offers available'**
  String get currentlyNoOffers;

  /// No description provided for @noOffersContent.
  ///
  /// In en, this message translates to:
  /// **'We can’t find offers for you right now. But we working hard to reward you!'**
  String get noOffersContent;

  /// No description provided for @searchForFaq.
  ///
  /// In en, this message translates to:
  /// **'Search for FAQ\'s'**
  String get searchForFaq;

  /// No description provided for @issueWithRecentBooking.
  ///
  /// In en, this message translates to:
  /// **'Issue with recent bookings?'**
  String get issueWithRecentBooking;

  /// No description provided for @needMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Need more help?'**
  String get needMoreHelp;

  /// No description provided for @callUsNow.
  ///
  /// In en, this message translates to:
  /// **'Call us now'**
  String get callUsNow;

  /// No description provided for @chatWithOurAgent.
  ///
  /// In en, this message translates to:
  /// **'Chat with our agent'**
  String get chatWithOurAgent;

  /// No description provided for @mailYourIssueToUs.
  ///
  /// In en, this message translates to:
  /// **'Mail your issue to us'**
  String get mailYourIssueToUs;

  /// No description provided for @officialDocuments.
  ///
  /// In en, this message translates to:
  /// **'Official Documents'**
  String get officialDocuments;

  /// No description provided for @privacyPolicyAboutUs.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyAboutUs;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get officialWebsite;

  /// No description provided for @licences.
  ///
  /// In en, this message translates to:
  /// **'Licences'**
  String get licences;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @adminChat.
  ///
  /// In en, this message translates to:
  /// **'Admin Chat'**
  String get adminChat;

  /// No description provided for @typeAmessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAmessage;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noBookingsText.
  ///
  /// In en, this message translates to:
  /// **'No bookings have been made yet.'**
  String get noBookingsText;

  /// No description provided for @createNewBookings.
  ///
  /// In en, this message translates to:
  /// **'Create a new booking to get started.'**
  String get createNewBookings;

  /// No description provided for @sucess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get sucess;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully.'**
  String get bookingCancelled;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @ticket.
  ///
  /// In en, this message translates to:
  /// **'Ticket:'**
  String get ticket;

  /// No description provided for @boaring.
  ///
  /// In en, this message translates to:
  /// **'Boarding:'**
  String get boaring;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival:'**
  String get arrival;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @seat.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get seat;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare:'**
  String get fare;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @noFaq.
  ///
  /// In en, this message translates to:
  /// **'No FAQs Found'**
  String get noFaq;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @clearNotifications.
  ///
  /// In en, this message translates to:
  /// **'Clear Notifications'**
  String get clearNotifications;

  /// No description provided for @clearNotificationtext.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you clear all notifications?'**
  String get clearNotificationtext;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get allClear;

  /// No description provided for @noNotificationAtMoment.
  ///
  /// In en, this message translates to:
  /// **'No notifications at the moment.'**
  String get noNotificationAtMoment;

  /// No description provided for @newAlertsText.
  ///
  /// In en, this message translates to:
  /// **'New updates and alerts will appear here when available.'**
  String get newAlertsText;

  /// No description provided for @deleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get deleteNotification;

  /// No description provided for @deleteNotificationConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to Delete this Notification?'**
  String get deleteNotificationConfirmation;

  /// No description provided for @referralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied to clipboard!'**
  String get referralCodeCopied;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @deleteSos.
  ///
  /// In en, this message translates to:
  /// **'Delete Sos'**
  String get deleteSos;

  /// No description provided for @deleteContactConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to Delete this Contact?'**
  String get deleteContactConfirmation;

  /// No description provided for @noSosFound.
  ///
  /// In en, this message translates to:
  /// **'No SOS contacts found.'**
  String get noSosFound;

  /// No description provided for @addContactText.
  ///
  /// In en, this message translates to:
  /// **'Add contacts now to ensure your safety.'**
  String get addContactText;

  /// No description provided for @selectContact.
  ///
  /// In en, this message translates to:
  /// **'Select Contact'**
  String get selectContact;

  /// No description provided for @supportTicket.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket'**
  String get supportTicket;

  /// No description provided for @viewTicket.
  ///
  /// In en, this message translates to:
  /// **'View Ticket'**
  String get viewTicket;

  /// No description provided for @createTicket.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get createTicket;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @selectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Title'**
  String get selectTitle;

  /// No description provided for @selectArea.
  ///
  /// In en, this message translates to:
  /// **'Select Area'**
  String get selectArea;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter Description'**
  String get enterDescription;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @uploadMaxFile.
  ///
  /// In en, this message translates to:
  /// **'Upload Maximum File'**
  String get uploadMaxFile;

  /// No description provided for @fileFormat.
  ///
  /// In en, this message translates to:
  /// **'png,jpg,jpeg,pdf,doc'**
  String get fileFormat;

  /// No description provided for @filesUploaded.
  ///
  /// In en, this message translates to:
  /// **'Files Uploaded'**
  String get filesUploaded;

  /// No description provided for @fillRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Fill The Required Field.'**
  String get fillRequiredField;

  /// No description provided for @replyText.
  ///
  /// In en, this message translates to:
  /// **'Reply Text'**
  String get replyText;

  /// No description provided for @messageText.
  ///
  /// In en, this message translates to:
  /// **'Message Text'**
  String get messageText;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter Message'**
  String get enterMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @filleMessageField.
  ///
  /// In en, this message translates to:
  /// **'Fill The Message Field.'**
  String get filleMessageField;

  /// No description provided for @noSupportTicketsFound.
  ///
  /// In en, this message translates to:
  /// **'No Support Tickets Found'**
  String get noSupportTicketsFound;

  /// No description provided for @havenotSubmmitedTickets.
  ///
  /// In en, this message translates to:
  /// **'You haven’t submitted any support tickets.'**
  String get havenotSubmmitedTickets;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @ticketId.
  ///
  /// In en, this message translates to:
  /// **'Ticket Id'**
  String get ticketId;

  /// No description provided for @assignTo.
  ///
  /// In en, this message translates to:
  /// **'Assign To'**
  String get assignTo;

  /// No description provided for @supportType.
  ///
  /// In en, this message translates to:
  /// **'Support Type'**
  String get supportType;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @acknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get acknowledged;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not Assigned'**
  String get notAssigned;

  /// No description provided for @requestId.
  ///
  /// In en, this message translates to:
  /// **'Request Id'**
  String get requestId;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @walletbalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletbalance;

  /// No description provided for @saveCards.
  ///
  /// In en, this message translates to:
  /// **'Save Cards'**
  String get saveCards;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @enterCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Card details'**
  String get enterCardDetails;

  /// No description provided for @enterCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please enter the credentials'**
  String get enterCredentials;

  /// No description provided for @enterAmountHere.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount Here'**
  String get enterAmountHere;

  /// No description provided for @savedCards.
  ///
  /// In en, this message translates to:
  /// **'Saved Cards'**
  String get savedCards;

  /// No description provided for @selectCards.
  ///
  /// In en, this message translates to:
  /// **'Select Cards'**
  String get selectCards;

  /// No description provided for @cardDisplayText.
  ///
  /// In en, this message translates to:
  /// **'You can choose which card numbers you want to display in the list of payment methods on the invoice.'**
  String get cardDisplayText;

  /// No description provided for @deleteCardConfirmationText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to delete this card ?'**
  String get deleteCardConfirmationText;

  /// No description provided for @noPaymentsMade.
  ///
  /// In en, this message translates to:
  /// **'You have not made any payments yet.'**
  String get noPaymentsMade;

  /// No description provided for @transactionsAppearText.
  ///
  /// In en, this message translates to:
  /// **'Transactions will appear here once booking is completed.'**
  String get transactionsAppearText;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @transferMoney.
  ///
  /// In en, this message translates to:
  /// **'Transfer Money'**
  String get transferMoney;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get chatWithUs;

  /// No description provided for @enteryInfoToRegister.
  ///
  /// In en, this message translates to:
  /// **'Enter your information to Register'**
  String get enteryInfoToRegister;

  /// No description provided for @m.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get m;

  /// No description provided for @f.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get f;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to'**
  String get enterVerificationCode;

  /// No description provided for @oneTimePassword.
  ///
  /// In en, this message translates to:
  /// **'One Time Password (OTP)'**
  String get oneTimePassword;

  /// No description provided for @loginUsingMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Login using your mobile number'**
  String get loginUsingMobileNumber;

  /// No description provided for @toSignIn.
  ///
  /// In en, this message translates to:
  /// **'to sign in'**
  String get toSignIn;

  /// No description provided for @your.
  ///
  /// In en, this message translates to:
  /// **'Your'**
  String get your;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @bookingsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Bookings Confirmation'**
  String get bookingsConfirmation;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @passesngersNames.
  ///
  /// In en, this message translates to:
  /// **'Passenger Names'**
  String get passesngersNames;

  /// No description provided for @ticketFare.
  ///
  /// In en, this message translates to:
  /// **'Ticket fare'**
  String get ticketFare;

  /// No description provided for @ticketStatus.
  ///
  /// In en, this message translates to:
  /// **'Ticket status : CONFIRMED'**
  String get ticketStatus;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @failure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get failure;

  /// No description provided for @ticketsNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Ticket not confirmed'**
  String get ticketsNotConfirmed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @timeDurationExpired.
  ///
  /// In en, this message translates to:
  /// **'Payment time duration expired, try again for booking'**
  String get timeDurationExpired;

  /// No description provided for @remainingTimeForPayment.
  ///
  /// In en, this message translates to:
  /// **'The remaining time for payment'**
  String get remainingTimeForPayment;

  /// No description provided for @reviewBooking.
  ///
  /// In en, this message translates to:
  /// **'Review Booking'**
  String get reviewBooking;

  /// No description provided for @selectedSeats.
  ///
  /// In en, this message translates to:
  /// **'Selected Seats :'**
  String get selectedSeats;

  /// No description provided for @passengerDetails.
  ///
  /// In en, this message translates to:
  /// **'Passenger Details'**
  String get passengerDetails;

  /// No description provided for @seatNo.
  ///
  /// In en, this message translates to:
  /// **'Seat No'**
  String get seatNo;

  /// No description provided for @fareBreakup.
  ///
  /// In en, this message translates to:
  /// **'Fare Breakup :'**
  String get fareBreakup;

  /// No description provided for @ticketprice.
  ///
  /// In en, this message translates to:
  /// **'Ticket price'**
  String get ticketprice;

  /// No description provided for @serviceTax.
  ///
  /// In en, this message translates to:
  /// **'Service Tax'**
  String get serviceTax;

  /// No description provided for @promo.
  ///
  /// In en, this message translates to:
  /// **'Promo'**
  String get promo;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get totalPrice;

  /// No description provided for @boardingPoints.
  ///
  /// In en, this message translates to:
  /// **'Boarding Points'**
  String get boardingPoints;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get pleaseEnterName;

  /// No description provided for @enterAge.
  ///
  /// In en, this message translates to:
  /// **'Enter Age'**
  String get enterAge;

  /// No description provided for @femalePassengerOnlyText.
  ///
  /// In en, this message translates to:
  /// **'This seat only available for Female passenger'**
  String get femalePassengerOnlyText;

  /// No description provided for @malePassengerOnlyText.
  ///
  /// In en, this message translates to:
  /// **'This seat only available for Male passenger'**
  String get malePassengerOnlyText;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @promoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo Code'**
  String get promoCode;

  /// No description provided for @promoCodeApplied.
  ///
  /// In en, this message translates to:
  /// **'Promo code applied successfully!'**
  String get promoCodeApplied;

  /// No description provided for @invalidPromo.
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code.'**
  String get invalidPromo;

  /// No description provided for @enterpromoCode.
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get enterpromoCode;

  /// No description provided for @pleaseEnterPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter promo code'**
  String get pleaseEnterPromoCode;

  /// No description provided for @promoCodeAlreadyApplied.
  ///
  /// In en, this message translates to:
  /// **'Promo code already applied'**
  String get promoCodeAlreadyApplied;

  /// No description provided for @applied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get applied;

  /// No description provided for @promoAdded.
  ///
  /// In en, this message translates to:
  /// **'Promo added'**
  String get promoAdded;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get pleaseSelectGender;

  /// No description provided for @continueToPay.
  ///
  /// In en, this message translates to:
  /// **'Continue to Pay'**
  String get continueToPay;

  /// No description provided for @noBusesFound.
  ///
  /// In en, this message translates to:
  /// **'No buses found!'**
  String get noBusesFound;

  /// No description provided for @noBusesText.
  ///
  /// In en, this message translates to:
  /// **'We can\'t find any buses in this exact date. Try changing date or places.'**
  String get noBusesText;

  /// No description provided for @ac.
  ///
  /// In en, this message translates to:
  /// **'A/C'**
  String get ac;

  /// No description provided for @nonAc.
  ///
  /// In en, this message translates to:
  /// **'Non A/C'**
  String get nonAc;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search Places'**
  String get searchPlaces;

  /// No description provided for @noPlacesFound.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get noPlacesFound;

  /// No description provided for @selectBoardingDropPoints.
  ///
  /// In en, this message translates to:
  /// **'Select Boarding & Drop Points'**
  String get selectBoardingDropPoints;

  /// No description provided for @boardingpoints.
  ///
  /// In en, this message translates to:
  /// **'Boarding points :'**
  String get boardingpoints;

  /// No description provided for @dropPoints.
  ///
  /// In en, this message translates to:
  /// **'Drop Points'**
  String get dropPoints;

  /// No description provided for @sleeper.
  ///
  /// In en, this message translates to:
  /// **'Sleeper'**
  String get sleeper;

  /// No description provided for @seater.
  ///
  /// In en, this message translates to:
  /// **'Seater'**
  String get seater;

  /// No description provided for @semiSleeper.
  ///
  /// In en, this message translates to:
  /// **'Semi-Sleeper'**
  String get semiSleeper;

  /// No description provided for @allPrice.
  ///
  /// In en, this message translates to:
  /// **'All Price'**
  String get allPrice;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @ticketSentTo.
  ///
  /// In en, this message translates to:
  /// **'Your ticket will be sent to'**
  String get ticketSentTo;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @seatType.
  ///
  /// In en, this message translates to:
  /// **'Seat Type'**
  String get seatType;

  /// No description provided for @busType.
  ///
  /// In en, this message translates to:
  /// **'Bus Type'**
  String get busType;

  /// No description provided for @busPartners.
  ///
  /// In en, this message translates to:
  /// **'Bus Partners'**
  String get busPartners;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @amenties.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenties;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @noFiltersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No filters available'**
  String get noFiltersAvailable;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @popularRecentRoutes.
  ///
  /// In en, this message translates to:
  /// **'Popular Recent Routes'**
  String get popularRecentRoutes;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTheCity.
  ///
  /// In en, this message translates to:
  /// **'Please select the city'**
  String get selectTheCity;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'proceed'**
  String get proceed;

  /// No description provided for @cancelBookingText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to cancel this booking?'**
  String get cancelBookingText;

  /// No description provided for @lowerDeck.
  ///
  /// In en, this message translates to:
  /// **'Lower Deck'**
  String get lowerDeck;

  /// No description provided for @upperDeck.
  ///
  /// In en, this message translates to:
  /// **'Upper Deck'**
  String get upperDeck;

  /// No description provided for @youCanBook.
  ///
  /// In en, this message translates to:
  /// **'You can book upto '**
  String get youCanBook;

  /// No description provided for @seatsOnly.
  ///
  /// In en, this message translates to:
  /// **'seats only'**
  String get seatsOnly;

  /// No description provided for @enterRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Please enter all required field'**
  String get enterRequiredField;

  /// No description provided for @editBankDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Bank Details'**
  String get editBankDetails;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @textAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get textAdd;

  /// No description provided for @textView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get textView;

  /// No description provided for @requestWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Request Withdraw'**
  String get requestWithdraw;

  /// No description provided for @recentWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Recent Withdrawal'**
  String get recentWithdrawal;

  /// No description provided for @updatePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Update Payment Method'**
  String get updatePaymentMethod;

  /// No description provided for @paymentMethodSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment method updated successfully'**
  String get paymentMethodSuccess;

  /// No description provided for @noPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'No payment history yet.'**
  String get noPaymentHistory;

  /// No description provided for @bookingRideText.
  ///
  /// In en, this message translates to:
  /// **'Start your journey by booking a ride today!'**
  String get bookingRideText;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @insufficientWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance to withdraw this amount'**
  String get insufficientWithdraw;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Invalid Age'**
  String get invalidAge;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// No description provided for @bookingCancellation.
  ///
  /// In en, this message translates to:
  /// **'Booking cancellation'**
  String get bookingCancellation;

  /// No description provided for @bookingCancellationText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to cancel this booking!'**
  String get bookingCancellationText;

  /// No description provided for @noWalletHistory.
  ///
  /// In en, this message translates to:
  /// **'No withdrawal records found.'**
  String get noWalletHistory;

  /// No description provided for @emptyWalletText.
  ///
  /// In en, this message translates to:
  /// **'Initiate your first withdrawal to get started.'**
  String get emptyWalletText;

  /// No description provided for @cancellationFee.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Fee'**
  String get cancellationFee;

  /// No description provided for @tripCompleted.
  ///
  /// In en, this message translates to:
  /// **'Trip Completed'**
  String get tripCompleted;

  /// No description provided for @tripCompletedtext.
  ///
  /// In en, this message translates to:
  /// **'Your trip has been completed successfully.'**
  String get tripCompletedtext;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @liveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTracking;

  /// No description provided for @trackingDetails.
  ///
  /// In en, this message translates to:
  /// **'Tracking Details'**
  String get trackingDetails;

  /// No description provided for @boardingPoint.
  ///
  /// In en, this message translates to:
  /// **'Boarding Point'**
  String get boardingPoint;

  /// No description provided for @stopPoint.
  ///
  /// In en, this message translates to:
  /// **'Stop Point'**
  String get stopPoint;

  /// No description provided for @trackNow.
  ///
  /// In en, this message translates to:
  /// **'Track Now'**
  String get trackNow;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatus;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @creditedAmountToWallet.
  ///
  /// In en, this message translates to:
  /// **'Credited Amount to wallet'**
  String get creditedAmountToWallet;

  /// No description provided for @shareticket.
  ///
  /// In en, this message translates to:
  /// **'Share Ticket'**
  String get shareticket;

  /// No description provided for @failedToDownload.
  ///
  /// In en, this message translates to:
  /// **'Failed to download invoice.'**
  String get failedToDownload;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied.'**
  String get storagePermissionDenied;

  /// No description provided for @invoiceDownloadedSucessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice downloaded successfully!'**
  String get invoiceDownloadedSucessfully;

  /// No description provided for @invoiceUrlNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Invoice URL not available.'**
  String get invoiceUrlNotAvailable;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get rateUs;

  /// No description provided for @pleaseRateYourRide.
  ///
  /// In en, this message translates to:
  /// **'Please rate your ride !'**
  String get pleaseRateYourRide;

  /// No description provided for @helpUsImprove.
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get helpUsImprove;

  /// No description provided for @ticketNumber.
  ///
  /// In en, this message translates to:
  /// **'Ticket Number'**
  String get ticketNumber;

  /// No description provided for @giveRatings.
  ///
  /// In en, this message translates to:
  /// **'Give Ratings'**
  String get giveRatings;

  /// No description provided for @leavefeedback.
  ///
  /// In en, this message translates to:
  /// **'Leave Feedback'**
  String get leavefeedback;

  /// No description provided for @leavefeedbackOptional.
  ///
  /// In en, this message translates to:
  /// **'Leave a feedback (Optional)'**
  String get leavefeedbackOptional;

  /// No description provided for @pleaseGiveRatings.
  ///
  /// In en, this message translates to:
  /// **'Please give ratings'**
  String get pleaseGiveRatings;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @rateYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Journey!'**
  String get rateYourJourney;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @supportTicketCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket Created Successfully'**
  String get supportTicketCreatedSuccessfully;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @baseprice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get baseprice;

  /// No description provided for @ticketCreated.
  ///
  /// In en, this message translates to:
  /// **'Ticket Created'**
  String get ticketCreated;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
