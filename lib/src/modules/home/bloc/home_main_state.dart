part of 'home_main_cubit.dart';

@immutable
abstract class HomeMainState extends Equatable {
  final String? errorMessage;
  final List<CustomerDto>? customDto;
  final DateTime _time;

  HomeMainState({this.customDto, this.errorMessage}) : _time = DateTime.now();

  @override
  List<Object?> get props => [customDto,errorMessage,_time];
}

class HomeMainInitial extends HomeMainState {}

class HomeMainLoading extends HomeMainState {}

class HomeMainNotLocation extends HomeMainState {}

class HomeMainNotData extends HomeMainState {}

class HomeMainSuccess extends HomeMainState {
  HomeMainSuccess({super.customDto});
}

class HomeMainBuildSuccess extends HomeMainState {
  HomeMainBuildSuccess({super.customDto});
}
class HomeMainAddDataSuccess extends HomeMainState {
  HomeMainAddDataSuccess({super.customDto});
}

class HomeMainFailed extends HomeMainState {
   HomeMainFailed({super.errorMessage});

}
