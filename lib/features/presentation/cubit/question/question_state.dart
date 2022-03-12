part of 'question_cubit.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<QuestionEntity> questions;
  QuestionLoaded({required this.questions});

  @override
  List<Object> get props => [questions];
}

class QuestionFailure extends QuestionState {}
