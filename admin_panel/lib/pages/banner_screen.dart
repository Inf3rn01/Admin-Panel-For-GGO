import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/controllers/banner_controller.dart';
import 'package:admin_panel/models/banner_model.dart';

class BannersScreen extends StatelessWidget {
  BannersScreen({super.key});

  final BannerController bannerController = Get.put(BannerController());

  void _showAddEditDialog(BuildContext context, [BannerModel? banner]) {
    final isEditing = banner != null;
    final TextEditingController imageUrlController = TextEditingController(text: banner?.imageUrl ?? '');
    bool active = banner?.active ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Изменить' : 'Добавить'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Ссылка на изображение'),
                  ),
                  CheckboxListTile(
                    title: Text(active ? 'Активен' : 'Не активен'),
                    value: active,
                    onChanged: (value) {
                      setState(() {
                        active = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final newBanner = BannerModel(
                  id: banner?.id ?? '',
                  imageUrl: imageUrlController.text,
                  active: active,
                );
                if (isEditing) {
                  bannerController.editBanner(newBanner);
                } else {
                  bannerController.addBanner(newBanner);
                }
                Navigator.of(context).pop();
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
        if (bannerController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 815,
            columns: const [
              DataColumn(label: Text('Изображение')),
              DataColumn(label: Text('Статус')),
              DataColumn(label: Text('Действия')),
            ],
            rows: bannerController.banners.map((banner) {
              return DataRow(
                cells: [
                  DataCell(
                    CachedNetworkImage(
                      imageUrl: banner.imageUrl,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DataCell(Text(banner.active ? 'Активен' : 'Не активен')),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showAddEditDialog(context, banner);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Удалить баннер'),
                                  content: const Text('Вы уверены, что хотите удалить баннер?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Отменить'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        bannerController.deleteBanner(banner.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Удалить'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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