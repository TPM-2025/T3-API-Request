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
      body: Padding(padding: EdgeInsets.all(20), child: _userDetail()),
    );
  }

  Widget _userDetail() {
    return FutureBuilder(
      future: ClothingService.getUserById(id),
      builder: (context, snapshot) {
        // Jika error (gagal memanggil API), maka tampilkan teks error
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        // Jika berhasil memanggil API
        else if (snapshot.hasData) {
          /*
            Baris 1:
            Untuk mengambil response dari API, kita bisa mengakses "snapshot.data"
            Nah, snapshot.data tadi itu bentuknya masih berupa Map<String, dynamic>.

            Untuk memudahkan pengolahan data, 
            kita perlu mengonversi data JSON tersebut ke dalam model Dart (Clothing).
            Setelah itu, hasil konversinya disimpan ke dalam variabel bernama "user".
            
            Kenapa yg kita simpan "snapshot.data["data"]" bukan "snapshot.data" aja?
            Karena kalau kita lihat di dokumentasi API, bentuk response-nya itu kaya gini:
            {
              "status": ...
              "message": ...
              "data": {
                "id": 1,
                "name": "tes",
                "price": 25000,
                ...
              },
            }

            Nah, kita itu cuman mau ngambil properti "data" doang, 
            kita gamau ngambil properti "status" dan "message",
            makanya yg kita simpan ke variabel clothing itu response.data["data"]


            Baris 2:
            Setelah dikonversi, tampilkan data tadi di widget bernama "_clothingWidget()"
            dengan mengirimkan data tadi sebagai parameternya.
          */
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
        Text("Brand: ${clothing.brand!}"),
      ],
    );
  }
}
