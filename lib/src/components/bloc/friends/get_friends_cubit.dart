// import 'package:bloc/bloc.dart';
// import 'package:dating_app/src/domain/dtos/chat/list_friends_dto/list_friends_dto.dart';
// import 'package:dating_app/src/domain/repositories/chat_repo/get_friends_repo.dart';
// import 'package:meta/meta.dart';
//
// import '../../../data/remote/middle-handler/failure.dart';
// import '../../../domain/repositories/static_info/static_info_repo.dart';
//
// part 'get_friends_state.dart';
//
// class GetFriendsCubit extends Cubit<GetFriendsState> {
//   GetFriendsCubit() : super(GetFriendsInitial());
//
//   final GetFriendsRepo _repo = getIt<GetFriendsRepo>();
//
//   Future<void> getFriends(int pageSize, int currentPage) async {
//     _repo.getFriends(pageSize, currentPage).then((value) => value.fold((left) {
//       return emit(GetFriendsFailed(left));
//     }, (right) {
//       emit(GetFriendsSuccess(right));
//     },),);
//   }
// }
//
