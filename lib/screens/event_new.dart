import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:the_endodontist_app/screens/CalendarClient.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';

class EventNew extends StatefulWidget {
  static const routeName = '/event_new';

  @override
  _EventNewState createState() => _EventNewState();
}

class _EventNewState extends State<EventNew> {
  CalendarClient calendarClient = CalendarClient();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(days: 1));
  TextEditingController _eventName = TextEditingController();
  TextEditingController _eventDesc = TextEditingController();
  
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1950, 1, 1),
                          maxTime: DateTime(2200, 12, 31), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          this.startTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      'Event Start Time',
                      style: TextStyle(color: Colors.blue),
                    )),
                Text('$startTime'),
              ],
            ),
            // RichText(
            //   text: TextSpan(
            //     text: 'Start Time',
            //     style: TextStyle(
            //       color: Colors.cyan,
            //       // fontFamily: 'Raleway',
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //       letterSpacing: 1,
            //     ),
            //     children: <TextSpan>[
            //       TextSpan(
            //         text: '*',
            //         style: TextStyle(
            //           color: Colors.red,
            //           fontSize: 28,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   cursorColor: Colors.blue[200],
            //   controller: textControllerStartTime,
            //   onTap: () {
            //     DatePicker.showDateTimePicker(context,
            //         showTitleActions: true,
            //         minTime: DateTime(1950, 1, 1),
            //         maxTime: DateTime(2200, 12, 31), onChanged: (date) {
            //       print('change $date');
            //     }, onConfirm: (date) {
            //       setState(() {
            //         this.startTime = date;
            //         textControllerStartTime = date as TextEditingController;
            //       });
            //     }, currentTime: DateTime.now(), locale: LocaleType.en);
            //   },
            //   readOnly: true,
            //   style: TextStyle(
            //     color: Colors.black87,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 0.5,
            //   ),
            //   decoration: new InputDecoration(
            //     disabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //       borderSide: BorderSide(color: Colors.blue, width: 1),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //       borderSide: BorderSide(color: Colors.blue, width: 1),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //       borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            //     ),
            //     errorBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //       borderSide: BorderSide(color: Colors.redAccent, width: 2),
            //     ),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //     ),
            //     contentPadding: EdgeInsets.only(
            //       left: 16,
            //       bottom: 16,
            //       top: 16,
            //       right: 16,
            //     ),
            //     hintText: 'eg: 09:30 AM',
            //     hintStyle: TextStyle(
            //       color: Colors.grey.withOpacity(0.6),
            //       fontWeight: FontWeight.bold,
            //       letterSpacing: 0.5,
            //     ),
            //     errorText: textControllerStartTime.text.isNotEmpty
            //         ? null
            //         : 'Start time can\'t be empty',
            //     errorStyle: TextStyle(
            //       fontSize: 12,
            //       color: Colors.redAccent,
            //     ),
            //   ),
            // ),
            Row(
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1950, 1, 1),
                          maxTime: DateTime(2200, 12, 31), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          this.endTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      'Event End Time',
                      style: TextStyle(color: Colors.blue),
                    )),
                Text('$endTime'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _eventName,
                decoration: InputDecoration(hintText: 'Enter Event Title'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _eventDesc,
                decoration:
                    InputDecoration(hintText: 'Enter Event Description'),
              ),
            ),
            ElevatedButton(
                child: Text(
                  'Add Event',
                ),
                // color: Colors.grey,
                onPressed: () {
                  //log('add event pressed');
                  calendarClient.insert(
                    _eventName.text,
                    _eventDesc.text,
                    startTime,
                    endTime,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
