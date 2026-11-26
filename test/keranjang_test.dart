import 'package:flutter/material.dart';
import 'package:flutter_application_1/keranjang_model.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  // Keunggulan Provider: logika bisa diuji tanpa membangun widget
  test('model keranjang: tambah, kurangi, total, reset, notifikasi', () {
    final a = Product('A', '', 10000, 'a.jpg');
    final b = Product('B', '', 25000, 'b.jpg');
    final k = KeranjangModel();
    var notif = 0;
    k.addListener(() => notif++);

    k.tambah(a);
    k.tambah(a);
    k.tambah(b);
    expect(k.jumlahItem, 3);
    expect(k.totalHarga, 45000);

    k.kurangi(a);
    k.kurangi(b); // jumlah 1 -> produk hilang dari keranjang
    expect(k.isi, {a: 1});
    k.kurangi(b); // tidak ada di keranjang -> diabaikan, tanpa notifikasi

    k.reset();
    expect(k.jumlahItem, 0);
    expect(notif, 6);
  });

  testWidgets('tambah dari Detail -> badge & halaman Keranjang ikut berubah',
      (tester) async {
    final product = Product('Uji', 'Deskripsi', 50000, 'kopi_gayo.jpg');
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => KeranjangModel(),
      child: MaterialApp(home: DetailPage(product: product)),
    ));

    await tester.ensureVisible(find.text('Tambah ke Keranjang'));
    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget); // badge di AppBar

    await tester.tap(find.byTooltip('Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Total: Rp 100.000'), findsOneWidget);

    await tester.tap(find.byTooltip('Kurangi'));
    await tester.pump();
    expect(find.text('Total: Rp 50.000'), findsOneWidget);

    await tester.tap(find.text('Kosongkan'));
    await tester.pump();
    expect(find.text('Keranjang masih kosong.'), findsOneWidget);
  });
}
