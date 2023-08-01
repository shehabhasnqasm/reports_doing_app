import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_entity.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/delete_user_f_auth_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/register_user_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/sign_in_user_usecase%20.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignInUserUseCase signInUserUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final DeleteUserFromAuthUseCase deleteUserFromAuthUseCase;
  UserCubit(
      {required this.signInUserUseCase,
      required this.registerUserUseCase,
      required this.deleteUserFromAuthUseCase})
      : super(UserInitial());

//-------------------------------------------------------
  // Future<void> signIn(UserData userData) async {
  //   emit(LoadingUserState());
  //   final userEntityOrFailure = await signInUserUseCase(userData);
  //   userEntityOrFailure.fold(
  //       (failure) => emit(FailureUserState(errorMsg: signInErrorMsgs(failure))),
  //       (userEntity) => emit(SuccessUserState(user: userEntity)));
  // }

//-- -----------------------------------------------------
  Future<void> login(UserData userData) async {
    emit(LoadingUserState());
    final userId = await signInUserUseCase.login(userData);
    userId.fold((failure) {
      emit(FailureLoginState(errorMsg: loginErrorMsg(failure)));
    }, (uid) {
      if (uid != null) {
        emit(SuccessLoginState(userId: uid));
      } else {
        emit(FailureLoginState(errorMsg: SignInUserNotFoundFailure().message));
      }
    });
  }

//--------------------------------------------------------
  Future<void> registerNewUser(UserData userData) async {
    emit(LoadingUserState());
    final userIdOrFailure = await registerUserUseCase(userData);
    userIdOrFailure.fold((failure) {
      emit(FailureRegisterState(errorMsg: registerErrorMsgs(failure)));
      return;
    }, (uid) async {
      final getImgUrlOrFailure =
          await registerUserUseCase.saveImgToStorage(userData.profileUrl!, uid);

      getImgUrlOrFailure.fold((failure) async {
        //await deleteUserFromAuthUseCase.call(uid);
        emit(FailureRegisterState(
            errorMsg: saveImgUserToStorageErrorMsgs(failure)));
        return;
      }, (imgUrl) async {
        final addToFstoreOrFailure =
            await registerUserUseCase.addUserToFirestore(uid, userData, imgUrl);

        addToFstoreOrFailure.fold((failure) async {
          // await registerUserUseCase.deletImgFromStorage(uid);
          //var ff = await deleteUserFromAuthUseCase.call(uid);
          emit(FailureRegisterState(
              errorMsg: addUserToFirestoreErrorMsgs(failure)));
          return;
        }, (userEntity) => emit(SuccessRegisterState(user: userEntity)));
      });
    });
  }
}

//-------------------------------------------------

// String signInErrorMsgs(Failure failure) {
//   switch (failure.runtimeType) {
//     case SignInInvalidCredentialsFailure:
//       return SignInInvalidCredentialsFailure().message;
//     case SignInInvalidEmailFailure:
//       return SignInInvalidEmailFailure().message;
//     case SignInUserDisabledFailure:
//       return SignInUserDisabledFailure().message;
//     case SignInUserNotFoundFailure:
//       return SignInUserNotFoundFailure().message;
//     case SignInWrongPasswordFailure:
//       return SignInWrongPasswordFailure().message;
//     case SignInOtherFailure:
//       return SignInOtherFailure().message;
//     case OfflineFailure:
//       return OfflineFailure().message;

//     default:
//       return "unknown error when sign in ";
//   }
// }

// --- ----------------------------------------------------
String loginErrorMsg(Failure failure) {
  switch (failure.runtimeType) {
    case SignInInvalidEmailFailure:
      return SignInInvalidEmailFailure().message;
    case SignInUserDisabledFailure:
      return SignInUserDisabledFailure().message;
    case SignInUserNotFoundFailure:
      return SignInUserNotFoundFailure().message;
    case SignInWrongPasswordFailure:
      return SignInWrongPasswordFailure().message;
    case SignInInvalidCredentialsFailure:
      return SignInInvalidCredentialsFailure().message;
    case OfflineFailure:
      return OfflineFailure().message;

    default:
      return "unknown error when sign in in F_Auth ";
  }
}

//-----------------------------------------------------------
String registerErrorMsgs(Failure failure) {
  switch (failure.runtimeType) {
    case SignUpUserEmptyFailure:
      return SignUpUserEmptyFailure().message;
    case SignUpEmailAlreadyInUseFailure:
      return SignUpEmailAlreadyInUseFailure().message;
    case SignUpInvalidEmailFailure:
      return SignUpInvalidEmailFailure().message;
    case SignUpOperationNotAllowedFailure:
      return SignUpOperationNotAllowedFailure().message;
    case SignUpWeakPasswordFailure:
      return SignUpWeakPasswordFailure().message;
    case SignUpOtherFailure:
      return SignUpOtherFailure().message;
    case OfflineFailure:
      return OfflineFailure().message;
    default:
      return "unknown error when register new user ";
  }
}

//-----------------------------------------------------------
String saveImgUserToStorageErrorMsgs(Failure failure) {
  switch (failure.runtimeType) {
    case StorageFailure:
      return StorageFailure().message;
    case OfflineFailure:
      return OfflineFailure().message;
    default:
      return "unknown error ; firebase storage ";
  }
}

//-----------------------------------------------------
String addUserToFirestoreErrorMsgs(Failure failure) {
  switch (failure.runtimeType) {
    case AddUserToFirestorFailure:
      return AddUserToFirestorFailure().message;
    case OfflineFailure:
      return OfflineFailure().message;
    default:
      return "unknown error ; firebase Firestore ";
  }
}


//---------------------------------------------------