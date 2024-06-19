part of 'explore_detail_page_cubit.dart';

@immutable
abstract class ExploreDetailPageState {

  String? errorMessage;
  List<CustomerDto>? customDto;

  copy(ExploreDetailPageState state) {
    this.customDto = state.customDto ?? <CustomerDto>[];
  }

  setError(String? errorMessage) {
    this.errorMessage = errorMessage;
  }
}


class ExploreDetailPageInitial extends ExploreDetailPageState {}

class ExploreDetailPageLoading extends ExploreDetailPageState {}

class ExploreDetailPageSuccess extends ExploreDetailPageState {
  ExploreDetailPageSuccess(ExploreDetailPageState state) {
    super.copy(state);
  }
}


class ExploreDetailPageFailed extends ExploreDetailPageState {
  ExploreDetailPageFailed(Failure failure) {
    setError(failure.message);
  }
}

