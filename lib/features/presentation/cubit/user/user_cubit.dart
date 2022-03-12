import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_host_group_chat_app/features/domain/entities/user_entity.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_update_user_usecase.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_user_usecase.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUpdateUserUseCase getUpdateUserUseCase;
  final GetUserUseCase getUserUseCase;
  final UpdateUserUsecase updateUserUsecase;

  UserCubit({
    required this.getUpdateUserUseCase,
    required this.getUserUseCase,
    required this.updateUserUsecase,
  }) : super(UserInitial());

  Future<void> getUpdateUser({required UserEntity user}) async {
    try {
      await getUpdateUserUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> getUser(String uid) async {
    emit(UserLoading());
    try {
      getUserUseCase.call(uid).listen((user) {
        emit(UserLoaded(user: user));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      updateUserUsecase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
