import 'package:flutter/material.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ReferencePage extends StatefulWidget {
  static const routeName = '/reference';
  @override
  _ReferencePageState createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  Future<void> sendMail(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('Could not Launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dentista'),
      ),
      drawer: AppDrawer(),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('QR Code', style: TextStyle(color: Colors.white,),),
              ),
              Card(
                color: Colors.white,
                elevation: 6,
                shadowColor: Colors.lightBlueAccent,
                child: Padding(
                  padding: EdgeInsets.all(9),
                  child: BarcodeWidget(
                    data: 'https://oximsoft.com/?page_id=13',
                    barcode: Barcode.qrCode(),
                    width: 200,
                    height: 200,
                    drawText: false,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Bar Code', style: TextStyle(color: Colors.white,),),
              ),
              Card(
                color: Colors.white,
                elevation: 6,
                shadowColor: Colors.lightBlueAccent,
                child: Padding(
                  padding: EdgeInsets.all(9),
                  child: BarcodeWidget(
                    data: 'https://oximsoft.com/?page_id=13',
                    barcode: Barcode.code128(),
                    width: 200,
                    height: 200,
                    drawText: false,
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(18),
              //     image: DecorationImage(
              //       image: AssetImage('assets/images/Ajit1.png'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              //   height: 250,
              //   width: 250,
              // ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);

                  sendMail(
                      'mailto:referalid@email.com?subject=Enter%20Subject&body=PlayStore%20Link:Link%20Here&iOS%20Link:Link%20Here');
                },
                child: Text('Send Referal Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
