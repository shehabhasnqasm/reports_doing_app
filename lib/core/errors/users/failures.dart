// sign up failures
//
abstract class Failure {
  //String  message = "Registration Error";

}

class SignUpUserEmptyFailure extends Failure {
  final message = "Registration failure ";
  String? erorMessage;
  String get error =>
      erorMessage ?? " unknown error when register a new user  ";
  setError(String e) {
    erorMessage = e;
  }
}

class SignUpEmailAlreadyInUseFailure extends Failure {
  final message = "Email Already In Use";
}

class SignUpInvalidEmailFailure extends Failure {
  final message = "Invalid Email";
}

class SignUpWeakPasswordFailure extends Failure {
  final message = "Weak Password";
}

class SignUpOperationNotAllowedFailure extends Failure {
  final message = "Registeration not allowed";
}

class SignUpOtherFailure extends Failure {
  String? erorMessage;
  String get message =>
      erorMessage ?? " unknown error when register user auth ";
  setError(String e) {
    erorMessage = e;
  }
}

// SignIn
//--------------------
class SignInInvalidCredentialsFailure extends Failure {
  final message = "Invalid Login Or Password";
}

class SignInInvalidEmailFailure extends Failure {
  final message = "Invalid Email";
}

class SignInUserDisabledFailure extends Failure {
  final message = "user disabled";
}

class SignInUserNotFoundFailure extends Failure {
  final message = "user not found";
}

class SignInWrongPasswordFailure extends Failure {
  final message = "wrong password";
}

class SignInOtherFailure extends Failure {
  String? erorMessage;
  String get message => erorMessage ?? " unknown error when sigin ";
  setError(String e) {
    erorMessage = e;
  }
}

// other failures
//----------------------------
class OfflineFailure extends Failure {
  final message = "No internet connection !";
}

class SignOutErrorFailure extends Failure {
  final message = " sign out error !";
}

class AddUserToFirestorFailure extends Failure {
  String? erorMessage;
  String get message =>
      erorMessage ?? "an error happen when add user to firestore";
  setError(String e) {
    erorMessage = e;
  }

  // String get erorMessage => error ?? "" an error happen when add user to firestore"";//
}

// // firebase storage failures

class StorageFailure extends Failure {
  String? erorMessage;
  String get message =>
      erorMessage ?? "an error when get storage img's url (getdownloadurl) ";
  setError(String e) {
    erorMessage = e;
  }
}

//---- PublicErrorFailure
class PublicErrorFailure extends Failure {
  String? erorMessage;
  String get message => erorMessage ?? "an error ; public error !";
  setError(String e) {
    erorMessage = e;
  }
}

//-
class UserNotFoundFailure extends Failure {
  final message = " user not registerd yet ! ;";
}
