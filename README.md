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

**Di luar lingkup:** login, keranjang, pembayaran, database/API, dark mode.

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

Named routes dan `go_router` tidak dipakai: materi 6 menandai named routes tidak direkomendasikan, dan 3 halaman cukup dengan `MaterialPageRoute`.

## 6. Struktur Proyek

```
lib/
  main.dart      // MaterialApp + tema, Beranda, Detail, Form, RatingBox
  product.dart   // class Product, class Ulasan, data 9 beans kopi
assets/kopi/     // 9 foto beans kopi (terdaftar di pubspec.yaml)
test/
  product_test.dart       // format harga, 9 produk, file gambar ada
  ulasan_flow_test.dart   // validasi form & ulasan tampil di Detail
```

| Paket | Versi | Alasan |
|-------|-------|--------|
| `google_fonts` | ^8.0.0 | Poppins dan Lato (versi 9 bentrok dengan `flutter/material.dart`) |


## Menjalankan

```
flutter pub get
flutter run -d chrome
flutter test
```

## Kredit Gambar

Semua foto dari [Wikimedia Commons](https://commons.wikimedia.org), diperkecil ke lebar 960 px. Nama produk hanya label katalog; foto tidak berasal dari daerah tersebut.

| File | Sumber | Pembuat | Lisensi |
|------|--------|---------|---------|
| `kopi_gayo.jpg` | [Roasted arabica coffee beans Minca](https://commons.wikimedia.org/wiki/File:Roasted_arabica_coffee_beans_Minca.jpg) | Roger Burger | CC0 |
| `kopi_toraja.jpg` | [Roasted coffee beans (Unsplash)](https://commons.wikimedia.org/wiki/File:Roasted_coffee_beans_(Unsplash).jpg) | Daniel Ruswick | CC0 |
| `kopi_kintamani.jpg` | [Roasted Coffee Beans in Hermetic Jar](https://commons.wikimedia.org/wiki/File:Roasted_Coffee_Beans_in_Hermetic_Jar.jpg) | Pierre Camateros | CC BY-SA 3.0 |
| `kopi_mandheling.jpg` | [Roasted coffee beans](https://commons.wikimedia.org/wiki/File:Roasted_coffee_beans.jpg) | MarkSweep | Public domain |
| `kopi_robusta.jpg` | [Dark roasted coffee beans](https://commons.wikimedia.org/wiki/File:Dark_roasted_coffee_beans.jpg) | Jon Sullivan | Public domain |
| `kopi_liberika.jpg` | [Liberica coffee beans, roasted](https://commons.wikimedia.org/wiki/File:Liberica_coffee_beans,_roasted.jpg) | HaztechGuy | CC BY 3.0 |
| `kopi_espresso.jpg` | [Dark roasted espresso blend coffee beans 1](https://commons.wikimedia.org/wiki/File:Dark_roasted_espresso_blend_coffee_beans_1.jpg) | Sage Ross | CC BY-SA 3.0 |
| `kopi_green_preanger.jpg` | [Green Bean Coffee](https://commons.wikimedia.org/wiki/File:Green_Bean_Coffee.jpg) | DeaPeaJay | CC BY-SA 2.0 |
| `kopi_flores.jpg` | [Pre-roasted Coffee Beans](https://commons.wikimedia.org/wiki/File:Pre-roasted_Coffee_Beans_(11516809276).jpg) | Paul Galow | CC BY 2.0 |
