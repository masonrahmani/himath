import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:himath/features/domain/use_cases/add_to_bookmark_usecase.dart';
import 'package:himath/features/domain/use_cases/delete_bookmark_usecase.dart';
import 'package:himath/features/domain/use_cases/get_all_questions_usecase.dart';
import 'package:himath/features/domain/use_cases/get_all_subject_usecase.dart';
import 'package:himath/features/domain/use_cases/get_cheatsheets_usecase.dart';
import 'package:himath/features/domain/use_cases/get_contents_usecase.dart';
import 'package:himath/features/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:himath/features/domain/use_cases/get_current_uid_usecase.dart';
import 'package:himath/features/domain/use_cases/get_bookmarks_usecase.dart';
import 'package:himath/features/domain/use_cases/get_user_usecase.dart';
import 'package:himath/features/domain/use_cases/update_user_usecase.dart';
import 'package:himath/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:himath/features/presentation/cubit/cheatsheet/cheatsheet_cubit.dart';
import 'package:himath/features/presentation/cubit/content/content_cubit.dart';
import 'package:himath/features/presentation/cubit/question/question_cubit.dart';
import 'package:himath/features/presentation/cubit/subject/subject_cubit.dart';

import 'package:himath/features/presentation/cubit/user/user_cubit.dart';

import '../features/data/remote/data_sources/firebase_remote_data_source.dart';
import '../features/data/remote/data_sources/firebase_remote_data_source_impl.dart';
import '../features/data/repositories/firebase_repository_impl.dart';
import '../features/domain/repositories/firebase_repository.dart';
import '../features/domain/use_cases/forgot_password_usecase.dart';
import '../features/domain/use_cases/get_update_user_usecase.dart';
import '../features/domain/use_cases/google_sign_in_usecase.dart';
import '../features/domain/use_cases/is_sign_in_usecase.dart';
import '../features/domain/use_cases/sign_in_usecase.dart';
import '../features/domain/use_cases/sign_out_usecase.dart';
import '../features/domain/use_cases/sign_up_usecase.dart';
import '../features/presentation/cubit/auth/auth_cubit.dart';
import '../features/presentation/cubit/credential/credential_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Contents bloc
  sl.registerFactory<ContentCubit>(() => ContentCubit(
        getContentsUsecase: sl.call(),
      ));

  //Contents bloc
  sl.registerFactory<CheatsheetCubit>(() => CheatsheetCubit(
        getCheatSheetUsecase: sl.call(),
      ));
  //User Bloc
  sl.registerFactory<UserCubit>(() => UserCubit(
        getUpdateUserUseCase: sl.call(),
        getUserUseCase: sl.call(),
        updateUserUsecase: sl.call(),
      ));
  // Question bloc

  sl.registerFactory<QuestionCubit>(() => QuestionCubit(
        getAllQuestionsUsecase: sl.call(),
      ));

  // BookMark Bloc
  sl.registerFactory<BookmarkCubit>(() => BookmarkCubit(
        getBookMarksUsecase: sl.call(),
        addToBookMarkUsecase: sl.call(),
        deleteBookMarkUsecase: sl.call(),
      ));

  //Future bloc
  //SubjectBloc
  sl.registerFactory<SubjectCubit>(
      () => SubjectCubit(getAllSubjectUsecase: sl.call()));

  //Future bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        isSignInUseCase: sl.call(),
        signOutUseCase: sl.call(),
        getCurrentUIDUseCase: sl.call(),
      ));

  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
      forgotPasswordUseCase: sl.call(),
      getCreateCurrentUserUseCase: sl.call(),
      signInUseCase: sl.call(),
      signUpUseCase: sl.call(),
      googleSignInUseCase: sl.call()));

  //UseCases
  sl.registerLazySingleton<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(repository: sl.call()));

  sl.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetCurrentUIDUseCase>(
      () => GetCurrentUIDUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateCurrentUserUseCase>(
      () => GetCreateCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetAllSubjectUsecase>(
      () => GetAllSubjectUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetAllQuestionsUsecase>(
      () => GetAllQuestionsUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetUserUseCase>(
      () => GetUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetUpdateUserUseCase>(
      () => GetUpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<UpdateUserUsecase>(
      () => UpdateUserUsecase(repository: sl.call()));

  sl.registerLazySingleton<AddToBookMarkUsecase>(
      () => AddToBookMarkUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetBookMarksUsecase>(
      () => GetBookMarksUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetContentsUsecase>(
      () => GetContentsUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCheatSheetUsecase>(
      () => GetCheatSheetUsecase(repository: sl.call()));
  sl.registerLazySingleton<DeleteBookMarkUsecase>(
      () => DeleteBookMarkUsecase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //Remote DataSource
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(sl.call(), sl.call(), sl.call(), sl.call()));

  //External
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => googleSignIn);
  sl.registerLazySingleton(() => facebookAuth);
}
