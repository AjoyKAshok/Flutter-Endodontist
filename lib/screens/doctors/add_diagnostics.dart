import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:flutter/material.dart';

class AddDiagnostics extends StatefulWidget {
  static const routeName = '/add_diagnostics';

  final String? uid;
  // final String id;
  AddDiagnostics({
    this.uid,
  });

  @override
  _AddDiagnosticsState createState() => _AddDiagnosticsState();
}

class _AddDiagnosticsState extends State<AddDiagnostics> {
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  late String selectedDateTime;
  late String selectedTimeDate;
  String? pickedDateAndTime;
  String? imageLink;
  String? _userId;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  Future getUserInfo() async {
    String? uId = widget.uid!;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          _userName.text = snapshot['User Name'];
          _userId = snapshot['User Id'];
        });
      }
    });
    return documentReference;
  }

  Future getUserPic() async {
    String? uId = widget.uid!;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Profile Pics').doc(uId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          imageLink = snapshot['Profile Image Path'];
        });
      }
    });
    return documentReference;
  }

  final TextEditingController _userName = TextEditingController();
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
        selectedDateTime = "${date.year} : ${date.month} : ${date.day}";
        dateController.text = selectedDateTime;
        // print(selectedDateTime);
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: time);
    if (pickedTime != null) {
      setState(() {
        time = pickedTime;
        selectedTimeDate = "${time.hour} : ${time.minute}";
        timeController.text = selectedTimeDate;
        // print(selectedTimeDate);
        pickedDateAndTime = "${dateController.text} - ${timeController.text}";
      });
    }
  }

  @override
  void initState() {
    getUserInfo();
    getUserPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${'Add Diaganostic of -'} ${_userName.text}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_userName.text}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.save_sharp,
                          color: Colors.green,
                          size: 29,
                        ),
                        onPressed: () async {
                          await updateDetail(
                            _userName.text,
                            _userId,
                            detailController.text,
                            pickedDateAndTime,
                          );

                          Navigator.of(context).pop();
                          // print(_userId);
                        }),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 29,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Select Date'),
                    IconButton(
                      icon: Icon(Icons.calendar_today_sharp),
                      onPressed: () {
                        selectDatePicker(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Select Time'),
                    IconButton(
                      icon: Icon(Icons.timer_outlined),
                      onPressed: () {
                        selectTime(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: detailController,
                  maxLines: 15,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
