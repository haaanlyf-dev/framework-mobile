// Model data Katalog Beans Kopi (materi 2: sintaks Dart, class, List)

class Ulasan {
  final String nama;
  final String isi;

  const Ulasan(this.nama, this.isi);
}

class Product {
  final String name;
  final String description;
  final int price; // harga per 250 gram
  final String image; // nama file di assets/kopi/
  int rating = 0; // diubah oleh RatingBox
  final List<Ulasan> ulasan = []; // ditambah dari Form Ulasan

  Product(this.name, this.description, this.price, this.image);

  // 85000 -> "Rp 85.000"
  String get hargaRupiah => 'Rp ${price.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      )}';

  static List<Product> getProducts() {
    return [
      Product('Arabika Gayo',
          'Aceh. Medium roast, rasa cokelat dan rempah dengan asam lembut.',
          95000, 'kopi_gayo.jpg'),
      Product('Arabika Toraja',
          'Sulawesi Selatan. Body tebal, rasa karamel dan sedikit herbal.',
          110000, 'kopi_toraja.jpg'),
      Product('Arabika Kintamani',
          'Bali. Light roast, segar dengan aroma jeruk.',
          105000, 'kopi_kintamani.jpg'),
      Product('Mandheling',
          'Sumatera Utara. Dark roast, earthy dan pahit manis.',
          100000, 'kopi_mandheling.jpg'),
      Product('Robusta Lampung',
          'Lampung. Dark roast, pahit kuat, cocok untuk kopi susu.',
          65000, 'kopi_robusta.jpg'),
      Product('Liberika Jambi',
          'Jambi. Biji besar, aroma nangka dan kayu.',
          85000, 'kopi_liberika.jpg'),
      Product('Espresso Blend',
          'Campuran arabika dan robusta, crema tebal untuk espresso.',
          90000, 'kopi_espresso.jpg'),
      Product('Green Bean Java Preanger',
          'Jawa Barat. Biji mentah untuk disangrai sendiri.',
          75000, 'kopi_green_preanger.jpg'),
      Product('Green Bean Flores Bajawa',
          'NTT. Biji mentah, setelah disangrai rasa manis dan kacang.',
          80000, 'kopi_flores.jpg'),
    ];
  }
}

// Dibuat sekali, supaya rating & ulasan tetap ada saat pindah halaman
final List<Product> daftarProduk = Product.getProducts();
