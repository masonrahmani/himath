part of 'bookmark_cubit.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookMarkInitial extends BookmarkState {}

class BookMarkLoading extends BookmarkState {}

class BookMarkLoaded extends BookmarkState {
  final List<BookMarkEntity> bookmarks;

  BookMarkLoaded({required this.bookmarks});

  @override
  List<Object> get props => [bookmarks];
}

class BookMarkFailure extends BookmarkState {}
