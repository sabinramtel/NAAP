/// US-015: brands with how their sizes run compared with our base chart.
/// A positive [offsetCm] means the brand runs small, so you need one size up.
/// Sample data until the shop backend exists.
class Brand {
  final String id;
  final String name;
  final double offsetCm;

  /// Lower-case name, worked out once so search doesn't redo it per keystroke.
  final String searchKey;

  Brand(this.id, this.name, this.offsetCm) : searchKey = name.toLowerCase();
}

class Brands {
  Brands._();

  static final List<Brand> all = [
    Brand('levis', "Levi's", 0),
    Brand('zara', 'Zara', 2),
    Brand('hm', 'H&M', 0),
    Brand('uniqlo', 'Uniqlo', 1),
    Brand('nike', 'Nike', 0),
    Brand('adidas', 'Adidas', 0),
    Brand('puma', 'Puma', 1),
    Brand('mango', 'Mango', 2),
    Brand('gap', 'Gap', -2),
    Brand('marks', 'Marks & Spencer', -1),
    Brand('forever21', 'Forever 21', 2),
    Brand('allensolly', 'Allen Solly', 0),
    Brand('vanheusen', 'Van Heusen', 0),
    Brand('peterengland', 'Peter England', -1),
    Brand('fabindia', 'Fabindia', -1),
    Brand('biba', 'Biba', 0),
    Brand('decathlon', 'Decathlon', 0),
    Brand('pepe', 'Pepe Jeans', 1),
    Brand('jackjones', 'Jack & Jones', 1),
    Brand('only', 'Only', 2),
    Brand('veromoda', 'Vero Moda', 2),
    Brand('tommy', 'Tommy Hilfiger', -1),
  ];

  static final Map<String, Brand> _byId = {for (final b in all) b.id: b};

  /// O(1) lookup by id.
  static Brand? byId(String id) => _byId[id];

  /// AC: the list filters as you type. One pass over the brands: O(n).
  static List<Brand> search(List<Brand> brands, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return brands;
    return [
      for (final b in brands)
        if (b.searchKey.contains(q)) b
    ];
  }

  /// AC: in the size guide, the user's brands come first. A stable split in
  /// one pass (O(n)), so both groups keep their original order.
  static ({List<Brand> mine, List<Brand> others}) splitForUser(
      List<Brand> brands, Set<String> selected) {
    final mine = <Brand>[], others = <Brand>[];
    for (final b in brands) {
      (selected.contains(b.id) ? mine : others).add(b);
    }
    return (mine: mine, others: others);
  }
}
