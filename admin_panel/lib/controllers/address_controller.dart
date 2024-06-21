import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/models/address_model.dart';
import 'package:admin_panel/utils/constants/images_strings.dart';
import 'package:admin_panel/utils/helpers/network_manager.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';

import '../../../data/repositories/address/address_repository.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final country = TextEditingController();
  final city = TextEditingController();
  final street = TextEditingController();
  final house = TextEditingController();
  final apartament = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  @override
  void onInit () {
    super.onInit();
    getAllUserAddresses();
  }

  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddress();
      return addresses;
    } catch (e) {
      Loaders.errorSnackBar(title: 'Адрес не найден', message: e.toString());
      return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      if(selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(selectedAddress.value.id, false);
      }

      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      await addressRepository.updateSelectedField(selectedAddress.value.id, true);

    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка выбора', message: e.toString());
    }
  }

  Future addNewAddress() async {
    try {
      FullScreenLoader.openLoadingDialog('Сохранение адреса...', GImages.loading);

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected){
        FullScreenLoader.stopLoading();
        return;
      } 

      if (addressFormKey.currentState != null && !addressFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      final address = AddressModel(
        id: '',
        country: country.text.trim(),
        city: city.text.trim(),
        street: street.text.trim(),
        house: house.text.trim(),
        apartment: apartament.text.trim(),
      );

      final id = await addressRepository.addAddress(address);

      address.id = id;
      await selectAddress(address);

      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(title: 'Поздравляю!', message: 'Ваш адрес был успешно сохранён');

      refreshData.toggle();

      resetFormFields();

      Navigator.of(Get.context!).pop();

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Адрес не найден', message: e.toString());
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await addressRepository.deleteAddress(addressId);
      refreshData.toggle();
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ошибка удаления', message: e.toString());
    }
  }

  void resetFormFields() {
    country.clear();
    city.clear();
    street.clear();
    house.clear();
    apartament.clear();
    addressFormKey.currentState?.reset();
  }
}