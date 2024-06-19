
import 'package:dating_app/src/data/datasource/chat_datasource/remove_channel_datasource.dart';
import 'package:dating_app/src/domain/dtos/response_base/response_base_dto.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class RemoveChannelRepo {
  RemoveChannelDataSource get removeChannelDatasource => getIt<RemoveChannelDataSource>();

  Future<Either<Failure, ResultAPI<AnyJson>>> removeChannel(String channelId) async {
    return ResultMiddleHandler.checkResult(() async {
      return await removeChannelDatasource.removeChannel(channelId);
    });
  }

}
