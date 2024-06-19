import 'package:dating_app/src/data/datasource/chat_datasource/get_channel_id_datasource.dart';
import 'package:dating_app/src/domain/dtos/chat/channel/get_channel_id.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class GetChannelIdRepo {
  GetChannelIdDataSource get getChannelIdDataSource => getIt<GetChannelIdDataSource>();

  Future<Either<Failure, ChannelIdDto>> getChannelId(receiverId) async {
    return ResultMiddleHandler.checkResult(() async {
      return await getChannelIdDataSource.getChannelId(receiverId);
    });
  }

}