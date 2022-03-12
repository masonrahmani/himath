import 'package:self_host_group_chat_app/features/data/remote/data_sources/firebase_remote_data_source.dart';
import 'package:self_host_group_chat_app/features/domain/entities/cheatsheet_entity.dart';
import 'package:self_host_group_chat_app/features/domain/entities/content_entity.dart';
import 'package:self_host_group_chat_app/features/domain/entities/bookmark_entity.dart';
import 'package:self_host_group_chat_app/features/domain/entities/question_entity.dart';
import 'package:self_host_group_chat_app/features/domain/entities/subject_entity.dart';

import 'package:self_host_group_chat_app/features/domain/entities/user_entity.dart';
import 'package:self_host_group_chat_app/features/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      await remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUId() async =>
      await remoteDataSource.getCurrentUId();

  @override
  Future<bool> isSignIn() async => await remoteDataSource.isSignIn();

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();

  @override
  Future<void> googleAuth() async => remoteDataSource.googleAuth();

  @override
  Future<void> forgotPassword(String email) async =>
      remoteDataSource.forgotPassword(email);

  @override
  Future<void> signIn(UserEntity user) async => remoteDataSource.signIn(user);

  @override
  Future<void> signUp(UserEntity user) async => remoteDataSource.signUp(user);

  @override
  Future<void> getUpdateUser(UserEntity user) async =>
      remoteDataSource.getUpdateUser(user);

  @override
  Stream<List<SubjectEntity>> getAllSubjects() =>
      remoteDataSource.getAllSubjects();

  @override
  Stream<List<QuestionEntity>> getAllQuestions(String subId, String conId) =>
      remoteDataSource.getAllQuestions(subId, conId);

  @override
  Stream<UserEntity> getUser(String uid) => remoteDataSource.getUser(uid);

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  @override
  Stream<List<ContentEntity>> getContents(String subid) =>
      remoteDataSource.getContents(subid);

  @override
  Stream<List<CheatSheetEntity>> getCheatsheets(String subid) =>
      remoteDataSource.getCheatsheets(subid);

  @override
  Future<void> deleteFromBookMark(String qid) async =>
      remoteDataSource.deleteFromBookMark(qid);

  @override
  Future<bool> addToBookMark(BookMarkEntity bookMarkEntity) async =>
      remoteDataSource.addToBookMark(bookMarkEntity);

  @override
  Stream<List<BookMarkEntity>> getBookMarks(String uId) =>
      remoteDataSource.getBookMarks(uId);
}
