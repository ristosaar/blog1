import 'dart:math';
import 'otp_response.dart';

class MockHttpClient {
  var randomGenerator = new Random();

  Future<String> getResponseBody() async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _generateOneTimePassword();
  }




  _generateOneTimePassword() {
    return '{ "verificationCode": "' +
        randomGenerator.nextInt(10).toString() +
        randomGenerator.nextInt(10).toString() +
        randomGenerator.nextInt(10).toString() +
        randomGenerator.nextInt(10).toString() +
        '"}';
  }
}

class OneTimePasswordService {
  final httpClient = MockHttpClient();
  Future<OneTimePasswordResponse> getOneTimePassword(String phoneNumber) async {
    final responseBody = await httpClient.getResponseBody();
    return OneTimePasswordResponse.fromJson(responseBody);
  }
}