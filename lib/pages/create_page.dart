import 'package:asisten_tpm_8/models/clothing_model.dart';
import 'package:asisten_tpm_8/pages/home_page.dart';
import 'package:asisten_tpm_8/services/clothing_service.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
  int yearReleased = 2018;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Clothing")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
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
                    return DropdownMenuItem(
                      value: value,
                      child: Text("$value"),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            // Tombol buat submit data baru
            ElevatedButton(
              onPressed: () {
                // Jalankan fungsi _createClothing() ketika tombol diklik
                _createClothing(context);
              },
              child: const Text("Add Clothing"),
            ),
          ],
        ),
      ),
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

  // Fungsi untuk menambah data pakaian ketika tombol "Add Clothin" diklik
  Future<void> _createClothing(BuildContext context) async {
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
        Karena kita mau menambahkan data baru, maka kita juga perlu datanya.
        Disini kita mengambil data-data yang dah diisi pada form,
        Terus datanya itu disimpan ke dalam variabel "newClothing" dengan tipe data "Clothing".
      */
      Clothing newClothing = Clothing(
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
        Lakukan pemanggilan API create, setelah itu
        simpan ke dalam variabel bernama "response"
      */
      final response = await ClothingService.addClothing(newClothing);

      /*
        Jika response status "Success", 
        maka tampilkan snackbar yg bertuliskan "Clothing Added"
      */
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Clothing Added")));

        // Pindah ke halaman sebelumnya
        Navigator.pop(context);

        // Untuk merefresh tampilan (menampilkan data baru ke dalam daftar pada hal. utama)
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
      /*
        Jika gagal mengirimkan data, 
        maka tampilkan snackbar dengan tulisan "Gagal: error-nya apa"
      */
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
    }
  }
}
