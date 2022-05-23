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
    final Project project = widget.project;
    final List<User> editors = widget.editors;
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<Task>(
        future: _api.fetchTask(widget.task.url),
        builder: (context_, snapshot) {
          if (snapshot.hasError) Text("Error Happened");
          if (snapshot.hasData) {
            final Task task = snapshot.data!;
            return FutureBuilder<User>(
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
                                      ? Navigator.pop(context, res)
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
                                      ? Navigator.pop(context, res)
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
                      ScaffoldMessenger.of(context_).showSnackBar(
                        SnackBar(
                          backgroundColor: res ? Colors.green : Colors.red,
                          content: Text(res ? "Updated" : "Canceled"),
                        ),
                      );
                      ScaffoldMessenger.of(context_).setState(() {});
                      break;
                    case 2:
                      bool res = (await Navigator.of(context_).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context_) => EditTask(
                            project: widget.project,
                            task: task,
                          ),
                        ),
                      ))!;
                      await Future.delayed(
                        Duration(
                          milliseconds: 1500,
                        ),
                      );
                      ScaffoldMessenger.of(context_).showSnackBar(
                        SnackBar(
                          backgroundColor: res ? Colors.green : Colors.red,
                          content: Text(res ? "Edited" : "Canceled"),
                        ),
                      );
                      ScaffoldMessenger.of(context_).setState(() {});
                      break;
                    case 3:
                      ScaffoldMessenger.of(context_).setState(() {});
                      break;
                    case 4:
                      bool res = (await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Delete project",
                            ),
                            content: Text(
                              "Are you sure about deleting ${task.title}?\n"
                              "These changes can't be undone once you click on \"Yes\" button..",
                            ),
                            actions: [
                              TextButton.icon(
                                onPressed: () async {
                                  bool res = await _api.deleteTask(task);
                                  res
                                      ? Navigator.pop(context, true)
                                      : setState(() {});
                                  res ? setState(() {}) : setState(() {});
                                },
                                icon: Icon(Icons.delete),
                                label: Text("Yes"),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                icon: Icon(Icons.arrow_back),
                                label: Text("No"),
                              ),
                            ],
                          );
                        },
                      ))!;
                      res ? Navigator.pop(context) : setState(() {});
                      res ? setState(() {}) : setState(() {});
                      setState(() {});
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
                          itemBuilder: (context) =>
                              project.owner == user.username &&
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
                                      const PopupMenuDivider(
                                        height: 1,
                                      ),
                                      const PopupMenuItem<int>(
                                        value: 4,
                                        child: Text('Delete task'),
                                      ),
                                      const PopupMenuItem<int>(
                                        value: 3,
                                        child: Text("Refresh"),
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
                                          const PopupMenuDivider(
                                            height: 1,
                                          ),
                                          const PopupMenuItem<int>(
                                            value: 4,
                                            child: Text('Delete task'),
                                          ),
                                          const PopupMenuItem<int>(
                                            value: 3,
                                            child: Text("Refresh"),
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
                                          const PopupMenuDivider(
                                            height: 1,
                                          ),
                                          const PopupMenuItem<int>(
                                            value: 3,
                                            child: Text("Refresh"),
                                          ),
                                        ],
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width - 20,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Card(
                                      color: Colors.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Text("Task title: " + task.title),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Text("Task status: " + task.status),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.center,
                                child: Card(
                                  color: Colors.blue,
                                  child: SizedBox(
                                    width: width * 0.8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Text("Description: " + task.desc),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width - 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Card(
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Starts " +
                                                Jiffy(task.start).fromNow(),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Ends " + Jiffy(task.end).fromNow(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.center,
                                child: Card(
                                  color: Colors.blue,
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
                              ),
                              Card(
                                color: Colors.blue,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: editors
                                          .map((e) => e.username)
                                          .contains(user.username)
                                      ? Text("You're allowed to edit status")
                                      : Text(
                                          "You aren't allowed to edit status"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
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
