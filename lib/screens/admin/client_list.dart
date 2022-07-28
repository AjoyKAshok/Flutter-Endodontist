import 'package:flutter/material.dart';
import 'package:the_endodontist_app/screens/doctors/list_page.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';

class ClientList extends StatefulWidget {
  static const routeName = '/clients';
  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client List'),
      ),
      drawer: AdminAppDrawer(),
      body: ListPage(),
    );
  }
}