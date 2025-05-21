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
          child: Text("Create New User"),
        ),

        // Tampilkan tiap-tiap user dengan melakukan perulangan pada variabel "users".
        // Simpan data tiap user ke dalam variabel "user" (gapake s)
        for (var clothing in clothes)
          Container(
            // Untuk keperluan tampilan doang (opsional)
            margin: EdgeInsets.only(top: 12), // <- Ngasih margin
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ), // <- Ngasih Padding
            color: Colors.green.shade100, // <- Ngasih warna background ijo
            // Nampilin datanya dalam bentuk layout kolom (ke bawah)
            child: Column(
              // Cross Axis Alignment "Stretch" berfungsi supaya teks menjadi rata kiri
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tampilkan nama, email, gender dalam bentuk teks
                Text(clothing.name!),
                Text("${clothing.price!}"),
                Text(clothing.category!),
                Text("${clothing.rating!}"),
                const SizedBox(height: 8), // <- Beri jarak buat tombol di bawah
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
                          Pindah ke halaman EditUserPage() (edit_user_page.dart)
                          Karena kita mau mengubah user yg dipilih berdasarkan id-nya, 
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
                          Karena kita mau menghapus user berdasarkan id-nya, maka
                          jalankan fungsi _deleteUser() dengan memberi
                          parameter berupa id yg dipilih
                        */
                        _deleteUser(clothing.id!);
                      },
                      child: Text("Delete"),
                    ),
                    // Tombol detail
                    ElevatedButton(
                      onPressed: () {
                        /*
                          Pindah ke halaman DetailUserPage() (detail_user_page.dart)
                          Karena kita mau menampilkan detail user yg dipilih berdasarkan id-nya, 
                          maka beri parameter berupa id yg dipilih
                        */
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (BuildContext context) =>
                                    DetailPage(id: clothing.id!),
                          ),
                        );
                      },
                      child: Text("Detail"),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Fungsi untuk menghapus user ketika tombol "Delete User" diklik
  void _deleteUser(int id) async {
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
