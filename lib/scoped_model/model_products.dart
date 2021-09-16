// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

// List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

// String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  int id;
  String title;
  double price;
  String description;
  Category category;
  String image;
  Rating rating;

  factory ProductModel.fromJson(Map<String, dynamic> parsedJson) =>
      ProductModel(
        id: parsedJson["id"],
        title: parsedJson["title"],
        price: parsedJson["price"].toDouble(),
        description: parsedJson["description"],
        category: categoryValues.map[parsedJson["category"]],
        image: parsedJson["image"],
        rating: Rating.fromJson(parsedJson["rating"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "category": categoryValues.reverse[category],
    "image": image,
    "rating": rating.toJson(),
  };

  ProductModel toList() {}
}

enum Category { MEN_S_CLOTHING, JEWELERY, ELECTRONICS, WOMEN_S_CLOTHING }

final categoryValues = EnumValues({
  "electronics": Category.ELECTRONICS,
  "jewelery": Category.JEWELERY,
  "men's clothing": Category.MEN_S_CLOTHING,
  "women's clothing": Category.WOMEN_S_CLOTHING
});

class Rating {
  Rating({
    this.rate,
    this.count,
  });

  double rate;
  dynamic count;

  factory Rating.fromJson(Map<String, dynamic> parsedJson) => Rating(
    rate: parsedJson["rate"].toDouble(),
    count: parsedJson["count"],
  );

  Map<String, dynamic> toJson() => {
    "rate": rate,
    "count": count,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
