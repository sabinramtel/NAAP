# Time and space choices in Sprint 1

The brief asks for code that takes little time and little space. These are the places in Sprint 1 where that choice mattered, with the cost of each.

| Where | What we did | Cost | What we avoided |
|---|---|---|---|
| `auth_service.dart` | One storage key per email (`naap_user_<email>`) | O(1) lookup | Loading a list of every user and searching it, O(n) |
| `auth_service.dart` | Salted SHA-256 for passwords, compared in constant time | O(length of hash) | Storing plain passwords, or a comparison that stops early and leaks timing |
| `login_guard.dart` | Two numbers per email: failed count and lock end time | O(1) time and space | Keeping a log of every failed attempt |
| `session_store.dart` | One secure entry holding the email and an expiry date | O(1) | A token list that grows with each login |
| `validators.dart` | Password check walks the text once and stops at the first digit | O(n), O(1) extra space | Several regex passes over the same text |
| `unit_converter.dart` | Height kept as whole centimetres, converted with integer maths | O(1) | Storing both units and keeping them in sync |
| `height_ruler.dart` | `ListView.builder` with a fixed `itemExtent`, value = scroll offset / tick width | O(1) per scroll event, only visible ticks built | Building all 131 ticks, or measuring each one to find the value |
| `profile_setup_screen.dart` | Image picker shrinks photos to 512 px wide | Small file on disk | Saving a full camera photo (often 5 to 12 MB) |
| `splash_screen.dart` | Session check runs while the logo plays | Wait = max(animation, check), not the sum | Playing the logo first and then loading |
| `verify_email_banner.dart` | One periodic timer for the 60 second countdown | O(1) | A new timer per tap |

## Why not a database yet

Sprint 1 only needs to find one user by email, so a key-value store with O(1) lookups is enough. When later sprints add measurements and product history, the team can decide between Firestore and a local database. Changing it only affects the files in `lib/services`.
