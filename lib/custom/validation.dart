bool isValidEmail(String? email) {
  if (email == null) return false;

  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);
}

bool isValidPassword(String? password) {
  if (password == null) return false;

  return RegExp(
    r'^.{6,}$',
  ).hasMatch(password);
}
bool isValidName(String? name) {
  if (name == null) return false;

  return RegExp(
    r'^[a-zA-Z\s]{3,30}$',
  ).hasMatch(name);
}

