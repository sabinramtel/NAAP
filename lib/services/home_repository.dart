import '../data/brands.dart';
import '../data/catalog.dart';
import '../models/measurements.dart';
import '../models/product.dart';
import '../models/user_profile.dart';
import '../utils/picks.dart';
import '../utils/size_recommender.dart';
import 'measurement_store.dart';
import 'profile_store.dart';

/// Everything Home needs in one object.
class HomeData {
  final UserProfile? profile;
  final Measurements? measurements;
  final FitPreference fit;
  final List<Product> picks;
  final bool hasStyles;

  const HomeData({
    required this.profile,
    required this.measurements,
    required this.fit,
    required this.picks,
    required this.hasStyles,
  });

  /// Size for one kind of clothing on our base chart, or null before a scan.
  String? sizeFor(Garment garment) => measurements == null
      ? null
      : SizeRecommender.recommend(garment, measurements!, fit);

  /// Size for a product, taking its brand into account (US-013, US-015, US-020).
  String? sizeForProduct(Product p) => measurements == null
      ? null
      : SizeRecommender.recommend(p.garment, measurements!, fit,
          brandOffsetCm: Brands.byId(p.brandId)?.offsetCm ?? 0);
}

/// US-022: Home reads only from the phone, so its content is ready in
/// milliseconds even on a slow connection. The profile and measurements are
/// read at the same time rather than one after the other.
/// When the shop backend arrives, its call goes here with a 2 second timeout
/// and the phone copy stays as the fallback for offline use.
class HomeRepository {
  HomeRepository._();

  static Future<HomeData> load(String email) async {
    final (profile, measurements) = await (
      ProfileStore.instance.load(email),
      MeasurementStore.instance.load(email),
    ).wait;
    final styles = {...?profile?.styles};
    return HomeData(
      profile: profile,
      measurements: measurements,
      fit: FitPreferenceCode.fromCode(profile?.fit),
      picks: Picks.forUser(Catalog.products, styles),
      hasStyles: styles.isNotEmpty,
    );
  }
}
