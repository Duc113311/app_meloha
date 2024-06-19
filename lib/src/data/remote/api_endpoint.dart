
import '../../general/constants/app_enum.dart';

abstract class ApiEndpoint {
  ApiEndpoint({required this.environment});
  AppEnvironment environment;
  String baseUrl();
  String chatHost();

  /// fetch full path for query server
  /// fullPath  = baseUrl server of environment + path;
  String getUrlQueryApi(String path) => '${baseUrl()}/$path';
  String getChatUrlQueryApi(String path) => '${chatHost()}/$path';
}

class AppPath {
  static const register = "api/v1/register";
  static const cards = "api/v1/cards/recommends";
  static const like = "api/v1/like";
  static const superLike = "api/v1/superLike";
  static const nope = "api/v1/nope";
  static const boost = "api/v1/boost";
  static const report = "api/v1/report";
  static const reasons = "api/v1/reasons";
  static const guestStatics = "api/v1/guest/statics";
  static const staticsCommon = "api/v1/statics/commons";
  static const staticsReason = "api/v1/statics/reason";
  static const staticsPrompt = "api/v1/guest/prompts";
  static const staticsBasics = "api/v1/statics/basics";
  static const staticsLifeStyles = "api/v1/statics/life-styles";
  static const likes = "api/v1/list-action-you";
  static const forYou = "api/v1/list-you-action";
  static const deletedAccount = "api/v1/users/delete";
  static const joinExplore = "api/v1/topics";
  static const getCardExplore = "api/v1/cards/group";
  static const verifyUrl = "api/v1/users/verify";
  static const getTopics = "api/v1/topics";
  static const getVerifiedCards = "api/v1/cards/verified";

  static const profileImages = "api/v1/image/profile";
  static const changeImageOrder = "api/v1/image/profileChangeOrder";

  static String outTopic(String topicId) {
    return "api/v1/topics/$topicId/out";
  }


  /// Chat
  static String addMessage(String channelId) {
    return "api/v1/channels/$channelId/add-message";
  }

  static String editMessage(String messageId) {
    return "api/v1/messages/$messageId/edit";
  }

  static String removeMessage(String messageId) {
    return "api/v1/messages/$messageId/remove";
  }

  static String updateStatusMessage() {
    return "api/v1/messages/update-status";
  }

  static String getMessages(String channelId, int pageSize, int currentPage) {
    return "api/v1/channels/$channelId/messages?pageSize=$pageSize&currentPage=$currentPage";
  }

  static String getAllFriends(int pageSize, int currentPage) {
    return "api/v1/friends/?pageSize=$pageSize&currentPage=$currentPage";
  }

  static String getNewFriends(int pageSize, int currentPage) {
    return "api/v1/friends/new/?pageSize=$pageSize&currentPage=$currentPage";
  }

  static String getChannels(int pageSize, int currentPage) {
    return "api/v1/channels/?pageSize=$pageSize&currentPage=$currentPage";
  }

  static String getChannelId(String receiverId) {
    return "api/v1/getChannelId?receiverId=$receiverId";
  }

  static String removeChannel(String channelId) {
    return "api/v1/channels/$channelId/remove";
  }

}