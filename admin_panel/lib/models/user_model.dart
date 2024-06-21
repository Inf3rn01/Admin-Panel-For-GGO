import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String name;
  String phoneNumber;
  final String email;
  String profilePicture;
  String balance;

  /// Конструктор для UserModel
  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    required this.balance,
  });

  /// Вспомогательная функция для получения номера телефона
  String get formattedPhoneNo => GFormatter.formatPhoneNumber(phoneNumber);

  /// Статический метод для создания пустой модели пользователя
  static UserModel empty() => UserModel(id: '', name: '', phoneNumber: '', email: '', profilePicture: '', balance: '0');

  /// Преобразование модели в структуру JSON для хранения данных в Firebase
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Email': email,
      'ProfilePicture': profilePicture,
      'Balance': balance,
    };
  }

  /// Отображение снимка документа, ориентированного на Json, из Firebase в UserModel
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        name: data['Name'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        email: data['Email'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        balance: data['Balance'] ?? '0',
      );
    } else {
      return UserModel.empty();
    }
  }
}
