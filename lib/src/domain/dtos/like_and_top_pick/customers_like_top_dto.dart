import 'package:dating_app/src/domain/dtos/customer_setting/customer_setting_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/explore_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../utils/date_time_utils.dart';
import '../profiles/profiles_dto.dart';

part 'customers_like_top_dto.g.dart';

@JsonSerializable()
class LikeTopDto {
  @JsonKey(name: 'skip')
  final int? skip;
  @JsonKey(name: 'limit')
  final int? limit;
  @JsonKey(name: 'currentPage')
  final int? currentPage;
  @JsonKey(name: 'count')
  final int? count;
  @JsonKey(name: 'list_data')
  final List<CustomersLikeTopDto>? listData;
  @JsonKey(name: 'total')
  final int? total;

  LikeTopDto({
    this.skip,
    this.limit,
    this.currentPage,
    this.count,
    this.listData,
    this.total,
  }) : super();

  factory LikeTopDto.fromJson(Map<String, dynamic> json) =>
      _$LikeTopDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LikeTopDtoToJson(this);
}

@JsonSerializable()
class CustomersLikeTopDto {
  @JsonKey(name: 'profiles')
  final ProfilesDto profilesDto;
  @JsonKey(name: 'onlineNow', defaultValue: false)
  final bool? onlineNow;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'fullname')
  final String fullName;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'dob', fromJson: _dob)
  final DateTime? dob;
  @JsonKey(name: 'distanceKm', defaultValue: 0)
  final double? distanceKm;
  @JsonKey(name: 'explore')
  ExploreDto? explore;

  CustomersLikeTopDto({
    required this.profilesDto,
    this.onlineNow,
    required this.id,
    required this.fullName,
    this.phone,
    this.dob,
    this.distanceKm,
    this.explore,
  }) : super();

  //from json
  static DateTime? _dob(String? dob) =>
      DateTimeUtils.convertStringToDateTime(dob);

  factory CustomersLikeTopDto.fromJson(Map<String, dynamic> json) =>
      _$CustomersLikeTopDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomersLikeTopDtoToJson(this);

  int getAge() {
    if (dob == null) return 0;
    return DateTimeUtils.getAgeFromMilliseconds(dob!.millisecondsSinceEpoch);
  }

  AvatarDto? get getAvatarModel {
    return profilesDto?.avatars?.firstOrNull;
  }

  String get getAvatar {
    return profilesDto?.avatars?.first?.url ?? '';
  }

  String get getAvatarCacheKeyId {
    return getAvatar.removeQuery;
  }

  List<String> get getListAvatar {
    return profilesDto?.avatars?.map((e) => e.url).toList() ?? [];
  }

  String get getThumbnailMaxSize {
    return profilesDto?.avatars?.first?.meta.thumbnails.lastOrNull ?? '';
  }

  String get getCacheKeyThumbnailMaxSize {
    return getThumbnailMaxSize.removeQuery;
  }

  CustomerDto toCustomer() {
    return CustomerDto(
        id: id,
        fullname: fullName,
        profiles: profilesDto,
        onlineNow: onlineNow,
        phone: phone,
        distanceKm: distanceKm,
        dob: dob,
        explore: explore,
        settings: CustomerSettingDto.createEmptySettings());
  }
}
