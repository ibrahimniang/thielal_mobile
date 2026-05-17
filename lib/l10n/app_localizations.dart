import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
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
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'LifeLink'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @centers.
  ///
  /// In en, this message translates to:
  /// **'Centers'**
  String get centers;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your donor space'**
  String get loginSubtitle;

  /// No description provided for @identifier.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get identifier;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @receiveOtp.
  ///
  /// In en, this message translates to:
  /// **'Receive OTP code'**
  String get receiveOtp;

  /// No description provided for @receiveOtpDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number or email to receive a secure code and start your registration.'**
  String get receiveOtpDescription;

  /// No description provided for @phoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone or email'**
  String get phoneOrEmail;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @receiveCode.
  ///
  /// In en, this message translates to:
  /// **'Receive code'**
  String get receiveCode;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterOtpDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the received code to continue your registration.'**
  String get enterOtpDescription;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining time'**
  String get remainingTime;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'OTP code expired.'**
  String get otpExpired;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @enterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit OTP code'**
  String get enterOtpCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @addressContact.
  ///
  /// In en, this message translates to:
  /// **'Address and contact'**
  String get addressContact;

  /// No description provided for @healthConsent.
  ///
  /// In en, this message translates to:
  /// **'Health and consent'**
  String get healthConsent;

  /// No description provided for @personalInformationDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your basic identity information to begin.'**
  String get personalInformationDescription;

  /// No description provided for @addressContactDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your location and verify your contact details.'**
  String get addressContactDescription;

  /// No description provided for @healthConsentDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your medical information and validate the conditions.'**
  String get healthConsentDescription;

  /// No description provided for @chooseBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Choose birth date'**
  String get chooseBirthDate;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @estimatedDistance.
  ///
  /// In en, this message translates to:
  /// **'Estimated distance'**
  String get estimatedDistance;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get route;

  /// No description provided for @availableCenters.
  ///
  /// In en, this message translates to:
  /// **'Available centers'**
  String get availableCenters;

  /// No description provided for @activeCentersIn.
  ///
  /// In en, this message translates to:
  /// **'active centers in'**
  String get activeCentersIn;

  /// No description provided for @searchCenter.
  ///
  /// In en, this message translates to:
  /// **'Search for a center...'**
  String get searchCenter;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @unableToLoadUserData.
  ///
  /// In en, this message translates to:
  /// **'Unable to load user data.'**
  String get unableToLoadUserData;

  /// No description provided for @badgesRewards.
  ///
  /// In en, this message translates to:
  /// **'Badges & rewards'**
  String get badgesRewards;

  /// No description provided for @donorProgress.
  ///
  /// In en, this message translates to:
  /// **'Your donor progress'**
  String get donorProgress;

  /// No description provided for @bronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get bronze;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @elite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get elite;

  /// No description provided for @firstDonorLevel.
  ///
  /// In en, this message translates to:
  /// **'First donor level'**
  String get firstDonorLevel;

  /// No description provided for @regularDonor.
  ///
  /// In en, this message translates to:
  /// **'Regular donor'**
  String get regularDonor;

  /// No description provided for @exemplaryDonor.
  ///
  /// In en, this message translates to:
  /// **'Exemplary donor'**
  String get exemplaryDonor;

  /// No description provided for @lifelinkHero.
  ///
  /// In en, this message translates to:
  /// **'LifeLink Hero'**
  String get lifelinkHero;

  /// No description provided for @historyError.
  ///
  /// In en, this message translates to:
  /// **'History error'**
  String get historyError;

  /// No description provided for @noDonationRecorded.
  ///
  /// In en, this message translates to:
  /// **'No donation recorded'**
  String get noDonationRecorded;

  /// No description provided for @donationHistoryWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Your donation history will appear here.'**
  String get donationHistoryWillAppear;

  /// No description provided for @lifelinkDonor.
  ///
  /// In en, this message translates to:
  /// **'LifeLink Donor'**
  String get lifelinkDonor;

  /// No description provided for @qrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'QR Code unavailable'**
  String get qrUnavailable;

  /// No description provided for @qrGeneratedAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Your donor QR code will be generated automatically.'**
  String get qrGeneratedAutomatically;

  /// No description provided for @medicalInformationContacts.
  ///
  /// In en, this message translates to:
  /// **'Your medical information and contact details'**
  String get medicalInformationContacts;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get bloodGroup;

  /// No description provided for @medicalStatus.
  ///
  /// In en, this message translates to:
  /// **'Medical status'**
  String get medicalStatus;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error while updating profile'**
  String get profileUpdateError;

  /// No description provided for @changeAddEmail.
  ///
  /// In en, this message translates to:
  /// **'Change / Add email'**
  String get changeAddEmail;

  /// No description provided for @codeSentByEmail.
  ///
  /// In en, this message translates to:
  /// **'Code sent by email'**
  String get codeSentByEmail;

  /// No description provided for @emailUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Email updated successfully'**
  String get emailUpdatedSuccessfully;

  /// No description provided for @changePhone.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhone;

  /// No description provided for @codeSentBySms.
  ///
  /// In en, this message translates to:
  /// **'Code sent by SMS'**
  String get codeSentBySms;

  /// No description provided for @phoneUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Phone updated successfully'**
  String get phoneUpdatedSuccessfully;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contactDetails;

  /// No description provided for @securityActions.
  ///
  /// In en, this message translates to:
  /// **'Security actions'**
  String get securityActions;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @currentEmail.
  ///
  /// In en, this message translates to:
  /// **'Current email'**
  String get currentEmail;

  /// No description provided for @noEmailAdded.
  ///
  /// In en, this message translates to:
  /// **'No email added'**
  String get noEmailAdded;

  /// No description provided for @currentPhone.
  ///
  /// In en, this message translates to:
  /// **'Current phone'**
  String get currentPhone;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @chooseBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Choose your blood group'**
  String get chooseBloodGroup;

  /// No description provided for @chooseBloodGroupHint.
  ///
  /// In en, this message translates to:
  /// **'Choose your blood group'**
  String get chooseBloodGroupHint;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmWithoutBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm continuing without a blood group?'**
  String get confirmWithoutBloodGroup;

  /// No description provided for @confirmBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm your blood group'**
  String get confirmBloodGroup;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @gpsDisabled.
  ///
  /// In en, this message translates to:
  /// **'GPS/location is disabled on the phone.'**
  String get gpsDisabled;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Permission permanently denied. Enable it in settings.'**
  String get locationDeniedForever;

  /// No description provided for @locationRetrieved.
  ///
  /// In en, this message translates to:
  /// **'Location retrieved'**
  String get locationRetrieved;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get locationUnavailable;

  /// No description provided for @recentDonationQuestionError.
  ///
  /// In en, this message translates to:
  /// **'Please indicate whether you donated blood during the last 4 months.'**
  String get recentDonationQuestionError;

  /// No description provided for @acceptConditionsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and privacy policy.'**
  String get acceptConditionsError;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

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

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get chooseDate;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birthDate;

  /// No description provided for @phoneRecoveredOtp.
  ///
  /// In en, this message translates to:
  /// **'Phone number recovered from OTP'**
  String get phoneRecoveredOtp;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @recentDonationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you donated blood during the last 4 months?'**
  String get recentDonationQuestion;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @acceptConditions.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms'**
  String get acceptConditions;

  /// No description provided for @acceptPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I accept the privacy policy'**
  String get acceptPrivacy;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @receivedCode.
  ///
  /// In en, this message translates to:
  /// **'Received code'**
  String get receivedCode;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP code'**
  String get otpCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the password'**
  String get confirmPasswordMessage;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @phoneNotFound.
  ///
  /// In en, this message translates to:
  /// **'Phone not found'**
  String get phoneNotFound;

  /// No description provided for @setPassword.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get setPassword;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @gpsCoordinates.
  ///
  /// In en, this message translates to:
  /// **'GPS coordinates'**
  String get gpsCoordinates;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @activeCenter.
  ///
  /// In en, this message translates to:
  /// **'Active center'**
  String get activeCenter;

  /// No description provided for @centerAvailableDescription.
  ///
  /// In en, this message translates to:
  /// **'This center is currently available for blood donations and requests.'**
  String get centerAvailableDescription;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kilometers;

  /// No description provided for @nouakchott.
  ///
  /// In en, this message translates to:
  /// **'Nouakchott'**
  String get nouakchott;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get sessionExpired;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get requestSent;

  /// No description provided for @nearbyDonorsAlerted.
  ///
  /// In en, this message translates to:
  /// **'Nearby donors will immediately receive your request.'**
  String get nearbyDonorsAlerted;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @urgentRequest.
  ///
  /// In en, this message translates to:
  /// **'Urgent request'**
  String get urgentRequest;

  /// No description provided for @urgentNeed.
  ///
  /// In en, this message translates to:
  /// **'URGENT NEED'**
  String get urgentNeed;

  /// No description provided for @sendBloodRequest.
  ///
  /// In en, this message translates to:
  /// **'Send a blood request'**
  String get sendBloodRequest;

  /// No description provided for @donorsReceiveAlert.
  ///
  /// In en, this message translates to:
  /// **'Nearby donors will immediately receive an alert.'**
  String get donorsReceiveAlert;

  /// No description provided for @enterYourCity.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enterYourCity;

  /// No description provided for @requestedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Requested quantity'**
  String get requestedQuantity;

  /// No description provided for @bags.
  ///
  /// In en, this message translates to:
  /// **'bag'**
  String get bags;

  /// No description provided for @urgentDetails.
  ///
  /// In en, this message translates to:
  /// **'Urgency details'**
  String get urgentDetails;

  /// No description provided for @medicalCenter.
  ///
  /// In en, this message translates to:
  /// **'Medical center'**
  String get medicalCenter;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @recoveryPeriod.
  ///
  /// In en, this message translates to:
  /// **'You are currently in recovery period.'**
  String get recoveryPeriod;

  /// No description provided for @nextDonationDate.
  ///
  /// In en, this message translates to:
  /// **'Next possible donation'**
  String get nextDonationDate;

  /// No description provided for @centerInformation.
  ///
  /// In en, this message translates to:
  /// **'Center information'**
  String get centerInformation;

  /// No description provided for @addressUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Address unavailable'**
  String get addressUnavailable;

  /// No description provided for @phoneUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Phone unavailable'**
  String get phoneUnavailable;

  /// No description provided for @viewDirections.
  ///
  /// In en, this message translates to:
  /// **'View directions'**
  String get viewDirections;

  /// No description provided for @respondUrgency.
  ///
  /// In en, this message translates to:
  /// **'Respond to urgency'**
  String get respondUrgency;

  /// No description provided for @phoneCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone copied'**
  String get phoneCopied;

  /// No description provided for @myDonations.
  ///
  /// In en, this message translates to:
  /// **'My donations'**
  String get myDonations;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get unknownDate;

  /// No description provided for @bloodDonation.
  ///
  /// In en, this message translates to:
  /// **'Blood donation'**
  String get bloodDonation;

  /// No description provided for @validated.
  ///
  /// In en, this message translates to:
  /// **'Validated'**
  String get validated;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @unknownCenter.
  ///
  /// In en, this message translates to:
  /// **'Unknown center'**
  String get unknownCenter;

  /// No description provided for @unknownCity.
  ///
  /// In en, this message translates to:
  /// **'Unknown city'**
  String get unknownCity;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @viewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View certificate'**
  String get viewCertificate;

  /// No description provided for @openCertificate.
  ///
  /// In en, this message translates to:
  /// **'Open certificate'**
  String get openCertificate;

  /// No description provided for @certificateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Certificate unavailable'**
  String get certificateUnavailable;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @iNeedBlood.
  ///
  /// In en, this message translates to:
  /// **'I need blood'**
  String get iNeedBlood;

  /// No description provided for @urgentRequests.
  ///
  /// In en, this message translates to:
  /// **'Urgent requests'**
  String get urgentRequests;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noUrgencyAvailable.
  ///
  /// In en, this message translates to:
  /// **'No urgency available'**
  String get noUrgencyAvailable;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration for'**
  String get registrationSuccess;

  /// No description provided for @alreadyRegisteredCollection.
  ///
  /// In en, this message translates to:
  /// **'You are already registered for this collection '**
  String get alreadyRegisteredCollection;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'Registration error'**
  String get registrationError;

  /// No description provided for @activeCollection.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE COLLECTION'**
  String get activeCollection;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @registeredPlural.
  ///
  /// In en, this message translates to:
  /// **'registered'**
  String get registeredPlural;

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get daysShort;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get hoursShort;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get minutesShort;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get secondsShort;

  /// No description provided for @imGoing.
  ///
  /// In en, this message translates to:
  /// **'I\'m going'**
  String get imGoing;

  /// No description provided for @nationalImpact.
  ///
  /// In en, this message translates to:
  /// **'NATIONAL IMPACT'**
  String get nationalImpact;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @lastValidatedDonation.
  ///
  /// In en, this message translates to:
  /// **'Last validated donation'**
  String get lastValidatedDonation;

  /// No description provided for @totalValidated.
  ///
  /// In en, this message translates to:
  /// **'Validated total'**
  String get totalValidated;

  /// No description provided for @savedLives.
  ///
  /// In en, this message translates to:
  /// **'Saved lives'**
  String get savedLives;

  /// No description provided for @realImpact.
  ///
  /// In en, this message translates to:
  /// **'Real impact'**
  String get realImpact;

  /// No description provided for @delay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @averageTime.
  ///
  /// In en, this message translates to:
  /// **'Average time'**
  String get averageTime;

  /// No description provided for @realTimeSituation.
  ///
  /// In en, this message translates to:
  /// **'REAL-TIME SITUATION'**
  String get realTimeSituation;

  /// No description provided for @viewMap.
  ///
  /// In en, this message translates to:
  /// **'View map'**
  String get viewMap;

  /// No description provided for @nearbyCenters.
  ///
  /// In en, this message translates to:
  /// **'nearby centers'**
  String get nearbyCenters;

  /// No description provided for @urgencies.
  ///
  /// In en, this message translates to:
  /// **'urgencies'**
  String get urgencies;

  /// No description provided for @activeCenters.
  ///
  /// In en, this message translates to:
  /// **'Active centers'**
  String get activeCenters;

  /// No description provided for @smartDonationAndEmergencies.
  ///
  /// In en, this message translates to:
  /// **'Smart donation & emergencies'**
  String get smartDonationAndEmergencies;

  /// No description provided for @livesSavedToday.
  ///
  /// In en, this message translates to:
  /// **'lives saved today'**
  String get livesSavedToday;

  /// No description provided for @activeDonorsInYourArea.
  ///
  /// In en, this message translates to:
  /// **'active donors in your area'**
  String get activeDonorsInYourArea;

  /// No description provided for @sendUrgentBloodRequest.
  ///
  /// In en, this message translates to:
  /// **'Quickly send an urgent blood request.'**
  String get sendUrgentBloodRequest;

  /// No description provided for @sendNow.
  ///
  /// In en, this message translates to:
  /// **'Send now'**
  String get sendNow;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @donations.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get donations;

  /// No description provided for @donationHistory.
  ///
  /// In en, this message translates to:
  /// **'Donation history'**
  String get donationHistory;

  /// No description provided for @nearbyDonors.
  ///
  /// In en, this message translates to:
  /// **'Nearby donors'**
  String get nearbyDonors;

  /// No description provided for @urgentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Urgent alerts'**
  String get urgentAlerts;

  /// No description provided for @healthCenters.
  ///
  /// In en, this message translates to:
  /// **'Health centers'**
  String get healthCenters;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @bloodCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Blood compatibility'**
  String get bloodCompatibility;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @lifelinkDonationCertificate.
  ///
  /// In en, this message translates to:
  /// **'LifeLink Donation Certificate'**
  String get lifelinkDonationCertificate;

  /// No description provided for @donor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get donor;

  /// No description provided for @center.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get center;

  /// No description provided for @lifelinkCertificate.
  ///
  /// In en, this message translates to:
  /// **'LifeLink Certificate'**
  String get lifelinkCertificate;

  /// No description provided for @officialBloodDonationCertificate.
  ///
  /// In en, this message translates to:
  /// **'Official blood donation certificate'**
  String get officialBloodDonationCertificate;

  /// No description provided for @donationCertificate.
  ///
  /// In en, this message translates to:
  /// **'Donation Certificate'**
  String get donationCertificate;

  /// No description provided for @verifiedCertificate.
  ///
  /// In en, this message translates to:
  /// **'Verified certificate'**
  String get verifiedCertificate;

  /// No description provided for @thankYouBloodDonation.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your contribution to blood donation.'**
  String get thankYouBloodDonation;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @lives.
  ///
  /// In en, this message translates to:
  /// **'lives'**
  String get lives;

  /// No description provided for @viewCertificateShare.
  ///
  /// In en, this message translates to:
  /// **'View certificate & share'**
  String get viewCertificateShare;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @donorPoints.
  ///
  /// In en, this message translates to:
  /// **'donor points'**
  String get donorPoints;

  /// No description provided for @donorProgression.
  ///
  /// In en, this message translates to:
  /// **'donor progression'**
  String get donorProgression;

  /// No description provided for @nextDonationPossible.
  ///
  /// In en, this message translates to:
  /// **'Next possible donation'**
  String get nextDonationPossible;

  /// No description provided for @noDateAvailable.
  ///
  /// In en, this message translates to:
  /// **'No date available'**
  String get noDateAvailable;

  /// No description provided for @newDonationAvailableDate.
  ///
  /// In en, this message translates to:
  /// **'You will be able to donate again on this date.'**
  String get newDonationAvailableDate;

  /// No description provided for @nextDonationDateSoon.
  ///
  /// In en, this message translates to:
  /// **'Your next donation date will be available soon.'**
  String get nextDonationDateSoon;

  /// No description provided for @receiveReminder.
  ///
  /// In en, this message translates to:
  /// **'Receive reminder'**
  String get receiveReminder;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @bloodGroupVerified.
  ///
  /// In en, this message translates to:
  /// **'Blood group verified'**
  String get bloodGroupVerified;

  /// No description provided for @pendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending verification'**
  String get pendingVerification;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @medicalProfileVerified.
  ///
  /// In en, this message translates to:
  /// **'Medical profile verified'**
  String get medicalProfileVerified;

  /// No description provided for @verificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification required'**
  String get verificationRequired;

  /// No description provided for @yourBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Your blood group'**
  String get yourBloodGroup;

  /// No description provided for @hasBeenValidated.
  ///
  /// In en, this message translates to:
  /// **'has been validated.'**
  String get hasBeenValidated;

  /// No description provided for @pleaseCompleteMedicalVerification.
  ///
  /// In en, this message translates to:
  /// **'Please complete a medical verification.'**
  String get pleaseCompleteMedicalVerification;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @qr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get qr;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @presentQrAtDonationCenters.
  ///
  /// In en, this message translates to:
  /// **'Present this QR code at donation centers'**
  String get presentQrAtDonationCenters;

  /// No description provided for @secureDonationQrInfo.
  ///
  /// In en, this message translates to:
  /// **'This QR contains your secured donation information'**
  String get secureDonationQrInfo;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
