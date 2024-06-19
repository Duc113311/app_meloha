/*
import 'package:dating_app/src/components/models/customer.dart';
import 'package:dating_app/src/data/datasource/explore/explore_datasource.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../dtos/customers/customers_dto.dart';

@Singleton()
class ExploreRepo {
  ExploreDataSource get data => getIt<ExploreDataSource>();

  Future<Either<Failure, Customer?>> joinExplore(String idTopic) async {
    return ResultMiddleHandler.checkResult(() async {
      return await data.joinExplore(idTopic);
    });
  }

  Future<Either<Failure, CustomersDto>> getCards(String idTopic) async {
    return ResultMiddleHandler.checkResult(() async {
      return await data.getListCards(idTopic);
    });
  }
}
*/
