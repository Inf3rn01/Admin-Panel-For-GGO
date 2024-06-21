import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/banner_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// получение всех банеров
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final result = await _db.collection('Banners').get();
      return result.docs.map((documentSnapshot) => BannerModel.fromSnapshot(documentSnapshot)).toList();
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException().message;
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message; 
    } catch (e) {
      throw 'Что-то пошло не так при получении баннеров.';
    }
  }

  /// добавление нового баннера
  Future<BannerModel> addBanner(BannerModel banner) async {
    try {
      final docRef = await _db.collection('Banners').add(banner.toJson());
      final newBanner = BannerModel(
        id: docRef.id,
        imageUrl: banner.imageUrl,
        active: banner.active,
      );
      return newBanner;
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException().message;
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message; 
    } catch (e) {
      throw 'Что-то пошло не так при добавлении баннера.';
    }
  }

  Future<void> updateBanner(BannerModel banner) async {
    try {
      await _db.collection('Banners').doc(banner.id).update(banner.toJson());
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException().message;
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message; 
    } catch (e) {
      throw 'Что-то пошло не так при обновлении баннера.';
    }
  }

  Future<void> deleteBanner(String bannerId) async {
    try {
      await _db.collection('Banners').doc(bannerId).delete();
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException().message;
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message; 
    } catch (e) {
      throw 'Что-то пошло не так при удалении баннера.';
    }
  }
}