import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String email;
  final String uid;
  final String about;
  final String password;
  final String location;

  UserEntity(
      {this.name = "",
      this.email = "",
      this.uid = "",
      this.about = "Hello there i'm using this app",
      this.password = "",
      this.location = ""});

  @override
  // TODO: implement props
  List<Object> get props => [name, email, uid, about, password, location];
}
