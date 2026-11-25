import 'package:flutter_test/flutter_test.dart';
import 'package:naap/data/catalog.dart';
import 'package:naap/utils/picks.dart';

void main() {
  test('at least 6 items, matching styles first (US-020)', () {
    final picks = Picks.forUser(Catalog.products, {'ethnic'});
    expect(picks.length >= Picks.minimum, isTrue);
    expect(picks.first.styles.contains('ethnic'), isTrue);
    // Every ethnic item comes before any item without the tag.
    final firstOther = picks.indexWhere((p) => !p.styles.contains('ethnic'));
    final lastEthnic = picks.lastIndexWhere((p) => p.styles.contains('ethnic'));
    expect(firstOther == -1 || lastEthnic < firstOther, isTrue);
  });

  test('no styles gives the most popular items (US-014)', () {
    final picks = Picks.forUser(Catalog.products, {});
    for (var i = 1; i < picks.length; i++) {
      expect(picks[i - 1].popularity >= picks[i].popularity, isTrue);
    }
  });

  test('items matching two styles rank above items matching one', () {
    final picks = Picks.forUser(Catalog.products, {'casual', 'minimal'});
    expect(
        picks.first.styles.contains('casual') &&
            picks.first.styles.contains('minimal'),
        isTrue);
  });
}
