part of 'report_cubit.dart';
enum ReportEnum { REASON, HAPPEN, ABOUT }
@immutable
abstract class ReportState {
  ReportState({
    this.reportEnum,
    this.reportDto,
    this.percent = 0,
    });

  ReportEnum? reportEnum;
  List<ReasonsDto>? reportDto;
  double percent;

  copy(ReportState state) {
    reportEnum = state.reportEnum;
    reportDto = state.reportDto;
    percent = state.percent;
  }
}

class ReportInitial extends ReportState {
  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && other is ReportInitial  && reportEnum == other.reportEnum &&
        percent == other.percent;
  }

  @override
  int get hashCode =>
      Object.hash(reportEnum,percent);
}
class ReportLoading extends ReportState {
  ReportLoading(ReportState state) {
    super.copy(state);
  }
}

class ReportSuccess extends ReportState {
  ReportSuccess(ReportState state) {
    super.copy(state);
  }
}

// state is happened when user answered all the question
class ReportComplete extends ReportState {
  ReportComplete();
}

class ReportCompleteWithError extends ReportState {
  ReportCompleteWithError();
}

class ReportSelecteAnswer extends ReportState {
  ReportSelecteAnswer(ReportState state,
      {required this.selectedAnswer, required this.isCorrect}) {
    super.copy(state);
  }

  final String selectedAnswer;
  final bool isCorrect;
}

class ReportInputAnswer extends ReportState {
  ReportInputAnswer(ReportState state, {required this.isCorrect}) {
    super.copy(state);
  }

  final bool isCorrect;
}
