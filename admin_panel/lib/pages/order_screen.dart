import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:admin_panel/controllers/order_controller.dart';
import 'package:admin_panel/models/order_model.dart';

class OrderScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  OrderScreen({super.key});

  void _showAddDialog(BuildContext context) async {
    String userId = '';
    List<String> productIds = [];
    List<int> quantities = [];
    String totalPrice = '';

    final userIdController = TextEditingController();
    final productIdsController = TextEditingController();
    final quantitiesController = TextEditingController();
    final totalPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить заказ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'id пользователя'),
                controller: userIdController,
                onChanged: (value) => userId = value,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(labelText: 'номера товаров (через запятую)'),
                controller: productIdsController,
                onChanged: (value) => productIds = value.split(','),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(labelText: 'Количество товаров (через запятую)'),
                controller: quantitiesController,
                onChanged: (value) {
                  quantities = value.split(',').map((e) => int.tryParse(e) ?? 0).toList();
                },
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(labelText: 'Общая стоимость'),
                controller: totalPriceController,
                onChanged: (value) => totalPrice = value,
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
                orderController.createOrder(OrderModel(
                  userId: userId,
                  productId: productIds,
                  quantity: quantities,
                  totalPrice: totalPrice,
                ));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, OrderModel order, String address) {
    final userIdController = TextEditingController(text: order.userId);
    final productIdsController = TextEditingController(text: order.productId?.join(', '));
    final quantitiesController = TextEditingController(text: order.quantity?.join(', '));
    final totalPriceController = TextEditingController(text: order.totalPrice);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать заказ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'id пользователя'),
                controller: userIdController,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(labelText: 'номера товаров (через запятую)'),
                controller: productIdsController,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(labelText: 'Количество товаров (через запятую)'),
                controller: quantitiesController,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(labelText: 'Общая стоимость'),
                controller: totalPriceController,
              ),
              const SizedBox(height: 15),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Отменить'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                orderController.updateOrder(OrderModel(
                  id: order.id,
                  userId: userIdController.text,
                  productId: productIdsController.text.split(','),
                  quantity: quantitiesController.text.split(',').map((e) => int.tryParse(e) ?? 0).toList(),
                  totalPrice: totalPriceController.text,
                ));
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
        stream: FirebaseFirestore.instance.collection('Order').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders available'));
          } else {
            final orders = snapshot.data!.docs.map((doc) => OrderModel.fromDocumentSnapshot(doc)).toList();
            final productIds = orders.expand((order) => order.productId ?? []).toList().cast<String>();

            return FutureBuilder<Map<String, String>>(
              future: orderController.getProductNames(productIds),
              builder: (context, productNamesSnapshot) {
                if (productNamesSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productNamesSnapshot.hasError) {
                  return Center(child: Text('Error: ${productNamesSnapshot.error}'));
                } else {
                  final productNames = productNamesSnapshot.data ?? {};
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 100,
                        columns: const [
                          DataColumn(label: Text('Номер заказа', textAlign: TextAlign.center)),
                          DataColumn(label: Text('Id пользователя', textAlign: TextAlign.center)),
                          DataColumn(label: Text('Название товара', textAlign: TextAlign.center)),
                          DataColumn(label: Text('Количество товаров', textAlign: TextAlign.center)),
                          DataColumn(label: Text('Общая стоимость', textAlign: TextAlign.center)),
                          DataColumn(label: Text('Адрес доставки', textAlign: TextAlign.center)),
                          DataColumn(label: Text('Действие', textAlign: TextAlign.center)),
                        ],
                        rows: orders.map((order) {
                          final productNamesList = order.productId?.map((id) => productNames[id] ?? '').join(', ') ?? '';
                          return DataRow(cells: [
                            DataCell(Text(order.id ?? '')),
                            DataCell(Text(order.userId ?? '')),
                            DataCell(Text(productNamesList)),
                            DataCell(Text(order.quantity?.join(', ') ?? '')),
                            DataCell(Text(order.totalPrice ?? '')),
                            DataCell(FutureBuilder<String>(
                              future: orderController.getSelectedAddress(order.userId ?? ''),
                              builder: (context, addressSnapshot) {
                                if (addressSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Загрузка адреса...');
                                } else if (addressSnapshot.hasError) {
                                  return Text('Ошибка: ${addressSnapshot.error}');
                                } else {
                                  return Text(addressSnapshot.data ?? 'Адрес не найден');
                                }
                              },
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, order, '');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    orderController.deleteOrder(order);
                                  },
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
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