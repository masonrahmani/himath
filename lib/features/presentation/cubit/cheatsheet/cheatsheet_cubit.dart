import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_host_group_chat_app/features/domain/entities/cheatsheet_entity.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_cheatsheets_usecase.dart';

part 'cheatsheet_state.dart';

class CheatsheetCubit extends Cubit<CheatsheetState> {
  final GetCheatSheetUsecase getCheatSheetUsecase;
  CheatsheetCubit({required this.getCheatSheetUsecase}) : super(CheatsheetInitial());
  Future<void> getCheatSheets(String subId) async {
    emit(CheatsheetLoading());
    try {
      getCheatSheetUsecase.call(subId).listen((cheatSheets) {
        emit(CheatsheetLoaded(cheatsheets: cheatSheets));
      });
    } on SocketException catch (_) {
      emit(CheatsheetFailure());
    } catch (_) {
      emit(CheatsheetFailure());
    }
  }
}
