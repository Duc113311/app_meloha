part of 'chat_conversation_bloc.dart';

@immutable
abstract class ChatConversationState {}

class ChatConversationInitial extends ChatConversationState {}

class GetAllChannelStateLoading extends ChatConversationState {}

class GetAllChannelStateLoaded extends ChatConversationState {
  final ListChannelsDto channels;

  GetAllChannelStateLoaded({required this.channels});
}

class GetAllChannelStateError extends ChatConversationState {
  final Failure error;

  GetAllChannelStateError({required this.error});
}

class GetNewFriendStateLoading extends ChatConversationState {}

class GetNewFriendStateLoaded extends ChatConversationState {
  final ListFriendsDto friends;

  GetNewFriendStateLoaded({required this.friends});
}

class GetNewFriendStateError extends ChatConversationState {
  final Failure error;

  GetNewFriendStateError({required this.error});
}

class GetOtherLikeYouStateLoading extends ChatConversationState {}

class GetOtherLikeYouStateLoaded extends ChatConversationState {
  final LikeTopDto likeYou;

  GetOtherLikeYouStateLoaded({required this.likeYou});
}

class GetOtherLikeYouStateError extends ChatConversationState {
  final Failure error;

  GetOtherLikeYouStateError({required this.error});
}
