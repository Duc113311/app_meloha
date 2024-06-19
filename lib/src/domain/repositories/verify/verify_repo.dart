import 'package:dating_app/src/data/datasource/verify/verify_datasource.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class VerifyRepo {
  VerifyDataSource get data => getIt<VerifyDataSource>();

  Future<Either<Failure, bool>> verifyPhotos(List<String> videoUrl) async {
    return ResultMiddleHandler.checkResult(() async {
      return await data.verifyPhotos(videoUrl);
    });
  }

}
