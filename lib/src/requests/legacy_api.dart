// import 'dart:convert';
// import 'dart:math';
//
// import 'package:dating_app/src/services/api/account/tele_debug.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
//
// import '../../../model/interest_tag.dart';
// import '../../../model/local/sexual.dart';
// import '../../../utils/pref_assist.dart';
// import '../../model/account/auth_token.dart';
// import '../../model/account/auth_user.dart';
// import '../../model/account/auth_verify.dart';
// import '../../model/explore/explore_model.dart';
// import '../../model/home/match/like_object.dart';
// import '../../model/home/match/like_response.dart';
// import '../../model/home/match/match_object.dart';
// import '../../model/home/match/match_response.dart';
// import '../../model/home/match/profile_detail.dart';
// import '../../model/home/match/user_data.dart';
// import '../../model/likeTopic/filter_request.dart';
// import '../../model/likeTopic/like_user.dart';
//
// class RequestApi {
// // api insert new user
//   Future<AuthUser> createUserInfo(UserData accInfo) async {
//     String uId = PrefAssist.getMyUser().userId!;
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     String url = "user/v1/create-one/$uId";
//     await TeleDebug.debugMessage(url);
//     debugPrint("url : $url");
//     debugPrint("PARAM : ${accInfo.toRawJson()}");
//     try {
//       http.Response response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//         body: accInfo.toRawJson(),
//       );
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("response : ${response.body.toString()}");
//       return AuthUser.fromJson(body);
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//     return AuthUser(data: "", message: "");
//   }
//
// // Update user profile
//   Future<AuthUser> editUserInfo(Map<String, dynamic> userData) async {
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     String uId = PrefAssist.getMyUser().userId!;
//     String url = "user/v1/update-one/$uId";
//     await TeleDebug.debugMessage(url);
//     debugPrint("url : $url");
//     debugPrint("body param : ${userData.toString()}");
//
//     try {
//       http.Response response = await http.patch(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//         body: jsonEncode(userData),
//       );
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("response : ${response.body.toString()}");
//       return AuthUser.fromJson(body);
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//     return AuthUser.fromJson({});
//   }
//
// // create access token
//   Future<AuthToken> createAccessToken(String uId) async {
//     final String url = "login/v1/create-token/$uId";
//     await TeleDebug.debugMessage(url);
//     debugPrint("CREATE TOKEN URL : $url");
//     try {
//       http.Response response = await http.post(
//         Uri.parse(url),
//       );
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("Access Token : $body");
//       return AuthToken.fromJson(body);
//     } catch (e) {
//       debugPrint("Message Error : ${e.toString()}");
//     }
//     return AuthToken.fromJson({});
//   }
//
// // logout
//   Future<void> doLogout(String token) async {
//     debugPrint("url logout : $token");
//     try {
//       http.Response response = await http.get(Uri.parse("$token"));
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("body :$body");
//     } catch (e) {
//       debugPrint("error :$e");
//     }
//   }
//
// // get access token outdated
//   Future<void> refreshAccessToken(String token) async {
//     debugPrint("url refresh : $token");
//     try {
//       http.Response response = await http.get(Uri.parse("$token"));
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("body : $body");
//     } catch (e) {
//       debugPrint("error :$e");
//     }
//   }
//
// // Get list sexual orientations
//   Future<void> getListSexualOrientations(String lang) async {
//     final String url = "base/v1/get-detail?entityName=sexuals&entityId=$lang";
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     await TeleDebug.debugMessage(url);
//     if (token.isEmpty) return;
//     debugPrint("URL SEXUAL : $url");
//     debugPrint("TOKEN USE LIST SEXUAL : $token");
//     try {
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//       );
//       Map<String, dynamic> map = jsonDecode(response.body);
//       List<String> keyList = map['data'].keys.toList();
//       debugPrint("Key List : $keyList");
//
// // List<String> listOfValues = [];
//       List<Sexual> sexualLists = [];
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       for (int i = 0; i < keyList.length; i++) {
//         if (keyList[i] != "createDate") {
//           String obj = body["data"][keyList[i]].toString();
//           Sexual sexual = Sexual(obj, keyList[i], false);
//           sexualLists.add(sexual);
//         }
//       }
//       PrefAssist.setListString(PrefConst.kListSexOrientation, sexualLists.map((e) => e.toRawJson()).toList());
//       debugPrint("LIST OF VALUE : $sexualLists");
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//   }
//
// // Get list interest
//   Future<void> getListInterest(String lang) async {
//     final String url = "base/v1/get-detail?entityName=interests&entityId=$lang";
//     String token = PrefAssist.getString(PrefConst.kAccessToken);
//     await TeleDebug.debugMessage(url);
//     if (token.isEmpty) return;
//     debugPrint("URL INTEREST : $url");
//     debugPrint("TOKEN USE : $token");
//     try {
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//       );
//       Utils.logger(response.body);
//       Map<String, dynamic> map = jsonDecode(response.body);
//       if (map['data'].containsKey('status') && map['data']['status'] == 401) throw new Exception();
//       List<String> keyList = map['data'].keys.toList();
//       debugPrint("Key List : $keyList");
//
//       List<InterestTag> tagLists = [];
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       for (int i = 0; i < keyList.length; i++) {
//         if (keyList[i] != "createDate") {
//           String obj = body["data"][keyList[i]].toString();
//           InterestTag tag = InterestTag(obj, keyList[i], false);
//           tagLists.add(tag);
//         }
//       }
//       PrefAssist.setListString(PrefConst.kListDataInterest, tagLists.map((e) => e.toRawJson()).toList());
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//   }
//
// // Get user profile detail
// // Future<UserProfile> getDetailUserProfile(String userId, String lang) async {
// //   debugPrint("URL DETAIL : get-detail/$userId/$lang");
//
// //   try {
// //     http.Response response =
// //         await http.get(Uri.parse("get-detail/$userId/$lang"));
// //     final body = json.decode(response.body); await TeleDebug.debugResponse(response.body);
// //     debugPrint("DATA : ${body.toString()}");
// //     return UserProfile.fromJson(body);
// //   } catch (e) {
// //     debugPrint("message error : ${e.toString()}");
// //   }
// //   return UserProfile.fromJson({});
// // }
//
// // Post request get list user for home page
//   Future<MatchObject> requestListUserSuggestion([pageNumber = 1]) async {
//     UserData userData = PrefAssist.getMyUser();
//     String uId = userData.userId ?? '';
//     int showMeGender = userData.showMeGender ?? PrefConst.kGenderEveryoneId;
//     int distance = PrefAssist.getInt(PrefConst.kMaximumDistance, PrefConst.kMaximumDistanceDefault);
//     int startAge = PrefAssist.getInt(PrefConst.kUserStartAge, PrefConst.kUserStartAgeDefault);
//     int endAge = PrefAssist.getInt(PrefConst.kUserEndAge, PrefConst.kUserEndAgeDefault);
//     double latitude = userData.lat ?? 0;
//     double longitude = userData.lng ?? 0;
//     String url =
//         "home/v1/profile?userId=$uId&latitude=$latitude&longitude=$longitude&page=$pageNumber&pageNumber=30&startAge=$startAge&endAge=$endAge&showMeGender=$showMeGender&location=$distance";
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     await TeleDebug.debugMessage(url);
//     debugPrint("URL REQUEST : $url");
//     debugPrint("TOKEN : $token");
//     try {
//       http.Response response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{'Authorization': 'Basic $token'},
//       );
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("Body Response : " + "${jsonEncode(body)}");
//       MatchObject matchObject = MatchObject.fromJson(body);
//       if (matchObject.data.length > 0)
//         return matchObject;
//       else
//         return await requestListUserSuggestion(pageNumber + 1);
//     } catch (e) {
//       debugPrint("message Errror : ${e.toString()}");
//     }
//
//     return MatchObject(data: [], message: '');
//   }
//
// // insert like / superlike api
// // api
//   Future<LikeResponse> insertLikeObject(String document, bool online, LikeObject likeObject) async {
//     String uId = PrefAssist.getMyUser().userId!;
//
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//
//     String url = "home/v1/$document/$uId/";
//     await TeleDebug.debugMessage(url);
//     debugPrint("Like URL : $url");
//
//     try {
//       http.Response response = await http.post(Uri.parse(url),
//           headers: <String, String>{'Authorization': 'Basic $token', 'Content-Type': 'application/json'},
//           body: jsonEncode(
//             <String, dynamic>{
//               'userIdCustomer': likeObject.userIdCustomer,
//             },
//           ));
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("API RESPONSE : ${body.toString()}");
//       return LikeResponse.fromJson(body);
//     } catch (e) {
//       debugPrint("message Errror : ${e.toString()}");
//     }
//     return LikeResponse.fromJson({});
//   }
//
// // Nope action
//   Future<LikeResponse> insertNopeAction(String userIdCustomer, String firstName) async {
//     String uId = PrefAssist.getMyUser().userId!;
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//
//     String nopeUrl = "home/v1/nope/$uId/";
//     debugPrint("NOPE URL :$nopeUrl");
//     try {
//       http.Response response = await http.patch(Uri.parse(nopeUrl),
//           headers: <String, String>{'Authorization': 'Basic $token', 'Content-Type': 'application/json'},
//           body: jsonEncode(
//             <String, dynamic>{
//               'userIdCustomer': userIdCustomer,
//               'firstName': firstName,
//             },
//           ));
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("NOPE RESPONESE : ${body.toString()}");
//       return LikeResponse.fromJson(body);
//     } catch (e) {
//       debugPrint("message Errror : ${e.toString()}");
//     }
//
//     return LikeResponse.fromJson({});
//   }
//
// // Check user make after send like / super like
//   Future<void> checkUserMatched(String uid) async {
//     String url = "home/v1/$uid";
//     await TeleDebug.debugMessage(url);
//     debugPrint("URL HERE : $url");
//   }
//
// // Get list match user
//   Future<MatchResponse> getListUserMatched() async {
//     String uId = PrefAssist.getMyUser().userId!;
//     String url = "home/v1/make-all?userId=$uId";
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     await TeleDebug.debugMessage(url);
//     debugPrint("String url : $url");
//     debugPrint("token : $token");
//     try {
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//       );
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("LIST MATCH RESPONES : ${body.toString()}");
//       return MatchResponse.fromJson(body);
//     } catch (e) {
//       debugPrint("Message Error: ${e.toString()}");
//     }
//     return MatchResponse.fromJson({});
//   }
//
// // GET LIST CATEGORIES
//   Future<ExploreModel> getListExplores() async {
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     String url = "base/v1/get-all?entityName=category-explore";
//     await TeleDebug.debugMessage(url);
//     try {
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//       );
//       debugPrint(response.body);
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       return ExploreModel.fromJson(body);
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//     return ExploreModel.fromJson({});
//   }
//
// // Explore
//   Future<MatchObject> filterListUserExploreOption(String userId, int typeExplore, double latitude, double longitude, int startAge, int endAge, int showMeGender,
//       int location, int page, int pageNumber, int typeDating) async {
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     String url =
//         "explore/v1/option?userId=$userId&typeExplore=$typeExplore&latitude=$latitude&longitude=$longitude&startAge=$startAge&endAge=$endAge&showMeGender=$showMeGender&location=$location&page=$page&pageNumber=$pageNumber&typeDating=$typeDating";
//     debugPrint("URL CALING : $url");
//     try {
//       http.Response response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//       );
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("BODY RESPONSE : $body");
//       return MatchObject.fromJson(body);
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//     return MatchObject.fromJson({});
//   }
//
// // LIKE & TOPIC
// // lay danh sach user minh da thich
//   Future<LikeUser> getListUserLiked() async {
//     String userId = PrefAssist.getMyUser().userId!;
// // String userId = "SzqFbvqrZnGFLmNyiwuGgfOHYFQ1";
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     String url = "like-topic/v1/liked?userId=$userId";
//     await TeleDebug.debugMessage(url);
//     debugPrint("LIKE TOP PIC URL $url");
//     try {
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//       );
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("BODY RESPONSE : $body");
//       return LikeUser.fromJson(body);
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//     return LikeUser.fromJson({});
//   }
//
// // lay danh sach user da thich minh
//   Future<LikeUser> getListLikedUser() async {
//     String userId = PrefAssist.getMyUser().userId!;
// // String userId = "SzqFbvqrZnGFLmNyiwuGgfOHYFQ15";
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//
//     String url = "like-topic/v1/likes-account?userId=$userId";
//     await TeleDebug.debugMessage(url);
//
//     try {
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'},
//       );
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("BODY RESPONSE : $body");
//       return LikeUser.fromJson(body);
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//
//     return LikeUser.fromJson({});
//   }
//
// // fillter option lay danh sach user da thich minh
//   Future<MatchObject> filterListLikedUser(FilterRequestObject filterRequestObject) async {
//     String userId = PrefAssist.getMyUser().userId!;
// // String userId = "SzqFbvqrZnGFLmNyiwuGgfOHYFQ15";
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//
//     String url = "like-topic/v1/like-option/$userId";
//     await TeleDebug.debugMessage(url);
//     debugPrint("URL FILTER : $url");
//     debugPrint("PARAM REQUEST : ${filterRequestObject.toRawJson().toString()}");
//
//     try {
//       http.Response response = await http.post(Uri.parse(url),
//           headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'}, body: filterRequestObject.toRawJson());
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("BODY RESPONSE 222 : $body");
//       return MatchObject.fromJson(body);
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//
//     return MatchObject.fromJson({});
//   }
//
// // check existence user
//   Future<bool> checkExistsUser(String token) async {
//     String userId = PrefAssist.getMyUser().userId!;
//     String url = "login/v1/check-exist?userId=$userId";
//     await TeleDebug.debugMessage(url);
//     try {
//       http.Response response = await http.get(Uri.parse(url));
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       if (body["data"]) {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       debugPrint("Message Error : ${e.toString()}");
//     }
//     return false;
//   }
//
// // get detail user information
//   Future<ProfileDetail> getDetailInfoById(String userId) async {
//     final String token = PrefAssist.getString(PrefConst.kAccessToken);
//     String language = "en"; //StorageManager.getDeviceLocale();
//
//     String url = "user/v1/get-detail/$userId/$language";
//     await TeleDebug.debugMessage(url);
//     debugPrint("URL DETAIL : $url");
//
//     try {
//       http.Response response = await http.get(Uri.parse(url), headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'});
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("BODY RESPONSE 222 : ${response.body}");
//       ProfileDetail profileDetail = ProfileDetail.fromJson(body);
//       if (userId == PrefAssist.getMyUser().userId!) {
//         profileDetail.userData.userId = userId;
//         PrefAssist.setMyUser(profileDetail.userData);
//       }
//       return profileDetail;
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//
//     return ProfileDetail.fromJson({});
//   }
//
// // save last message chat to make-friend
//   Future<void> saveLastMessageChat(Map<String, dynamic> lastMess) async {
//     String uId = PrefAssist.getMyUser().userId!;
//     String token = PrefAssist.getString(PrefConst.kAccessToken);
//
//     String url = "home/v1/make/$uId";
//     await TeleDebug.debugMessage(url);
//     debugPrint("Save message url : $url");
//     debugPrint("body map : $lastMess");
//     try {
//       http.Response response = await http.patch(Uri.parse(url),
//           headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $token'}, body: jsonEncode(lastMess));
//
//       final body = json.decode(response.body);
//       await TeleDebug.debugResponse(response.body);
//       debugPrint("RESPONSE : $body");
//     } catch (e) {
//       debugPrint("message error : ${e.toString()}");
//     }
//   }
//
// // VERIFY VIDEO
//   Future<AuthVerify> verifyPhotos(String videoUrl) async {
//     debugPrint("START VERIFY");
//     String verifyUrl = "http://118.70.126.72:7000/nhanvdieo";
//     var map = <String, dynamic>{};
//     map["videobase64"] = videoUrl;
//     debugPrint("VERIFY MAP : ${map.toString()}");
//     final response = await http.post(Uri.parse(verifyUrl), body: map);
//     debugPrint("VERIFY RESONSE : ${response.body.toString()}");
//     AuthVerify result = AuthVerify(response: response.body.toString() == "true");
//     return result;
//   }
// }
