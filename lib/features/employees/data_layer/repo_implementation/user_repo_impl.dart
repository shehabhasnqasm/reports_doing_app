import 'dart:io';

import 'package:reports_doing_app/core/errors/users/exceptions.dart';
import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/core/network/check_internet.dart';
import 'package:reports_doing_app/features/employees/data_layer/datasources/remote_data/remote_data_firebase.dart';
import 'package:reports_doing_app/features/employees/data_layer/models/user_model.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';
import 'package:dartz/dartz.dart';

class UserRepoImpl implements UserRepo {
  RemoteData remoteDataFirebase;
  CheckInternet checkInternet;
  UserRepoImpl({required this.remoteDataFirebase, required this.checkInternet});
//----------------------------------------------------------------
  @override
  Future<bool> isSignin() async => remoteDataFirebase.isSignin();
//------------------------------------------------------------
  @override
  Future<String> getCurrentUserId() async =>
      remoteDataFirebase.getCurrentUserId();
//------------------------------------------------
  @override
  Future<Either<Failure, UserModel?>> getUserInfo(String userId) async {
    try {
      final userModel = await remoteDataFirebase.getUserInfo(userId);
      if (userModel != null) {
        return Right(userModel);
      } else {
        return const Right(null);
      }
    } on PublicErrorException {
      return left(PublicErrorFailure());
    } on SocketException {
      return left(OfflineFailure());
    } catch (e) {
      return left(PublicErrorFailure().setError(e.toString()));
    }
  }
//--------------------------------------------------------------

  @override
  Future<Either<Failure, String?>> login(UserData user) async {
    try {
      final userId = await remoteDataFirebase.login(user);
      if (userId != null) {
        return right(userId);
      } else {
        return right(null);
      }
    } on SignInInvalidEmailException {
      return left(SignInInvalidEmailFailure());
    } on SignInUserDisabledException {
      return left(SignInUserDisabledFailure());
    } on SignInUserNotFoundException {
      return left(SignInUserNotFoundFailure());
    } on SignInWrongPasswordException {
      return left(SignInWrongPasswordFailure());
    } on SignInInvalidCredentialsException {
      return left(SignInInvalidCredentialsFailure());
    } on SocketException {
      return left(OfflineFailure());
    }
  }
  //-------------------------------------------------------
/*
  @override
  Future<Either<Failure, UserModel>> signInUser(UserData userData) async {
    if (await checkInternet.isConnected) {
      try {
        final userModel = await remoteDataFirebase.signInUser(userData);
        return Right(userModel);
      } on SignInInvalidCredentialsException {
        return left(SignInInvalidCredentialsFailure());
      } on SignInInvalidEmailException {
        return left(SignInInvalidEmailFailure());
      } on SignInUserDisabledException {
        return left(SignInUserDisabledFailure());
      } on SignInUserNotFoundException {
        return left(SignInUserNotFoundFailure());
      } on SignInWrongPasswordException {
        return left(SignInWrongPasswordFailure());
      } on SignInOtherException {
        var error = SignInOtherException().error;
        return left(SignInOtherFailure().setError(error));
      } on SocketException {
        return left(OfflineFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }
  */
  //-------------------------------------------

  @override
  Future<Either<Failure, bool>> checkIsFounsUserinAuthByuid(
      String userId) async {
    try {
      final isFound =
          await remoteDataFirebase.checkIsFounsUserinAuthByuid(userId);
      return right(isFound);
    } on SocketException {
      return left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUserFromAuthByUserid(
      String userId) async {
    if (await checkInternet.isConnected) {
      try {
        await remoteDataFirebase.deleteUserFromAuthByUserid(userId);
        return right(unit);
      } on PublicErrorException {
        var error = PublicErrorException().error;
        return left(PublicErrorFailure().setError(error));
      }
      // on SocketException {
      //   return left(OfflineFailure());
      // }
    } else {
      return left(OfflineFailure());
    }
  }

  //---------------------------------------------------------------------

  @override
  Future<Either<Failure, String>> registerNewUser(UserData userData) async {
    if (await checkInternet.isConnected) {
      try {
        final userId = await remoteDataFirebase.registerNewUser(userData);
        return Right(userId);
      } on SignUpUserEmptyException {
        return left(SignUpUserEmptyFailure());
      } on SignUpEmailAlreadyInUseException {
        return left(SignUpEmailAlreadyInUseFailure());
      } on SignUpInvalidEmailException {
        return left(SignUpInvalidEmailFailure());
      } on SignUpOperationNotAllowedException {
        return left(SignUpOperationNotAllowedFailure());
      } on SignUpWeakPasswordException {
        return left(SignUpWeakPasswordFailure());
      } on SignUpOtherException {
        var error = SignUpOtherException().error;
        return left(SignUpOtherFailure().setError(error));
      } on SocketException {
        return left(OfflineFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }
//----  ---  -----   - ------ ---   --------

  @override
  Future<Either<Failure, String>> saveProfileCreatedUserToStorage(
      String imgUrl, String userId) async {
    if (await checkInternet.isConnected) {
      try {
        final userProfileStorageUrl = await remoteDataFirebase
            .saveProfileCreatedUserToStorage(imgUrl, userId);
        return Right(userProfileStorageUrl);
      } on StorageException {
        var error = StorageException().error;
        return left(StorageFailure().setError(error.toString()));
      } on SocketException {
        return left(OfflineFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }

//--
  @override
  Future<Either<Failure, Unit>> deletImgFromStorage(String userId) async {
    if (await checkInternet.isConnected) {
      try {
        await remoteDataFirebase.deletImgFromStorage(userId);
        return const Right(unit);
      } on StorageException {
        var error = StorageException().error;
        return left(StorageFailure().setError(error.toString()));
      } on SocketException {
        return left(OfflineFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }
  //----  ---  -----   - ------ ---   --------

  @override
  Future<Either<Failure, UserModel?>> addCreatedUserToFirestore(
      String userId, UserData userData, String userStorageUrl) async {
    if (await checkInternet.isConnected) {
      try {
        var userModel = await remoteDataFirebase.addCreatedUserToFirestore(
            userId, userData, userStorageUrl);
        return Right(userModel);
      } on AddUserToFirestorException {
        var error = AddUserToFirestorException().error;
        AddUserToFirestorFailure().setError(error);
        return left(AddUserToFirestorFailure());
      } on SocketException {
        return left(OfflineFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }

//--------------------------------------------------------------------
  @override
  Future<Either<Failure, Unit>> signOut() async {
    if (await checkInternet.isConnected) {
      try {
        await remoteDataFirebase.signOut();
        return right(unit);
      } on SocketException {
        return left(OfflineFailure());
      } on SignOutErrorException {
        return left(SignOutErrorFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }

//---------------------------------------------------------------------------
}
