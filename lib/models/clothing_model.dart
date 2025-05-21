class ClothingModel {
  String? status;
  String? message;
  List<Clothing>? data;

  ClothingModel({this.status, this.message, this.data});

  ClothingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Clothing>[];
      json['data'].forEach((v) {
        data!.add(Clothing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clothing {
  int? id;
  String? name;
  int? price;
  String? category;
  String? brand;
  int? sold;
  double? rating;
  int? stock;
  int? yearReleased;
  String? material;

  Clothing({
    this.id,
    this.name,
    this.price,
    this.category,
    this.brand,
    this.sold,
    this.rating,
    this.stock,
    this.yearReleased,
    this.material,
  });

  Clothing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    category = json['category'];
    brand = json['brand'];
    sold = json['sold'];

    // Karena data kita ada yang bilangan bulat (cth: 5, 4, dst),
    // maka kita perlu mengkonversinya terlebih dahulu ke tipe data double
    rating = json['rating'].toDouble();

    stock = json['stock'];
    yearReleased = json['yearReleased'];
    material = json['material'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['category'] = category;
    data['brand'] = brand;
    data['sold'] = sold;
    data['rating'] = rating;
    data['stock'] = stock;
    data['yearReleased'] = yearReleased;
    data['material'] = material;
    return data;
  }
}
