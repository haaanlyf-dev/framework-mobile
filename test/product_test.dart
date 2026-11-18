import 'dart:io';

import 'package:flutter_application_1/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('harga diformat sebagai rupiah', () {
    expect(Product('A', 'B', 85000, 'x.jpg').hargaRupiah, 'Rp 85.000');
    expect(Product('A', 'B', 1200000, 'x.jpg').hargaRupiah, 'Rp 1.200.000');
    expect(Product('A', 'B', 90, 'x.jpg').hargaRupiah, 'Rp 90');
  });

  test('9 beans kopi, tiap gambar unik dan file-nya ada di assets/kopi', () {
    final products = Product.getProducts();
    expect(products.length, 9);
    expect(products.map((p) => p.image).toSet().length, 9);
    for (final p in products) {
      expect(File('assets/kopi/${p.image}').existsSync(), isTrue,
          reason: p.image);
    }
  });
}
