import 'otp_response.dart';
import 'otp_service.dart';
import 'verification_exception.dart';
import 'package:flutter/cupertino.dart';

enum NotifierState { initial, loading, loaded }

class VerificationChangeNotifier extends ChangeNotifier {
  final _otpService = OneTimePasswordService();

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
  }

  VerificationException _exception;
  VerificationException get exception => _exception;
  void _setFailure(VerificationException exception) {
    _exception = exception;
  }

  OneTimePasswordResponse _otpResponse;
  OneTimePasswordResponse get otpResponse => _otpResponse;
  void _setPost(OneTimePasswordResponse otpResponse) {
    _otpResponse = otpResponse;
  }

  void getOneTimePassword(String phoneNumber) async {
    _setState(NotifierState.loading);
    try {
      final post = await _otpService.getOneTimePassword(phoneNumber);
      _setPost(post);
    } on VerificationException catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }
}