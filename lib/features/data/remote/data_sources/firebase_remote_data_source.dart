import 'package:himath/features/domain/entities/bookmark_entity.dart';
import 'package:himath/features/domain/entities/user_entity.dart';

import '../../../domain/entities/cheatsheet_entity.dart';
import '../../../domain/entities/content_entity.dart';
import '../../../domain/entities/question_entity.dart';
import '../../../domain/entities/subject_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<void> getCreateCurrentUser(UserEntity user);

  Future<void> forgotPassword(String email);

  Future<void> signIn(UserEntity user);

  Future<void> signUp(UserEntity user);

  Future<void> getUpdateUser(UserEntity user);

  Future<void> googleAuth();

  Future<bool> isSignIn();

  Future<void> signOut();
  Future<String> getCurrentUId();
  Stream<List<SubjectEntity>> getAllSubjects();
  Stream<List<QuestionEntity>> getAllQuestions(String subId, String conId);
  Stream<List<BookMarkEntity>> getBookMarks(String uId);
  Future<bool> addToBookMark(BookMarkEntity bookMarkEntity);
  Future<void> deleteFromBookMark(String qid);
  Stream<UserEntity> getUser(String uid);
  Future<void> updateUser(UserEntity user);
  Stream<List<ContentEntity>> getContents(String subid);
  Stream<List<CheatSheetEntity>> getCheatsheets(String subid);
}
