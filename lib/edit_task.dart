// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/project.dart';
import 'package:project/services/middleware.dart';

import 'models/task.dart';
// import 'package:project/screens/addWork_screen.dart';

class EditTask extends StatefulWidget {
  final Project project;
  final Task task;

  const EditTask({
    required this.project,
    required this.task,
  });
  @override
  State<StatefulWidget> createState() {
    return _EditTask();
  }
}

class _EditTask extends State<EditTask> {
  final ApiService _api = ApiService();
  TextEditingController taskNameCon = TextEditingController();
  TextEditingController noteCon = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Project _project = widget.project;
    final Task task = widget.task;
    return Scaffold(
      body: FutureBuilder<Task>(
        future: _api.fetchTask(task.url),
        builder: (context, snapshot) {
          if (snapshot.hasError) Text("Error Happened");
          if (snapshot.hasData) {
            Task _task = snapshot.data!;
            selectedStartDate = _task.start;
            selectedEndDate = _task.end;
            taskNameCon.text = _task.title;
            noteCon.text = _task.desc;
            var startDate = (DateFormat.yMMMMEEEEd().format(
                      selectedStartDate,
                    ) ==
                    DateFormat.yMMMMEEEEd().format(
                      DateTime.now(),
                    ))
                ? "today"
                : DateFormat.yMMMMEEEEd().format(
                    selectedStartDate,
                  );
            var endDate = (DateFormat.yMMMMEEEEd().format(
                      selectedEndDate,
                    ) ==
                    DateFormat.yMMMMEEEEd().format(
                      DateTime.now(),
                    ))
                ? "today"
                : DateFormat.yMMMMEEEEd().format(
                    selectedEndDate,
                  );
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff076792),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                  size: 30.0,
                ),
                title: Center(
                  child: Text(
                    _project.title,
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
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              body: Container(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Edit Task',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff076792),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 0,
                        ),
                        child: TextFormField(
                          controller: taskNameCon,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 22.0,
                              horizontal: 10.0,
                            ),
                            hintText: "",
                            labelText: 'Task Name',
                            labelStyle: TextStyle(
                              fontSize: 15,
                              color: Color(0xffc9c9c9),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                width: 2,
                                color: Color(0xff076792),
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        controller: noteCon,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 50.0,
                            horizontal: 10.0,
                          ),
                          labelText: 'Task Note',
                          hintText: "",
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xffc9c9c9),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color(0xff076792),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  right: 20.0,
                                ),
                                width: 150,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Start time"),
                                    ),
                                    ElevatedButton(
                                      child: Text(
                                        "Selected date is\n" + startDate,
                                      ),
                                      onPressed: () async {
                                        DateTime _selected =
                                            (await showDatePicker(
                                          context: context,
                                          initialDate: selectedStartDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2050),
                                        ))!;
                                        setState(() {
                                          selectedStartDate = _selected;
                                        });
                                        print(selectedStartDate);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                ),
                                width: 150,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("End time"),
                                    ),
                                    ElevatedButton(
                                      child: Text(
                                        "Selected date is\n" + endDate,
                                      ),
                                      onPressed: () async {
                                        DateTime _selected =
                                            (await showDatePicker(
                                          context: context,
                                          initialDate: selectedEndDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2050),
                                        ))!;
                                        setState(() {
                                          selectedEndDate = _selected;
                                        });
                                        print(selectedEndDate);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              String _taskName = taskNameCon.text;
                              String _taskNote = noteCon.text;
                              Task _task = task.copyWith(
                                url: task.url,
                                projectId: task.projectId,
                                id: task.id,
                                owner: task.owner,
                                project: task.project,
                                title: _taskName,
                                start: selectedStartDate,
                                end: selectedEndDate,
                                desc: _taskNote,
                                status: task.status,
                                members: task.members,
                              );
                              if (_taskName.isNotEmpty &&
                                  _taskNote.isNotEmpty) {
                                bool res = await _api.updateTask(_task);
                                if (res) {
                                  Navigator.pop(context, res);
                                }
                              } else if (_taskName.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("Enter the name of task"),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("Enter the note of task"),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 50),
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
