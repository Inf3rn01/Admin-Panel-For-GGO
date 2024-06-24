import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/controllers/product_controller.dart';
import 'package:admin_panel/controllers/category_controller.dart';
import 'package:admin_panel/models/product_models.dart';
import 'package:admin_panel/models/category_models.dart';
import '../models/product_features_model.dart';

class ProductScreen extends StatelessWidget {
  final ProductController _productController = Get.put(ProductController());
  final CategoryController _categoryController = Get.put(CategoryController());

  ProductScreen({super.key});

  void _showAddEditDialog(BuildContext context, [ProductModel? product]) {
  final TextEditingController titleController = TextEditingController(text: product?.title ?? '');
  final TextEditingController priceController = TextEditingController(text: product?.price.toString() ?? '');
  final TextEditingController descriptionController = TextEditingController(text: product?.description ?? '');
  final TextEditingController imagesController = TextEditingController(text: product?.images?.join(',') ?? '');
  final Map<String, dynamic> initialFeatures = product?.productFeatures?.features ?? {};
  final List<MapEntry<String, dynamic>> featuresEntries = initialFeatures.entries.toList();
  CategoryModel? selectedCategory = product?.categoryId != null ? _categoryController.allCategories.firstWhere((cat) => cat.id == product?.categoryId) : null;
  bool isFeatured = product?.isFeatured ?? false; // Добавляем переменную для чекбокса

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(product == null ? 'Добавить продукт' : 'Изменить продукт'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<CategoryModel>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Категория'),
                    items: _categoryController.allCategories.map((CategoryModel category) {
                      return DropdownMenuItem<CategoryModel>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (CategoryModel? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: imagesController,
                    decoration: const InputDecoration(labelText: 'Фотографии (через запятую)'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Название'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Цена'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Описание'),
                  ),
                  const SizedBox(height: 10),
                  FeaturesEditor(initialFeatures: featuresEntries),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Активен'),
                    value: isFeatured,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isFeatured = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
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
                  final Map<String, dynamic> featuresMap = featuresEntries.fold({}, (map, entry) {
                    map[entry.key] = entry.value;
                    return map;
                  });
                  final newProduct = ProductModel(
                    id: product?.id ?? '',
                    title: titleController.text,
                    price: double.parse(priceController.text),
                    description: descriptionController.text,
                    images: imagesController.text.split(','),
                    categoryId: selectedCategory?.id,
                    productFeatures: ProductFeaturesModel(features: featuresMap),
                    isFeatured: isFeatured, // Добавляем значение чекбокса
                  );
                  if (product == null) {
                    _productController.addProduct(newProduct);
                  } else {
                    _productController.updateProduct(newProduct);
                  }
                  Navigator.of(context).pop();
                },
                child: Text(product == null ? 'Добавить' : 'Обновить'),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowMaxHeight: double.infinity,
                  columns: const [
                    DataColumn(label: Center(child: Text('Фото'))),
                    DataColumn(label: Center(child: Text('Название'))),
                    DataColumn(label: Center(child: Text('Категория'))),
                    DataColumn(label: Center(child: Text('Цена'))),
                    DataColumn(label: Center(child: Text('Описание'))),
                    DataColumn(label: Center(child: Text('Особенности'))),
                    DataColumn(label: Center(child: Text('Действия'))),
                    DataColumn(label: Center(child: Text('Активен'))),
                  ],
                  rows: _productController.allProducts.map((product) {
                    final category = _categoryController.allCategories.firstWhere(
                      (cat) => cat.id == product.categoryId,
                      orElse: () => CategoryModel(id: '', name: '', image: '', isFeatured: false),
                    );
                    return DataRow(
                      cells: [
                        DataCell(Container(
                          width: 150,
                          child: product.images != null && product.images!.isNotEmpty
                              ? Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: product.images!.map((url) => Image.network(url, width: 50, height: 50)).toList(),
                                )
                              : const Text('Нет фото'),
                        )),
                        DataCell(Text(product.title)),
                        DataCell(Text(category.name)),
                        DataCell(Text(product.price.toString())),
                        DataCell(Container(
                          width: 150,
                          child: Text(
                            product.description ?? '',
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        DataCell(Container(
                          width: 150,
                          child: RichText(
                            text: TextSpan(
                              text: product.productFeatures?.features.entries.map((e) => '${e.key}: ${e.value}').join(', ') ?? '',
                              style: DefaultTextStyle.of(context).style,
                            ),
                          ),
                        )),
                        DataCell(Checkbox(
                          value: product.isFeatured ?? false,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              _productController.updateProductFeaturedStatus(product.id, newValue);
                            }
                          },
                        )),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showAddEditDialog(context, product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _productController.deleteProduct(product.id),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}



class FeaturesEditor extends StatefulWidget {
  final List<MapEntry<String, dynamic>> initialFeatures;

  const FeaturesEditor({super.key, required this.initialFeatures});

  @override
  _FeaturesEditorState createState() => _FeaturesEditorState();
}

class _FeaturesEditorState extends State<FeaturesEditor> {
  List<MapEntry<String, dynamic>> featuresEntries = [];

  @override
  void initState() {
    super.initState();
    featuresEntries = widget.initialFeatures;
  }

  void _addFeature() {
    setState(() {
      featuresEntries.add(const MapEntry('', ''));
    });
  }

  void _removeFeature(int index) {
    setState(() {
      featuresEntries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < featuresEntries.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Ключ ${i + 1}'),
                    onChanged: (value) {
                      featuresEntries[i] = MapEntry(value, featuresEntries[i].value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Значение ${i + 1}'),
                    onChanged: (value) {
                      featuresEntries[i] = MapEntry(featuresEntries[i].key, value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () => _removeFeature(i),
                ),
              ],
            ),
          ),
        TextButton(
          onPressed: _addFeature,
          child: const Text('Добавить особенность'),
        ),
      ],
    );
  }
}