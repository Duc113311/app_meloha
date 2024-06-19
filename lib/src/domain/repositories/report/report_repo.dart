import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasource/report/report_datasource.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../dtos/report/report_dto.dart';

@Singleton()
class ReportRepo {
  ReportDataSource get data => getIt<ReportDataSource>();

  Future<Either<Failure, ReasonDto>> getReason() async {
    return ResultMiddleHandler.checkResult(() async {
      return await data.getReason();
    });
  }

  Future<Either<Failure, ReportDto>> report(ReportDto reportDto) async {
    return ResultMiddleHandler.checkResult(() async {
      return await data.report(reportDto);
    });
  }

}
