import 'package:get/get.dart';

import '../../../data/repositories/banners/banner_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/banner_model.dart';

class BannerController extends GetxController {

  final isLoading = false.obs;
  final carouselCurrentIndex = 0.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  /// Получение баннеров
  Future<void> fetchBanners() async {
    try {
      // Показывать загрузчик, пока загружается баннер
      isLoading.value = true;

      // Получение баннеров
      final bannerRepository = Get.put(BannerRepository());
      final banners = await bannerRepository.fetchBanners();

      // Assign banners
      this.banners.assignAll(banners);

    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      // Уберает загрузчик
      isLoading.value = false;
    }
  }

  /// Редактирование баннера
  Future<void> editBanner(BannerModel banner) async {
    try {
      isLoading.value = true;
      final bannerRepository = Get.put(BannerRepository());
      await bannerRepository.updateBanner(banner);
      final index = banners.indexWhere((b) => b.id == banner.id);
      if (index != -1) {
        banners[index] = banner;
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Добавление баннера
  Future<void> addBanner(BannerModel banner) async {
    try {
      isLoading.value = true;
      final bannerRepository = Get.put(BannerRepository());
      final newBanner = await bannerRepository.addBanner(banner);
      banners.add(newBanner);
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Удаление баннера
  Future<void> deleteBanner(String bannerId) async {
    try {
      isLoading.value = true;
      final bannerRepository = Get.put(BannerRepository());
      await bannerRepository.deleteBanner(bannerId);
      banners.removeWhere((b) => b.id == bannerId);
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}