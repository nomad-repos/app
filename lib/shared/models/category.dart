import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  int categoryId;
  String catergoryName;

  Category({
    required this.categoryId,
    required this.catergoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        catergoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": catergoryName,
      };

  String get _catergoryName => catergoryName;
}
