part of 'deleted_account_cubit.dart';

@immutable
abstract class DeletedAccountState {}

class DeletedAccountInitial extends DeletedAccountState {}
class DeletedAccountLoading extends DeletedAccountState {}
class DeletedAccountSuccess extends DeletedAccountState {}
class DeletedAccountFailed extends DeletedAccountState {}
