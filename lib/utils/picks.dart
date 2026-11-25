import '../models/product.dart';

/// US-020: chooses the "Picked for you" row.
///
/// Each product gets a score: how many of its style tags the user picked
/// (Set lookups, O(1) each). Products are sorted by score, then popularity.
/// Sorting n products is O(n log n); n is small (the catalogue page).
///
/// With no styles chosen everything scores 0, so the row becomes the most
/// popular items (US-014: "Home shows popular items").
class Picks {
  Picks._();

  static const int minimum = 6;

  static List<Product> forUser(List<Product> products, Set<String> styles,
      {int limit = 10}) {
    int score(Product p) {
      var s = 0;
      for (final tag in p.styles) {
        if (styles.contains(tag)) s++;
      }
      return s;
    }

    final scored = [for (final p in products) (product: p, score: score(p))];
    scored.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      return byScore != 0
          ? byScore
          : b.product.popularity.compareTo(a.product.popularity);
    });
    // Matching items come first; others fill the row up to at least [minimum].
    final count = limit < minimum ? minimum : limit;
    return [for (final e in scored.take(count)) e.product];
  }
}
