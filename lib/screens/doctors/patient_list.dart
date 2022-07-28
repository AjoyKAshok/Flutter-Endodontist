import 'package:flutter/material.dart';
import 'package:the_endodontist_app/screens/doctors/list_page.dart';
import 'package:the_endodontist_app/widgets/doc_app_drawer.dart';


class PatientList extends StatefulWidget {
  static const routeName = '/patients';
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client List'),
      ),
      drawer: DocAppDrawer(),
      body: ListPage(),
    );
  }
}