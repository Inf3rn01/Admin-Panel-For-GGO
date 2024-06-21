import 'package:get/get.dart';

import '../pages/banner_screen.dart';
import '../pages/cart_screen.dart';
import '../pages/category_screen.dart';
import '../pages/order_screen.dart';
import '../pages/product_screen.dart';
import '../pages/user_screen.dart';

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  final Rx<int> selectedIndex = 0.obs;
  final Rx<bool> isDrawerOpen = false.obs;

  final screens = [
    BannersScreen(),
    CategoryScreen(),
    ProductScreen(),
    CartScreen(),
    OrderScreen(),
    UserScreen()
  ];

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  String getSelectedPageTitle() {
    switch (selectedIndex.value) {
      case 0:
        return 'Баннеры';
      case 1:
        return 'Категории';
      case 2:
        return 'Продукты';
      case 3:
        return 'Корзины';
      case 4:
        return 'Заказы';
      case 5:
        return 'Пользователи';
      default:
        return 'Unknown';
    }
  }
}