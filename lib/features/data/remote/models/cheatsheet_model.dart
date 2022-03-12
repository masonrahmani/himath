



  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_host_group_chat_app/features/domain/entities/cheatsheet_entity.dart';

class CheatSheetModel extends CheatSheetEntity {
  CheatSheetModel({
    final String cheatsheetID='',
  final String subjectID='',
  final String name='',
  final String body='',
  }) : super(
          name: name,
          subjectID: subjectID,
          cheatsheetID: cheatsheetID,
          body: body,
        );

  factory CheatSheetModel.fromJson(Map<String, dynamic> json) {
    return CheatSheetModel(
        name: json['name'],
        subjectID: json['subjectID'],
        cheatsheetID: json['cheatsheetID'],
        body: json['body'],
        
        );
  }

  factory CheatSheetModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CheatSheetModel(
      name: snapshot.get('name'),
      subjectID: snapshot.get('subjectID'),
      body: snapshot.get('body'),
      cheatsheetID: snapshot.get('cheatsheetID'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "subjectID": subjectID,
      "cheatsheetID": cheatsheetID,
      "body": body,

    };
  }
}
