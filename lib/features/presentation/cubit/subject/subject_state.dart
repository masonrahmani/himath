part of 'subject_cubit.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<SubjectEntity> subjects;
  SubjectLoaded({required this.subjects});
  @override
  List<Object> get props => [subjects];
}

class SubjectFailure extends SubjectState {}
