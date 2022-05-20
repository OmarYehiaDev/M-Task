// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:project/services/middleware.dart';

import '../edit_task.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/user.dart';

class SingleTaskView extends StatefulWidget {
  final Task task;
  final Project project;
  final List<User> editors;
  const SingleTaskView({
    Key? key,
    required this.task,
    required this.project,
    required this.editors,
  }) : super(key: key);

  @override
  State<SingleTaskView> createState() => _SingleTaskViewState();
}

class _SingleTaskViewState extends State<SingleTaskView> {
  final ApiService _api = ApiService();

  @override
  Widget build(BuildContext context) {
    final Task task = widget.task;
    final Project project = widget.project;
    final List<User> editors = widget.editors;
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<User>(
        future: _api.fetchUserData(),
        builder: (context, snapshot) {
          onSelected(BuildContext context, int item) async {
            switch (item) {
              case 0:
                await _api.leaveTask(context, project, task);
                setState(() {});
                Navigator.pop(context, true);
                setState(() {});
                break;
              case 1:
                bool res = (await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Update task",
                      ),
                      content: Text(
                        "You're updating ${task.title} status",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Task _task = task.copyWith(
                              url: task.url,
                              projectId: task.projectId,
                              id: task.id,
                              owner: task.owner,
                              project: task.project,
                              title: task.title,
                              start: task.start,
                              end: task.end,
                              desc: task.desc,
                              status: "in progress",
                              members: task.members,
                            );
                            bool res = await _api.updateTask(_task);
                            res
                                ? Navigator.pop(context, true)
                                : setState(() {});
                            res ? setState(() {}) : setState(() {});
                          },
                          child: Text("Start task"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Task _task = task.copyWith(
                              url: task.url,
                              projectId: task.projectId,
                              id: task.id,
                              owner: task.owner,
                              project: task.project,
                              title: task.title,
                              start: task.start,
                              end: task.end,
                              desc: task.desc,
                              status: "done",
                              members: task.members.cast<String>(),
                            );
                            bool res = await _api.updateTask(_task);
                            res
                                ? Navigator.pop(context, true)
                                : setState(() {});
                            res ? setState(() {}) : setState(() {});
                          },
                          child: Text("Finish task"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    );
                  },
                ))!;
                res ? setState(() {}) : setState(() {});
                setState(() {});
                break;
              case 2:
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditTask(
                      project: widget.project,
                      task: task,
                    ),
                  ),
                );
                break;
            }
          }

          if (snapshot.hasError) Text("Error Happened");
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text(task.title),
                actions: [
                  PopupMenuButton<int>(
                    onSelected: (int item) => onSelected(context, item),
                    itemBuilder: (context) => project.owner == user.username &&
                            editors
                                .map((e) => e.username)
                                .contains(user.username)
                        ? [
                            const PopupMenuItem<int>(
                              value: 0,
                              child: Text("Leave task"),
                            ),
                            const PopupMenuDivider(
                              height: 1,
                            ),
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Text("Update task status"),
                            ),
                            const PopupMenuDivider(
                              height: 1,
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Text("Edit task"),
                            ),
                          ]
                        : !editors
                                .map((e) => e.username)
                                .contains(user.username)
                            ? [
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Text("Edit task"),
                                ),
                              ]
                            : [
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text("Leave task"),
                                ),
                                const PopupMenuDivider(
                                  height: 1,
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text("Update task status"),
                                ),
                              ],
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width - 50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Task title: " + task.title),
                              Text("Task status: " + task.status),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text("Description: " + task.desc),
                        ),
                      ),
                      SizedBox(
                        width: width - 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Starts " + Jiffy(task.start).fromNow(),
                              ),
                              Text(
                                "Ends " + Jiffy(task.end).fromNow(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            "Assigned to: " +
                                editors
                                    .map((e) => e.username)
                                    .toList()
                                    .join(" - "),
                          ),
                        ),
                      ),
                      editors.map((e) => e.username).contains(user.username)
                          ? Text("You're allowed to edit status")
                          : Text("You aren't allowed to edit status"),
                    ],
                  ),
                ),
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
