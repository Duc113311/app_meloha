import 'dart:async';

class OTPManager {
  static final OTPManager _shared = OTPManager._internal();

  OTPManager._internal();

  static OTPManager shared() => _shared;

  //Variables
  final int MAX_REQUEST_OTP = 4;
  final int MAX_REQUEST_DURATION = 1000 * 3600 * 24;

  List<OTPModel> allValues = [];
  final int TIME_TO_CAN_RESEND = 30 * 1000; // 30s
  int lastTime = 0;
  Timer? resentTimer;

  void Function(int time)? _callback;

  String _phoneNumber = "";
  String verificationId = "";

  bool isWaiting(String phone) {
    return _phoneNumber == phone && canResent;
  }

  bool get canResent {
    return (DateTime.now().millisecondsSinceEpoch - lastTime) >=
        TIME_TO_CAN_RESEND;
  }

  void reset() {
    _phoneNumber = "";
    verificationId = "";
    allValues = [];
  }

  Future<void> _addOTP(OTPModel otp) async {
    allValues.add(otp);
  }

  bool isValid(OTPModel otp) {
    _addOTP(otp);

    final oldValues =
    allValues.where((element) => element.phone == otp.phone).toList();
    oldValues.sort((a, b) => a.time.millisecond.compareTo(b.time.millisecond));

    if (oldValues.length < MAX_REQUEST_OTP) {
      return true;
    } else {
      final item = oldValues[MAX_REQUEST_OTP - 1];
      final validTime = DateTime.now().millisecond - item.time.millisecond;
      return validTime > MAX_REQUEST_DURATION;
    }
  }

  void registerCallback(void Function(int time) callback) {
    _callback = callback;
  }

  void startTimer(String phoneNumber, String verificationID) {
    if (resentTimer != null && _phoneNumber == phoneNumber) {
      return;
    }
    _phoneNumber = phoneNumber;
    verificationId = verificationID;
    lastTime = DateTime.now().millisecondsSinceEpoch;
    resentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      double time = (TIME_TO_CAN_RESEND -
          (DateTime.now().millisecondsSinceEpoch - lastTime))
          .toDouble() /
          1000;


      if (_callback != null) {
        _callback!(time.toInt());
      }
      if (time <= 0) {
        resentTimer?.cancel();
        resentTimer = null;
      }
    });
  }
}

class OTPModel {
  OTPModel({required this.phone});

  String phone;
  DateTime time = DateTime.now();
}
