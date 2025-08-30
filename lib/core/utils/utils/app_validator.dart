//ToDo :: Mohnd :: App Validator

class AppValidator {
  AppValidator._();
  static AppValidator? _instance;
  factory AppValidator() {
    _instance ??= AppValidator._();
    return _instance!;
  }
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "please enter name !";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "please enter password !";
    } else if (value.length <= 5) {
      return "password lenght should be more than 5";
    }
    return null;
  }

  String? confirmPasswordValidator(String? value, String? compareValue) {
    if (value == null || value.isEmpty) {
      return "please enter password !";
    }
    if (compareValue != value) {
      return "not match with password";
    }
    return null;
  }
}
