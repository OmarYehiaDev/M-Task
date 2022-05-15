// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:project/models/project.dart';

class MembersView extends StatefulWidget {
  final Project project;
  MembersView({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
