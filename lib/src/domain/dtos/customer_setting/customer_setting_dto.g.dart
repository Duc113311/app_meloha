// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_setting_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerSettingDto _$CustomerSettingDtoFromJson(Map<String, dynamic> json) =>
    CustomerSettingDto(
      global: json['global'] == null
          ? null
          : GlobalDto.fromJson(json['global'] as Map<String, dynamic>),
      distancePreference: json['distancePreference'] == null
          ? null
          : DistancePreferenceDto.fromJson(
              json['distancePreference'] as Map<String, dynamic>),
      agePreference: json['agePreference'] == null
          ? null
          : AgePreferenceDto.fromJson(
              json['agePreference'] as Map<String, dynamic>),
      notiSeenEmail: json['notiSeenEmail'] == null
          ? null
          : NotiSeenEmailDto.fromJson(
              json['notiSeenEmail'] as Map<String, dynamic>),
      notiSeenApp: json['notiSeenApp'] == null
          ? null
          : NotiSeenAppDto.fromJson(
              json['notiSeenApp'] as Map<String, dynamic>),
      genderFilter: json['genderFilter'] as String?,
      autoPlayVideo: json['autoPlayVideo'] as String? ?? 'always',
      showTopPick: json['showTopPick'] as bool? ?? true,
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
      showActiveStatus: json['showActiveStatus'] as bool? ?? true,
      incognitoMode: json['incognitoMode'] as bool? ?? false,
    );

Map<String, dynamic> _$CustomerSettingDtoToJson(CustomerSettingDto instance) =>
    <String, dynamic>{
      'global': instance.global,
      'distancePreference': instance.distancePreference,
      'agePreference': instance.agePreference,
      'notiSeenEmail': instance.notiSeenEmail,
      'notiSeenApp': instance.notiSeenApp,
      'genderFilter': instance.genderFilter,
      'autoPlayVideo': instance.autoPlayVideo,
      'showTopPick': instance.showTopPick,
      'showOnlineStatus': instance.showOnlineStatus,
      'showActiveStatus': instance.showActiveStatus,
      'incognitoMode': instance.incognitoMode,
    };

DistancePreferenceDto _$DistancePreferenceDtoFromJson(
        Map<String, dynamic> json) =>
    DistancePreferenceDto(
      range: (json['range'] as num?)?.toInt() ?? 10,
      unit: json['unit'] as String? ?? 'km',
      onlyShowInThis: json['onlyShowInThis'] as bool? ?? false,
    );

Map<String, dynamic> _$DistancePreferenceDtoToJson(
        DistancePreferenceDto instance) =>
    <String, dynamic>{
      'range': instance.range,
      'unit': instance.unit,
      'onlyShowInThis': instance.onlyShowInThis,
    };

AgePreferenceDto _$AgePreferenceDtoFromJson(Map<String, dynamic> json) =>
    AgePreferenceDto(
      min: (json['min'] as num?)?.toInt() ?? 15,
      max: (json['max'] as num?)?.toInt() ?? 70,
      onlyShowInThis: json['onlyShowInThis'] as bool? ?? false,
    );

Map<String, dynamic> _$AgePreferenceDtoToJson(AgePreferenceDto instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'onlyShowInThis': instance.onlyShowInThis,
    };

NotiSeenEmailDto _$NotiSeenEmailDtoFromJson(Map<String, dynamic> json) =>
    NotiSeenEmailDto(
      newMatchs: json['newMatchs'] as bool? ?? false,
      incomingMessage: json['incomingMessage'] as bool? ?? false,
      promotions: json['promotions'] as bool? ?? false,
    );

Map<String, dynamic> _$NotiSeenEmailDtoToJson(NotiSeenEmailDto instance) =>
    <String, dynamic>{
      'newMatchs': instance.newMatchs,
      'incomingMessage': instance.incomingMessage,
      'promotions': instance.promotions,
    };

NotiSeenAppDto _$NotiSeenAppDtoFromJson(Map<String, dynamic> json) =>
    NotiSeenAppDto(
      newMatchs: json['newMatchs'] as bool? ?? false,
      incomingMessage: json['incomingMessage'] as bool? ?? false,
      promotions: json['promotions'] as bool? ?? false,
      superLike: json['superLike'] as bool? ?? false,
    );

Map<String, dynamic> _$NotiSeenAppDtoToJson(NotiSeenAppDto instance) =>
    <String, dynamic>{
      'newMatchs': instance.newMatchs,
      'incomingMessage': instance.incomingMessage,
      'promotions': instance.promotions,
      'superLike': instance.superLike,
    };

GlobalDto _$GlobalDtoFromJson(Map<String, dynamic> json) => GlobalDto(
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$GlobalDtoToJson(GlobalDto instance) => <String, dynamic>{
      'languages': instance.languages,
      'isEnabled': instance.isEnabled,
    };
