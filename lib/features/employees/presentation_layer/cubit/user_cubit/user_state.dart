part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class LoadingUserState extends UserState {
  @override
  List<Object> get props => [];
}

class SuccessRegisterState extends UserState {
  final UserEntity? user;
  const SuccessRegisterState({required this.user});
}

/////
class SuccessLoginState extends UserState {
  final String userId;
  const SuccessLoginState({required this.userId});
  @override
  List<Object> get props => [userId];
}

//--
class FailureLoginState extends UserState {
  final String errorMsg;
  const FailureLoginState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
////

class FailureRegisterState extends UserState {
  final String errorMsg;
  const FailureRegisterState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}





// class ErrorMsgAuthState extends AuthState {
//   final String errorMsg;
//   const ErrorMsgAuthState({required this.errorMsg});
//   @override
//   List<Object> get props => [errorMsg];
// }
