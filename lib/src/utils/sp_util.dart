
import 'package:sp_util/sp_util.dart';

class SPService {
  Future<void> getInstance() async {
    if (!SpUtil.isInitialized()) await SpUtil.getInstance();
  }

  static final SPService _singleton = SPService._internal();

  factory SPService() => _singleton;

  SPService._internal();

}

SPService spService = SPService();
