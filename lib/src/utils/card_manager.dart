import 'package:dating_app/src/utils/utils.dart';

import '../domain/dtos/customers/customers_dto.dart';
import '../domain/repositories/home_main/home_main_repo.dart';
import '../domain/services/connect/connectivity_service.dart';
import '../general/inject_dependencies/inject_dependencies.dart';

class CardManager {
  static final CardManager _shared = CardManager._internal();

  CardManager._internal();

  static CardManager shared() => _shared;

  //Variables
  HomeMainRepo homeMainRepo = getIt<HomeMainRepo>();
  List<CustomerDto> listCustomers = [];
  int currentIndex = 0;

  CustomerDto? get currentCustomer {
    if (listCustomers.isEmpty) {return null;}
    if (currentIndex < listCustomers.length) {
      return listCustomers[currentIndex];
    } else {
      return listCustomers.first;
    }
  }

  Future<List<CustomerDto>> getCards(bool addMore) async {
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return [];
    }
    return await homeMainRepo.getCards().then(
          (value) => value.fold(
            (left) {
              return [];
            },
            (right) {
              if (addMore) {
                listCustomers.addAll(right.data);
              } else {
                listCustomers = right.data;
              }
              return right.data;
            },
          ),
        );
  }

  Future<void> removeAll() async {
    listCustomers.clear();
    currentIndex = 0;
  }
}
