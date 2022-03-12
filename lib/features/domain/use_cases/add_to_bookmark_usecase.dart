import 'package:himath/features/domain/entities/bookmark_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class AddToBookMarkUsecase {
  final FirebaseRepository repository;

  AddToBookMarkUsecase({required this.repository});

  Future<bool> call(BookMarkEntity bookMarkEntity) {
    return repository.addToBookMark(bookMarkEntity);
  }
}
