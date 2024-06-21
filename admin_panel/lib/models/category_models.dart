import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  bool isFeatured;
  
  ///Конструктор для CategoryModel
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
  });

  /// метод для создания пустой модели пользователя
  static CategoryModel empty() => CategoryModel(id: '', image: '', name: '', isFeatured: false);

  /// Преобразование модели в структуру JSON для хранения данных в Firebase
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Image': image,
      'IsFeatured': isFeatured,
    };
  } 

  /// Отображение снимка документа, ориентированного на Json, из Firebase в CategoryModel
  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CategoryModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        isFeatured: data['IsFeatured'] ?? false,
      );
    } else {
      return CategoryModel.empty();
    }
  }

}