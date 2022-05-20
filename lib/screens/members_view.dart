// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project/models/group.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/AddMember.dart';
import 'package:project/services/middleware.dart';

import '../models/user.dart';

class MembersView extends StatefulWidget {
  final Project project;
  final Group? group;
  MembersView({
    Key? key,
    required this.project,
    this.group,
  }) : super(key: key);

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  final ApiService _api = ApiService();
  @override
  Widget build(BuildContext context) {
    final Project project = widget.project;
    final Group? group = widget.group;
    return Scaffold(
      body: FutureBuilder<Group>(
        future: _api.fetchGroup(
          group == null ? project.group : group.url,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) Text("Error happened ${snapshot.error}");
          if (snapshot.hasData) {
            final Group group = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  group.title + " group",
                ),
              ),
              body: FutureBuilder<List<User>>(
                future: _api.getGroupMembers(group.members),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Text("Error happened ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    List<User> users = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddMember(
                                    project: project,
                                    members: users,
                                    group: group,
                                  ),
                                ),
                              );
                            },
                            child: Text("Edit members"),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              int count = 0;
                              User user = users[index];
                              for (String task
                                  in project.tasks.cast<String>()) {
                                if (user.tasks.cast<String>().contains(task)) {
                                  count++;
                                }
                              }
                              return ListTile(
                                leading: Icon(
                                  project.owner == user.username
                                      ? Icons.admin_panel_settings
                                      : Icons.person,
                                ),
                                title: Text(user.username),
                                subtitle: Text("Tasks number: $count"),
                                trailing: project.owner == user.username
                                    ? Text("Owner")
                                    : Text("Member"),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
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
