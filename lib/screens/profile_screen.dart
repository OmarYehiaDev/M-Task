// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:project/models/user.dart';

import '../services/middleware.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({
    required this.user,
  });
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _usernameCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076792),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30.0,
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Color(0xa6A2B6D4),
                offset: Offset(7, 5),
                blurRadius: 20,
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<User>(
        stream: _api.fetchUserData().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final User _user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(00.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40.0,
                        horizontal: 105.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        // TODO: implementing `ChangePic` Function
                        child: Image.asset(
                          "assets/images/image.png",
                          height: 150.0,
                          width: 150.0,
                          fit: BoxFit.cover,

                          //change image fill type
                        ),
                      ),
                    ),
                    Center(
                      child: const Text(
                        'Change User Name',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff076792),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextFormField(
                        controller: _usernameCon,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: _user.username,
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color(0xffc9c9c9),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Color(0xff076792),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Center(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              String newUsername = _usernameCon.text;
                              if (newUsername.isNotEmpty) {
                                bool res = await _api.updateUser(
                                  user.copyWith(
                                    url: user.url,
                                    id: user.id,
                                    firstName: user.firstName,
                                    lastName: user.lastName,
                                    username: newUsername,
                                    email: user.email,
                                    projects: user.projects,
                                    tasks: user.tasks,
                                  ),
                                );
                                if (res) {
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text("Updated successfully"),
                                    ),
                                  );
                                  setState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "There're another user with this username\n"
                                        "Choose another one",
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("Enter new username"),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 100),
                              primary: const Color(0xff076792),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 100),
                              primary: const Color(0xff076792),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error Happened"),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
