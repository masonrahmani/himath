import 'package:himath/features/domain/entities/bookmark_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class GetBookMarksUsecase {
  final FirebaseRepository repository;

  GetBookMarksUsecase({required this.repository});

  Stream<List<BookMarkEntity>> call(String uId) {
    return repository.getBookMarks(uId);
  }
}
