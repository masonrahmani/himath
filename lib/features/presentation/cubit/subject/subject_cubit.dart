import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_host_group_chat_app/features/domain/entities/subject_entity.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_all_subject_usecase.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final GetAllSubjectUsecase getAllSubjectUsecase;

  SubjectCubit({required this.getAllSubjectUsecase}) : super(SubjectInitial());

  Future<void> getSubjects() async {
    emit(SubjectLoading());
    try {
      getAllSubjectUsecase.call().listen((subjects) {
        emit(SubjectLoaded(subjects: subjects));
      });
    } on SocketException catch (_) {
      emit(SubjectFailure());
    } catch (_) {
      emit(SubjectFailure());
    }
  }
}
