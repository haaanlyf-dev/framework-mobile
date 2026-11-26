# Katalog Beans Kopi — PRD Sederhana

Aplikasi katalog beans kopi Nusantara berbasis Flutter. Pengguna melihat daftar beans kopi, membuka detail, memberi rating, dan menulis ulasan. Proyek latihan mata kuliah **Framework Mobile**; setiap fitur dipilih agar memakai materi pertemuan 1–7 (folder `referensi/`).

## 1. Tujuan

- Satu aplikasi kecil yang utuh, bukan tujuh demo terpisah.
- Katalog 9 beans kopi (arabika, robusta, liberika, green bean) dengan gambar aset lokal.
- Diuji di Chrome: `flutter run -d chrome`.

## 2. Fitur

| No | Fitur | Keterangan |
|----|-------|------------|
| F1 | Daftar beans kopi | Grid responsif (1–3 kolom): gambar, nama, deskripsi, harga per 250 g |
| F2 | Detail | Gambar besar, asal dan profil rasa, harga, daftar ulasan |
| F3 | Rating bintang | Ketuk 1–3 bintang |
| F4 | Form ulasan | Nama + isi ulasan dengan validasi; ulasan tampil di Detail |
| F5 | Keranjang belanja | Badge jumlah item, tambah/kurangi, total harga, kosongkan (Provider). Dokumentasi: [`doc-pertemuan7/`](doc-pertemuan7/README.md) |

**Di luar lingkup:** login, checkout/pembayaran, database/API, dark mode.

## 3. Alur Layar

```
┌──────────────┐  ketuk kartu   ┌──────────────┐  Tulis Ulasan  ┌─────────────┐
│ Beranda      │ ─────────────> │ Detail Kopi  │ ─────────────> │ Form Ulasan │
│ (grid kopi,  │ <───────────── │ (rating +    │ <───────────── │ (validasi)  │
│  ikon ☕)    │    kembali     │  ulasan)     │  pop + ulasan  └─────────────┘
└──────────────┘                └──────────────┘
```

- Beranda → Detail: data `Product` dikirim lewat konstruktor.
- Form → Detail: ulasan dikembalikan dengan `Navigator.pop(context, ulasan)`, lalu ditambahkan dengan `setState`.
- Gambar memakai animasi `Hero` dari Beranda ke Detail.

## 4. Gaya Visual

Semua gaya diatur sekali di `ThemeData`, lalu dipakai lewat `Theme.of(context)`.

| Elemen | Pilihan |
|--------|---------|
| Navbar | Ikon `Icons.coffee` + judul "Katalog Beans Kopi" |
| Warna utama | Cokelat kopi `#6F4E37` (AppBar, tombol, harga) |
| Latar | Krem `#F8F1E7` |
| Teks judul | Cokelat tua `#3E2723` |
| Font judul | Poppins 18, tebal (`textTheme.titleMedium`) |
| Font paragraf | Lato 14 (`textTheme.bodyMedium`) |
| Container detail | `BoxDecoration`: gradien putih–latte, sudut membulat, garis tepi, bayangan |
| Override | Harga = `titleMedium.copyWith(color: kCoffee, fontSize: 20)` |
| Gambar | 9 foto di `assets/kopi/` (lihat Kredit Gambar) |

## 5. Pemetaan ke Materi

| Pertemuan | Materi | Dipakai di |
|-----------|--------|------------|
| 1 | Pengenalan Flutter, animasi Hero | Hero pada gambar Beranda → Detail |
| 2 | Sintaks Dart: class, fungsi, List | `class Product`, `class Ulasan`, `getProducts()` |
| 3 | Stateless vs Stateful | `RatingBox` dan `DetailPage` sebagai `StatefulWidget` |
| 4 | Layout: Card, Row, Column, Expanded, GridView | Grid kartu kopi dan susunan halaman detail |
| 5 | Form: `TextFormField`, `GlobalKey<FormState>`, validator, `GestureDetector` | Form ulasan + `SnackBar`; ketuk kartu dan bintang |
| 6 | Navigasi: `Navigator.push` / `pop`, kirim & kembalikan data | Kirim `Product` ke Detail, kembalikan `Ulasan` dari Form |
| 7 | Assets, Fonts, Styling, `ThemeData`, override | 9 gambar aset, ikon, Poppins + Lato, `BoxDecoration`, override harga |
| 9 | State management: `ChangeNotifier`, `ChangeNotifierProvider`, `Consumer`, `watch`/`read` | Keranjang belanja ([`doc-pertemuan7/`](doc-pertemuan7/README.md)) |

Named routes dan `go_router` tidak dipakai: materi 6 menandai named routes tidak direkomendasikan, dan 3 halaman cukup dengan `MaterialPageRoute`.

## 6. Struktur Proyek

```
lib/
  main.dart             // Provider + tema, Beranda, Detail, Form, RatingBox, Keranjang
  keranjang_model.dart  // KeranjangModel (ChangeNotifier)
  product.dart   // class Product, class Ulasan, data 9 beans kopi
assets/kopi/     // 9 foto beans kopi (terdaftar di pubspec.yaml)
test/
  product_test.dart       // format harga, 9 produk, file gambar ada
  ulasan_flow_test.dart   // validasi form & ulasan tampil di Detail
  keranjang_test.dart     // model keranjang & alur badge/total
doc-pertemuan7/   // dokumentasi + screenshot fitur keranjang
```

| Paket | Versi | Alasan |
|-------|-------|--------|
| `google_fonts` | ^8.0.0 | Poppins dan Lato (versi 9 bentrok dengan `flutter/material.dart`) |
| `provider` | ^6.1.5+1 | State management keranjang (app state) |


## Menjalankan

```
flutter pub get
flutter run -d chrome
flutter test
```

