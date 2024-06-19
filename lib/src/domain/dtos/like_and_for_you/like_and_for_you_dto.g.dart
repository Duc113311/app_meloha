// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_and_for_you_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeAndForYouDto _$LikeAndForYouDtoFromJson(Map<String, dynamic> json) =>
    LikeAndForYouDto(
      (json['count'] as num).toInt(),
      (json['data'] as List<dynamic>)
          .map((e) => LikesDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LikeAndForYouDtoToJson(LikeAndForYouDto instance) =>
    <String, dynamic>{
      'data': instance.likeDto,
      'count': instance.count,
    };

LikesDto _$LikesDtoFromJson(Map<String, dynamic> json) => LikesDto(
      ProfileLikeDto.fromJson(json['profiles'] as Map<String, dynamic>),
      json['onlineNow'] as bool,
      json['_id'] as String,
      json['fullname'] as String,
      json['email'] as String,
      LikesDto._dob(json['dob'] as String?),
    );

Map<String, dynamic> _$LikesDtoToJson(LikesDto instance) => <String, dynamic>{
      'profiles': instance.profiles,
      'onlineNow': instance.onlineNow,
      '_id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'dob': LikesDto._dobDateFormat(instance.dob),
    };

ProfileLikeDto _$ProfileLikeDtoFromJson(Map<String, dynamic> json) =>
    ProfileLikeDto(
      (json['avatars'] as List<dynamic>).map((e) => e as String).toList(),
      (json['orientationSexuals'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      (json['favoriteSongs'] as List<dynamic>).map((e) => e as String).toList(),
      json['showGender'] as bool,
      json['showSexual'] as bool,
      json['showAge'] as bool,
      json['showDistance'] as bool,
      json['address'] as String?,
      json['gender'] as String,
      json['about'] as String,
      json['zodiac'] as String,
      json['company'] as String,
      json['jobTitle'] as String,
    );

Map<String, dynamic> _$ProfileLikeDtoToJson(ProfileLikeDto instance) =>
    <String, dynamic>{
      'avatars': instance.avatars,
      'orientationSexuals': instance.orientationSexuals,
      'interests': instance.interests,
      'languages': instance.languages,
      'favoriteSongs': instance.favoriteSongs,
      'showGender': instance.showGender,
      'showSexual': instance.showSexual,
      'showAge': instance.showAge,
      'showDistance': instance.showDistance,
      'address': instance.address,
      'gender': instance.gender,
      'about': instance.about,
      'zodiac': instance.zodiac,
      'company': instance.company,
      'jobTitle': instance.jobTitle,
    };
