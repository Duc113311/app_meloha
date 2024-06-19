part of 'verify_cubit.dart';

@immutable
abstract class VerifyState {}

class VerifyInitial extends VerifyState {}
class VerifyLoading extends VerifyState {}
class VerifySuccess extends VerifyState {}
class VerifyFailed extends VerifyState {}
