import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class CheckInternet {
  Future<bool> get isConnected;
}

class CheckInternetImplement implements CheckInternet {
  final InternetConnectionChecker connectionChecker;
  const CheckInternetImplement({required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
