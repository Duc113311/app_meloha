part of 'chat_conversation_bloc.dart';

@immutable
abstract class ChatConversationEvent {
  const ChatConversationEvent();
}

class GetAllChannelEventLoading extends ChatConversationEvent {}

class GetAllChannelEventLoaded extends ChatConversationEvent {
  final ListChannelsDto channels;

  const GetAllChannelEventLoaded({required this.channels});
}

class GetAllChannelEventRaiseError extends ChatConversationEvent {
  final Failure error;

  const GetAllChannelEventRaiseError({required this.error});
}

class GetNewFriendEventLoading extends ChatConversationEvent {}

class GetNewFriendEventLoaded extends ChatConversationEvent {
  final ListFriendsDto friends;

  const GetNewFriendEventLoaded({required this.friends});
}

class GetNewFriendEventRaiseError extends ChatConversationEvent {
  final Failure error;

  const GetNewFriendEventRaiseError({required this.error});
}

class GetOtherLikeYouEventLoading extends ChatConversationEvent {}

class GetOtherLikeYouEventLoaded extends ChatConversationEvent {
  final LikeTopDto likeYou;

  const GetOtherLikeYouEventLoaded({required this.likeYou});
}

class GetOtherLikeYouEventError extends ChatConversationEvent {
  final Failure error;

  const GetOtherLikeYouEventError({required this.error});
}
