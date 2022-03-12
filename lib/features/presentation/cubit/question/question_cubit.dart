import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_host_group_chat_app/features/domain/entities/question_entity.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_all_questions_usecase.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final GetAllQuestionsUsecase getAllQuestionsUsecase;

  QuestionCubit({required this.getAllQuestionsUsecase})
      : super(QuestionInitial());

  Future<void> getQuestions(String subId, String conId) async {
    emit(QuestionLoading());
    try {
      getAllQuestionsUsecase.call(subId, conId).listen((questions) {
        emit(QuestionLoaded(questions: questions));
      });
    } on SocketException catch (_) {
      emit(QuestionFailure());
    } catch (_) {
      emit(QuestionFailure());
    }
  }
}
