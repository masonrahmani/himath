import 'package:himath/features/domain/entities/subject_entity.dart';
import 'package:himath/features/domain/repositories/firebase_repository.dart';

class GetAllSubjectUsecase {
  final FirebaseRepository repository;

  GetAllSubjectUsecase({required this.repository});

  Stream<List<SubjectEntity>> call() {
    return repository.getAllSubjects();
  }
}
