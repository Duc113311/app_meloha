import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../core/exception.dart';
import 'failure.dart';
import 'logger_interceptor.dart';

abstract class ResultMiddleHandler {
  static Future<Either<Failure, T>> checkResult<T>(Function function) async {
    try {
      final data = await function.call();
      return Right(data);
    } on ForbiddenException catch (e) {
      cancelTokenMiddleware.cancel();
      // RouteService.popToBlocked(forBiddenResponseDto: e.forBiddenDto);
      return Left(ForbiddenFailure(e.message));
    } on UnauthorizedException catch (e) {
      print('UnauthorizedException  $e');
      Future.delayed(const Duration(seconds: 1)).whenComplete(() {
        // RouteService.routeOnboarding();
      });
      return Left(UnauthorizedFailure(e.message));
    } on ErrorStatusFromServerWithStatus200 catch (e) {
      return Left(e);
    } catch (e) {
      print('${e
      is ServerException ? e.message : e} \n');
      if (!cancelTokenMiddleware.isCancelled) {
        String codeError = getCodeError(e is ServerException ? e.message : e, function);
        log(codeError);
        // DialogService.showErrorDefault(codeError: codeError);
      }
      return Left(ServerFailure('Server error'));
    }
  }

  static getCodeError(dynamic errorFromCatch, Function function) {
    List<dynamic> errors = [];
    errors.add(DateTime.now());
    errors.add(function);
    errors.add(StackTrace.current);
    errors.add(LoggerInterceptor.requestOptionsError);
    errors.add(LoggerInterceptor.responseError?.data);
    errors.add(errorFromCatch.toString());
    return errors.join("\n");
  }
}
