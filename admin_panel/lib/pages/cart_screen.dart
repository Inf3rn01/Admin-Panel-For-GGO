import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:admin_panel/controllers/cart_controller.dart';
import 'package:admin_panel/controllers/product_controller.dart';
import 'package:admin_panel/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final ProductController productController = ProductController.instance;

  CartScreen({super.key});

  void _showAddDialog(BuildContext context) {
    String userId = '';
    String productId = '';
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить запись в корзину'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'id пользователя'),
                onChanged: (value) => userId = value,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'id товара'),
                onChanged: (value) => productId = value,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Количество'),
                keyboardType: TextInputType.number,
                onChanged: (value) => quantity = int.tryParse(value) ?? 1,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Отменить'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Добавить'),
              onPressed: () {
                cartController.addNewCartItem(userId, productId, quantity);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, String userId, String productId, int quantity) {
    String newUserId = userId;
    String newProductId = productId;
    int newQuantity = quantity;

    final productIdController = TextEditingController(text: productId);
    final quantityController = TextEditingController(text: quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать запись корзины'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'id товара'),
                onChanged: (value) => newProductId = value,
                controller: productIdController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Количество'),
                keyboardType: TextInputType.number,
                onChanged: (value) => newQuantity = int.tryParse(value) ?? quantity,
                controller: quantityController,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Отменить'),
              onPressed: () {
                productIdController.dispose();
                quantityController.dispose();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                cartController.updateCartItem(newUserId, productId, newProductId, newQuantity);
                productIdController.dispose();
                quantityController.dispose();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Cart').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final cartItems = snapshot.data!.docs.map((doc) => CartModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 420,
                  columns: const [
                    DataColumn(label: Text('id пользователя', textAlign: TextAlign.center)),
                    DataColumn(label: Text('Название товара', textAlign: TextAlign.center)),
                    DataColumn(label: Text('Количество', textAlign: TextAlign.center)),
                    DataColumn(label: Text('Действие', textAlign: TextAlign.center)),
                  ],
                  rows: cartItems.expand((cart) {
                    final productNames = cartController.productNamesMap[cart.userId!] ?? [];
                    return cart.productId!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final productId = entry.value;
                      final quantity = cart.quantity![index];
                      return DataRow(cells: [
                        DataCell(Text(cart.userId ?? '')),
                        DataCell(Text(productNames.length > index ? productNames[index] : '')),
                        DataCell(Text(quantity.toString())),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(context, cart.userId!, productId, quantity);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cartController.removeFromCart(cart.userId!, productId);
                              },
                            ),
                          ],
                        )),
                      ]);
                    }).toList();
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}