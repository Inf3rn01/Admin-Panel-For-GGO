import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:admin_panel/models/product_models.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot = await _db.collection('Products').where('IsFeatured', isEqualTo: true).get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз. $e';
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _db.collection('Products')
          .where('CategoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз. $e';
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _db.collection('Products').add(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _db.collection('Products').doc(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection('Products').doc(productId).delete();
  }

}