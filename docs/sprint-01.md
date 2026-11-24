# Sprint 1: account, sign-in and onboarding

Week 1. 12 stories, 28 points. Taken from the Sprint-1 Backlog tab in the team Google Sheet.

## Stories and files

| Story | Owner | What it is | Files |
|---|---|---|---|
| US-001 | Rujab | Sign up with email and password | `screens/sign_up_screen.dart`, `services/auth_service.dart`, `utils/validators.dart` |
| US-002 | Sabin | Sign up and log in with Google | Button in `sign_up_screen.dart` and `login_screen.dart`, `signInWithGoogle` in `auth_service.dart` |
| US-003 | Dipesh | Log in with email and password | `screens/login_screen.dart`, `utils/login_guard.dart`, eye toggle in `widgets/app_text_field.dart` |
| US-004 | Sabin | Reset a forgotten password | `screens/forgot_password_screen.dart`, `screens/reset_password_screen.dart` |
| US-005 | Unish | Stay logged in for 30 days | `services/session_store.dart`, `restoreSession` in `auth_service.dart`, `screens/splash_screen.dart` |
| US-006 | Sabin | Log out with a confirm step | `widgets/logout_sheet.dart` |
| US-007 | Unish | Verify email | `widgets/verify_email_banner.dart` on `screens/home_screen.dart` |
| US-008 | Sabin | Change password | `screens/change_password_screen.dart` |
| US-009 | Dipesh | Three welcome screens, shown once | `screens/onboarding_screen.dart`, `widgets/page_dots.dart` |
| US-010 | Sabin | Animated logo on launch | `screens/splash_screen.dart`, `widgets/naap_logo.dart` |
| US-011 | Rujab | Name, date of birth and photo | `screens/profile_setup_screen.dart`, `utils/profile_helpers.dart` |
| US-012 | Unish | Height in cm or ft/in | `screens/height_screen.dart`, `widgets/height_ruler.dart`, `utils/unit_converter.dart` |

## Acceptance criteria that need Firebase

The blueprint covers every criterion it can in local mode. These need Firebase or a later sprint:

- US-001: the verification email arriving within 2 minutes.
- US-002: everything about Google sign-in, including linking a Google account to an existing email account.
- US-004: the reset email itself. The demo button opens the same reset screen the email link would.
- US-007: tapping the real email link, and the "already verified" page when it is opened twice.
- US-008: logging out other devices after a password change.
- US-012: the body scan using the saved height. The height is saved now. The scan comes in a later sprint.

## Things for the team to decide on Friday

1. US-003 in the sheet says "log in with my facebook and password", but its criteria are about email and password. The code follows the criteria. Should the story text be fixed?
2. US-005 says a logged-out user sees "the welcome screen" on reopening. The blueprint shows the welcome screens only on first launch (US-009) and the log in screen after that. Is that what we mean?
3. US-011 says the photo is "cropped to a circle". The blueprint shows it inside a circle without cutting the file. A real crop step would need another package (`image_cropper`).
4. Home is a simple account page for now. The real Home is US-017 in Sprint 2.
5. Unish is listed as Tester in the Sprint-1 tab and as UI/UX in the proposal. Which one is right?

## How to test it by hand

1. First launch: logo plays, then three welcome screens. Skip goes to sign up.
2. Sign up with a password like `abc` and check the rule appears. Then use `naapdemo1`.
3. Fill in profile setup. Try a birth date under 18 and check the message.
4. Pick a height on the ruler, switch to ft/in, tap the number and type 250 to see the range message.
5. On Home, try Resend email twice to see the countdown. Then tap "Mark verified (demo)".
6. Log out, cancel once, then confirm. Press the phone's back button and check you can't get back in.
7. Log in with a wrong password 5 times and check the 5 minute pause.
8. Use Forgot password, then "Open reset link (demo)", set a new password and log in with it.
9. Close the app and open it again. You should go straight to Home.
