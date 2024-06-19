import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/repositories/report/report_repo.dart';
import 'package:meta/meta.dart';

import '../../../domain/dtos/report/report_dto.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  final ReportRepo repo = ReportRepo();

  //

  // late ReportDto report;
  ReportDto report = ReportDto();

  int selectReasonId = 0;

  double currentPercent = 1.0 / 3.0;

  Future<void> getReason() async {
    await Future.delayed(const Duration(milliseconds: 600), () {
      emit(ReportLoading(state));
    });
    repo.getReason().then((value) => value.fold((left) {
          return null;
        }, (right) {
          Future.delayed(const Duration(milliseconds: 600), () {
            emit(ReportSuccess(state)
              ..percent = currentPercent
              ..reportDto = right.reports);
          });
        }));
  }

  Future<void> pushReport(ReportDto reportDto) async {
    await Future.delayed(const Duration(milliseconds: 600), () {
      emit(ReportLoading(state));
    });
    repo.report(reportDto).then((value) => value.fold((left) {
          return null;
        }, (right) {
          Future.delayed(const Duration(milliseconds: 600), () {
            emit(ReportComplete());
          });
        }));
  }

  Future<void> saveDataReport({
    String? userId,
    String? reasonId,
    String? reasonDetail,
    String? comments,
  }) async {
    report = report.copyWith(
      userId: userId,
      reasonId: reasonId,
      reasonDetail: reasonDetail,
      comments: comments,
    );
  }
}
