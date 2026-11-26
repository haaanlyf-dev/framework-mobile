// MODEL keranjang belanja (materi 9: State management dengan Provider)
// Keranjang = APP STATE: dibaca di Beranda (badge), Detail (tombol tambah),
// dan halaman Keranjang. Karena itu disimpan di ChangeNotifier, bukan setState.

import 'package:flutter/foundation.dart';

import 'product.dart';

class KeranjangModel extends ChangeNotifier {
  // Data privat: hanya boleh diubah lewat method di bawah
  final Map<Product, int> _isi = {}; // produk -> jumlah bungkus

  Map<Product, int> get isi => Map.unmodifiable(_isi);

  int get jumlahItem => _isi.values.fold(0, (a, b) => a + b);

  int get totalHarga =>
      _isi.entries.fold(0, (total, e) => total + e.key.price * e.value);

  void tambah(Product p) {
    _isi[p] = (_isi[p] ?? 0) + 1;
    notifyListeners(); // beri tahu semua widget pendengar
  }

  void kurangi(Product p) {
    final jumlah = _isi[p];
    if (jumlah == null) return;
    if (jumlah <= 1) {
      _isi.remove(p);
    } else {
      _isi[p] = jumlah - 1;
    }
    notifyListeners();
  }

  void reset() {
    _isi.clear();
    notifyListeners();
  }
}
