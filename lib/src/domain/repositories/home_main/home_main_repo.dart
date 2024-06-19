import 'package:injectable/injectable.dart';
import 'package:either_dart/either.dart';
import '../../../data/datasource/home_main/home_main_datasource.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../dtos/customers/customers_dto.dart';

@Singleton()
class HomeMainRepo {
  HomeMainDataSource get homeMainDataSource => getIt<HomeMainDataSource>();

  Future<Either<Failure, CustomersDto>> getCards() async {
    return ResultMiddleHandler.checkResult(() async {
      return await homeMainDataSource.getListCards();
    });
  }

}
