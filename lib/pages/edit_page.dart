// import 'package:asisten_tpm_8/models/user_model.dart';
// import 'package:asisten_tpm_8/pages/home_page.dart';
// import 'package:asisten_tpm_8/services/user_service.dart';
// import 'package:flutter/material.dart';

// class EditPage extends StatefulWidget {
//   final int id;
//   const EditPage({super.key, required this.id});

//   @override
//   State<EditPage> createState() => _EditPageState();
// }

// class _EditPageState extends State<EditPage> {
//   /* 
//     Controller dipake buat mengelola input teks dari TextField.
//     Di sini kita bikin controller buat input name sama email.
//     Buat input gender, hasilnya cukup kita simpan ke dalam string biasa karena kita make radio button
//   */
//   final TextEditingController name = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   String? gender;

//   bool _isDataLoaded = false;

//   // Fungsi untuk mengupdate user ketika tombol "Update User" diklik
//   Future<void> _updateUser(BuildContext context) async {
//     try {
//       /*
//         Karena kita mau mengedit user, maka kita juga perlu data yg baru.
//         Disini kita mengambil data nama, email, & gender yang dah diisi pada form,
//         Terus datanya itu disimpan ke dalam variabel "updatedUser" dengan tipe data User.
//       */
//       User updatedUser = User(
//         name: name.text.trim(),
//         email: email.text.trim(),
//         gender: gender,
//       );

//       /*
//         Lakukan pemanggilan API update, setelah itu
//         simpan ke dalam variabel bernama "response"
//       */
//       final response = await ClothingService.updateUser(updatedUser, widget.id);

//       /*
//         Jika response status "Success", 
//         maka tampilkan snackbar yg bertuliskan "Berhasil mengubah user [nama_user]"
//       */
//       if (response["status"] == "Success") {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Berhasil mengubah user ${updatedUser.name}")),
//         );

//         // Pindah ke halaman sebelumnya
//         Navigator.pop(context);

//         // Untuk merefresh tampilan (menampilkan data user yg telah diedit ke dalam daftar)
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (BuildContext context) => const HomePage(),
//           ),
//         );
//       } else {
//         // Jika response status "Error", maka kode akan dilempar ke bagian catch
//         throw Exception(response["message"]);
//       }
//     } catch (error) {
//       /*
//         Jika user gagal menghapus, 
//         maka tampilkan snackbar dengan tulisan "Gagal: error-nya apa"
//       */
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Update User"), centerTitle: true),
//       body: Padding(padding: const EdgeInsets.all(20), child: _userEdit()),
//     );
//   }

//   Widget _userEdit() {
//     return FutureBuilder(
//       future: ClothingService.getUserById(widget.id),
//       builder: (context, snapshot) {
//         // Jika error (gagal memanggil API), maka tampilkan teks error
//         if (snapshot.hasError) {
//           return Text("Error: ${snapshot.error.toString()}");
//         }
//         // Jika berhasil memanggil API (ada datanya)
//         else if (snapshot.hasData) {
//           /*
//             Jika data belum pernah di-load sama sekali (baru pertama kali),
//             maka program akan masuk ke dalam percabangan ini.

//             Mengapa perlu dicek? Karena setiap kali layar mengupdate state menggunakan setState(),
//             Widget ini akan terus dijalankan berulang-ulang.
//             Untuk mencegah pengambilan data berulang-ulang, kita perlu mengecek
//             apakah data sudah pernah diambil atau belum.
//           */
//           if (!_isDataLoaded) {
//             // Jika data baru pertama kali di-load, ubah menjadi true
//             _isDataLoaded = true;

//             /*
//               Baris 1:
//               Untuk mengambil response dari API, kita bisa mengakses "snapshot.data"
//               Nah, snapshot.data tadi itu bentuknya masih berupa Map<String, dynamic>.

//               Untuk memudahkan pengolahan data, 
//               kita perlu mengonversi data JSON tersebut ke dalam model Dart (User),
//               makanya kita pake method User.fromJSON() buat mengonversinya.
//               Setelah itu, hasil konversinya disimpan ke dalam variabel bernama "user".
              
//               Kenapa yg kita simpan "snapshot.data["data"]" bukan "snapshot.data" aja?
//               Karena kalau kita lihat di dokumentasi API, bentuk response-nya itu kaya gini:
//               {
//                 "status": ...
//                 "message": ...
//                 "data": {
//                   "id": 1,
//                   "name": "rafli",
//                   "email": "rafli@gmail.com",
//                   "gender": "Male",
//                   "createdAt": "2025-04-29T13:17:17.000Z",
//                   "updatedAt": "2025-04-29T13:17:17.000Z"
//                 },
//               }

//               Nah, kita itu cuman mau ngambil properti "data" doang, 
//               kita gamau ngambil properti "status" dan "message",
//               makanya yg kita simpan ke variabel user itu response.data["data"]

//               Baris 2-4
//               Setelah mendapatkan data user yg dipilih,
//               masukkan data tadi sebagai nilai default pada tiap-tiap input

//               Baris 5:
//               Setelah dikonversi, tampilkan data tadi di widget bernama "_user()"
//               dengan mengirimkan data tadi sebagai parameternya.
//             */
//             User user = User.fromJson(snapshot.data!["data"]);
//             name.text = user.name!;
//             email.text = user.email!;
//             gender = user.gender!;
//           }

//           return _userEditForm(context);
//         }
//         // Jika masih loading, tampilkan loading screen di tengah layar
//         else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   Widget _userEditForm(BuildContext context) {
//     return ListView(
//       children: [
//         // Buat input nama user
//         TextField(
//           /*
//             Ngasi tau kalau ini input buat name, jadi segala hal yg kita ketikan 
//             bakalan disimpan ke dalam variabel "name" yg udah kita bikin di atas
//           */
//           controller: name,
//           decoration: const InputDecoration(
//             labelText: "Name", // <- Ngasi label
//             border: OutlineInputBorder(), // <- Ngasi border di form-nya
//           ),
//         ),
//         const SizedBox(height: 16), // <- Ngasi jarak antar widget
//         // Buat input email user
//         TextField(
//           /*
//             Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
//             bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
//           */
//           controller: email,
//           decoration: const InputDecoration(
//             labelText: "Email", // <- Ngasi label
//             border: OutlineInputBorder(), // <- Ngasi border di form-nya
//           ),
//         ),
//         const SizedBox(height: 16), // <- Ngasi jarak antar widget
//         // Buat input gender (pake radio button)
//         Text("Gender"),
//         Row(
//           children: [
//             // Radio button buat male
//             Radio(
//               value: "Male",
//               groupValue: gender,
//               onChanged: (event) {
//                 // Kalau male dipilih,
//                 // maka variabel "gender" akan memiliki nilai "Male"
//                 setState(() {
//                   gender = event;
//                 });
//               },
//             ),
//             Text("Male"),
//             // Radio button buat female
//             Radio(
//               value: "Female",
//               groupValue: gender,
//               onChanged: (event) {
//                 // Kalau female dipilih,
//                 // maka variabel "gender" akan memiliki nilai "Female"
//                 setState(() {
//                   gender = event;
//                 });
//               },
//             ),
//             Text("Female"),
//           ],
//         ),
//         const SizedBox(height: 16), // <- Ngasi jarak antar widget
//         // Tombol buat bikin user baru
//         ElevatedButton(
//           onPressed: () {
//             // Jalankan fungsi _updateUser() ketika tombol diklik
//             _updateUser(context);
//           },
//           child: const Text("Update User"),
//         ),
//       ],
//     );
//   }
// }
