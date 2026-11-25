import '../services/language_controller.dart';

/// Every piece of text the user sees, in English and Nepali (US-016).
///
/// Each getter returns the text for the language chosen in
/// LanguageController, so screens use `Text(AppStrings.logIn)` without `const`.
/// Size labels (S, M, L, 32) and units (cm) are never translated.
class AppStrings {
  AppStrings._();

  static String _t(String en, String ne) =>
      LanguageController.instance.isNepali ? ne : en;

  static const String appName = "NAAP";
  static const String appNameNepali = "नाप";
  static String get fromTeam => _t("from Team NAAP", "टिम नापबाट");
  static String get measure => _t("measure", "नाप");

  // Onboarding (US-009)
  static List<String> get onboardingTitles => [
        _t("Know your size from two photos",
            "दुई फोटोबाट आफ्नो साइज थाहा पाउनुहोस्"),
        _t("See clothes on your own avatar", "आफ्नै अवतारमा लुगा हेर्नुहोस्"),
        _t("Buy the size that fits", "मिल्ने साइज मात्र किन्नुहोस्"),
      ];
  static List<String> get onboardingBodies => [
        _t("Stand in front of your phone camera. NAAP turns two photos into your body measurements.",
            "फोनको क्यामेरा अगाडि उभिनुहोस्। नापले दुई फोटोबाट तपाईंको शरीरको नाप निकाल्छ।"),
        _t("Your measurements build an avatar, so you can check how clothes sit before you buy.",
            "तपाईंको नापबाट अवतार बन्छ, त्यसैले किन्नुअघि लुगा कस्तो देखिन्छ हेर्न सक्नुहुन्छ।"),
        _t("Every item shows the size that matches you, so you guess less and return less.",
            "हरेक सामानमा तपाईंलाई मिल्ने साइज देखिन्छ, त्यसैले अनुमान र फिर्ता दुवै कम हुन्छ।"),
      ];
  static String get next => _t("Next", "अर्को");
  static String get skip => _t("Skip", "छोड्नुहोस्");
  static String get getStarted => _t("Get started", "सुरु गरौं");

  // Sign up / log in (US-001 to US-004)
  static String get createAccount => _t("Create account", "खाता बनाउनुहोस्");
  static String get createYourAccount =>
      _t("Create your account", "आफ्नो खाता बनाउनुहोस्");
  static String get measurementsPrivate => _t(
      "Your measurements stay private to you.",
      "तपाईंको नाप तपाईंसँग मात्र रहन्छ।");
  static String get orWithEmail => _t("or with email", "वा इमेलबाट");
  static String get welcomeBack => _t("Welcome back", "फेरि स्वागत छ");
  static String get logInToSee =>
      _t("Log in to see your sizes.", "आफ्नो साइज हेर्न लग इन गर्नुहोस्।");
  static String get logIn => _t("Log in", "लग इन");
  static String get fullName => _t("Full name", "पूरा नाम");
  static String get email => _t("Email", "इमेल");
  static String get password => _t("Password", "पासवर्ड");
  static String get passwordRule => _t(
      "Use 8 or more characters with at least one number.",
      "कम्तीमा एउटा अंकसहित ८ वा बढी अक्षर राख्नुहोस्।");
  static String get continueWithGoogle =>
      _t("Continue with Google", "Google बाट जारी राख्नुहोस्");
  static String get googleNeedsFirebase => _t(
      "Google sign-in will work once the team connects Firebase. Use email for now.",
      "Firebase जोडेपछि Google लग इन चल्नेछ। अहिलेलाई इमेल प्रयोग गर्नुहोस्।");
  static String get haveAccount =>
      _t("I already have an account", "मेरो खाता पहिले नै छ");
  static String get noAccount =>
      _t("Create a new account", "नयाँ खाता बनाउनुहोस्");
  static String get emailTaken =>
      _t("This email already has an account.", "यो इमेलमा पहिले नै खाता छ।");
  static String get goToLogin => _t("Log in instead", "लग इन गर्नुहोस्");
  static String get wrongCredentials =>
      _t("Email or password is incorrect.", "इमेल वा पासवर्ड मिलेन।");
  static String tooManyTries(String wait) => _t(
      "Too many tries. Try again in $wait.",
      "धेरै पटक प्रयास भयो। $wait पछि फेरि प्रयास गर्नुहोस्।");
  static String get enterPassword =>
      _t("Enter your password.", "पासवर्ड लेख्नुहोस्।");
  static String get forgotPassword =>
      _t("Forgot password?", "पासवर्ड बिर्सनुभयो?");
  static String get resetYourPassword =>
      _t("Reset your password", "पासवर्ड रिसेट गर्नुहोस्");
  static String get resetIntro => _t(
      "Enter your email and we'll send you a link.",
      "इमेल लेख्नुहोस्, हामी लिंक पठाउँछौं।");
  static String get sendLink => _t("Send link", "लिंक पठाउनुहोस्");
  static String get openResetLinkDemo =>
      _t("Open reset link (demo)", "रिसेट लिंक खोल्नुहोस् (डेमो)");
  static String get resetSentMessage => _t(
      "If an account exists for this email, we've sent a link to reset the password. The link works for 30 minutes.",
      "यो इमेलमा खाता भए पासवर्ड रिसेट गर्ने लिंक पठाइएको छ। लिंक ३० मिनेटसम्म चल्छ।");
  static String get resetExpired => _t(
      "This reset link has expired. Ask for a new one.",
      "यो रिसेट लिंकको समय सकियो। नयाँ लिंक माग्नुहोस्।");
  static String get chooseNewPassword =>
      _t("Choose a new password", "नयाँ पासवर्ड छान्नुहोस्");
  static String get passwordChangedLogIn => _t(
      "Password changed. Log in with your new password.",
      "पासवर्ड फेरियो। नयाँ पासवर्डले लग इन गर्नुहोस्।");
  static String get newPassword => _t("New password", "नयाँ पासवर्ड");
  static String get confirmPassword =>
      _t("Confirm new password", "नयाँ पासवर्ड फेरि लेख्नुहोस्");
  static String get passwordsDontMatch =>
      _t("Passwords do not match", "पासवर्ड मिलेन");
  static String get passwordChanged => _t("Password changed", "पासवर्ड फेरियो");

  // Form checks (validators.dart)
  static String get enterEmail => _t("Enter your email.", "इमेल लेख्नुहोस्।");
  static String get invalidEmail => _t(
      "Enter a valid email, like name@example.com.",
      "सही इमेल लेख्नुहोस्, जस्तै name@example.com।");
  static String get passwordTooShort =>
      _t("Use at least 8 characters.", "कम्तीमा ८ अक्षर राख्नुहोस्।");
  static String get passwordNeedsNumber =>
      _t("Add at least one number.", "कम्तीमा एउटा अंक राख्नुहोस्।");
  static String get enterName =>
      _t("Enter your name.", "आफ्नो नाम लेख्नुहोस्।");
  static String get nameTooShort =>
      _t("Name looks too short.", "नाम धेरै छोटो भयो।");

  // Verification (US-007)
  static String get verifyBanner => _t("Check your inbox to verify your email.",
      "इमेल पुष्टि गर्न इनबक्स हेर्नुहोस्।");
  static String get resendEmail => _t("Resend email", "इमेल फेरि पठाउनुहोस्");
  static String resendIn(int seconds) =>
      _t("Resend in ${seconds}s", "$seconds सेकेन्डपछि फेरि पठाउनुहोस्");
  static String get markVerifiedDemo =>
      _t("Mark verified (demo)", "पुष्टि भयो भनौं (डेमो)");
  static String get verificationSent =>
      _t("Verification email sent", "पुष्टि गर्ने इमेल पठाइयो");
  static String get emailVerified => _t("Email verified", "इमेल पुष्टि भयो");

  // Logout (US-006)
  static String get logOut => _t("Log out", "लग आउट");
  static String get logOutQuestion =>
      _t("Log out of NAAP?", "नापबाट लग आउट गर्ने?");
  static String get logOutBody => _t(
      "Your measurements stay saved to your account.",
      "तपाईंको नाप खातामा सुरक्षित रहन्छ।");
  static String get cancel => _t("Cancel", "रद्द गर्नुहोस्");

  // Change password (US-008)
  static String get changePassword =>
      _t("Change password", "पासवर्ड फेर्नुहोस्");
  static String get currentPassword => _t("Current password", "हालको पासवर्ड");
  static String get enterCurrentPassword =>
      _t("Enter your current password.", "हालको पासवर्ड लेख्नुहोस्।");
  static String get differentPassword => _t(
      "Use a different password from your current one.",
      "हालको भन्दा फरक पासवर्ड राख्नुहोस्।");
  static String get wrongCurrentPassword =>
      _t("Your current password is not right.", "हालको पासवर्ड मिलेन।");
  static String get logInAgain =>
      _t("Please log in again.", "कृपया फेरि लग इन गर्नुहोस्।");
  static String get save => _t("Save", "सेभ गर्नुहोस्");

  // Profile setup (US-011)
  static String get aboutYou =>
      _t("Tell us about you", "आफ्नो बारेमा बताउनुहोस्");
  static String get dateOfBirth => _t("Date of birth", "जन्म मिति");
  static String get pickDateOfBirth =>
      _t("Pick your date of birth.", "जन्म मिति छान्नुहोस्।");
  static String get tapToChoose => _t("Tap to choose", "छान्न थिच्नुहोस्");
  static String get addPhoto =>
      _t("Add photo (optional)", "फोटो थप्नुहोस् (चाहेमा)");
  static String get photoError => _t(
      "Could not open your photos. You can add one later.",
      "फोटो खोल्न सकिएन। पछि थप्न सक्नुहुन्छ।");
  static String get underAge => _t("NAAP is for users aged 18 and over.",
      "नाप १८ वर्ष वा माथिकालाई मात्र हो।");
  static String get continueText => _t("Continue", "जारी राख्नुहोस्");
  static String get editProfile => _t("Edit profile", "प्रोफाइल बदल्नुहोस्");
  static List<String> get monthNames => LanguageController.instance.isNepali
      ? const [
          'जनवरी',
          'फेब्रुअरी',
          'मार्च',
          'अप्रिल',
          'मे',
          'जुन',
          'जुलाई',
          'अगस्ट',
          'सेप्टेम्बर',
          'अक्टोबर',
          'नोभेम्बर',
          'डिसेम्बर'
        ]
      : const [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];

  // Height (US-012). "cm" stays the same in both languages.
  static String get howTall => _t("How tall are you?", "तपाईंको उचाइ कति हो?");
  static String get heightHelp => _t(
      "Your height sets the scale for photo measurements.",
      "फोटोबाट नाप लिँदा तपाईंको उचाइलाई आधार मानिन्छ।");
  static String get heightOutOfRange => _t(
      "Please check your height. It should be between 100 cm and 230 cm.",
      "उचाइ फेरि हेर्नुहोस्। यो 100 cm देखि 230 cm बीच हुनुपर्छ।");
  static String get height => _t("Height", "उचाइ");
  static String get editHeight => _t("Edit height", "उचाइ बदल्नुहोस्");
  static String get notSet => _t("Not set", "राखिएको छैन");
  static String get tapToType => _t("tap to type", "लेख्न थिच्नुहोस्");
  static String get typeYourHeight => _t("Type your height", "उचाइ लेख्नुहोस्");
  static const String centimetres = "cm";
  static const String feetInches = "ft / in";

  // Setup steps (Sprint 2)
  static String stepOf(int step, int total) =>
      _t("Step $step of $total", "चरण $step / $total");

  // Language (US-016). Each option is written in its own language on purpose.
  static String get chooseLanguage =>
      _t("Choose your language", "भाषा छान्नुहोस्");
  static String get languageHelp => _t("You can change this later in Profile.",
      "यो पछि प्रोफाइलबाट बदल्न सक्नुहुन्छ।");
  static String get language => _t("Language", "भाषा");
  static const String english = "English";
  static const String nepali = "नेपाली";

  // Fit (US-013)
  static String get howDoYouLikeFit =>
      _t("How do you like your clothes to fit?", "लुगा कस्तो फिट मन पर्छ?");
  static String get fitHelp => _t(
      "We use this when we suggest a size. Regular is chosen if you skip.",
      "साइज सुझाउँदा यसलाई हेरिन्छ। छोड्नुभयो भने रेगुलर राखिन्छ।");
  static String get fit => _t("Fit", "फिट");
  static String get fitSlim => _t("Slim", "स्लिम");
  static String get fitRegular => _t("Regular", "रेगुलर");
  static String get fitRelaxed => _t("Relaxed", "खुकुलो");
  static String get fitSlimHelp => _t("Close to the body", "शरीरमा टाँसिएको");
  static String get fitRegularHelp =>
      _t("Not tight, not loose", "न टाइट, न खुकुलो");
  static String get fitRelaxedHelp =>
      _t("Extra room to move", "चल्न सजिलो, अलि खुकुलो");

  // Styles (US-014)
  static String get whatDoYouWear =>
      _t("What do you like to wear?", "तपाईं कस्तो लुगा लगाउन रुचाउनुहुन्छ?");
  static String get stylesHelp => _t("Pick as many as you like, or none.",
      "जति मन लाग्छ छान्नुहोस्, वा कुनै पनि नछान्नुहोस्।");
  static String get styles => _t("Styles", "शैली");
  static String get styleCasual => _t("Casual", "क्यासुअल");
  static String get styleFormal => _t("Office and formal", "अफिस र फर्मल");
  static String get styleEthnic => _t("Ethnic", "परम्परागत");
  static String get styleSporty => _t("Sporty", "खेलकुद");
  static String get styleStreet => _t("Streetwear", "स्ट्रिटवेयर");
  static String get styleMinimal => _t("Minimal", "सादा");
  static String get noneChosen => _t("None chosen", "केही छानिएको छैन");

  // Brands (US-015)
  static String get whichBrands =>
      _t("Which brands do you buy?", "कुन ब्रान्ड किन्नुहुन्छ?");
  static String get brandsHelp => _t(
      "Their size charts show first in the size guide.",
      "साइज गाइडमा यिनको साइज चार्ट पहिले देखिन्छ।");
  static String get searchBrands => _t("Search brands", "ब्रान्ड खोज्नुहोस्");
  static String get brands => _t("Brands", "ब्रान्ड");
  static String continueWithCount(int n) =>
      _t("Continue ($n selected)", "जारी राख्नुहोस् ($n छानियो)");
  static String get cantFindIt => _t("Can't find it?", "भेटिएन?");
  static String get requestBrand =>
      _t("Request a brand", "ब्रान्ड थप्न अनुरोध");
  static String get brandName => _t("Brand name", "ब्रान्डको नाम");
  static String get send => _t("Send", "पठाउनुहोस्");
  static String brandRequested(String name) => _t(
      "Thanks. We'll look at adding $name.",
      "धन्यवाद। $name थप्ने बारे हेर्नेछौं।");
  static String get noBrandsMatch =>
      _t("No brands match your search.", "खोजसँग मिल्ने ब्रान्ड भेटिएन।");

  // Size guide
  static String get sizeGuide => _t("Size guide", "साइज गाइड");
  static String get yourBrands => _t("Your brands", "तपाईंका ब्रान्ड");
  static String get otherBrands => _t("Other brands", "अरू ब्रान्ड");
  static String get runsSmall => _t("Runs small", "साइज सानो आउँछ");
  static String get runsLarge => _t("Runs large", "साइज ठूलो आउँछ");
  static String get trueToSize => _t("True to size", "साइज ठीक आउँछ");

  // Main tabs (US-018)
  static String get tabHome => _t("Home", "गृह");
  static String get tabExplore => _t("Explore", "खोज्नुहोस्");
  static String get tabTryOn => _t("Try-On", "लगाएर हेर्नुहोस्");
  static String get tabSaved => _t("Saved", "सेभ गरिएका");
  static String get tabProfile => _t("Profile", "प्रोफाइल");
  static String get comingSoon =>
      _t("Coming in a later sprint.", "पछिको स्प्रिन्टमा आउँदैछ।");

  // Home (US-017, US-020, US-022)
  static String hi(String name) => _t("Hi, $name", "नमस्ते, $name");
  static String get yourSizes => _t("Your sizes", "तपाईंको साइज");
  static String get tops => _t("Tops", "माथिल्लो लुगा");
  static String get jeans => _t("Jeans", "जिन्स");
  static String get dresses => _t("Dresses", "ड्रेस");
  static String fitLabel(String fit) => _t("$fit fit", "$fit फिट");
  static String get sampleNote => _t(
      "Based on sample measurements. Do a body scan for your real sizes.",
      "नमुना नापमा आधारित। सही साइजका लागि बडी स्क्यान गर्नुहोस्।");
  static String get seeAllMeasurements =>
      _t("See all measurements", "सबै नाप हेर्नुहोस्");
  static String get noScanTitle =>
      _t("Find your size", "आफ्नो साइज पत्ता लगाउनुहोस्");
  static String get noScanBody => _t(
      "Take two photos and we'll work out your measurements.",
      "दुई फोटो खिच्नुहोस्, हामी तपाईंको नाप निकाल्छौं।");
  static String get startBodyScan =>
      _t("Start body scan", "बडी स्क्यान सुरु गर्नुहोस्");
  static String get pickedForYou =>
      _t("Picked for you", "तपाईंका लागि छानिएका");
  static String get popularNow => _t("Popular now", "अहिले लोकप्रिय");
  static String get youreOffline => _t(
      "You're offline. Showing your saved sizes.",
      "इन्टरनेट छैन। सेभ गरिएको साइज देखाउँदै।");
  static String get yourSize => _t("Your size", "तपाईंको साइज");
  static String get scanToSeeSize =>
      _t("Scan your body to see your size", "साइज हेर्न बडी स्क्यान गर्नुहोस्");
  static String get sizes => _t("Sizes", "साइजहरू");
  static String price(int npr) => _t("Rs $npr", "रु $npr");

  // Measurements screen (US-017). Units stay in cm.
  static String get measurements => _t("Measurements", "नाप");
  static String get chest => _t("Chest", "छाती");
  static String get waist => _t("Waist", "कम्मर");
  static String get hip => _t("Hip", "हिप");
  static String get shoulder => _t("Shoulder", "काँध");
  static String get inseam => _t("Inside leg", "भित्री खुट्टा");
  static String get sleeve => _t("Sleeve", "बाहुला");
  static String measuredOn(String date) =>
      _t("Measured on $date", "$date मा नापिएको");

  // Shortcuts (US-019)
  static String get bodyScan => _t("Body scan", "बडी स्क्यान");
  static String get avatar => _t("Avatar", "अवतार");
  static String get scanComingBody => _t(
      "The camera scan is built in a later sprint. For now you can load sample measurements worked out from your height.",
      "क्यामेरा स्क्यान पछिको स्प्रिन्टमा बन्छ। अहिलेलाई तपाईंको उचाइबाट निकालिएको नमुना नाप राख्न सक्नुहुन्छ।");
  static String get useSampleMeasurements =>
      _t("Use sample measurements (demo)", "नमुना नाप राख्नुहोस् (डेमो)");
  static String get avatarComing => _t(
      "Your 3D avatar is built in a later sprint.",
      "तपाईंको 3D अवतार पछिको स्प्रिन्टमा बन्छ।");

  // Notifications (US-021)
  static String get notifications => _t("Notifications", "सूचनाहरू");
  static String unreadCount(int n) =>
      _t("Notifications, $n unread", "सूचनाहरू, $n नपढिएको");
  static String get unread => _t("Unread", "नपढिएको");
  static String get noNotifications =>
      _t("No notifications yet.", "अहिलेसम्म कुनै सूचना छैन।");
  static String priceDropTitle(String item) =>
      _t("Price drop on $item", "$item को मूल्य घट्यो");
  static String get priceDropBody => _t("An item you saved is cheaper now.",
      "तपाईंले सेभ गरेको सामान अहिले सस्तो भयो।");
  static String backInStockTitle(String item) =>
      _t("$item is back in stock", "$item फेरि उपलब्ध छ");
  static String get backInStockBody =>
      _t("Your size is available again.", "तपाईंको साइज फेरि उपलब्ध भयो।");
  static String get newArrivalTitle =>
      _t("New arrivals in your style", "तपाईंको शैलीमा नयाँ लुगा");
  static String get newArrivalBody => _t(
      "We added clothes that match what you like.",
      "तपाईंलाई मन पर्ने खालका नयाँ लुगा थपिएका छन्।");
  static String minutesAgo(int n) => _t("$n min ago", "$n मिनेट अघि");
  static String hoursAgo(int n) => _t("$n h ago", "$n घण्टा अघि");
  static String daysAgo(int n) => _t("$n d ago", "$n दिन अघि");

  // Profile tab
  static String get preferences => _t("Preferences", "रोजाइ");
  static String get account => _t("Account", "खाता");
  static String bornOn(String date) => _t("Born $date", "जन्म $date");
  static String get dateNotSet =>
      _t("Date of birth not set", "जन्म मिति राखिएको छैन");
  static String get sprintNote => _t(
      "Explore, Try-On and Saved arrive in later sprints.",
      "खोज्नुहोस्, लगाएर हेर्नुहोस् र सेभ गरिएका पछिको स्प्रिन्टमा आउँछन्।");
}
