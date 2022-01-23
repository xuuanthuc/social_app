class Validator {
  static const emailPattern =
      r'^[a-zA-Z0-9](([.]{1}|[_]{1})?[a-zA-Z0-9])*[@]([a-z0-9]+([.]{1}|-)?)*[a-zA-Z0-9]+[.]{1}[a-z]{2,253}$';
  static const formalPattern = r'^[A-Za-z0-9_.]+$';

  static bool isMatchedPattern(String pattern, dynamic input) {
    if (!RegExp(pattern).hasMatch(input)) {
      return false;
    }

    return true;
  }

  static bool isPhone(String phone) {
    return RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b').hasMatch(phone);
  }

  static bool isUsername(String phone) {
    return RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$')
        .hasMatch(phone);
  }

  static bool isEmail(String email) {
    if (email.isEmpty ||
        email.length < 6 ||
        !isMatchedPattern(emailPattern, email)) {
      return false;
    }

    return true;
  }
}

class TextFieldValidator {
  static String? notEmptyValidator(String? string) {
    if (string?.trim().isEmpty ?? true) return 'Vui lòng điền thông tin';
    return null;
  }

  static String? usernameValidator(String? string) {
    // if (!Validator.isUsername(string ?? '')) {
    //   return 'Tên người dùng không hợp lệ';
    // }
    // return null;
    if (string != null && string.length >= 3) {
      return null;
    }
    return 'Tên người dùng không hợp lệ';
  }

  static String? numberValidator(String? string) {
    if (double.tryParse(string?.replaceAll(',', '') ?? '') == null) {
      return 'Số không hợp lệ';
    }
    return null;
  }

  static String? emailValidator(String? string) {
    if (!Validator.isEmail(string ?? '')) return 'Email không hợp lệ';
    return null;
  }

  static String? formalValidator(String? string) {
    if (string?.trim() == '') return null;
    if (!RegExp(Validator.formalPattern).hasMatch(string ?? '')) {
      return """dấu _ , a-z , 0-9""";
    }
    return null;
  }

  static String? phoneValidator(String? string) {
    if (!Validator.isPhone(string ?? '')) return 'Số điện thoại không hợp lệ';
    return null;
  }

  static String? passValidator(String? string) {
    if (string != null && string.length >= 6) {
      return null;
    }
    return 'Cần bằng hoặc nhiều hơn 6 kí tự';
  }
}
