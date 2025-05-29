import 'package:asisten_tpm_8/models/clothing_model.dart';
import 'package:asisten_tpm_8/pages/home_page.dart';
import 'package:asisten_tpm_8/services/clothing_service.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final int id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // Controller dipake buat mengelola input teks dari TextField.
  final name = TextEditingController();
  final price = TextEditingController();
  final category = TextEditingController();
  final brand = TextEditingController();
  final sold = TextEditingController();
  final rating = TextEditingController();
  final stock = TextEditingController();
  final material = TextEditingController();
  final yearList = [2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025];
  late int yearReleased;

  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Clothing"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothingWidget(),
      ),
    );
  }

  Widget _clothingWidget() {
    return FutureBuilder(
      future: ClothingService.getClothingById(widget.id),
      builder: (context, snapshot) {
        // Jika error (gagal memanggil API), maka tampilkan teks error
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        // Jika berhasil memanggil API (ada datanya)
        else if (snapshot.hasData) {
          /*
            Jika data belum pernah di-load sama sekali (baru pertama kali),
            maka program akan masuk ke dalam percabangan ini.

            Mengapa perlu dicek? Karena setiap kali layar mengupdate state menggunakan setState(),
            Widget ini akan terus dijalankan berulang-ulang.
            Untuk mencegah pengambilan data berulang-ulang, kita perlu mengecek
            apakah data sudah pernah diambil atau belum.
          */
          if (!_isDataLoaded) {
            // Jika data baru pertama kali di-load, ubah menjadi true
            _isDataLoaded = true;

            /*
              Baris 1:
              Untuk mengambil response dari API, kita bisa mengakses "snapshot.data"
              Nah, snapshot.data tadi itu bentuknya masih berupa Map<String, dynamic>.

              Untuk memudahkan pengolahan data, 
              kita perlu mengonversi data JSON tersebut ke dalam model Dart (Clothing),
              makanya kita pake method Clothing.fromJSON() buat mengonversinya.
              Setelah itu, hasil konversinya disimpan ke dalam variabel bernama "clothing".
              
              Kenapa yg kita simpan "snapshot.data["data"]" bukan "snapshot.data" aja?
              Karena kalau kita lihat di dokumentasi API, bentuk response-nya itu kaya gini:
              {
                "status": ...
                "message": ...
                "data": {
                  "id": 1,
                  "name": "tes",
                  "price": 22000,
                  ...
                },
              }

              Nah, kita itu cuman mau ngambil properti "data" doang, 
              kita gamau ngambil properti "status" dan "message",
              makanya yg kita simpan ke variabel itu response.data["data"]

              Baris 2-4
              Setelah mendapatkan data pakaian yg dipilih,
              masukkan data tadi sebagai nilai default pada tiap-tiap input
            */
            Clothing clothing = Clothing.fromJson(snapshot.data!["data"]);
            name.text = clothing.name!;
            price.text = clothing.price!.toString();
            category.text = clothing.category!;
            brand.text = clothing.brand!;
            material.text = clothing.material!;
            sold.text = clothing.sold!.toString();
            stock.text = clothing.stock!.toString();
            rating.text = clothing.rating!.toString();
            yearReleased = clothing.yearReleased!;
          }

          return _clothingEditForm(context);
        }
        // Jika masih loading, tampilkan loading screen di tengah layar
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothingEditForm(BuildContext context) {
    return ListView(
      children: [
        _textField(name, "Name"),
        _textField(price, "Price"),
        _textField(category, "Category"),
        _textField(brand, "Brand"),
        _textField(material, "Material"),
        _textField(sold, "Sold"),
        _textField(stock, "Stock"),
        _textField(rating, "Rating"),
        const SizedBox(height: 12),
        const Text("Year Released"),
        DropdownButton(
          value: yearReleased,
          onChanged: (int? value) {
            setState(() {
              yearReleased = value!;
            });
          },
          items:
              yearList.map((int value) {
                return DropdownMenuItem(value: value, child: Text("$value"));
              }).toList(),
        ),
        const SizedBox(height: 16),
        // Tombol buat submit data baru
        ElevatedButton(
          onPressed: () {
            // Jalankan fungsi _createClothing() ketika tombol diklik
            _updateClothing(context);
          },
          child: const Text("Update Clothing"),
        ),
      ],
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, // <- Ngasi label
      ),
    );
  }

  // Fungsi untuk mengupdate data ketika tombol "Update Clothing" diklik
  Future<void> _updateClothing(BuildContext context) async {
    try {
      // Ngubah jadi tipe data angka
      int? priceInt = int.tryParse(price.text.trim());
      int? soldInt = int.tryParse(sold.text.trim());
      int? stockInt = int.tryParse(stock.text.trim());
      double? ratingDouble = double.tryParse(rating.text.trim());

      // Ngecek tipe datanya angka atau bukan
      if (priceInt == null ||
          soldInt == null ||
          stockInt == null ||
          ratingDouble == null) {
        throw Exception("Input tidak valid.");
      }

      /*
        Karena kita mau mengedit data, maka kita juga perlu datanya.
        Disini kita mengambil data-data yang dah diisi pada form,
        Terus datanya itu disimpan ke dalam variabel "updatedClothing" dengan tipe data "Clothing".
      */
      Clothing updatedClothing = Clothing(
        id: widget.id,
        name: name.text.trim(),
        price: priceInt,
        category: category.text.trim(),
        brand: brand.text.trim(),
        material: material.text.trim(),
        sold: soldInt,
        stock: stockInt,
        rating: ratingDouble,
        yearReleased: yearReleased,
      );

      /*
        Lakukan pemanggilan API update, setelah itu
        simpan ke dalam variabel bernama "response"
      */
      final response = await ClothingService.updateClothing(updatedClothing);

      /*
        Jika response status "Success", 
        maka tampilkan snackbar yg bertuliskan "Clothing [nama] updated"
      */
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Clothing ${updatedClothing.name} updated")),
        );

        // Pindah ke halaman sebelumnya
        Navigator.pop(context);

        // Untuk merefresh tampilan (menampilkan data yg telah diedit ke dalam daftar)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        // Jika response status "Error", maka kode akan dilempar ke bagian catch
        throw Exception(response["message"]);
      }
    } catch (error) {
      // Jika gagal, maka tampilkan snackbar dengan tulisan "Gagal: error-nya apa"
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
    }
  }
}
