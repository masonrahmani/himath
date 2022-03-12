import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:self_host_group_chat_app/core/app_const.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/cheatsheet/cheatsheet_cubit.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/content/content_cubit.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/question/question_cubit.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/subject/subject_cubit.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/user/user_cubit.dart';
import 'features/presentation/cubit/auth/auth_cubit.dart';
import 'features/presentation/cubit/credential/credential_cubit.dart';
import 'features/presentation/pages/screens.dart';
import 'core/on_generate_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider<CredentialCubit>(
          create: (_) => di.sl<CredentialCubit>(),
        ),
        BlocProvider<SubjectCubit>(
          create: (_) => di.sl<SubjectCubit>(),
        ),
        BlocProvider<QuestionCubit>(
          create: (_) => di.sl<QuestionCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>(),
        ),
        BlocProvider<BookmarkCubit>(
          create: (_) => di.sl<BookmarkCubit>(),
        ),
        BlocProvider<ContentCubit>(
          create: (_) => di.sl<ContentCubit>(),
        ),
        BlocProvider<CheatsheetCubit>(
          create: (_) => di.sl<CheatsheetCubit>(),
        ),
      ],
      child: MaterialApp(
        title: AppConst.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        onGenerateRoute: OnGenerateRoute.route,
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MyDashBoard(uid: authState.uid);
                } else
                  return LoginPage();
              },
            );
          }
        },
      ),
    );
  }
}
