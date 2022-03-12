import 'package:equatable/equatable.dart';

class ContentEntity extends Equatable {
  final String contentID;
  final String name;
  final String subjectID;

  ContentEntity({this.name = "", this.contentID = "", this.subjectID = ""});

  @override
  // TODO: implement props
  List<Object> get props => [name, subjectID, contentID];
}
