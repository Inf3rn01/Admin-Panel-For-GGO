import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:admin_panel/data/repositories/user/user_repository.dart';
import 'package:admin_panel/authentication/screens/login/login.dart';

import '../../../navigation_menu.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/local_storage/storage_utility.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  

  /// Get authenticated user data
  User? get authUser => _auth.currentUser;

  /// Called from main.dart on app launch
  @override
  void onReady() {
    //FlutterNativeSplash.remove();
    screenRedirect();
  }
  
  /// Function to show relevant screen
  void screenRedirect() async {
    final user = _auth.currentUser;
    if(user != null) {
      if(user.emailVerified){
        await GLocalStorage.init(user.uid);
        Get.offAll(()=>const NavigationMenu());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  

/*-------------- Email & Password Sign In ------------*/

  ///[EmailAuthentication] - SignIn
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try{
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw GFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException();
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз';
    }
  }

  ///[EmailVerification] - Mail verification
  Future<void> sendEmailVerification() async {
    try{
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw GFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException();
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз';
    }
  }

  ///[EmailAuthentication] - Forget password
  Future<void> sendPasswordResetEmail(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw GFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException();
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз';
    }
  }

  ///[ReAuthenticate] - ReAuthenticate yser
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      // Create credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      
      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw GFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException();
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз';
    }
  }

  ///[LogoutUser] - Valid for any authentication
  Future<void> logout() async {
    try{
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw GFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException();
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз';
    }
  }

  ///[DeleteUser] - Remove user Auth and Firestore account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw GFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw GFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const GFormatException();
    } on PlatformException catch (e) {
      throw GPlatformException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так. Пожалуйста, попробуйте еще раз';
    }
  }
}
