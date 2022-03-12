import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_host_group_chat_app/features/domain/entities/content_entity.dart';

class ContentModel extends ContentEntity {
  ContentModel({
    final String contentID = "",
    final String name = "",
    final String subjectID = "",
  }) : super(
          name: name,
          contentID: contentID,
          subjectID: subjectID,
        );

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
        name: json['name'],
        subjectID: json['subjectID'],
        contentID: json['contentID']);
  }

  factory ContentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ContentModel(
      name: snapshot.get('name'),
      subjectID: snapshot.get('subjectID'),
      contentID: snapshot.get('contentID'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "subjectID": subjectID,
      "contentID": contentID,
    };
  }
}
