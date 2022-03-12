import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_host_group_chat_app/features/domain/entities/bookmark_entity.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/add_to_bookmark_usecase.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/delete_bookmark_usecase.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_bookmarks_usecase.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final GetBookMarksUsecase getBookMarksUsecase;
  final AddToBookMarkUsecase addToBookMarkUsecase;
  final DeleteBookMarkUsecase deleteBookMarkUsecase;
  BookmarkCubit(
      {required this.getBookMarksUsecase,
      required this.addToBookMarkUsecase,
      required this.deleteBookMarkUsecase})
      : super(BookmarkInitial());

  Future<void> getBookMarks(String subId) async {
    emit(BookMarkLoading());
    try {
      getBookMarksUsecase.call(subId).listen((bookmarks) {
        emit(BookMarkLoaded(bookmarks: bookmarks));
      });
    } on SocketException catch (_) {
      emit(BookMarkFailure());
    } catch (_) {
      emit(BookMarkFailure());
    }
  }

  Future<bool> addToBookMark(BookMarkEntity bookMarkEntity) async {
    bool add = await addToBookMarkUsecase.call(bookMarkEntity);
    return add;
  }

  Future<void> deleteBookMark(String qid) async {
    deleteBookMarkUsecase.call(qid);
  }
}
