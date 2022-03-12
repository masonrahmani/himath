import 'package:himath/features/domain/entities/content_entity.dart';
import 'package:himath/features/domain/entities/question_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class GetContentsUsecase {
  final FirebaseRepository repository;

  GetContentsUsecase({required this.repository});

  Stream<List<ContentEntity>> call(String subid) {
    return repository.getContents(subid);
  }
}
