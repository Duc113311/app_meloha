import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasource/card_action/card_action_datasource.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../dtos/card_action/card_action_dto.dart';

@Singleton()
class CardActionRepo {
  CardActionDataSource get cardActionDataSource => getIt<CardActionDataSource>();

  Future<Either<Failure, LikeDto>> likeAction(String interactorId) async {
    return ResultMiddleHandler.checkResult(() async {
      return await cardActionDataSource.likeAction(interactorId);
    });
  }
  Future<Either<Failure, NopeDto>> supperLikeAction(String interactorId) async {
    return ResultMiddleHandler.checkResult(() async {
      return await cardActionDataSource.supperLikeAction(interactorId);
    });
  }
  Future<Either<Failure, NopeDto>> nopeAction(String interactorId) async {
    return ResultMiddleHandler.checkResult(() async {
      return await cardActionDataSource.nopeAction(interactorId);
    });
  }
  Future<Either<Failure, BoostDto?>> boostAction() async {
    return ResultMiddleHandler.checkResult(() async {
      return await cardActionDataSource.boostAction();
    });
  }

}
