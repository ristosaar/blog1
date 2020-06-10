import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_service.dart';
import 'otp_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _phoneNumber;
  Future<OneTimePasswordResponse> otpResponseFuture;
  final otpService = OneTimePasswordService();

  void getOneTimePassword() async {
    setState(() {
      otpResponseFuture = otpService.getOneTimePassword(_phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: TextField(
                  onChanged: (phoneNumber) {
                    setState(() {
                      _phoneNumber = phoneNumber;
                    });
                  },
                  decoration: InputDecoration(hintText: 'Enter a phone number'),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number),
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            FutureBuilder<OneTimePasswordResponse>(
              future: otpResponseFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text(error.toString());
                } else if (snapshot.hasData) {
                  final response = snapshot.data;
                  return Text(response.toString());
                } else {
                  return Text(
                      'After entering the phone number, press the button below');
                }
              },
            ),
            RaisedButton(
              onPressed: () {
                getOneTimePassword();
              },
              child: Text('Get Code'),
            ),
          ],
        ),
      ),
    );
  }
}
