/// Every piece of text the user sees in Sprint 1.
/// Keeping text in one place makes the Nepali version (US-016, Sprint 2)
/// a matter of adding a second map instead of editing every screen.
class AppStrings {
  AppStrings._();

  static const String appName = "NAAP";
  static const String appNameNepali = "नाप";
  static const String fromTeam = "from Team NAAP";

  // Onboarding (US-009)
  static const List<String> onboardingTitles = [
    "Know your size from two photos",
    "See clothes on your own avatar",
    "Buy the size that fits",
  ];
  static const List<String> onboardingBodies = [
    "Stand in front of your phone camera. NAAP turns two photos into your body measurements.",
    "Your measurements build an avatar, so you can check how clothes sit before you buy.",
    "Every item shows the size that matches you, so you guess less and return less.",
  ];
  static const String next = "Next";
  static const String skip = "Skip";
  static const String getStarted = "Get started";

  // Sign up / log in (US-001 to US-004)
  static const String createAccount = "Create account";
  static const String logIn = "Log in";
  static const String fullName = "Full name";
  static const String email = "Email";
  static const String password = "Password";
  static const String passwordRule = "Use 8 or more characters with at least one number.";
  static const String continueWithGoogle = "Continue with Google";
  static const String haveAccount = "I already have an account";
  static const String noAccount = "Create a new account";
  static const String emailTaken = "This email already has an account.";
  static const String goToLogin = "Log in instead";
  static const String wrongCredentials = "Email or password is incorrect.";
  static const String forgotPassword = "Forgot password?";
  static const String sendLink = "Send link";
  static const String resetSentMessage =
      "If an account exists for this email, we've sent a link to reset the password. The link works for 30 minutes.";
  static const String resetExpired = "This reset link has expired. Ask for a new one.";
  static const String newPassword = "New password";
  static const String confirmPassword = "Confirm new password";
  static const String passwordsDontMatch = "Passwords do not match";
  static const String passwordChanged = "Password changed";

  // Verification (US-007)
  static const String verifyBanner = "Check your inbox to verify your email.";
  static const String resendEmail = "Resend email";
  static const String verificationSent = "Verification email sent";
  static const String emailVerified = "Email verified";

  // Logout (US-006)
  static const String logOut = "Log out";
  static const String logOutQuestion = "Log out of NAAP?";
  static const String logOutBody = "Your measurements stay saved to your account.";
  static const String cancel = "Cancel";

  // Change password (US-008)
  static const String changePassword = "Change password";
  static const String currentPassword = "Current password";
  static const String save = "Save";

  // Profile setup (US-011)
  static const String aboutYou = "Tell us about you";
  static const String dateOfBirth = "Date of birth";
  static const String addPhoto = "Add photo (optional)";
  static const String underAge = "NAAP is for users aged 18 and over.";
  static const String continueText = "Continue";

  // Height (US-012)
  static const String howTall = "How tall are you?";
  static const String heightHelp = "Your height sets the scale for photo measurements.";
  static const String heightOutOfRange = "Please check your height. It should be between 100 cm and 230 cm.";
  static const String centimetres = "cm";
  static const String feetInches = "ft / in";
}
