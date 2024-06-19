// import 'package:equatable/equatable.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';
//
// import '../../src/domain/dtos/customers/customers_dto.dart';
// import '../../src/domain/dtos/profiles/profiles_dto.dart';
//
// part 'user.g.dart';
//
// enum UserState {online, busy, offline, typing}
//
// /// All possible roles user can have.
// enum Role { admin, agent, moderator, user }
//
// /// A class that represents user.
// @JsonSerializable()
// @immutable
// abstract class User extends Equatable {
//   /// Creates a user.
//   const User._({
//     required this.id,
//     this.fullname,
//     this.email,
//     this.phone,
//     this.dob,
//     this.profiles,
//     this.verifyStatus,
//     this.onlineNow,
//     this.activeStatus,
//     this.lastActiveTime,
//     this.location,
//     this.coins,
//     this.disable,
//     this.distanceKm,
//     this.imageUrl,
//     this.lastSeen,
//     this.metadata,
//     this.role,
//     this.updatedAt,
//     this.state,
//     this.createdAt,
//   });
//
//   const factory User({
//     required String id,
//     String? fullname,
//     String? email,
//     String? phone,
//     DateTime? dob,
//     ProfilesDto? profiles,
//     bool? verifyStatus,
//     bool? onlineNow,
//     String? activeStatus,
//     DateTime? lastActiveTime,
//     LocationDto? location,
//     int? coins,
//     bool? disable,
//     double? distanceKm,
//     String? imageUrl,
//     int? lastSeen,
//     Map<String, dynamic>? metadata,
//     Role? role,
//     int? updatedAt,
//     UserState? state,
//     int? createdAt,
//   }) = _User;
//
//   factory User.withCustomer(CustomerDto customer) =>
//       const _User(id: '').initWith(userInfo: customer);
//
//   /// Creates user from a map (decoded JSON).
//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//
//   /// Created user timestamp, in ms.
//   final int? createdAt;
//
//   /// Unique ID of the user.
//   final String id;
//
//   /// Remote image URL representing user's avatar.
//   final String? imageUrl;
//
//   /// Fill name of the user.
//   final String? fullname;
//
//   /// Email of the user.
//   final String? email;
//
//   /// Phone of the user.
//   final String? phone;
//
//   /// online status of the user.
//   final bool? onlineNow;
//
//   /// verify status of the user.
//   final bool? verifyStatus;
//
//   /// active status of the user.
//   final String? activeStatus;
//   final ProfilesDto? profiles;
//
//   final DateTime? dob;
//   final DateTime? lastActiveTime;
//   final LocationDto? location;
//   final int? coins;
//   final bool? disable;
//   final double? distanceKm;
//
//   /// Timestamp when user was last visible, in ms.
//   final int? lastSeen;
//
//   /// Additional custom metadata or attributes related to the user.
//   final Map<String, dynamic>? metadata;
//
//   /// User [Role].
//   final Role? role;
//
//   /// Updated user timestamp, in ms.
//   final int? updatedAt;
//
//   /// Updated user timestamp, in ms.
//   final UserState? state;
//
//   /// Equatable props.
//   @override
//   List<Object?> get props => [
//     id,
//     fullname,
//     email,
//     phone,
//     dob,
//     profiles,
//     verifyStatus,
//     onlineNow,
//     activeStatus,
//     lastActiveTime,
//     location,
//     coins,
//     disable,
//     distanceKm,
//     imageUrl,
//     lastSeen,
//     metadata,
//     role,
//     updatedAt,
//     state,
//     createdAt,
//   ];
//
//   User copyWith({
//     String id,
//     String? fullname,
//     String? email,
//     String? phone,
//     DateTime? dob,
//     ProfilesDto? profiles,
//     bool? verifyStatus,
//     bool? onlineNow,
//     String? activeStatus,
//     DateTime? lastActiveTime,
//     LocationDto? location,
//     int? coins,
//     bool? disable,
//     double? distanceKm,
//     String? imageUrl,
//     int? lastSeen,
//     Map<String, dynamic>? metadata,
//     Role? role,
//     int? updatedAt,
//     UserState? state,
//     int? createdAt,
//   });
//
//   User initWith({required CustomerDto userInfo});
//
//   /// Converts user to the map representation, encodable to JSON.
//   Map<String, dynamic> toJson() => _$UserToJson(this);
// }
//
// /// A utility class to enable better copyWith.
// class _User extends User {
//   const _User({
//     required super.id,
//     super.fullname,
//     super.email,
//     super.phone,
//     super.dob,
//     super.profiles,
//     super.verifyStatus,
//     super.onlineNow,
//     super.activeStatus,
//     super.lastActiveTime,
//     super.location,
//     super.coins,
//     super.disable,
//     super.distanceKm,
//     super.imageUrl,
//     super.lastSeen,
//     super.metadata,
//     super.role,
//     super.updatedAt,
//     super.state,
//     super.createdAt,
//   }) : super._();
//
//   @override
//   User copyWith({
//     String? id,
//     dynamic fullname = _Unset,
//     dynamic email = _Unset,
//     dynamic phone = _Unset,
//     dynamic dob = _Unset,
//     dynamic profiles = _Unset,
//     dynamic verifyStatus = _Unset,
//     dynamic onlineNow = _Unset,
//     dynamic activeStatus = _Unset,
//     dynamic lastActiveTime = _Unset,
//     dynamic location = _Unset,
//     dynamic coins = _Unset,
//     dynamic disable = _Unset,
//     dynamic distanceKm = _Unset,
//     dynamic imageUrl = _Unset,
//     dynamic lastSeen = _Unset,
//     dynamic metadata = _Unset,
//     dynamic role = _Unset,
//     dynamic updatedAt = _Unset,
//     dynamic state = _Unset,
//     dynamic createdAt = _Unset,
//   }) =>
//       _User(
//         id: id ?? this.id,
//         fullname: fullname == _Unset ? this.fullname : fullname as String?,
//         email: email == _Unset ? this.email : email as String?,
//         phone: phone == _Unset ? this.phone : phone as String?,
//         dob: dob == _Unset ? this.dob : dob as DateTime?,
//         profiles: profiles == _Unset ? this.profiles : profiles as ProfilesDto?,
//         verifyStatus: verifyStatus == _Unset ? this.verifyStatus : verifyStatus as bool?,
//         onlineNow: onlineNow == _Unset ? this.onlineNow : onlineNow as bool?,
//         activeStatus: activeStatus == _Unset ? this.activeStatus : activeStatus as String?,
//         lastActiveTime: lastActiveTime == _Unset ? this.lastActiveTime : lastActiveTime as DateTime?,
//         location: location == _Unset ? this.location : location as LocationDto?,
//         coins: coins == _Unset ? this.coins : coins as int?,
//         disable: disable == _Unset ? this.disable : disable as bool?,
//         distanceKm: distanceKm == _Unset ? this.distanceKm : distanceKm as double?,
//         imageUrl: imageUrl == _Unset ? this.imageUrl : imageUrl as String?,
//         lastSeen: lastSeen == _Unset ? this.lastSeen : lastSeen as int?,
//         metadata: metadata == _Unset ? this.metadata : metadata as Map<String, dynamic>?,
//         role: role == _Unset ? this.role : role as Role?,
//         updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
//         state: state == _Unset ? this.state : state as UserState?,
//         createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
//       );
//
//   @override
//   User initWith({required CustomerDto userInfo}) => _User(
//     id: userInfo.id ?? this.id,
//     fullname: userInfo.fullname,
//     email: userInfo.email,
//     phone: userInfo.phone,
//     dob: userInfo.dob,
//     profiles: userInfo.profiles,
//     verifyStatus: userInfo.verifyStatus,
//     onlineNow: userInfo.onlineNow,
//     activeStatus: userInfo.activeStatus,
//     lastActiveTime: userInfo.lastActiveTime,
//     location: userInfo.location,
//     coins: userInfo.coins,
//     disable: userInfo.disable,
//     distanceKm: userInfo.distanceKm,
//     imageUrl: userInfo.profiles?.avatars?.first,
//     lastSeen: userInfo.lastActiveTime?.millisecondsSinceEpoch,
//     metadata: userInfo.profiles?.toJson(),
//     role: Role.user,
//     updatedAt: userInfo.lastActiveTime?.millisecondsSinceEpoch,
//     state: UserState.online,
//     createdAt: userInfo.lastActiveTime?.millisecondsSinceEpoch,
//   );
//
//
// }
//
// class _Unset {}
