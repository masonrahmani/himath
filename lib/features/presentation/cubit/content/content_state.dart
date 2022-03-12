part of 'content_cubit.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<ContentEntity> contents;
  ContentLoaded({required this.contents});

  @override
  List<Object> get props => [contents];
}

class ContentFailure extends ContentState {}
