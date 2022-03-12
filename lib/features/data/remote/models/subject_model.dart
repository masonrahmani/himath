import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_host_group_chat_app/features/domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  SubjectModel(
      {final String name = "",
      final String subjectId = "",
      final int color = 0})
      : super(
          name: name,
          subjectId: subjectId,
          color: color,
        );

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
        name: json['name'], subjectId: json['subjectId'], color: json['color']);
  }

  factory SubjectModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SubjectModel(
      name: snapshot.get('name'),
      subjectId: snapshot.get('subjectId'),
      color: snapshot.get('color'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "subjectId": subjectId,
      "color": color,
    };
  }
}
