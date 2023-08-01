//

//____________________________________________________________________

//
//
class SignUpUserEmptyException implements Exception {
  // final message = "Registration failure";
  // @override
  // String toString() {
  //   return message;
  // }
}

//--

class PublicErrorException implements Exception {
  String? erorMessage;
  String get message =>
      erorMessage ?? "Unknoun error happen ; public exception ";
  setError(String e) {
    erorMessage = e;
  }
}

//--
class UserNotFoundException implements Exception {}
