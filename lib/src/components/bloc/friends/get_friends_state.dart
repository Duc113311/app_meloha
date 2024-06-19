// part of 'get_friends_cubit.dart';
//
// @immutable
// abstract class GetFriendsState {
//   ListFriendsDto? result;
//   Failure? failure;
//
//   GetFriendsState({this.result, this.failure});
//
//   setSuccess(ListFriendsDto result) {
//     this.result = result;
//   }
//
//   setError(Failure failure) {
//     this.failure = failure;
//   }
// }
//
// class GetFriendsInitial extends GetFriendsState {}
//
// class GetFriendsSuccess extends GetFriendsState {
//   GetFriendsSuccess(ListFriendsDto result) {
//     super.setSuccess(result);
//   }
// }
//
// class GetFriendsFailed extends GetFriendsState {
//   GetFriendsFailed(Failure failure) {
//     setError(failure);
//   }
// }
