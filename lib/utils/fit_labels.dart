import '../constants/app_strings.dart';
import 'size_recommender.dart';

/// US-013: the fit names in the current language. Kept apart from
/// size_recommender.dart so the size logic stays free of UI text.
extension FitPreferenceLabel on FitPreference {
  String get label {
    switch (this) {
      case FitPreference.slim:
        return AppStrings.fitSlim;
      case FitPreference.regular:
        return AppStrings.fitRegular;
      case FitPreference.relaxed:
        return AppStrings.fitRelaxed;
    }
  }
}
