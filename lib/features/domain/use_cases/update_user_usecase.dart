import 'package:himath/features/domain/entities/user_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class UpdateUserUsecase {
  final FirebaseRepository repository;

  UpdateUserUsecase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.updateUser(user);
  }
}
