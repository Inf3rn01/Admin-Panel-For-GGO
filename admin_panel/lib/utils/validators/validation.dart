class GValidator {

  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty){
      return 'Введите $fieldName';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите адрес электронной почты';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Неверный адрес электронной почты';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty){
      return 'Введите пароль';
    }
  
    if (value.length < 6) {
      return 'Длина пароля должна составлять не менее 6 символов';
    }

    if (!value.contains(RegExp(r'[A-ZА-Я]'))) {
      return 'Пароль должен содержать хотя бы одну заглавную букву';
    }
    return null;
  }

  static String? validateNumberPhone(String? value) {
    if (value == null || value.isEmpty){
      return 'Введите номер телефона';
    }

    final phoneRegExp = RegExp(r'^\d{11}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Неверный формат телефонного номера. Требуется 11 цифр)';
    }
    return null;
  }
}
