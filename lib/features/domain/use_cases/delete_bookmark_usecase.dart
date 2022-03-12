import 'package:himath/features/domain/repositories/firebase_repository.dart';

class DeleteBookMarkUsecase {
  final FirebaseRepository repository;

  DeleteBookMarkUsecase({required this.repository});

  Future<void> call(String qid) {
    return repository.deleteFromBookMark(qid);
  }
}
