import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('kirim ulasan: validasi, kembali ke Detail, ulasan tampil',
      (tester) async {
    final product = Product('Uji', 'Deskripsi', 1000, 'kopi_gayo.jpg');
    // MaterialApp polos (tanpa GoogleFonts) supaya test tidak butuh internet
    await tester.pumpWidget(MaterialApp(home: DetailPage(product: product)));

    await tester.ensureVisible(find.text('Tulis Ulasan'));
    await tester.tap(find.text('Tulis Ulasan'));
    await tester.pumpAndSettle();

    // Kirim kosong -> ditolak, tetap di form
    await tester.tap(find.text('Kirim'));
    await tester.pump();
    expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
    expect(find.text('Ulasan minimal 5 karakter'), findsOneWidget);

    // Isi benar -> form tertutup, ulasan muncul di Detail
    await tester.enterText(find.byType(TextFormField).at(0), 'Dayat');
    await tester.enterText(find.byType(TextFormField).at(1), 'Barangnya bagus sekali');
    await tester.tap(find.text('Kirim'));
    await tester.pumpAndSettle();

    expect(find.byType(FormUlasanPage), findsNothing);
    expect(find.text('Barangnya bagus sekali'), findsOneWidget);
    expect(find.text('Ulasan (1)'), findsOneWidget);
    expect(product.ulasan.length, 1);

    // Reset: Batal -> ulasan tetap ada
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(product.ulasan.length, 1);

    // Reset: Hapus -> ulasan kosong, tombol Reset hilang
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(product.ulasan, isEmpty);
    expect(find.text('Ulasan (0)'), findsOneWidget);
    expect(find.text('Reset'), findsNothing);
  });
}
