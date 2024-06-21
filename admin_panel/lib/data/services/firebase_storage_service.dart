import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GFirebaseStorageService extends GetxController {
  static GFirebaseStorageService get instance => Get.find();

  final _firebaseStorage = FirebaseStorage.instance;

  /// Загрузка локальных ассетов из IDE
  /// Возвращает список Uint8List, содержащий данные изображения
  Future<Uint8List> getImageDataFromAssets(String path) async {
    try {
      final byteData = await rootBundle.load(path);
      final imageData = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      return imageData;
    } catch (e) {
      throw 'Ошибка при загрузке данных изображения: $e';
    }
  }
  
  /// Загрузка изображений с помощью ImageData Firebase
  /// Возвращает URL-адрес загрузки загруженного изображения
  Future<String> uploadImageData(String path, Uint8List image, String name) async {
    try {
      final ref = _firebaseStorage.ref(path).child(name);
      await ref.putData(image);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      if (e is FirebaseException) {
        throw 'Firebase exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Ошибка сети: ${e.message}';
      } else if (e is PlatformException) {
        throw 'Исключение для платформы: ${e.message}';
      } else {
        throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз.';
      }
    }
  }

  /// Загрузка изображений в Firebase
  /// Возвращает URL-адрес загрузки загруженного изображения
  Future<String> uploadImageFile(String path, XFile image) async {
    try {
      final ref = _firebaseStorage.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      if (e is FirebaseException) {
        throw 'Firebase exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Ошибка сети: ${e.message}';
      } else if (e is PlatformException) {
        throw 'Исключение для платформы: ${e.message}';
      } else {
        throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз.';
      }
    }
  }
}
