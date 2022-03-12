import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_host_group_chat_app/features/domain/entities/bookmark_entity.dart';

class BookMarkModel extends BookMarkEntity {
  BookMarkModel({
    final String bookmarkID = "",
    final String header = "",
    final String body = "",
    final String answer = "",
    final String subjectname = "",
    final String date = "",
  }) : super(
          bookmarkID: bookmarkID,
          header: header,
          body: body,
          answer: answer,
          subjectname: subjectname,
          date: date,
        );

  factory BookMarkModel.fromJson(Map<String, dynamic> json) {
    return BookMarkModel(
      bookmarkID: json['bookmarkID'],
      header: json['header'],
      body: json['body'],
      answer: json['answer'],
      subjectname: json['subjectname'],
      date: json['date'],
    );
  }

  factory BookMarkModel.fromSnapshot(DocumentSnapshot snapshot) {
    return BookMarkModel(
      bookmarkID: snapshot.get('bookmarkID'),
      header: snapshot.get('header'),
      body: snapshot.get('body'),
      answer: snapshot.get('answer'),
      subjectname: snapshot.get('subjectname'),
      date: snapshot.get('date'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "bookmarkID": bookmarkID,
      "header": header,
      "body": body,
      "answer": answer,
      "date": date,
      "subjectname": subjectname,
    };
  }
}
