import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SFCal extends StatefulWidget {
  static const routeName = '/sync_cal';
  // const SFCal({ Key? key }) : super(key: key);

  @override
  _SFCalState createState() => _SFCalState();
}

class _SFCalState extends State<SFCal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments Calendar'),
      ),
      drawer: AdminAppDrawer(),
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 6,
        dataSource: MeetingDataSource(getAppointments()),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting',
      color: Colors.blue,
      recurrenceRule: 'FREQ=DAILY;COUNT=3',
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

