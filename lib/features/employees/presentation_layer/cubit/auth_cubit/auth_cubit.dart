import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_entity.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/delete_user_f_auth_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/get_curent_user_id_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/get_user_info.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/is_sign_in_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/sign_out_usecase.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserIdUseCase getCurrentUserIdUseCase;
  final GetUserInfoUseCase getUserInfoUseCase;
  final DeleteUserFromAuthUseCase deleteUserFromAuthUseCase;
  AuthCubit(
      {required this.isSignInUseCase,
      required this.signOutUseCase,
      required this.getCurrentUserIdUseCase,
      required this.getUserInfoUseCase,
      required this.deleteUserFromAuthUseCase})
      : super(LoadingAuthState());
//------------------------------------------
  Future<void> appStarted() async {
    emit(LoadingAuthState());
    final isSignIn = await isSignInUseCase();
    if (isSignIn) {
      final uid = await getCurrentUserIdUseCase();
      final data = await getUserInfoUseCase.call(uid);
      data.fold(
          (failure) => emit(
              ErrorMsgFirestoreState(errorMsg: firestoreErrorMsgs(failure))),
          ((userInfo) async {
        if (userInfo != null) {
          emit(AuthenticatedState(userEntity: userInfo));
        } else if (userInfo == null) {
          emit(NotGetInfoFromFirestoreState());
        }
      }));
    } else {
      emit(UnAuthenticatedState());
    }
  }

//------------------------------------------------------
  Future<void> loggedIn() async {
    emit(LoadingAuthState());
    final uid = await getCurrentUserIdUseCase();
    final data = await getUserInfoUseCase.call(uid);
    data.fold(
        (failure) =>
            emit(ErrorMsgFirestoreState(errorMsg: firestoreErrorMsgs(failure))),
        (userInfo) {
      if (userInfo != null) {
        emit(AuthenticatedState(userEntity: userInfo));
      } else {
        emit(NotGetInfoFromFirestoreState());
      }
    });
  }

//--------------------------------
  Future<void> loggedOut() async {
    emit(LoadingAuthState());
    final success = await signOutUseCase();
    success.fold(
        (failure) =>
            emit(ErrorMsgFirestoreState(errorMsg: logoutErrorMsgs(failure))),
        (unit) => emit(UnAuthenticatedState()));
  }

//------------------------------------
  Future<void> deleteUserAuth() async {
    emit(LoadingAuthState());
    final uid = await getCurrentUserIdUseCase();
    await deleteUserFromAuthUseCase.call(uid).then((value) {
      value.fold((l) => null, (r) => null);
    });
    // await deleteUserFromAuthUseCase.call(uid);
    await deleteUserFromAuthUseCase.deletUserImgFromStorage(uid);
    emit(UnAuthenticatedState());
  }
}

//---------------------------------------------------
String logoutErrorMsgs(Failure failure) {
  switch (failure.runtimeType) {
    case SignOutErrorFailure:
      return SignOutErrorFailure().message;
    case OfflineFailure:
      return OfflineFailure().message;
    default:
      return "unknown error when log out ";
  }
}

//-------------------------------------------------------
String firestoreErrorMsgs(Failure failure) {
  switch (failure.runtimeType) {
    case PublicErrorFailure:
      return PublicErrorFailure().message;
    case OfflineFailure:
      return OfflineFailure().message;
    default:
      return "unknown error when get user info from firestore ";
  }
}
