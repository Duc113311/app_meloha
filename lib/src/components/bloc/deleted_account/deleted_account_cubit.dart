import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/repositories/deleted_account/deleted_account_repo.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:either_dart/either.dart';
import 'package:meta/meta.dart';

part 'deleted_account_state.dart';

class DeletedAccountCubit extends Cubit<DeletedAccountState> {
  DeletedAccountCubit() : super(DeletedAccountInitial());

  final DeletedAccountRepo repo = DeletedAccountRepo();

  Future<void> deleted() async {
    emit(DeletedAccountLoading());
    // call video verify
    repo.deleted().fold((left) {
      return emit(DeletedAccountFailed());
    }, (right)async {
      return emit(DeletedAccountSuccess());
    });
  }
}
