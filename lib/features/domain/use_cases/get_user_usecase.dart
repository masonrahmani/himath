import 'package:himath/features/domain/entities/user_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class GetUserUseCase {
  final FirebaseRepository repository;

  GetUserUseCase({required this.repository});

  Stream<UserEntity> call(String uid) {
    return repository.getUser(uid);
  }
}
