class CartModel {
  String? userId;
  List<String>? productId;
  List<int>? quantity;

  CartModel({this.userId, this.productId, this.quantity});

  // Метод для конвертации из JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'] as String?,
      productId: List<String>.from(json['productId'] ?? []),
      quantity: List<int>.from(json['quantity'] ?? []),
    );
  }

  // Метод для конвертации в JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
    };
  }
}