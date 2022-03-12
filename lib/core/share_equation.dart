import 'package:share_plus/share_plus.dart';

shareEquation(String question) async {
  await Share.share(question);
}
