import 'package:flutter/material.dart';

class NotificationSend extends StatefulWidget {
  static const routeName = '/notifications_sent';
  final String? payload;

  const NotificationSend({
    Key? key,
    required this.payload,
  }) : super(key: key);

  @override
  _NotificationSendState createState() => _NotificationSendState();
}

class _NotificationSendState extends State<NotificationSend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Sent'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.payload ?? '',
            ),
            SizedBox(
              height: 20,
            ),
            Text('PAYLOAD'), 
          ],
        ),
        ),
    );
  }
}

  