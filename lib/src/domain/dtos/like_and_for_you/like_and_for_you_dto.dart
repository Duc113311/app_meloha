import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../requests/api_utils.dart';
import '../../../utils/date_time_utils.dart';

part 'like_and_for_you_dto.g.dart';

@JsonSerializable()
class LikeAndForYouDto {
  @JsonKey(name: 'data')
  final List<LikesDto> likeDto;

  @JsonKey(name: 'count')
  final int count;


  LikeAndForYouDto(this.count, this.likeDto);
  factory LikeAndForYouDto.fromJson(Map<String, dynamic> json) => _$LikeAndForYouDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LikeAndForYouDtoToJson(this);
}

@JsonSerializable()
class LikesDto {
  @JsonKey(name: 'profiles')
  final ProfileLikeDto profiles;
  @JsonKey(name: 'onlineNow')
  final bool onlineNow;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'fullname')
  final String fullname;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'dob', fromJson: _dob, toJson: _dobDateFormat)
  final DateTime? dob;

  LikesDto(this.profiles, this.onlineNow, this.id, this.fullname, this.email, this.dob);

  //from json
  static DateTime? _dob(String? dob) => DateTimeUtils.convertStringToDateTime(dob);

  //to json
  static String? _dobDateFormat(DateTime? dob) {
    if (dob == null) return '';
    return DateFormat(ApiUtils.DATE_TIME_FORMAT).format(dob);
  }

  factory LikesDto.fromJson(Map<String, dynamic> json) => _$LikesDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LikesDtoToJson(this);
}

@JsonSerializable()
class ProfileLikeDto {
  @JsonKey(name: 'avatars')
  final List<String> avatars;
  @JsonKey(name: 'orientationSexuals')
  final List<String> orientationSexuals;
  @JsonKey(name: 'interests')
  final List<String> interests;
  @JsonKey(name: 'languages')
  final List<String> languages;
  @JsonKey(name: 'favoriteSongs')
  final List<String> favoriteSongs;
  @JsonKey(name: 'showGender')
  final bool showGender;
  @JsonKey(name: 'showSexual')
  final bool showSexual;
  @JsonKey(name: 'showAge')
  final bool showAge;
  @JsonKey(name: 'showDistance')
  final bool showDistance;
  @JsonKey(name: 'address')
  final String? address;

  // @JsonKey(name: 'school',defaultValue: null)
  // final String? school;
  @JsonKey(name: 'gender')
  final String gender;
  @JsonKey(name: 'about')
  final String about;
  @JsonKey(name: 'zodiac')
  final String zodiac;
  @JsonKey(name: 'company')
  final String company;
  @JsonKey(name: 'jobTitle')
  final String jobTitle;

  ProfileLikeDto(this.avatars, this.orientationSexuals, this.interests, this.languages, this.favoriteSongs, this.showGender, this.showSexual, this.showAge, this.showDistance, this.address, this.gender, this.about, this.zodiac, this.company, this.jobTitle);

  factory ProfileLikeDto.fromJson(Map<String, dynamic> json) => _$ProfileLikeDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileLikeDtoToJson(this);
}
