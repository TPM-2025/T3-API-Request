import 'package:asisten_tpm_8/models/clothing_model.dart';
import 'package:asisten_tpm_8/services/clothing_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clothing Detail")),
      body: Padding(padding: EdgeInsets.all(20), child: _clothingDetail()),
    );
  }

  Widget _clothingDetail() {
    return FutureBuilder(
      future: ClothingService.getClothingById(id),
      builder: (context, snapshot) {
        // Jika error (gagal memanggil API), maka tampilkan teks error
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        // Jika berhasil memanggil API
        else if (snapshot.hasData) {
          Clothing clothing = Clothing.fromJson(snapshot.data!["data"]);
          return _clothingWidget(clothing);
        }
        // Jika masih loading, tampilkan loading screen di tengah layar
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothingWidget(Clothing clothing) {
    // Nampilin datanya dalam bentuk layout kolom (ke bawah)
    return Column(
      // Biar rata kiri
      crossAxisAlignment: CrossAxisAlignment.start,
      // Tampilkan nama, email, gender dalam bentuk teks
      children: [
        Text("Nama: ${clothing.name!}"),
        Text("Kategori: ${clothing.category!}"),
        Text("Harga: Rp${clothing.price!}"),
        Text("Brand: ${clothing.brand!}"),
        Text("Stok: ${clothing.stock!}"),
        Text("Rating: ${clothing.rating!} / 5.0"),
        Text("Terjual: ${clothing.sold!}"),
        Text("Bahan: ${clothing.material!}"),
        Text("Tahun Rilis: ${clothing.yearReleased!}"),
        SizedBox(height: 12),
        Text(
          "ABAIKAN TAMPILAN \nJANGAN DITIRU! \nHANYA UNTUK CONTOH",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
