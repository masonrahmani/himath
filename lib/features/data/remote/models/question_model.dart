import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_host_group_chat_app/features/domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    final String questionID = "",
    final String header = "",
    final String body = "",
    final String answer = "",
  }) : super(
            questionID: questionID, header: header, body: body, answer: answer);

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionID: json['questionID'],
      header: json['header'],
      body: json['body'],
      answer: json['answer'],
    );
  }

  factory QuestionModel.fromSnapshot(DocumentSnapshot snapshot) {
    return QuestionModel(
      questionID: snapshot.get('questionID'),
      header: snapshot.get('header'),
      body: snapshot.get('body'),
      answer: snapshot.get('answer'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "questionID": questionID,
      "header": header,
      "body": body,
      "answer": answer,
    };
  }
}
