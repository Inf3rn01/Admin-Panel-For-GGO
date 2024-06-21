import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/repositories/products/product_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/product_models.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final isLoading = false.obs;
  RxList<ProductModel> product = <ProductModel>[].obs;
  final productRepository = Get.put(ProductRepository());

  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  Future<void> fetchFeaturedProducts() async {
  try {
    isLoading.value = true;
    final products = await productRepository.getFeaturedProducts();
    product.assignAll(products);
    allProducts.assignAll(products);
  } catch (e) {
    Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
  } finally {
    isLoading.value = false;
  }
}

  ProductModel getProductById(String productId) {
  return allProducts.firstWhere((product) => product.id == productId, orElse: () => ProductModel.empty());
}

  String getProductPrice(ProductModel product) {
    return product.price.toStringAsFixed(2);
  }

  void fetchProductsByCategory(String categoryId) async {
    try {
      isLoading.value = true;
      final products = await productRepository.getProductsByCategory(categoryId);
      allProducts.assignAll(products);
      filteredProducts.assignAll(products);
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      product.assignAll(allProducts);
    } else {
      product.assignAll(
        allProducts.where((product) =>
          product.title.toLowerCase().contains(query.toLowerCase())
        ).toList()
      );
    }
  }
  
  void filterProductsByOption(String? option) {
    if (option == null || option.isEmpty) {
      filteredProducts.assignAll(allProducts);
      return;
    }

    switch (option) {
      case 'По алфавиту':
        filteredProducts.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Высокая - Низкая цена':
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Низкая - Высокая цена':
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      default:
        filteredProducts.assignAll(allProducts);
        break;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await productRepository.addProduct(product);
    fetchFeaturedProducts();
  }

  Future<void> updateProduct(ProductModel product) async {
    await productRepository.updateProduct(product);
    fetchFeaturedProducts();
  }

  Future<void> deleteProduct(String productId) async {
    await productRepository.deleteProduct(productId);
    fetchFeaturedProducts();
  }

  Future<void> updateProductFeaturedStatus(String productId, bool isFeatured) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .update({'IsFeatured': isFeatured});

      final productIndex = allProducts.indexWhere((product) => product.id == productId);
      if (productIndex != -1) {
        allProducts[productIndex].isFeatured = isFeatured;
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating product featured status: $e");
      }
    }
  }
}