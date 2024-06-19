// import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
// import 'package:dating_app/src/utils/utils.dart';
//
// class RecommendManager {
//   static final RecommendManager _shared = RecommendManager._internal();
//
//   RecommendManager._internal();
//
//   static RecommendManager shared() => _shared;
//
//   List<UserRecommend> _recommends = [];
//
//   RecommendModel? getModel(String uid, int index) {
//     if (index < 0) {
//       return null;
//     }
//     final user = _recommends.firstWhereOrNull((element) => element.uid == uid);
//     if (user != null && user.recommends.length > index) {
//       return user.recommends[index];
//     } else {
//       return null;
//     }
//   }
//
//   bool contains(String uid, RecommendInfoType type) {
//     final user = _recommends.firstWhereOrNull((element) => element.uid == uid);
//     if (user != null && user.recommends.isNotEmpty) {
//       return user.recommends.firstWhereOrNull((element) => element.type != type) != null;
//     } else {
//       return false;
//     }
//   }
//
//   void add(String uid, RecommendModel model) {
//     final index = _recommends.indexWhere((element) => element.uid == uid);
//     UserRecommend user = index >= 0
//         ? _recommends[index]
//         : UserRecommend(uid: uid, recommends: []);
//     user.recommends.add(model);
//
//     if (index >= 0) {
//       _recommends[index] = user;
//     } else {
//       _recommends.add(user);
//     }
//   }
//
//   void remove(String uid) {
//     final index = _recommends.indexWhere((element) => element.uid == uid);
//     if (index >= 0) {
//       _recommends.removeAt(index);
//     }
//   }
//
//   void removeAll() {
//     _recommends.clear();
//   }
// }
//
// //Utils
//
// class LifeStyleModel {
//   LifeStyleModel({this.pet, this.drinking, this.smoking, this.workout});
//
//   String? pet;
//   String? drinking;
//   String? smoking;
//   String? workout;
//
//   bool get isEmpty {
//     return pet == null &&
//         drinking == null &&
//         smoking == null &&
//         workout == null;
//   }
//
//   bool get isNotEmpty {
//     return pet != null ||
//         drinking != null ||
//         smoking != null ||
//         workout != null;
//   }
//
//   List<String> get values {
//     List<String> values = [];
//     if (pet != null) {
//       values.add(StaticInfoManager.shared().convertPet(pet!));
//     }
//     if (drinking != null) {
//       values.add(StaticInfoManager.shared().convertPet(drinking!));
//     }
//
//     if (smoking != null) {
//       values.add(StaticInfoManager.shared().convertPet(smoking!));
//     }
//
//     if (workout != null) {
//       values.add(StaticInfoManager.shared().convertPet(workout!));
//     }
//
//     return values;
//   }
// }
//
// enum RecommendInfoType {
//   location,
//   about,
//   interests,
//   lifeStyle,
//   jobTitle,
//   datingPurpose,
//   empty
// }
//
// class RecommendModel {
//   RecommendModel({required this.type, required this.values});
//
//   RecommendInfoType type;
//   List<String> values;
// }
//
// class UserRecommend {
//   UserRecommend({required this.uid, required this.recommends});
//
//   String uid;
//   List<RecommendModel> recommends;
// }
