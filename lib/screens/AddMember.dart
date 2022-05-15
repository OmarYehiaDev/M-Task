// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:project/models/project.dart';
import 'package:project/models/user.dart';
import 'package:project/services/middleware.dart';

class AddMember extends StatefulWidget {
  final Project project;
  AddMember({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _chipKey = GlobalKey<ChipsInputState>();
  final ApiService _api = ApiService();
  List<AppProfile> newMems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076792),
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Add Members',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
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
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<List<User>>(
        future: _api.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<User> users = snapshot.data!;
            final List<AppProfile> usersProfiles = List.generate(
              users.length,
              (i) => AppProfile(
                users[i].firstName + " " + users[i].lastName,
                users[i].username,
              ),
            );
            return Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: ChipsInput<AppProfile>(
                        key: _chipKey,
                        autofocus: true,
                        keyboardAppearance: Brightness.dark,
                        textCapitalization: TextCapitalization.words,
                        textStyle: const TextStyle(
                          height: 1.5,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Select People',
                        ),
                        findSuggestions: (String query) {
                          if (query.isNotEmpty) {
                            var lowercaseQuery = query.toLowerCase();
                            return usersProfiles.where(
                              (profile) {
                                return profile.name.toLowerCase().contains(
                                          query.toLowerCase(),
                                        ) ||
                                    profile.email.toLowerCase().contains(
                                          query.toLowerCase(),
                                        );
                              },
                            ).toList(
                              growable: false,
                            )..sort(
                                (a, b) => a.name
                                    .toLowerCase()
                                    .indexOf(
                                      lowercaseQuery,
                                    )
                                    .compareTo(
                                      b.name.toLowerCase().indexOf(
                                            lowercaseQuery,
                                          ),
                                    ),
                              );
                          }
                          return usersProfiles;
                        },
                        onChanged: (data) {
                          // print(data);
                        },
                        chipBuilder: (context, state, profile) {
                          return InputChip(
                            key: ObjectKey(profile),
                            label: Text(profile.name),
                            avatar: const Icon(Icons.account_box_rounded),
                            onDeleted: () {
                              state.deleteChip(
                                profile,
                              );
                              newMems.remove(profile);
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        },
                        suggestionBuilder: (context, state, profile) {
                          return ListTile(
                            key: ObjectKey(profile),
                            leading: Icon(
                              Icons.account_box_rounded,
                            ),
                            title: Text(profile.name),
                            subtitle: Text(profile.email),
                            onTap: () {
                              state.selectSuggestion(
                                profile,
                              );
                              newMems.add(profile);
                            },
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: implement `addMembers` Function
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error Happened");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class AppProfile {
  final String name;
  final String email;
  //final String imageUrl;

  const AppProfile(
    this.name,
    this.email,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
