import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final String name;
  final String subjectId;
  final int color;

  SubjectEntity({this.name = "", this.subjectId = "", this.color = 0});

  @override
  // TODO: implement props
  List<Object> get props => [name, subjectId, color];
}
