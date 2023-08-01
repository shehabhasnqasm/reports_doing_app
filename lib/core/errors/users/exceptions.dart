// sign up exceptions
//
class SignUpUserEmptyException implements Exception {
  // final message = "Registration failure";
  // @override
  // String toString() {
  //   return message;
  // }
  String? erorMessage;
  String get error =>
      erorMessage ?? "Registration Error  ;; not registerd a new user !!";
  setError(String e) {
    erorMessage = e;
  }
}

class SignUpEmailAlreadyInUseException implements Exception {
  // final message = "Email Already In Use";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignUpInvalidEmailException implements Exception {
  // final message = "Invalid Email";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignUpOperationNotAllowedException implements Exception {
  // final message = "Registeration not allowed ";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignUpWeakPasswordException implements Exception {
  // final message = "Weak Password";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignUpOtherException implements Exception {
  //SignInOtherException(this.erorMessage);
  String? erorMessage;
  String get error => erorMessage ?? "Registration Error";
  setError(String e) {
    erorMessage = e;
  }
}

// SignIn
//-----------------------------------

class SignInInvalidCredentialsException implements Exception {
  // final message = "Invalid Login Or Password";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignInInvalidEmailException implements Exception {}

class SignInUserDisabledException implements Exception {
  // final message = "user disabled";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignInUserNotFoundException implements Exception {
  // final message = "user not found";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignInWrongPasswordException implements Exception {
  // final message = "wrong password";
  // @override
  // String toString() {
  //   return message;
  // }
}

class SignInOtherException implements Exception {
  //SignInOtherException(this.erorMessage);
  String? erorMessage;
  String get error => erorMessage ?? "Invalid Login Or Password";
  setError(String e) {
    erorMessage = e;
  }
}

// other exceptions
//----------------------------
class OfflineException implements Exception {}

class SignOutErrorException implements Exception {
  String? erorMessage;
  String get error => erorMessage ?? " Unknown sign out error";
  setError(String e) {
    erorMessage = e;
  }
}

class AddUserToFirestorException implements Exception {
  String? erorMessage;
  String get error => erorMessage ?? "an error when add user inf to firestore ";
  setError(String e) {
    erorMessage = e;
  }
}

// firebase storage
//class NotGetImgUrlFromStorageException implements Exception {}

class StorageException implements Exception {
  String? erorMessage;
  String get error => erorMessage ?? "an error  ; storage error ";
  setError(String e) {
    erorMessage = e;
  }
}

//--

class PublicErrorException implements Exception {
  String? erorMessage;
  String get error => erorMessage ?? "Unknoun error happen ; public exception ";
  setError(String e) {
    erorMessage = e;
  }
}

//--
class UserNotFoundException implements Exception {}
