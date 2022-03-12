import 'package:himath/features/domain/entities/question_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class GetAllQuestionsUsecase {
  final FirebaseRepository repository;

  GetAllQuestionsUsecase({required this.repository});

  Stream<List<QuestionEntity>> call(String subId, String conId) {
    return repository.getAllQuestions(subId, conId);
  }
}
