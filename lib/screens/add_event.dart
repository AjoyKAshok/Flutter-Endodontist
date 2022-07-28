import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:the_endodontist_app/screens/CalendarClient.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';

class AddEvent extends StatefulWidget {
  static const routeName = '/add_event';
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  CalendarClient calendarClient = CalendarClient();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(days: 1));
  TextEditingController _eventName = TextEditingController();
  TextEditingController _eventDesc = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  late TextEditingController textControllerDate;
  DateTime selectedDate = DateTime.now();
  bool isEditingDate = false;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2200),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textControllerDate.text = selectedDate.toString();
      });
    }
  }

  @override
  void initState() {
    textControllerDate = TextEditingController();
    // textControllerStartTime = TextEditingController();
    // textControllerEndTime = TextEditingController();
    // textControllerTitle = TextEditingController();
    // textControllerDesc = TextEditingController();
    // textControllerLocation = TextEditingController();
    // textControllerAttendee = TextEditingController();

    // textFocusNodeTitle = FocusNode();
    // textFocusNodeDesc = FocusNode();
    // textFocusNodeLocation = FocusNode();
    // textFocusNodeAttendee = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Page'),
      ),
      drawer: AdminAppDrawer(),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Select Date',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        // fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    cursorColor: Colors.purpleAccent,
                    controller: textControllerDate,
                    textCapitalization: TextCapitalization.characters,
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    decoration: new InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.redAccent, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 16,
                        bottom: 16,
                        top: 16,
                        right: 16,
                      ),
                      hintText: 'eg: September 10, 2020',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      errorText:
                          isEditingDate && textControllerDate.text != null
                              ? textControllerDate.text.isNotEmpty
                                  ? null
                                  : 'Date can\'t be empty'
                              : null,
                      errorStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Start Time',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        // fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    cursorColor: Colors.purpleAccent,
                    controller: startTimeController,
                    textCapitalization: TextCapitalization.characters,
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1950, 1, 1),
                          maxTime: DateTime(2200, 12, 31), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          this.startTime = date;
                          startTimeController.text =
                              // DateFormat.Hms().format(startTime).toString();
                              // DateFormat.yMEd().format(startTime).toString();
                              DateFormat.yMMMEd().format(startTime).toString();
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    readOnly: true,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    decoration: new InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.redAccent, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 16,
                        bottom: 16,
                        top: 16,
                        right: 16,
                      ),
                      hintText: 'eg: 09:30 AM',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      // errorText: isEditingDate && textControllerDate.text != null
                      //     ? textControllerDate.text.isNotEmpty
                      //         ? null
                      //         : 'Date can\'t be empty'
                      //     : null,
                      // errorStyle: TextStyle(
                      //   fontSize: 12,
                      //   color: Colors.redAccent,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
