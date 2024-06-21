import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../popups/loaders.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> resultList) {
  final ConnectivityResult result = resultList.last;
  _connectionStatus.value = result;
  if (result == ConnectivityResult.none) {
    Loaders.errorSnackBar(title: 'Нет подключения к интернету!', message: 'Пожалуйста, проверьте подключение к Интернету и повторите попытку.');
  } else {
    Loaders.successSnackBar(title: 'Всё в порядке', message: 'У вас есть подключение к интернету.');
  }
}

  Future<bool> isConnected() async {
  try {
    final result = await _connectivity.checkConnectivity();
    
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print('PlatformException: ${e.message}');
    }
    return false;
  } catch (e) {
    if (kDebugMode) {
      print('Exception: ${e.toString()}');
    }
    return false;
  }
}

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}