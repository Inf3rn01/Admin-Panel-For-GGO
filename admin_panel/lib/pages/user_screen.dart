import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:admin_panel/models/user_model.dart';

import '../data/repositories/user/user_repository.dart';


class UserScreen extends StatelessWidget {
  final UserRepository userRepository = Get.put(UserRepository());

  UserScreen({super.key});

  void _showAddDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController balanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Имя'),
              ),
              const SizedBox(height: 13),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Номер телефона'),
              ),
              const SizedBox(height: 13),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Почта'),
              ),
              const SizedBox(height: 13),
              TextField(
                controller: balanceController,
                decoration: const InputDecoration(labelText: 'Баланс'),
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
              onPressed: () async {
                UserModel newUser = UserModel(
                  id: '',
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                  email: emailController.text,
                  profilePicture: '',
                  balance: balanceController.text,
                );
                await userRepository.saveUserRecord(newUser);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) async {
    TextEditingController nameController = TextEditingController(text: user.name);
    TextEditingController phoneNumberController = TextEditingController(text: user.phoneNumber);
    TextEditingController emailController = TextEditingController(text: user.email);
    TextEditingController balanceController = TextEditingController(text: user.balance);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Имя'),
              ),
              const SizedBox(height: 13),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Номер телефона'),
              ),
              const SizedBox(height: 13),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Почта'),
              ),
              const SizedBox(height: 13),
              TextField(
                controller: balanceController,
                decoration: const InputDecoration(labelText: 'Баланс'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Отменить'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () async {
                UserModel updatedUser = UserModel(
                  id: user.id,
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                  email: emailController.text,
                  profilePicture: user.profilePicture,
                  balance: balanceController.text,
                );
                await userRepository.updateUserDetails(updatedUser);
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
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Нет доступных пользователей'));
          } else {
            final users = snapshot.data!.docs.map((doc) => UserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 204,
                columns: const [
                  DataColumn(label: Text('Id пользователя')),
                  DataColumn(label: Text('Имя')),
                  DataColumn(label: Text('Номер телефона')),
                  DataColumn(label: Text('Почта')),
                  DataColumn(label: Text('Баланс')),
                  DataColumn(label: Text('Действие')),    
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user.id)),
                    DataCell(Text(user.name)),
                    DataCell(Text(user.phoneNumber)),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.balance)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await userRepository.removeUserRecord(user.id);
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}