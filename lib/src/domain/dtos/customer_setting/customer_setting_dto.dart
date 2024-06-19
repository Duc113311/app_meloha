import 'package:json_annotation/json_annotation.dart';

part 'customer_setting_dto.g.dart';

@JsonSerializable()
class CustomerSettingDto {
  @JsonKey(name: 'global')
  GlobalDto? global; // Toàn cầu
  @JsonKey(name: 'distancePreference')
  DistancePreferenceDto? distancePreference; // Khoảng cách ưu tiên
  @JsonKey(name: 'agePreference')
  AgePreferenceDto? agePreference; // Độ tuổi ưu tiên
  @JsonKey(name: 'notiSeenEmail')
  NotiSeenEmailDto? notiSeenEmail;
  @JsonKey(name: 'notiSeenApp')
  NotiSeenAppDto? notiSeenApp;
  @JsonKey(name: 'genderFilter')
  String? genderFilter;
  @JsonKey(name: 'autoPlayVideo', defaultValue: 'always')
  String? autoPlayVideo;
  @JsonKey(name: 'showTopPick',defaultValue: true)
  bool? showTopPick;
  @JsonKey(name: 'showOnlineStatus',defaultValue: true)
  bool? showOnlineStatus;
  @JsonKey(name: 'showActiveStatus',defaultValue: true)
  bool? showActiveStatus;
  @JsonKey(name: 'incognitoMode',defaultValue: false)
  bool? incognitoMode;

  CustomerSettingDto({
    this.global,
    this.distancePreference,
    this.agePreference,
    this.notiSeenEmail,
    this.notiSeenApp,
    this.genderFilter,
    this.autoPlayVideo,
    this.showTopPick,
    this.showOnlineStatus,
    this.showActiveStatus,
    this.incognitoMode,
  }) : super();


  static CustomerSettingDto createEmptySettings() {
    return CustomerSettingDto();
  }


  factory CustomerSettingDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerSettingDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomerSettingDtoToJson(this);
}

@JsonSerializable()
class DistancePreferenceDto {
  @JsonKey(name: 'range', defaultValue: 10)
  int? range;
  @JsonKey(name: 'unit', defaultValue: 'km')
  String? unit;
  @JsonKey(name: 'onlyShowInThis', defaultValue: false)
  bool? onlyShowInThis;

  DistancePreferenceDto({
    this.range,
    this.unit,
    this.onlyShowInThis,
  }) : super();

  factory DistancePreferenceDto.fromJson(Map<String, dynamic> json) =>
      _$DistancePreferenceDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DistancePreferenceDtoToJson(this);
}

@JsonSerializable()
class AgePreferenceDto {
  @JsonKey(name: 'min', defaultValue: 15)
  int? min;
  @JsonKey(name: 'max', defaultValue: 70)
  int? max;
  @JsonKey(name: 'onlyShowInThis', defaultValue: false)
  bool? onlyShowInThis;

  AgePreferenceDto({
    this.min,
    this.max,
    this.onlyShowInThis,
  }) : super();

  factory AgePreferenceDto.fromJson(Map<String, dynamic> json) =>
      _$AgePreferenceDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AgePreferenceDtoToJson(this);
}

@JsonSerializable()
class NotiSeenEmailDto {
  @JsonKey(name: 'newMatchs', defaultValue: false)
  bool newMatchs;

  @JsonKey(name: 'incomingMessage', defaultValue: false)
  bool incomingMessage;

  @JsonKey(name: 'promotions', defaultValue: false)
  bool promotions;


  NotiSeenEmailDto({
    required this.newMatchs,
    required this.incomingMessage,
    required this.promotions,
  }) : super();

  factory NotiSeenEmailDto.fromJson(Map<String, dynamic> json) =>
      _$NotiSeenEmailDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotiSeenEmailDtoToJson(this);
}

@JsonSerializable()
class NotiSeenAppDto {
  @JsonKey(name: 'newMatchs', defaultValue: false)
  bool newMatchs;
  @JsonKey(name: 'incomingMessage', defaultValue: false)
  bool incomingMessage;
  @JsonKey(name: 'promotions', defaultValue: false)
  bool promotions;
  @JsonKey(name: 'superLike', defaultValue: false)
  bool superLike;


  NotiSeenAppDto({
    required this.newMatchs,
    required this.incomingMessage,
    required this.promotions,
    required this.superLike
  }) : super();

  factory NotiSeenAppDto.fromJson(Map<String, dynamic> json) =>
      _$NotiSeenAppDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotiSeenAppDtoToJson(this);
}


@JsonSerializable()
class GlobalDto {
  @JsonKey(name: 'languages')
  List<String> languages;

  @JsonKey(name: 'isEnabled')
  bool isEnabled;

  GlobalDto({
    required this.languages,
    required this.isEnabled
  }) : super();

  factory GlobalDto.fromJson(Map<String, dynamic> json) =>
      _$GlobalDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GlobalDtoToJson(this);
}