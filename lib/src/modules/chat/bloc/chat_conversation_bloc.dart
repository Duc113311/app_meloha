import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/src/data/object_request_api/likes_and_for_you/likes_request.dart';
import 'package:dating_app/src/data/remote/middle-handler/failure.dart';
import 'package:dating_app/src/domain/dtos/chat/list_friends_dto/list_friends_dto.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/dtos/chat/channel/get_channels_dto.dart';
import '../../../domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import '../../../domain/repositories/chat_repo/get_channels_repo.dart';
import '../../../domain/repositories/chat_repo/get_friends_repo.dart';
import '../../../domain/repositories/like_and_for_you/like_an_for_you_repo.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

part 'chat_conversation_event.dart';

part 'chat_conversation_state.dart';

class ChatConversationBloc
    extends Bloc<ChatConversationEvent, ChatConversationState> {

  //Repo
  final GetChannelsRepo _getChannelsRepo = getIt<GetChannelsRepo>();
  final LikeAndForYouRepo _likeAndForYouRepo = getIt<LikeAndForYouRepo>();
  final GetFriendsRepo _getFriendsRepo = getIt<GetFriendsRepo>();

  ChatConversationBloc() : super(ChatConversationInitial()) {
    on<GetAllChannelEventLoading>(
      (event, emit) async {
        emit(GetAllChannelStateLoading());
      },
    );
    on<GetAllChannelEventLoaded>(
      (event, emit) => emit(GetAllChannelStateLoaded(channels: event.channels)),
    );
    on<GetAllChannelEventRaiseError>(
      (event, emit) => emit(GetAllChannelStateError(error: event.error)),
    );

    on<GetNewFriendEventLoading>(
      (event, emit) async {
        emit(GetNewFriendStateLoading());
      },
    );
    on<GetNewFriendEventLoaded>(
      (event, emit) => emit(GetNewFriendStateLoaded(friends: event.friends)),
    );
    on<GetNewFriendEventRaiseError>(
      (event, emit) => emit(GetNewFriendStateError(error: event.error)),
    );

    on<GetOtherLikeYouEventLoading>(
          (event, emit) async {
        emit(GetOtherLikeYouStateLoading());
      },
    );
    on<GetOtherLikeYouEventLoaded>(
          (event, emit) => emit(GetOtherLikeYouStateLoaded(likeYou: event.likeYou)),
    );
    on<GetOtherLikeYouEventError>(
          (event, emit) => emit(GetOtherLikeYouStateError(error: event.error)),
    );
  }

  Future loadAllChannels(int pageSize, int currentPage) async {
    add(GetAllChannelEventLoading());

    _getChannelsRepo.getChannels(pageSize, currentPage).then(
          (value) => value.fold(
            (left) {
              add(GetAllChannelEventRaiseError(error: left));
            },
            (right) {
              add(GetAllChannelEventLoaded(channels: right));
            },
          ),
        );
  }

  Future getNewMatches(int pageSize, int currentPage) async {
    add(GetNewFriendEventLoading());

    _getFriendsRepo.getNewFriends(pageSize, currentPage).then(
          (value) => value.fold(
            (left) {
              add(GetNewFriendEventRaiseError(error: left));
            },
            (right) {
              add(GetNewFriendEventLoaded(friends: right));
            },
          ),
        );
  }

  Future getOtherLikes(int pageSize, int currentPage) async {
    add(GetOtherLikeYouEventLoading());
    final likesRequest = LikesRequest(-1, 0, 'like');

    _likeAndForYouRepo.getLikes(likesRequest).then(
          (value) => value.fold(
            (left) {
          add(GetOtherLikeYouEventError(error: left));
        },
            (right) {
          add(GetOtherLikeYouEventLoaded(likeYou: right));
        },
      ),
    );
  }

}
