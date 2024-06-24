import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../models/category_models.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryController _controller = Get.put(CategoryController());

  CategoryScreen({super.key});

  void _showAddEditDialog(BuildContext context, [CategoryModel? category]) {
    final TextEditingController nameController = TextEditingController(text: category?.name ?? '');
    final TextEditingController imageController = TextEditingController(text: category?.image ?? '');
    bool isFeatured = category?.isFeatured ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? 'Добавить категорию' : 'Изменить категорию'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: 'Адрес картинки'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Название'),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isFeatured,
                        onChanged: (value) {
                          setState(() {
                            isFeatured = value ?? false;
                          });
                        },
                      ),
                      Text(isFeatured ? 'Активна' : 'Не активна'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final newCategory = CategoryModel(
                  id: category?.id ?? '',
                  name: nameController.text,
                  image: imageController.text,
                  isFeatured: isFeatured,
                );
                if (category == null) {
                  _controller.addCategory(newCategory);
                } else {
                  _controller.updateCategory(newCategory);
                }
                Navigator.of(context).pop();
              },
              child: Text(category == null ? 'Добавить' : 'Обновить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 490,
            columns: const [
              DataColumn(label: Text('Изображение')),
              DataColumn(label: Text('Название')),
              DataColumn(label: Text('Статус')),
              DataColumn(label: Text('Действия')),
            ],
            rows: _controller.allCategories.map((category) {
              return DataRow(
                cells: [
                  DataCell(Image.network(
                    category.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  )),
                  DataCell(Text(category.name)),
                  DataCell(Text(category.isFeatured ? 'Активна' : 'Не активна')),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showAddEditDialog(context, category);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _controller.removeCategory(category.id);
                        },
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}