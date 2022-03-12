import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:intl/intl.dart';
import 'package:self_host_group_chat_app/features/presentation/widgets/common.dart';

import '../../../core/share_equation.dart';
import '../../../core/page_const.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../cubit/bookmark/bookmark_cubit.dart';
import '../cubit/question/question_cubit.dart';
import '../pages/questions/questions_screen.dart';

class question_box_widget extends StatelessWidget {
  const question_box_widget({
    Key? key,
    required this.contentName,
    required GlobalKey<ScaffoldState> scaffoldState,
    required this.context,
    required this.state,
    required this.index,
  })  : _scaffoldState = scaffoldState,
        super(key: key);

  final String contentName;
  final GlobalKey<ScaffoldState> _scaffoldState;
  final BuildContext context;
  final QuestionLoaded state;
  final int index;

  @override
  Widget build(BuildContext context) {
    final longEq = Math.tex(
      state.questions[index].header,
      textStyle: TextStyle(
        color: Colors.deepOrange.shade500,
        fontSize: MediaQuery.of(context).size.width / 20,
        fontWeight: FontWeight.w100,
      ),
      mathStyle: MathStyle.display,
    );

    final breakResult = longEq.texBreak();
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black12,
                )),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green.withOpacity(0.1)),
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: MediaQuery.of(context).size.width / 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                PageConst.viewQuestion,
                arguments: {
                  'header': state.questions[index].header,
                  'body': state.questions[index].body,
                  'answer': state.questions[index].answer,
                },
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black12),
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  children: breakResult.parts,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.1)),
                  child: InkWell(
                    onTap: () {
                      final newBookmark = BookMarkEntity(
                        bookmarkID: state.questions[index].questionID,
                        header: state.questions[index].header,
                        body: state.questions[index].body,
                        answer: state.questions[index].answer,
                        subjectname: contentName,
                        date: DateFormat.yMMMEd().format(DateTime.now()),
                      );
                      Future<bool> add = BlocProvider.of<BookmarkCubit>(context)
                          .addToBookMark(newBookmark);
                      add.then((value) {
                        if (value) {
                          snackBarNetwork(
                              msg: "Already Bookmarked",
                              scaffoldState: _scaffoldState);
                        } else {
                          snackBarNetwork(
                              msg: "BookMarked", scaffoldState: _scaffoldState);
                        }
                      });
                    },
                    child: Icon(
                      Icons.bookmark_add_outlined,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1)),
                    child: InkWell(
                      onTap: () {
                        shareEquation(state.questions[index].header);
                      },
                      child: Icon(
                        Icons.share,
                        size: 20,
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
