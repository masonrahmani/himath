import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_host_group_chat_app/features/domain/entities/user_entity.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/user/user_cubit.dart';
import '../../widgets/textfield_container.dart';

class EditProfile extends StatefulWidget {
  final UserEntity user;
  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _locationControlar = TextEditingController();
  TextEditingController _aboutControlar = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    _locationControlar.dispose();
    _aboutControlar.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.arrow_back,
            color: Colors.orange,
            size: 30,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      )),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.shade500,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextFieldContainer(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                hintText: widget.user.name,
                prefixIcon: Icons.person,
              ),
              TextFieldContainer(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: widget.user.email,
                prefixIcon: Icons.mail,
              ),
              TextFieldContainer(
                controller: _locationControlar,
                keyboardType: TextInputType.emailAddress,
                hintText: widget.user.location,
                prefixIcon: Icons.location_on_outlined,
              ),
              TextFieldContainer(
                controller: _aboutControlar,
                keyboardType: TextInputType.emailAddress,
                hintText: widget.user.about,
                prefixIcon: Icons.info_outline,
              ),

              ///Need Constract
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange.shade100,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange.shade100,
                        ),
                        onPressed: () {
                          final updatedUser = UserEntity(
                            uid: widget.user.uid,
                            name: _usernameController.text,
                            email: _emailController.text,
                            location: _locationControlar.text,
                            about: _aboutControlar.text,
                          );

                          BlocProvider.of<UserCubit>(context)
                              .updateUser(user: updatedUser);

                          Navigator.pop(context);
                        },
                        child: Text("Update")),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
