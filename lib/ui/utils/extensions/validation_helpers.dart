// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/
String? isEmailValid(String email) {
  String? error;
  final exp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  if (email.isEmpty) {
    error = 'Please enter your registered email';
  } else if (!exp.hasMatch(email)) {
    error = 'Email is not in proper format, please check it again';
  }

  return error;
}

String? isPasswordValid(String password) {
  String? error;
  if (password.isEmpty || password.length < 6) {
    error = 'Password must be at-least 6 characters';
  }

  return error;
}

String? isUserNameValid(String name) {
  String? error;
  if (name.isEmpty) {
    error = 'User name must not be empty';
  }

  return error;
}

String? isValidAmount(String amount) {
  String? error;
  if (amount.isEmpty) {
    error = 'Amount must not be empty';
    return error;
  }
  final am = int.parse(amount);
  if (am <= 0) {
    error = 'Amount must be greater then 0';
    return error;
  }

  return error;
}

String? isBioValid(String bio) {
  String? error;
  if (bio.isEmpty || bio.length < 120) {
    error = 'Bio must be at-least 120 characters long.';
  }

  return error;
}

String? isConfirmPasswordValid(String password, String confirmPassword) {
  String? error;
  if (password != confirmPassword) {
    error = 'Password does not match, please correct it!';
  }

  return error;
}
