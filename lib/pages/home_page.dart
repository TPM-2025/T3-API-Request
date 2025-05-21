import 'package:asisten_tpm_8/models/clothing_model.dart';
import 'package:asisten_tpm_8/pages/create_page.dart';
import 'package:asisten_tpm_8/pages/detail_page.dart';
import 'package:asisten_tpm_8/pages/edit_page.dart';
import 'package:asisten_tpm_8/services/clothing_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data User")),
      body: Padding(padding: EdgeInsets.all(20), child: _userContainer()),
    );
  }

  Widget _userContainer() {
    /*
      FutureBuilder adalah widget yang membantu menangani proses asynchronous
      Proses async adalah proses yang membutuhkan waktu. (ex: mengambil data dari API)

      FutureBuilder itu butuh 2 properti, yaitu future dan builder.
      Properti future adalah proses async yg akan dilakukan.
      Properti builder itu tampilan yg akan ditampilkan berdasarkan proses future tadi.
      
      Properti builder itu pada umumnya ada 2 status, yaitu hasError dan hasData.
      Status hasError digunakan untuk mengecek apakah terjadi kesalahan (misal: jaringan error).
      Status hasData digunakan untuk mengecek apakah data sudah siap.
    */
    return FutureBuilder(
      future: ClothingService.getUsers(),
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
            kita perlu mengonversi data JSON tersebut ke dalam 
            model Dart (UsersModel) untuk memudahkan pengolahan data.
            Setelah itu, hasil konversinya disimpan ke dalam variabel bernama "response".

            Baris 2:
            Setelah dikonversi, tampilkan data tadi di widget bernama "_userlist()"
            dengan mengirimkan data tadi sebagai parameternya.

            Kenapa yg dikirim "response.data" bukan "response" aja?
            Karena kalau kita lihat di dokumentasi API, bentuk response-nya itu kaya gini:
            {
              "status": ...
              "message": ...
              "data": [
                {
                  "id": 1,
                  "name": "rafli",
                  "email": "rafli@gmail.com",
                  "gender": "Male",
                  "createdAt": "2025-04-29T13:17:17.000Z",
                  "updatedAt": "2025-04-29T13:17:17.000Z"
                },
                ...
              ]
            }

            Nah, kita itu cuman mau ngambil properti "data" doang, 
            kita gamau ngambil properti "status" dan "message",
            makanya yg kita kirim ke Widget _userlist itu response.data
          */
          ClothingModel response = ClothingModel.fromJson(snapshot.data!);
          return _clothingList(context, response.data!);
        }
        // Jika masih loading, tampilkan loading screen di tengah layar
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothingList(BuildContext context, List<Clothing> clothes) {
    return ListView(
      children: [
        // Tombol create user
        ElevatedButton(
          onPressed: () {
            // Pindah ke halaman CreateUserPage() (create_user_page.dart)
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const CreatePage(),
              ),
            );
          },
          child: Text("Add Clothes"),
        ),
        SizedBox(height: 16),

        // Tampilkan tiap-tiap user dengan melakukan perulangan pada variabel "users".
        // Simpan data tiap user ke dalam variabel "user" (gapake s)
        for (var clothing in clothes)
          Container(
            margin: EdgeInsets.only(bottom: 14),
            child: InkWell(
              onTap: () {
                /*
                  Pindah ke halaman DetailPage() (detail_page.dart)
                  Karena kita mau menampilkan detail pakaian yg dipilih berdasarkan id-nya, 
                  maka beri parameter berupa id yg dipilih
                */
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (BuildContext context) => DetailPage(id: clothing.id!),
                  ),
                );
              },
              child: Container(
                // Untuk keperluan tampilan doang (opsional)
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ), // <- Ngasih Padding
                // Ngasi border
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                // Nampilin datanya dalam bentuk layout kolom (ke bawah)
                child: Column(
                  // Cross Axis Alignment "Stretch" berfungsi supaya teks menjadi rata kiri
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tampilkan nama, email, gender dalam bentuk teks
                    Text(
                      clothing.name!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Rp${clothing.price!},00"),
                    Text(clothing.category!),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          "${clothing.rating!}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ), // <- Beri jarak buat tombol di bawah
                    /*
                      Supaya tombol edit, delete, dan detail itu tidak ke bawah
                      melainkan menyamping, maka gunakan layout Row
                    */
                    Row(
                      spacing: 8, // <- Beri jarak antar widget sebanyak 8dp
                      children: [
                        // Tombol edit
                        ElevatedButton(
                          onPressed: () {
                            /*
                              Pindah ke halaman EdiPage() (edit_page.dart)
                              Karena kita mau mengubah data yg dipilih berdasarkan id-nya, 
                              maka beri parameter berupa id yg dipilih
                            */
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder:
                            //         (BuildContext context) =>
                            //             EditUserPage(id: clothing.id!),
                            //   ),
                            // );
                          },
                          child: Text("Edit"),
                        ),
                        // Tombol delete
                        ElevatedButton(
                          onPressed: () {
                            /*
                              Karena kita mau menghapus berdasarkan id-nya, maka
                              jalankan fungsi _delete() dengan memberi
                              parameter berupa id yg dipilih
                            */
                            _delete(clothing.id!);
                          },
                          child: Text("Delete"),
                        ),
                        // Tombol detail
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Fungsi untuk menghapus user ketika tombol "Delete User" diklik
  void _delete(int id) async {
    try {
      /*
        Lakukan pemanggilan API delete, setelah itu
        simpan ke dalam variabel bernama "response"
      */
      final response = await ClothingService.deleteUser(id);

      /*
        Jika response status "Success", 
        maka tampilkan snackbar yg bertuliskan "User Deleted"
      */
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User Deleted")));

        // Refresh tampilan (Supaya data yg dihapus ilang dari layar)
        setState(() {});
      } else {
        // Jika response status "Error", maka kode akan dilempar ke bagian catch
        throw Exception(response["message"]);
      }
    } catch (error) {
      /*
        Jika user gagal menghapus, 
        maka tampilkan snackbar dengan tulisan "Gagal: error-nya apa"
      */
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
    }
  }
}
