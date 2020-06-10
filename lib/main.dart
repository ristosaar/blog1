import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_service.dart';

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
  String _oneTimePassword;
  final otpService = OneTimePasswordService();

  void getOneTimePassword() async {
    var oneTimePasswordResponse = await otpService.getOneTimePassword(_phoneNumber);
    setState(() {
      _oneTimePassword = oneTimePasswordResponse.toString();
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
            if(_oneTimePassword != null) Text(_oneTimePassword),
            RaisedButton(
              onPressed: () {getOneTimePassword();},
              child: Text('Get Code'),
            ),
          ],
        ),
      ),
    );
  }
}
