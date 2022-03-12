import 'package:equatable/equatable.dart';

class BookMarkEntity extends Equatable {
  final String bookmarkID;
  final String header;
  final String body;
  final String answer;
  final String subjectname;
  final String date;

  BookMarkEntity({
    this.bookmarkID = "",
    this.header = "",
    this.body = "",
    this.answer = "",
    this.subjectname = "",
    this.date = "",
  });

  @override
  List<Object> get props =>
      [bookmarkID, header, body, answer, subjectname, date];
}
