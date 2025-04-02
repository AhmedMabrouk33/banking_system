extension CustomStringExtension on String {
  bool validated(String? validateInput) {
    if (length < 5) {
      print('The Min Length is 5 Characters');
    } else if ((validateInput != null) && (this != validateInput)) {
      print('Please Check your confirm Input');
    } else {
      return true;
    }
    return false;
  }
}
