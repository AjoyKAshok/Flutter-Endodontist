
import 'package:flutter/material.dart';
import 'package:the_endodontist_app/widgets/doc_app_drawer.dart';


class DoctorHome extends StatefulWidget {
  static const routeName = '/doctor-home';
  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
      ),
      drawer: DocAppDrawer(),
      
    );
  }
}