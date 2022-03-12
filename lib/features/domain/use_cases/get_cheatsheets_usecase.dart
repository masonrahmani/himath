import 'package:himath/features/domain/entities/cheatsheet_entity.dart';
import 'package:himath/features/domain/entities/content_entity.dart';
import 'package:himath/features/domain/entities/question_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class GetCheatSheetUsecase {
  final FirebaseRepository repository;

  GetCheatSheetUsecase({required this.repository});

  Stream<List<CheatSheetEntity>> call(String subid) {
    return repository.getCheatsheets(subid);
  }
}
