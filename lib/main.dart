import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product.dart';

// Palet warna kopi (materi 7)
const kCoffee = Color(0xFF6F4E37);
const kCream = Color(0xFFF8F1E7);
const kBrown = Color(0xFF3E2723);

void main() => runApp(const KatalogKuApp());

// =====================================================================
// APLIKASI + TEMA GLOBAL (materi 7: semua gaya ditulis sekali di sini)
// =====================================================================
class KatalogKuApp extends StatelessWidget {
  const KatalogKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Beans Kopi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kCoffee),
        scaffoldBackgroundColor: kCream,
        appBarTheme: AppBarTheme(
          backgroundColor: kCoffee,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shadowColor: kCoffee.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kCoffee,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        // Font dasar Lato, judul Poppins
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kBrown,
          ),
          bodyMedium: GoogleFonts.lato(
            fontSize: 14,
            height: 1.5,
            color: kBrown.withValues(alpha: 0.8),
          ),
        ),
      ),
      home: const BerandaPage(),
    );
  }
}

// =====================================================================
// HALAMAN 1: BERANDA — daftar produk (materi 4: ListView, Card, Row)
// =====================================================================
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ikon + judul di navbar (Row agar ikon di samping teks)
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.coffee),
            SizedBox(width: 8),
            Text('Katalog Beans Kopi'),
          ],
        ),
      ),
      // Grid responsif: tiap kolom maks. 420 px, jadi otomatis
      // 1 kolom di HP, 2 di tablet, 3 di layar laptop/Chrome
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 420,
          mainAxisExtent: 130, // tinggi kartu tetap
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: daftarProduk.length,
        itemBuilder: (context, index) {
          final product = daftarProduk[index];
          // Event handling: ketuk kartu -> buka detail (materi 5 & 6)
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                // Kirim data lewat konstruktor
                builder: (context) => DetailPage(product: product),
              ),
            ),
            child: ProductBox(product: product),
          );
        },
      ),
    );
  }
}

class ProductBox extends StatelessWidget {
  const ProductBox({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 130,
      child: Card(
        clipBehavior: Clip.antiAlias, // gambar ikut sudut membulat
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero: gambar "terbang" ke halaman detail (materi 1)
            Hero(
              tag: product.name,
              child: Image.asset(
                'assets/kopi/${product.image}',
                width: 110,
                fit: BoxFit.cover,
                // Cadangan kecil jika gambar gagal dimuat, agar kartu tidak rusak
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 110,
                  child: Icon(Icons.coffee, size: 40, color: kCoffee),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product.name,
                      style: textTheme.titleMedium,
                      maxLines: 1, // nama panjang dipotong "..."
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.description,
                      style: textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.hargaRupiah,
                      style: textTheme.titleMedium?.copyWith(
                        color: kCoffee,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: kCoffee),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// HALAMAN 2: DETAIL PRODUK — rating + daftar ulasan (materi 3: Stateful)
// =====================================================================
class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.product});
  final Product product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Buka form, tunggu ulasan yang dikembalikan lewat Navigator.pop (materi 6)
  Future<void> _tulisUlasan() async {
    final ulasan = await Navigator.push<Ulasan>(
      context,
      MaterialPageRoute(
        builder: (context) => FormUlasanPage(namaProduk: widget.product.name),
      ),
    );
    if (ulasan == null || !mounted) return; // batal / halaman sudah ditutup

    setState(() => widget.product.ulasan.add(ulasan));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terima kasih, ${ulasan.nama}! Ulasan ditambahkan.')),
    );
  }

  // Hapus semua ulasan setelah dikonfirmasi lewat AlertDialog (materi 1)
  Future<void> _resetUlasan() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset ulasan?'),
        content: Text(
          'Semua ${widget.product.ulasan.length} ulasan untuk '
          '${widget.product.name} akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true || !mounted) return; // batal / dialog ditutup

    setState(() => widget.product.ulasan.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua ulasan dihapus.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.name, // tag sama dengan di Beranda
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/kopi/${product.image}',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 240,
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 80),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Container berdekorasi (materi 7: BoxDecoration)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFEFE0CF)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kCoffee.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: kCoffee.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description, style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  // OVERRIDE: dasar titleMedium dari tema, warna & ukuran diganti
                  Text(
                    product.hargaRupiah,
                    style: textTheme.titleMedium?.copyWith(
                      color: kCoffee,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Beri rating:', style: textTheme.bodyMedium),
                      RatingBox(product: product),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Text('Ulasan (${product.ulasan.length})',
                      style: textTheme.titleMedium),
                ),
                // Tombol reset hanya muncul jika sudah ada ulasan
                if (product.ulasan.isNotEmpty)
                  TextButton.icon(
                    onPressed: _resetUlasan,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Reset'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (product.ulasan.isEmpty)
              Text(
                'Belum ada ulasan. Jadilah yang pertama!',
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              for (final u in product.ulasan)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kCoffee,
                      foregroundColor: Colors.white,
                      child: Text(u.nama[0].toUpperCase()),
                    ),
                    title: Text(u.nama),
                    subtitle: Text(u.isi),
                  ),
                ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _tulisUlasan,
                icon: const Icon(Icons.rate_review),
                label: const Text('Tulis Ulasan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// RATING BINTANG — event handling + setState (materi 3 & 5)
// =====================================================================
class RatingBox extends StatefulWidget {
  const RatingBox({super.key, required this.product});
  final Product product;

  @override
  State<RatingBox> createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 3; i++)
          IconButton(
            icon: Icon(
              widget.product.rating >= i ? Icons.star : Icons.star_border,
            ),
            color: Colors.amber.shade700,
            tooltip: 'Rating $i',
            onPressed: () => setState(() => widget.product.rating = i),
          ),
      ],
    );
  }
}

// =====================================================================
// HALAMAN 3: FORM ULASAN — input + validasi (materi 5)
// =====================================================================
class FormUlasanPage extends StatefulWidget {
  const FormUlasanPage({super.key, required this.namaProduk});
  final String namaProduk;

  @override
  State<FormUlasanPage> createState() => _FormUlasanPageState();
}

class _FormUlasanPageState extends State<FormUlasanPage> {
  final _formKey = GlobalKey<FormState>(); // dibuat sekali, bukan di build()
  final _namaController = TextEditingController();
  final _isiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose(); // cegah memory leak
    _isiController.dispose();
    super.dispose();
  }

  void _kirim() {
    if (!_formKey.currentState!.validate()) return;
    // Kembalikan ulasan ke halaman Detail
    Navigator.pop(
      context,
      Ulasan(_namaController.text.trim(), _isiController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ulasan ${widget.namaProduk}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bagikan pendapatmu',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _isiController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Ulasan',
                  hintText: 'Minimal 5 karakter',
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    (value == null || value.trim().length < 5)
                        ? 'Ulasan minimal 5 karakter'
                        : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _kirim,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
