import 'package:himath/features/domain/entities/cheatsheet_entity.dart';
import 'package:himath/features/domain/entities/content_entity.dart';
import 'package:himath/features/domain/entities/bookmark_entity.dart';
import 'package:himath/features/domain/entities/question_entity.dart';
import 'package:himath/features/domain/entities/subject_entity.dart';
import 'package:himath/features/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> googleAuth();
  Future<void> forgotPassword(String email);
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<void> getUpdateUser(UserEntity user);
  Future<String> getCurrentUId();
  Stream<List<SubjectEntity>> getAllSubjects();
  Stream<List<QuestionEntity>> getAllQuestions(String subId, String conId);
  //favorites pages usecases
  Stream<List<BookMarkEntity>> getBookMarks(String uId);
  Future<bool> addToBookMark(BookMarkEntity bookMarkEntity);
  Future<void> deleteFromBookMark(String qid);

  Stream<UserEntity> getUser(String uid);
  Future<void> updateUser(UserEntity user);

  Stream<List<ContentEntity>> getContents(String subid);
  Stream<List<CheatSheetEntity>> getCheatsheets(String subid);
}
