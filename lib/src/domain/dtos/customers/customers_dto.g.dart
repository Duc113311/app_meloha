// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDto _$LocationDtoFromJson(Map<String, dynamic> json) => LocationDto(
      lat: json['lat'] as String? ?? '0',
      long: json['long'] as String? ?? '0',
    );

Map<String, dynamic> _$LocationDtoToJson(LocationDto instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };

ShowCommonDto _$ShowCommonDtoFromJson(Map<String, dynamic> json) =>
    ShowCommonDto(
      showSexual: json['showSexual'] as bool? ?? false,
      showGender: json['showGender'] as bool? ?? false,
      showAge: json['showAge'] as bool? ?? false,
      showHeight: json['showHeight'] as bool? ?? false,
      showEthnicity: json['showEthnicity'] as bool? ?? false,
      showChildrenPlan: json['showChildrenPlan'] as bool? ?? false,
      showFamilyPlan: json['showFamilyPlan'] as bool? ?? false,
      showWork: json['showWork'] as bool? ?? false,
      showSchool: json['showSchool'] as bool? ?? false,
      showEducation: json['showEducation'] as bool? ?? false,
      showDrinking: json['showDrinking'] as bool? ?? false,
      showSmoking: json['showSmoking'] as bool? ?? false,
      showDrug: json['showDrug'] as bool? ?? false,
      showDistance: json['showDistance'] as bool? ?? false,
    );

Map<String, dynamic> _$ShowCommonDtoToJson(ShowCommonDto instance) =>
    <String, dynamic>{
      'showSexual': instance.showSexual,
      'showGender': instance.showGender,
      'showAge': instance.showAge,
      'showHeight': instance.showHeight,
      'showEthnicity': instance.showEthnicity,
      'showChildrenPlan': instance.showChildrenPlan,
      'showFamilyPlan': instance.showFamilyPlan,
      'showWork': instance.showWork,
      'showSchool': instance.showSchool,
      'showEducation': instance.showEducation,
      'showDrinking': instance.showDrinking,
      'showSmoking': instance.showSmoking,
      'showDrug': instance.showDrug,
      'showDistance': instance.showDistance,
    };

CustomersDto _$CustomersDtoFromJson(Map<String, dynamic> json) => CustomersDto(
      json['message'] as String? ?? '',
      (json['data'] as List<dynamic>)
          .map((e) => CustomerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomersDtoToJson(CustomersDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

CustomerDto _$CustomerDtoFromJson(Map<String, dynamic> json) => CustomerDto(
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      oAuth2Id: json['oAuth2Id'] as String? ?? '',
      id: json['_id'] as String,
      fullname: json['fullname'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      dob: CustomerDto._dob(json['dob'] as String?),
      profiles: ProfilesDto.fromJson(json['profiles'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : CustomerSettingDto.fromJson(
              json['settings'] as Map<String, dynamic>),
      verifyStatus: json['verifyStatus'] as bool? ?? false,
      onlineNow: json['onlineNow'] as bool? ?? false,
      activeStatus: json['activeStatus'] as bool?,
      lastActiveTime:
          CustomerDto._lastActiveTime(json['lastActiveTime'] as String?),
      pkgRegistrationDate: CustomerDto._pkgRegistrationDate(
          json['pkgRegistrationDate'] as String?),
      pkgExpirationDate:
          CustomerDto._pkgExpirationDate(json['pkgExpirationDate'] as String?),
      numberBooster: (json['numberBooster'] as num?)?.toInt(),
      location: json['location'] == null
          ? null
          : LocationDto.fromJson(json['location'] as Map<String, dynamic>),
      coins: (json['coins'] as num?)?.toInt(),
      numberSuperLike: (json['numberSuperLike'] as num?)?.toInt(),
      numberNotiSeenMsg: (json['numberNotiSeenMsg'] as num?)?.toInt(),
      packageId: json['packageId'] as String?,
      disable: json['disable'] as bool? ?? false,
      channelId: json['channelId'] as String? ?? '',
      boostInfo: json['boostInfo'] == null
          ? null
          : BoostDto.fromJson(json['boostInfo'] as Map<String, dynamic>),
      explore: json['explore'] == null
          ? null
          : ExploreDto.fromJson(json['explore'] as Map<String, dynamic>),
      plusCtrl: json['plusCtrl'] == null
          ? null
          : PlusCtrlDto.fromJson(json['plusCtrl'] as Map<String, dynamic>),
      languageMachine: json['languageMachine'] as String?,
    );

Map<String, dynamic> _$CustomerDtoToJson(CustomerDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'oAuth2Id': instance.oAuth2Id,
      'fullname': instance.fullname,
      'email': instance.email,
      'phone': instance.phone,
      'profiles': instance.profiles,
      'dob': CustomerDto._dobDateFormat(instance.dob),
      'settings': instance.settings,
      'verifyStatus': instance.verifyStatus,
      'onlineNow': instance.onlineNow,
      'activeStatus': instance.activeStatus,
      'lastActiveTime':
          CustomerDto._lastActiveTimeDateFormat(instance.lastActiveTime),
      'pkgRegistrationDate': CustomerDto._pkgRegistrationDateDateFormat(
          instance.pkgRegistrationDate),
      'pkgExpirationDate':
          CustomerDto._pkgExpirationDateDateFormat(instance.pkgExpirationDate),
      'numberBooster': instance.numberBooster,
      'location': instance.location,
      'coins': instance.coins,
      'numberSuperLike': instance.numberSuperLike,
      'numberNotiSeenMsg': instance.numberNotiSeenMsg,
      'packageId': instance.packageId,
      'disable': instance.disable,
      'distanceKm': instance.distanceKm,
      'channelId': instance.channelId,
      'explore': instance.explore,
      'plusCtrl': instance.plusCtrl,
      'boostInfo': instance.boostInfo,
      'languageMachine': instance.languageMachine,
    };
