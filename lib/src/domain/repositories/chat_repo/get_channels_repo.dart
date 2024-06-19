import 'package:dating_app/src/data/datasource/chat_datasource/get_channels_datasource.dart';
import 'package:dating_app/src/domain/dtos/chat/channel/get_channels_dto.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class GetChannelsRepo {
  GetChannelsDataSource get getChannelsDataSource => getIt<GetChannelsDataSource>();

  Future<Either<Failure, ListChannelsDto>> getChannels(int pageSize, int currentPage) async {
    return ResultMiddleHandler.checkResult(() async {
      return await getChannelsDataSource.getChannels(pageSize, currentPage);
    });
  }

}