import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/models/product_features_model.dart';

class ProductModel {
  String id;
  double price;
  String title;
  bool? isFeatured;
  String? description;
  String? categoryId;
  List<String>? images;
  ProductFeaturesModel? productFeatures;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    this.images,
    this.isFeatured,
    this.description,
    this.categoryId,
    this.productFeatures,
  });

  static ProductModel empty() => ProductModel(
    id: '',
    title: '',
    price: 0.0,
  );

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Price': price,
      'IsFeatured': isFeatured,
      'Description': description,
      'CategoryId': categoryId,
      'Images': images ?? [],
      'ProductFeatures': productFeatures?.toJson(),
    };
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return ProductModel.empty();
    final data = document.data()!;

    ProductFeaturesModel? productFeatures;
    if (data['ProductFeatures'] != null) {
      productFeatures = ProductFeaturesModel.fromJson(data['ProductFeatures'] as Map<String, dynamic>);
    }

    return ProductModel(
      id: document.id,
      title: data['Title'] ?? '',
      price: (data['Price'] as num?)?.toDouble() ?? 0.0,
      isFeatured: data['IsFeatured'] ?? false,
      description: data['Description'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productFeatures: productFeatures,
    );
  }
}