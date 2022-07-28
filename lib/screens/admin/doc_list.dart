
import 'package:flutter/material.dart';
import 'package:the_endodontist_app/screens/admin/doc_list_page.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';


class DocList extends StatefulWidget {
  static const routeName = '/doctors';
  @override
  _DocListState createState() => _DocListState();
}

class _DocListState extends State<DocList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List'),
      ),
      drawer: AdminAppDrawer(),
      body: DocListPage(),
    );
  }
}