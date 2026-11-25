import '../utils/size_recommender.dart';

/// A product shown on Home and its product page (US-020).
class Product {
  final String id;
  final String name;
  final String brandId;
  final Garment garment;
  final List<String> styles;
  final int priceNpr;
  final int popularity; // higher means more people opened it
  final int colorValue; // placeholder colour until real photos exist
  final String? imageUrl; // null until the shop backend has photos

  const Product({
    required this.id,
    required this.name,
    required this.brandId,
    required this.garment,
    required this.styles,
    required this.priceNpr,
    required this.popularity,
    required this.colorValue,
    this.imageUrl,
  });
}
