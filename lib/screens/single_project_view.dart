// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/members_view.dart';
import 'package:project/services/middleware.dart';
import 'package:project/widgets/empty_groups.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../tasks_view.dart';
import '../widgets/empty_tasks.dart';
import 'AddMember.dart';
import 'add_task_screen.dart';

class SingleProjectView extends StatefulWidget {
  final Project project;
  SingleProjectView({
    required this.project,
  });
  @override
  State<SingleProjectView> createState() => _ProjectState();
}

class _ProjectState extends State<SingleProjectView> {
  List<User>? members;
  final ApiService _api = ApiService();
  Future<List<User>?> fetchMems() async {
    final Project project = widget.project;

    if (project.group.isNotEmpty) {
      Group group = await _api.fetchGroup(project.group);
      List<User> _members = await _api.getGroupMembers(group.members);
      return _members;
    }
    return null;
  }

  onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTask(
              project: widget.project,
            ),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddMember(
              project: widget.project,
              members: members,
            ),
          ),
        );
        break;
      case 2:
        bool res = (await showDialog<bool>(
          context: context,
          builder: (context) {
            final Project _project = widget.project;
            final ApiService _api = ApiService();

            return AlertDialog(
              title: Text(
                "Delete project",
              ),
              content: Text(
                "Are you sure about deleting ${_project.title}?\n"
                "These changes can't be undone once you click on \"Yes\" button..",
              ),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    bool res = await _api.deleteProject(_project);
                    res ? Navigator.pop(context, true) : setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final Project _project = widget.project;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff076792),
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            _project.title,
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
        actions: [
          PopupMenuButton<int>(
            onSelected: (int item) => onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Add Tasks'),
              ),
              const PopupMenuDivider(
                height: 1,
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Edit Members'),
              ),
              const PopupMenuDivider(
                height: 1,
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Delete Project'),
              ),
            ],
          ),
        ],
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {});
          });
        },
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  _project.title,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff076792),
                  ),
                ),
              ),
            ),
            _project.group.isEmpty
                ? NoGroupsWidget(
                    project: _project,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.25),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MembersView(project: _project),
                          ),
                        );
                      },
                      child: Text("View group"),
                    ),
                  ),
            SizedBox(
              height: 50,
            ),
            _project.tasks.isEmpty
                ? NoTasksWidget(
                    project: _project,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.25),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TasksView(
                              project: _project,
                            ),
                          ),
                        );
                      },
                      child: Text("View tasks"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
