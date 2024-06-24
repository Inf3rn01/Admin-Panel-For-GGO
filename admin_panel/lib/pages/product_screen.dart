import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/controllers/product_controller.dart';
import 'package:admin_panel/controllers/category_controller.dart';
import 'package:admin_panel/models/product_models.dart';
import 'package:admin_panel/models/category_models.dart';
import '../data/repositories/products/product_repository.dart';
import '../models/product_features_model.dart';

class ProductScreen extends StatelessWidget {
  final ProductController _productController = Get.put(ProductController());
  final CategoryController _categoryController = Get.put(CategoryController());
  final ProductRepository _productRepository = Get.put(ProductRepository()); 

  ProductScreen({super.key});

void _showAddEditDialog(BuildContext context, [ProductModel? product]) {
    final isEditing = product != null;
    final TextEditingController titleController = TextEditingController(text: product?.title ?? '');
    final TextEditingController priceController = TextEditingController(text: product?.price.toString() ?? '');
    final TextEditingController descriptionController = TextEditingController(text: product?.description ?? '');
    final TextEditingController imageUrlController = TextEditingController(text: product?.images?.join('\n') ?? '');
    final List<MapEntry<TextEditingController, TextEditingController>> featureControllers = [];

    if (product?.productFeatures != null) {
      product!.productFeatures!.features.forEach((key, value) {
        featureControllers.add(MapEntry(TextEditingController(text: key), TextEditingController(text: value.toString())));
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Редактировать продукт' : 'Добавить продукт'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: imageUrlController, decoration: const InputDecoration(labelText: 'URL фотографии'), maxLines: null),
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Название')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Цена'), keyboardType: TextInputType.number),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Описание')),
                ...featureControllers.map((entry) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: entry.key,
                          decoration: const InputDecoration(labelText: 'Название поля'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: entry.value,
                          decoration: const InputDecoration(labelText: 'Значение поля'),
                        ),
                      ),
                    ],
                  );
                }),
                TextButton(
                  onPressed: () {
                    featureControllers.add(MapEntry(TextEditingController(), TextEditingController()));
                  },
                  child: const Text('Добавить новое поле'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена')),
            TextButton(
              onPressed: () async {
                final Map<String, dynamic> features = {};
                for (var entry in featureControllers) {
                  if (entry.key.text.isNotEmpty && entry.value.text.isNotEmpty) {
                    features[entry.key.text] = entry.value.text;
                  }
                }

                final newProduct = ProductModel(
                  id: product?.id ?? '',
                  title: titleController.text,
                  price: double.parse(priceController.text),
                  description: descriptionController.text,
                  categoryId: product?.categoryId ?? '',
                  isFeatured: product?.isFeatured ?? false,
                  images: imageUrlController.text.split('\n').where((url) => url.isNotEmpty).toList(),
                  productFeatures: ProductFeaturesModel(features: features),
                );
                if (isEditing) {
                  await _productRepository.updateProduct(newProduct.id, newProduct);
                } else {
                  await _productRepository.createProduct(newProduct);
                }
                Navigator.of(context).pop();
                _productController.fetchFeaturedProducts();
              },
              child: const Text('Сохранить'),
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
                        DataCell(
                          product.images != null && product.images!.isNotEmpty
                              ? Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: product.images!.map((url) {
                                    return Image.network(
                                      url,
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
                                    );
                                  }).toList(),
                                )
                              : const Text('Нет фото'),
                        ),
                        DataCell(Text(product.title)),
                        DataCell(Text(category.name)),
                        DataCell(Text(product.price.toString())),
                        DataCell(Container(
                          width: 445,
                          child: Text(
                            product.description ?? '',
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        DataCell(Container(
                          width: 445,
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