import 'package:get/get.dart';
import 'package:admin_panel/data/repositories/categories/category_repository.dart';
import 'package:admin_panel/models/category_models.dart';
import 'package:admin_panel/utils/popups/loaders.dart';

import '../models/product_models.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  Rx<CategoryModel> selectedCategory = CategoryModel(id: '', name: '', image: '', isFeatured: false).obs;
  RxList<ProductModel> categoryProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Load category data
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final categories = await _categoryRepository.getAllCategories();

      allCategories.assignAll(categories);

      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured).take(5).toList());
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    await _categoryRepository.addCategory(category);
    fetchCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoryRepository.updateCategory(category);
    fetchCategories();
  }


  /// Load selected category data
  Future<void> loadSelectedCategoryData(String categoryId) async {
    try {

      isLoading.value = true;

      final category = await _categoryRepository.getCategoryById(categoryId);

      selectedCategory.value = category;
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Get category or sub-category products
  Future<void> getCategoryOrSubCategoryProducts(String categoryId) async {
    try {

      isLoading.value = true;

      final products = await _categoryRepository.getProductsByCategoryId(categoryId);

      categoryProducts.assignAll(products);
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  /// Удаление категории
  Future<void> removeCategory(String categoryId) async {
    try {

      isLoading.value = true;

      await _categoryRepository.removeCategoryById(categoryId);

      await fetchCategories();
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}