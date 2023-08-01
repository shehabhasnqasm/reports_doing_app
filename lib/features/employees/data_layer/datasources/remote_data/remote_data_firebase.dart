import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reports_doing_app/core/errors/users/exceptions.dart';
import 'package:reports_doing_app/features/employees/data_layer/models/user_model.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';

abstract class RemoteData {
  Future<bool> isSignin();
  Future<String> getCurrentUserId();
  Future<UserModel?> getUserInfo(String userId);

  Future<String?> login(UserData user);
  // Future<UserModel> signInUser(UserData user);
  Future<bool> checkIsFounsUserinAuthByuid(String userId);
  Future<void> deleteUserFromAuthByUserid(String userId);
  Future<String> registerNewUser(UserData user);
  Future<String> saveProfileCreatedUserToStorage(String imgUrl, String userId);
  Future<UserModel?> addCreatedUserToFirestore(
      String userId, UserData userData, String userStorageUrl);
  Future<void> deletImgFromStorage(String userId);

  Future<void> signOut();
}

class RemoteDataImp implements RemoteData {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  RemoteDataImp(
      {required this.auth,
      required this.firestore,
      required this.firebaseStorage});

//----------------------------------------
  @override
  Future<bool> isSignin() async => auth.currentUser?.uid != null;
  @override
  Future<String> getCurrentUserId() async => auth.currentUser!.uid;

  @override
  Future<UserModel?> getUserInfo(String userId) async {
    UserModel? userModel;
    try {
      var userCollectionRef = firestore.collection("users");
      var userData = await userCollectionRef.doc(userId).get();
      if (userData.exists) {
        userModel = UserModel.fromSnapshot(userData);
      } else {
        userModel = null;
      }
      return userModel;
      // return userModel == null ? Future.value(userModel) : Future.value(null);
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } on FirebaseException catch (e) {
      throw PublicErrorException().setError(e.message ?? e.code);
    }
  }

//----------------------------------------------
// --------------- sign in -------

  @override
  Future<String?> login(UserData user) async {
    try {
      final User? firebaseUser = (await auth.signInWithEmailAndPassword(
              email: user.email, password: user.password))
          .user;
      if (firebaseUser != null) {
        return firebaseUser.uid;
      } else {
        return Future.value(null);
      }
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case "invalid-email":
          throw SignInInvalidEmailException();
        case "user-disabled":
          throw SignInUserDisabledException();
        case "user-not-found":
          throw SignInUserNotFoundException();
        case "wrong-password":
          throw SignInWrongPasswordException();
        default:
          throw SignInInvalidCredentialsException();
      }
    } on SocketException catch (e) {
      throw SocketException(e.message); // this is function from dart
      // throw OfflineException();//or
    } on FirebaseException catch (e) {
      throw PublicErrorException().setError(e.toString());
    }
  }

//___________________________________________________
  // @override
  // Future<UserModel> signInUser(UserData user) async {
  //   try {
  //     final User? firebaseUser = (await auth.signInWithEmailAndPassword(
  //             email: user.email, password: user.password))
  //         .user;
  //     late UserModel userModel;
  //     if (firebaseUser == null) {
  //       throw SignInInvalidCredentialsException();
  //     } else {
  //       final userId = firebaseUser.uid;
  //       final userCollectionRef = firestore.collection("users");
  //       userCollectionRef.doc(userId).get().then((value) {
  //         if (value.exists) {
  //           userModel = UserModel.fromSnapshot(value);
  //         }
  //       });
  //     }
  //     return userModel;
  //   } on FirebaseAuthException catch (exception) {
  //     switch (exception.code) {
  //       case "invalid-email":
  //         throw SignInInvalidEmailException();
  //       case "user-disabled":
  //         throw SignInUserDisabledException();
  //       case "user-not-found":
  //         throw SignInUserNotFoundException();
  //       case "wrong-password":
  //         throw SignInWrongPasswordException();
  //       default:
  //         throw SignInInvalidCredentialsException();
  //     }
  //   } on SocketException catch (e) {
  //     throw SocketException(e.message); // this is function from dart
  //     // throw OfflineException();//or
  //     //throw SignInOtherException().setError(e.toString());// or
  //   } on FirebaseException catch (e) {
  //     throw SignInOtherException().setError(e.toString());
  //     //or
  //     //rethrow;
  //   }
  // }
//-----------------------------------------------------

  @override
  Future<bool> checkIsFounsUserinAuthByuid(String userId) async {
    try {
      final user = await auth
          .userChanges()
          .firstWhere((element) => element?.uid == userId);
      if (user != null) {
        return Future.value(true);
      } else {
        return Future.value(false);
        //throw UserNotFoundException();
      }
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } on FirebaseException catch (e) {
      throw PublicErrorException().setError(e.toString());
    }
  }

//--------------------------------------------------------

  @override
  Future<void> deleteUserFromAuthByUserid(String userId) async {
    final currentUserId = auth.currentUser!.uid;
    if (auth.currentUser != null) {
      if (currentUserId == userId) {
        await auth.currentUser!.delete().then((value) {}).catchError((error) {
          throw PublicErrorException().setError(error.toString());
        });
      }
    } else {
      await auth
          .userChanges()
          .firstWhere((element) => element!.uid == userId)
          .then((value) {
        value!.delete();
      }).catchError((error) {
        throw PublicErrorException().setError(error.toString());
      });
    }
  }

//---------------------------------------------------------
//------------------ sign up -----------------------
  @override
  Future<String> registerNewUser(UserData userData) async {
    try {
      final firebaseUser = await auth.createUserWithEmailAndPassword(
          email: userData.email.trim().toLowerCase(),
          password: userData.password.trim());
      final userId = firebaseUser.user!.uid;
      return userId;
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case "email-already-in-use":
          throw SignUpEmailAlreadyInUseException();
        case "invalid-email":
          throw SignUpInvalidEmailException();
        case "operation-not-allowed":
          throw SignUpOperationNotAllowedException();
        case "weak-password":
          throw SignUpWeakPasswordException();
        default:
          throw SignUpUserEmptyException()
              .setError(exception.message ?? exception.code);
      }
    } on SocketException catch (e) {
      throw SocketException(e.message); // this is function from dart
    } catch (e) {
      throw PublicErrorException().setError(e.toString());
    } on FirebaseException catch (e) {
      throw PublicErrorException().setError(e.toString());
    }
  }

//--- ---------------------------------------------------
  @override
  Future<String> saveProfileCreatedUserToStorage(
      String imgUrl, String userId) async {
    try {
      String? userStorageUrl;
      final storage =
          firebaseStorage.ref().child('users_Imgs').child('$userId.jpg');
      await storage.putFile(File(imgUrl));
      userStorageUrl = await storage.getDownloadURL();
      return userStorageUrl;
      // if (userStorageUrl != null) {
      //   return userStorageUrl;
      // } else {
      //   throw NotGetImgUrlFromStorageException();
      // }

    } on FirebaseException catch (e) {
      await deleteUserFromAuthByUserid(userId);
      throw StorageException().setError(e.toString());
    } on SocketException catch (e) {
      await deleteUserFromAuthByUserid(userId);
      throw SocketException(e.message);
    }
  }

//--------------------------------------------------------
  @override
  Future<void> deletImgFromStorage(String userId) async {
    final ref = firebaseStorage.ref().child('users_Imgs');
    await ref.child("$userId.jpg").getDownloadURL().then((value) {
      if (value.isEmpty) {
      } else {
        ref.child("$userId.jpg").delete();
      }
    }).catchError((error) {
      throw StorageException().setError(error.toString());
    });
  }

//----------------------------------------------
  @override
  Future<UserModel?> addCreatedUserToFirestore(
      String userId, UserData userData, String userStorageUrl) async {
    try {
      UserModel? userModel = UserModel(
        uid: userId,
        name: userData.name ?? '',
        email: userData.email,
        phoneNumber: userData.phoneNumber ?? '',
        profileUrl: userStorageUrl,
        positionInCompany: userData.positionInCompany ?? '',
        createdAt: Timestamp.now(), //DateTime.now(), //
        active: true,
      );
      final userCollectionRef = firestore.collection("users");
      return userCollectionRef.doc(userId).get().then((value) async {
        final newUser = UserModel(
          uid: userId,
          name: userData.name ?? '',
          email: userData.email,
          phoneNumber: userData.phoneNumber ?? '',
          profileUrl: userStorageUrl,
          positionInCompany: userData.positionInCompany ?? '',
          createdAt: Timestamp.now(), //DateTime.now(), //
          active: true,
        ).toDocument();
        if (!value.exists) {
          await userCollectionRef.doc(userId).set(newUser);
          var value = await userCollectionRef.doc(userId).get();
          userModel = UserModel.fromSnapshot(value);
          return userModel;
        } else if (value.exists) {}
        return userModel;
      });
      // return userModel;
    } on FirebaseException catch (e) {
      await deleteUserFromAuthByUserid(userId);
      await deletImgFromStorage(userId);
      throw AddUserToFirestorException().setError(e.toString());
    } on SocketException catch (e) {
      await deleteUserFromAuthByUserid(userId);
      await deletImgFromStorage(userId);
      throw SocketException(e.message);
    }
  }

//-------------- sign out --------------------------------------
  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on SocketException catch (e) {
      throw SocketException(e
          .message); // this is function from dart ; for check internet connection
    } on FirebaseException catch (e) {
      throw SignOutErrorException().setError(e.toString());
    }
  }
}
