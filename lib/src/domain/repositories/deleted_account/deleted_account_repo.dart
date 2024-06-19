import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasource/deleted_account/deleted_account_datasource.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class DeletedAccountRepo {
  DeletedAccountDataSource get data => getIt<DeletedAccountDataSource>();

  Future<Either<Failure, bool>> deleted() async {
    return ResultMiddleHandler.checkResult(() async {
      return await data.deleted();
    });
  }
}
