// sign up failures
//
abstract class ReportFailure {
  //String  message = "Registration Error";

}

class SignUpUserEmptyFailure extends ReportFailure {
  final message = "Registration failure ";
}

//---- PublicErrorFailure
class PublicErrorFailure extends ReportFailure {
  String? erorMessage;
  String get message => erorMessage ?? "an error ; public error !";
  setError(String e) {
    erorMessage = e;
  }
}

class OfflineReportFailure extends ReportFailure {
  final message = "No internet connection !";
}
