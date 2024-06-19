import 'package:dating_app/src/domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasource/like_and_for_you/like_and_for_you_datasource.dart';
import '../../../data/object_request_api/likes_and_for_you/likes_request.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class LikeAndForYouRepo {
  LikeAndForYouDataSource get likeAndForYouDataSource => getIt<LikeAndForYouDataSource>();

  Future<Either<Failure, LikeTopDto>> getLikes(LikesRequest likesRequest) async {
    return ResultMiddleHandler.checkResult(() async {
      return await likeAndForYouDataSource.getLikes(likesRequest);
    });
  }

  Future<Either<Failure, LikeTopDto>> getForYou(LikesRequest likesRequest) async {
    return ResultMiddleHandler.checkResult(() async {
      return await likeAndForYouDataSource.getForYou(likesRequest);
    });
  }

}
