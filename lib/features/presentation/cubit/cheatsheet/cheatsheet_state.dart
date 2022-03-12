part of 'cheatsheet_cubit.dart';

abstract class CheatsheetState extends Equatable {
  const CheatsheetState();

  @override
  List<Object> get props => [];
}

class CheatsheetInitial extends CheatsheetState {}
class CheatsheetLoading extends CheatsheetState {}

class CheatsheetLoaded extends CheatsheetState {
  final List<CheatSheetEntity> cheatsheets;
  CheatsheetLoaded({required this.cheatsheets});

  @override
  List<Object> get props => [cheatsheets];
}

class CheatsheetFailure extends CheatsheetState {}

