import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/screens/doctors/add_diagnostics.dart';
import 'package:the_endodontist_app/screens/doctors/diagnostic_detail.dart';
import 'package:flutter/material.dart';

class ShowDiagnostics extends StatefulWidget {
  // static const routeName = '/show_diagnostics';

  final String? uid;
  // final String id;
  ShowDiagnostics({
    this.uid,
  });

  @override
  _ShowDiagnosticsState createState() => _ShowDiagnosticsState();
}

class _ShowDiagnosticsState extends State<ShowDiagnostics> {
  final TextEditingController _userName = TextEditingController();
  String? uName;

  Future getDetails() async {
    String? uid = widget.uid!;
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Diaganostic Detail')
        .doc(uid)
        .collection('Created On')
        .get();
    return qn.docs;
  }

  Future getUserInfoFromUser() async {
    String? uid = widget.uid!;
    
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          _userName.text = snapshot['User Name'];
          uName = _userName.text; 
          
        });
      }
    });
    return documentReference;
  }

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // ignore: unnecessary_statements
  Future<Null> selectDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2220),
    );
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
        dateController.text = date.toString();
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: time);
    if (pickedTime != null && pickedTime != time) {
      setState(() {
        time = pickedTime;
        timeController.text = date.toString();
      });
    }
  }

  navigateToDiaganosticDetail(DocumentSnapshot? post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DiagnosticDetail(
                  post: post,
                )));
  }

  @override
  void initState() {
    getUserInfoFromUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? uId = widget.uid!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          uName!,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: FutureBuilder(
                future: getDetails(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(snapshot.data[index]['Date']),
                            onTap: () => navigateToDiaganosticDetail(
                                snapshot.data[index]),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddDiagnostics(
                        uid: uId,
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
