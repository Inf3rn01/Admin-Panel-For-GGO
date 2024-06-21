import 'package:admin_panel/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import 'controllers/navigation_controller.dart';
import 'utils/constants/colors.dart';
import 'utils/constants/images_strings.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(navigationController.getSelectedPageTitle())),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: GColors.softGrey),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Obx(() => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: GColors.primary,
              ),
              child: Image(image: AssetImage(GImages.darkAppLogo), color: GColors.softGrey),
            ),
            _buildDrawerItem(
              context: context,
              icon: Iconsax.map_outline,
              title: 'Баннеры',
              index: 0,
              navigationController: navigationController,
              onTap: () {
                navigationController.selectedIndex.value = 0;
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Iconsax.map_1_outline,
              title: 'Категории',
              index: 1,
              navigationController: navigationController,
              onTap: () {
                navigationController.selectedIndex.value = 1;
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Iconsax.bag_outline,
              title: 'Продукты',
              index: 2,
              navigationController: navigationController,
              onTap: () {
                navigationController.selectedIndex.value = 2;
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: CupertinoIcons.shopping_cart,
              title: 'Корзины',
              index: 3,
              navigationController: navigationController,
              onTap: () {
                navigationController.selectedIndex.value = 3;
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Iconsax.truck_outline,
              title: 'Заказы',
              index: 4,
              navigationController: navigationController,
              onTap: () {
                navigationController.selectedIndex.value = 4;
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Iconsax.user_outline,
              title: 'Пользователи',
              index: 5,
              navigationController: navigationController,
              onTap: () {
                navigationController.selectedIndex.value = 5;
              },
            ),
            const SizedBox(height: 3),
            const Divider(),
            const SizedBox(height: 7),
            _buildDrawerItem(
              context: context,
              icon: FontAwesome.door_open_solid,
              title: 'Выйти из аккаунта',
              index: 6,
              navigationController: navigationController,
              onTap: () async {
                await userController.logout();
              },
            ),
          ],
        ),
      )),
      body: Obx(() => navigationController.screens[navigationController.selectedIndex.value]),
    );
  }

  ListTile _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int index,
    required NavigationController navigationController,
    required Function onTap,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: GColors.white),
      selected: navigationController.selectedIndex.value == index,
      onTap: () {
        onTap();
        Navigator.of(context).pop();
      },
    );
  }
}