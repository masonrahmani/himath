import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:himath/features/data/remote/models/cheatsheet_model.dart';
import 'package:himath/features/data/remote/models/content_model.dart';
import 'package:himath/features/data/remote/models/bookmark_model.dart';
import 'package:himath/features/data/remote/models/question_model.dart';
import 'package:himath/features/data/remote/models/subject_model.dart';
import 'package:himath/features/data/remote/models/user_model.dart';
import 'package:himath/features/domain/entities/cheatsheet_entity.dart';
import 'package:himath/features/domain/entities/content_entity.dart';
import 'package:himath/features/domain/entities/bookmark_entity.dart';
import 'package:himath/features/domain/entities/question_entity.dart';
import 'package:himath/features/domain/entities/subject_entity.dart';

import 'package:himath/features/domain/entities/user_entity.dart';
import 'firebase_remote_data_source.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookAuth;

  FirebaseRemoteDataSourceImpl(
      this.fireStore, this.auth, this.googleSignIn, this.facebookAuth);

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUId();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        name: user.name,
        uid: uid,
        email: user.email,
        about: user.about,
        location: user.location,
      ).toDocument();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
        return;
      } else {
        userCollection.doc(uid).update(newUser);
        print("user already exist");
        return;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> googleAuth() async {
    final usersCollection = fireStore.collection("users");

    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await account!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final information = (await auth.signInWithCredential(credential)).user;
      usersCollection.doc(auth.currentUser!.uid).get().then((user) async {
        if (!user.exists) {
          var uid = auth.currentUser!.uid;
          //TODO Initialize currentUser if not exist record
          var newUser = UserModel(
                  name: information!.displayName!,
                  email: information.email!,
                  location: "",
                  uid: information.uid)
              .toDocument();

          usersCollection.doc(uid).set(newUser);
        }
      }).whenComplete(() {
        print("New User Created Successfully");
      }).catchError((e) {
        print("getInitializeCreateCurrentUser ${e.toString()}");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signIn(UserEntity user) async {
    await auth.signInWithEmailAndPassword(
        email: user.email, password: user.password);
  }

  @override
  Future<void> signUp(UserEntity user) async {
    await auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
  }

  @override
  Future<void> getUpdateUser(UserEntity user) async {
    Map<String, dynamic> userInformation = Map();
    print(user.name);
    final userCollection = fireStore.collection("users");

    if (user.about != null && user.about != "")
      userInformation['about'] = user.about;
    if (user.name != null && user.name != "")
      userInformation["name"] = user.name;

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Stream<List<SubjectEntity>> getAllSubjects() {
    final subjectCollection = fireStore.collection("subjects");

    return subjectCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .map((docSnapshot) => SubjectModel.fromSnapshot(docSnapshot))
        .toList());
  }

  @override
  Stream<List<QuestionEntity>> getAllQuestions(String subId, String conId) {
    print(subId);
    print(conId);
    final vaccinationRef = fireStore
        .collection("subjects")
        .doc(subId)
        .collection("contents")
        .doc(conId)
        .collection("questions");

    return vaccinationRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => QuestionModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Stream<UserEntity> getUser(String uid) {
    final userRef = fireStore.collection("users");
    return userRef
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromSnapshot(event));
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    Map<String, dynamic> userInformation = Map();
    final userCollection = fireStore.collection("users");

    if (user.about != null && user.about != "")
      userInformation['about'] = user.about;
    if (user.name != null && user.name != "")
      userInformation["name"] = user.name;
    if (user.location != null && user.location != "")
      userInformation["location"] = user.location;

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Stream<List<ContentEntity>> getContents(String subid) {
    final contentRef =
        fireStore.collection("subjects").doc(subid).collection("contents");

    return contentRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => ContentModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Stream<List<CheatSheetEntity>> getCheatsheets(String subid) {
    final cheetRef =
        fireStore.collection("subjects").doc(subid).collection("cheatsheets");

    return cheetRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => CheatSheetModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Future<bool> addToBookMark(BookMarkEntity bookMarkEntity) async {
    final uid = await getCurrentUId();
    final favoritesQustionsRef =
        fireStore.collection("users").doc(uid).collection("bookmarks");
    final favQuestion = BookMarkModel(
      bookmarkID: bookMarkEntity.bookmarkID,
      header: bookMarkEntity.header,
      body: bookMarkEntity.body,
      answer: bookMarkEntity.answer,
      subjectname: bookMarkEntity.subjectname,
      date: bookMarkEntity.date,
    ).toDocument();

    return favoritesQustionsRef
        .doc(bookMarkEntity.bookmarkID)
        .get()
        .then((doc) {
      if (!doc.exists) {
        favoritesQustionsRef.doc(bookMarkEntity.bookmarkID).set(favQuestion);
        return false;
      }

      return true;
    });
  }

  @override
  Future<void> deleteFromBookMark(String qid) async {
    final uid = await getCurrentUId();
    final bookMarkRef =
        fireStore.collection("users").doc(uid).collection("bookmarks");

    bookMarkRef.doc(qid).get().then((doc) {
      if (doc.exists) {
        bookMarkRef.doc(qid).delete();
      }
    });
  }

  @override
  Stream<List<BookMarkEntity>> getBookMarks(String uId) {
    final bookMarkRef =
        fireStore.collection("users").doc(uId).collection("bookmarks");

    return bookMarkRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => BookMarkModel.fromSnapshot(docSnap))
          .toList();
    });
  }
}
