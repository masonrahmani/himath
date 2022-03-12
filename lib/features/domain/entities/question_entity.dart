import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final String questionID;
  final String header;
  final String body;
  final String answer;

  QuestionEntity(
      {this.questionID = "",
      this.header = "",
      this.body = "",
      this.answer = ""});

  @override
  // TODO: implement props
  List<Object> get props => [questionID, header, body, answer];
}
