import 'package:dating_app/src/data/datasource/chat_datasource/get_friends_datasource.dart';
import 'package:dating_app/src/domain/dtos/chat/list_friends_dto/list_friends_dto.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class GetFriendsRepo {
  GetFriendsDataSource get getFriendsDataSource => getIt<GetFriendsDataSource>();

  Future<Either<Failure, ListFriendsDto>> getAllFriends(int pageSize, int currentPage) async {
    return ResultMiddleHandler.checkResult(() async {
      return await getFriendsDataSource.getAllFriends(pageSize, currentPage);
    });
  }

  Future<Either<Failure, ListFriendsDto>> getNewFriends(int pageSize, int currentPage) async {
    return ResultMiddleHandler.checkResult(() async {
      return await getFriendsDataSource.getNewFriends(pageSize, currentPage);
    });
  }

}