part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

//class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  final UserEntity userEntity;
  const AuthenticatedState({required this.userEntity});
  @override
  List<Object> get props => [userEntity];
}

class UnAuthenticatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class ErrorMsgFirestoreState extends AuthState {
  final String errorMsg;
  const ErrorMsgFirestoreState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class NotGetInfoFromFirestoreState extends AuthState {
  @override
  List<Object> get props => [];
}
