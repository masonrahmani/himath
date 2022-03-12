import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_contents_usecase.dart';

import '../../../domain/entities/content_entity.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  final GetContentsUsecase getContentsUsecase;
  ContentCubit({required this.getContentsUsecase}) : super(ContentInitial());
  Future<void> getContents(String subId) async {
    emit(ContentLoading());
    try {
      getContentsUsecase.call(subId).listen((contents) {
        emit(ContentLoaded(contents: contents));
      });
    } on SocketException catch (_) {
      emit(ContentFailure());
    } catch (_) {
      emit(ContentFailure());
    }
  }
}
