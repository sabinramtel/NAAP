import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, nepali }

/// US-016: which language the app shows, saved on the phone so the app
/// reopens in the same language.
///
/// Every piece of text comes from AppStrings, which asks this controller for
/// the current language. When the language changes we mark every widget on
/// screen for rebuild once, so all menus and buttons switch straight away
/// without restarting the app or losing the screen the user is on.
class LanguageController extends ValueNotifier<AppLanguage> {
  LanguageController._() : super(AppLanguage.english);
  static final LanguageController instance = LanguageController._();

  static const String _key = 'naap_language';

  bool get isNepali => value == AppLanguage.nepali;
  String get code => isNepali ? 'ne' : 'en';

  static AppLanguage fromCode(String? code) => code == 'ne' ? AppLanguage.nepali : AppLanguage.english;

  /// Called once in main() before the first frame.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    value = fromCode(prefs.getString(_key));
  }

  Future<void> change(AppLanguage language) async {
    if (language == value) return;
    value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
    _rebuildEverything();
  }

  /// Walks the widget tree once and marks each element dirty. O(number of
  /// widgets on screen), and it only runs when the user changes language.
  void _rebuildEverything() {
    final root = WidgetsBinding.instance.rootElement;
    if (root == null) return;
    void mark(Element element) {
      element.markNeedsBuild();
      element.visitChildren(mark);
    }

    root.visitChildren(mark);
  }
}
