import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveOrder(OrderModel order) async {
    await _db.collection('Order').add(order.toJson());
  }

  Stream<QuerySnapshot> getOrders() {
    return _db.collection('Order').snapshots();
  }

  Future<void> updateOrder(OrderModel order) async {
    await _db.collection('Order').doc(order.id).update(order.toJson());
  }

  Future<void> deleteOrder(OrderModel order) async {
    await _db.collection('Order').doc(order.id).delete();
  }
}