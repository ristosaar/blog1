import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'otp_service.dart';
import 'otp_response.dart';
import 'verification_change_notifier.dart';

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
      home: ChangeNotifierProvider(
        create: (_) => VerificationChangeNotifier(),
        child: MyHomePage(title: 'Flutter Error Handling Demo'),
      ),
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
  void getOneTimePassword() async {
    Provider.of<VerificationChangeNotifier>(context)
        .getOneTimePassword(_phoneNumber);
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
            Consumer<VerificationChangeNotifier>(
              builder: (_, notifier, __) {
                if (notifier.state == NotifierState.initial) {
                  return Text(
                      'After entering the phone number, press the button below');
                } else if (notifier.state == NotifierState.loading) {
                  return CircularProgressIndicator();
                } else {
                  if (notifier.exception != null) {
                    return Text(notifier.exception.toString());
                  } else {
                    return Text(notifier.otpResponse.toString());
                  }
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
