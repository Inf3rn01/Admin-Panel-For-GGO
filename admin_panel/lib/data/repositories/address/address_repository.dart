import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:admin_panel/data/repositories/authentication/authentication_repository.dart';

import '../../../models/address_model.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<AddressModel>> fetchUserAddress() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw 'Невозможно найти информацию о пользователе. Повторите попытку через несколько минут.';

      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnaphot(documentSnapshot)).toList();
      
    } catch (e) {
      throw 'Что-то пошло не так при получении информации об адресе. Повторите попытку позже.';
    }
  }

  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({'SelectedAddress': selected});

    } catch (e) {
      throw 'Невозможно обновить выбранный адрес. Повторите попытку позже.';
    }
  }

  Future<String> addAddress(AddressModel address) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentAddress = await _db.collection('Users').doc(userId).collection('Addresses').add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'При сохранении информации об адресе что-то пошло не так. Повторите попытку позже.';
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).delete();
    } catch (e) {
      throw 'Невозможно удалить адрес. Повторите попытку позже.';
    }
  }
}