import 'package:flutter_test/flutter_test.dart';
import 'package:naap/data/brands.dart';

void main() {
  test('search filters as you type and ignores case (US-015)', () {
    final found = Brands.search(Brands.all, 'ZA');
    expect(found.length, 1);
    expect(found.first.name, 'Zara');
  });

  test('empty search shows every brand', () {
    expect(Brands.search(Brands.all, '  ').length, Brands.all.length);
  });

  test('your brands come first, both groups keep their order', () {
    final split = Brands.splitForUser(Brands.all, {'zara', 'levis'});
    expect(split.mine.map((b) => b.id).toList(), ['levis', 'zara']);
    expect(split.others.length, Brands.all.length - 2);
  });
}
