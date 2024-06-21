import 'package:admin_panel/controllers/cart_controller.dart';
import 'package:admin_panel/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String? userId;
  List<String>? productId;
  List<int>? quantity;
  String? totalPrice;

  OrderModel({
    this.id,
    this.userId,
    this.productId,
    this.quantity,
    this.totalPrice,
  });

  // Метод для конвертации из JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      productId: (json['productId'] as List?)?.cast<String>(),
      quantity: (json['quantity'] as List?)?.cast<int>(),
      totalPrice: json['totalPrice'] as String?,
    );
  }

  // Метод для конвертации в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  // Статический метод для создания OrderModel из userController и cartController
  static OrderModel fromControllers(UserController userController, CartController cartController) {
    List<String> flattenedProductIds = [];
    List<int> flattenedQuantities = [];

    for (var cartItem in cartController.cartItems) {
      if (cartItem.productId != null && cartItem.quantity != null) {
        flattenedProductIds.addAll(cartItem.productId!);
        flattenedQuantities.addAll(cartItem.quantity!);
      }
    }

    return OrderModel(
      userId: userController.user.value.id,
      productId: flattenedProductIds,
      quantity: flattenedQuantities,
      totalPrice: cartController.totalCartPrice.value.toStringAsFixed(2),
    );
  }

  // Метод для создания OrderModel из DocumentSnapshot
  factory OrderModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'],
      productId: List<String>.from(data['productId']),
      quantity: List<int>.from(data['quantity']),
      totalPrice: data['totalPrice'],
    );
  }
}