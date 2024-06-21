import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:admin_panel/data/repositories/order/order_repository.dart';
import 'package:admin_panel/models/order_model.dart';
import 'package:admin_panel/models/product_models.dart';
import 'package:admin_panel/controllers/address_controller.dart';
import '../models/address_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  
  final AddressController addressController = Get.put(AddressController());
  final OrderRepository _orderRepository = OrderRepository();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    String id = FirebaseFirestore.instance.collection('Order').doc().id;
    order.id = id;
    await FirebaseFirestore.instance.collection('Order').doc(id).set(order.toJson());
  }

  Stream<QuerySnapshot> getOrders() {
    return _orderRepository.getOrders();
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      if (order.id == null) {
        throw Exception('Order ID is null');
      }

      final docRef = _db.collection('Order').doc(order.id);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update(order.toJson());
      } else {
        throw Exception('Документа с id ${order.id} не существует');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating order: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteOrder(OrderModel order) async {
    await _orderRepository.deleteOrder(order);
  }

  Future<Map<String, String>> getProductNames(List<String> productIds) async {
    Map<String, String> productNames = {};
    for (var productId in productIds) {
      final productDoc = await _db.collection('Products').doc(productId).get();
      if (productDoc.exists) {
        ProductModel product = ProductModel.fromSnapshot(productDoc);
        productNames[productId] = product.title;
      }
    }
    return productNames;
  }

  Future<String> getSelectedAddress(String userId) async {
    final addressDoc = await _db.collection('Users').doc(userId).collection('Addresses').where('SelectedAddress', isEqualTo: true).get();
    if (addressDoc.docs.isNotEmpty) {
      AddressModel address = AddressModel.fromDocumentSnaphot(addressDoc.docs.first);
      return address.toString();
    }
    return 'Адрес не найден';
  }
}