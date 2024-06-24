import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:admin_panel/controllers/product_controller.dart';
import 'package:admin_panel/models/cart_model.dart';
import 'package:admin_panel/utils/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityCart = 1.obs;
  RxList<CartModel> cartItems = <CartModel>[].obs;
  final RxMap<String, List<String>> productNamesMap = <String, List<String>>{}.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final productController = Get.put(ProductController());

  @override
  void onInit() {
    super.onInit();
    fetchAllCartItems();
  }

  int get totalQuantity => cartItems.fold(0, (sum, item) => 
      sum + item.quantity!.fold(0, (sum, qty) => sum + qty));

  Future<void> addToCart(String userId, String productId, int quantity) async {
    if (quantity < 1) {
      Loaders.customToast(message: 'Выберите количество товаров');
      return;
    }

    final docRef = _firestore.collection('Cart').doc(userId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final cart = CartModel.fromJson(docSnapshot.data()!);
      final index = cart.productId!.indexOf(productId);

      if (index >= 0) {
        cart.quantity![index] += quantity;
      } else {
        cart.productId!.add(productId);
        cart.quantity!.add(quantity);
      }

      await docRef.set(cart.toJson());
    } else {
      final newCart = CartModel(
        userId: userId,
        productId: [productId],
        quantity: [quantity],
      );
      await docRef.set(newCart.toJson());
    }

    Loaders.customToast(message: 'Товар добавлен в корзину');
    await fetchAllCartItems();
    productQuantityCart.value = 1;
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Cart').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final cart = CartModel.fromJson(docSnapshot.data()!);
        final index = cart.productId!.indexOf(productId);

        if (index >= 0) {
          cart.productId!.removeAt(index);
          cart.quantity!.removeAt(index);
          await docRef.set(cart.toJson());
        }
      }
    } catch (e) {
      print('Error removing from cart: $e');
    }
    await fetchAllCartItems();
  }

  Future<void> clearCart(String userId) async {
    final docRef = _firestore.collection('Cart').doc(userId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final cart = CartModel.fromJson(docSnapshot.data()!);

      cart.productId!.clear();
      cart.quantity!.clear();

      await docRef.set(cart.toJson());
    }

    cartItems.clear();
    noOfCartItems.value = 0;
    totalCartPrice.value = 0.0;
    await fetchAllCartItems();
  }

  Future<void> fetchAllCartItems() async {
    try {
      productController.fetchFeaturedProducts(); // Загрузка избранных продуктов
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Cart').get();
      final List<CartModel> carts = querySnapshot.docs.map((doc) {
        return CartModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      for (var cart in carts) {
        final List<String> productNames = [];
        for (var productId in cart.productId!) {
          if (productId.isNotEmpty) {
            final product = productController.getProductById(productId);
            productNames.add(product.title);
          } else {
            productNames.add('');
          }
        }
        productNamesMap[cart.userId!] = productNames;
      }

      cartItems.value = carts.where((cart) => cart.productId!.any((id) => id.isNotEmpty)).toList();
      noOfCartItems.value = carts.fold(0, (sum, cart) => sum + cart.productId!.where((id) => id.isNotEmpty).length);
      calculateTotalCartPrice();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cart items: $e');
      }
    }
  }

  void calculateTotalCartPrice() {
    totalCartPrice.value = cartItems.fold(0.0, (sum, cart) {
      double cartTotal = 0.0;
      for (int i = 0; i < cart.productId!.length; i++) {
        final product = productController.getProductById(cart.productId![i]);
        cartTotal += product.price * cart.quantity![i];
      }
      return sum + cartTotal;
    });
  }

  Future<void> increaseQuantity(String userId, String productId) async {
    final cartItem = cartItems.firstWhere((cart) => cart.userId == userId);
    final index = cartItem.productId!.indexOf(productId);
    if (index >= 0) {
      cartItem.quantity![index]++;
      await updateCartInDB(userId, cartItem);
      cartItems.refresh();
      calculateTotalCartPrice();
    }
    await fetchAllCartItems();
  }

  Future<void> decreaseQuantity(String userId, String productId) async {
    final cartItem = cartItems.firstWhere((cart) => cart.userId == userId);
    final index = cartItem.productId!.indexOf(productId);
    if (index >= 0) {
      if (cartItem.quantity![index] > 1) {
        cartItem.quantity![index]--;
      } else {
        cartItem.productId!.removeAt(index);
        cartItem.quantity!.removeAt(index);
      }
      await updateCartInDB(userId, cartItem);
      cartItems.refresh();
      calculateTotalCartPrice();

      if (cartItem.productId!.isEmpty) {
        await clearCart(userId);
      }
    }
    await fetchAllCartItems();
  }

  Future<void> updateCartInDB(String userId, CartModel cart) async {
    await _firestore.collection('Cart').doc(userId).set(cart.toJson());
  }

  Future<void> updateCartItem(String userId, String oldProductId, String newProductId, int newQuantity) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Cart').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final cart = CartModel.fromJson(docSnapshot.data()!);
        final index = cart.productId!.indexOf(oldProductId);

        if (index >= 0) {
          cart.productId![index] = newProductId;
          cart.quantity![index] = newQuantity;
          await docRef.set(cart.toJson());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating cart item: $e');
      }
    }
    await fetchAllCartItems();
  }

  Future<void> addNewCartItem(String userId, String productId, int quantity) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Cart').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final cart = CartModel.fromJson(docSnapshot.data()!);
        cart.productId!.add(productId);
        cart.quantity!.add(quantity);
        await docRef.set(cart.toJson());
      } else {
        final newCart = CartModel(userId: userId, productId: [productId], quantity: [quantity]);
        await docRef.set(newCart.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding new cart item: $e');
      }
    }
    await fetchAllCartItems();
  }
}