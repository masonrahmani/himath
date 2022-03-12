import 'package:equatable/equatable.dart';

class CheatSheetEntity extends Equatable {
  final String cheatsheetID;
  final String subjectID;
  final String name;
  final String body;

  CheatSheetEntity({this.cheatsheetID="",this.name = "", this.body = "", this.subjectID = ""});

  @override
  // TODO: implement props
  List<Object> get props => [name, subjectID, cheatsheetID,body];
}
