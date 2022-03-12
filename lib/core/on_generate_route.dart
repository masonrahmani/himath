import 'package:flutter/material.dart';
import 'package:himath/core/page_const.dart';
import 'package:himath/features/domain/entities/cheatsheet_entity.dart';
import 'package:himath/features/domain/entities/subject_entity.dart';
import 'package:himath/features/domain/entities/user_entity.dart';
import 'package:himath/features/presentation/pages/profile/edit_profile.dart';
import 'package:himath/features/presentation/pages/screens.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.viewCheatsheetScreen:
        {
          if (args is CheatSheetEntity) {
            return materialBuilder(
              widget: ViewCheasheetScreen(
                cheatSheetEntity: args,
              ),
            );
          }

          return materialBuilder(widget: ErrorPage());
        }
      case PageConst.questionsScreen:
        {
          if (args is Map) {
            return materialBuilder(
              widget: QuestionScreen(
                sid: args['sid'],
                sname: args['sname'],
                conId: args['conId'],
              ),
            );
          }

          return materialBuilder(widget: ErrorPage());
        }

      case PageConst.contentScreen:
        {
          if (args is SubjectEntity) {
            return materialBuilder(
              widget: ContentScreen(
                subjectEntity: args,
              ),
            );
          }

          return materialBuilder(widget: ErrorPage());
        }
      case PageConst.viewQuestion:
        {
          if (args is Map) {
            return materialBuilder(
              widget: ViewQuestion(
                header: args['header'],
                body: args['body'],
                anwer: args['answer'],
              ),
            );
          }

          return materialBuilder(widget: ErrorPage());
        }
      case PageConst.editProfile:
        {
          if (args is UserEntity) {
            return materialBuilder(
              widget: EditProfile(
                user: args,
              ),
            );
            break;
          }

          return materialBuilder(widget: ErrorPage());
        }
      case PageConst.loginPage:
        {
          return materialBuilder(
            widget: LoginPage(),
          );
          break;
        }
      case PageConst.forgotPage:
        {
          return materialBuilder(
            widget: ForgetPassPage(),
          );
          break;
        }
      case PageConst.loginPage:
        {
          return materialBuilder(
            widget: LoginPage(),
          );
          break;
        }
      case PageConst.registrationPage:
        {
          return materialBuilder(
            widget: RegistrationPage(),
          );
          break;
        }
      default:
        return materialBuilder(
          widget: ErrorPage(),
        );
    }
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("error"),
      ),
      body: Center(
        child: Text("error"),
      ),
    );
  }
}

MaterialPageRoute materialBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
