import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import 'avatar_dto.dart';

part 'profiles_dto.g.dart';

@JsonSerializable()
class ProfilesDto {
  @JsonKey(name: 'showCommon')
  ShowCommonDto showCommon;
  @JsonKey(name: 'interests', defaultValue: [])
  List<String>? interests; // Sở thích
  @JsonKey(name: 'orientationSexuals', defaultValue: [])
  List<String>? orientationSexuals; // Khuynh hướng giới tính
  @JsonKey(name: 'languages', defaultValue: [])
  List<String>? languages; // Ngôn ngữ tôi biết
  @JsonKey(name: 'ethnicitys', defaultValue: [])
  List<String>? ethnicitys;
  @JsonKey(name: 'smartPhoto', defaultValue: false)
  bool? smartPhoto;
  @JsonKey(name: 'favoriteSongs', defaultValue: [])
  List<String>? favoriteSongs; // Bài hát yêu thích
  @JsonKey(name: 'about', defaultValue: '')
  String? about; // Mô tả bản thân
  @JsonKey(name: 'gender')
  String? gender;
  @JsonKey(name: 'height', defaultValue: -1)
  double? height;
  @JsonKey(name: 'school', defaultValue: '')
  String? school;
  @JsonKey(name: 'company', defaultValue: '')
  String? company;
  @JsonKey(name: 'jobTitle', defaultValue: '')
  String? jobTitle;

  // @JsonKey(name: 'work', defaultValue: '')
  // String? work; //Trùng company

  @JsonKey(name: 'datingPurpose', defaultValue: '')
  String? datingPurpose;
  @JsonKey(name: 'childrenPlan', defaultValue: '')
  String? childrenPlan;
  @JsonKey(name: 'zodiac', defaultValue: '')
  String? zodiac;
  @JsonKey(name: 'education', defaultValue: '')
  String? education;
  @JsonKey(name: 'familyPlan', defaultValue: '')
  String? familyPlan;
  @JsonKey(name: 'covidVaccine', defaultValue: '')
  String? covidVaccine;
  @JsonKey(name: 'communicationType', defaultValue: '')
  String? communicationType;
  @JsonKey(name: 'loveStyle', defaultValue: '')
  String? loveStyle;
  @JsonKey(name: 'pet', defaultValue: '')
  String? pet; // { type: String, index: true } // Vật nuôi
  @JsonKey(name: 'drinking', defaultValue: '')
  String? drinking; // { type: String, index: true } // Sở thích nhậu
  @JsonKey(name: 'smoking', defaultValue: '')
  String? smoking; // { type: String, index: true } // Hút thuốc
  @JsonKey(name: 'workout', defaultValue: '')
  String? workout;
  @JsonKey(name: 'dietaryPreference', defaultValue: '')
  String? dietaryPreference;
  @JsonKey(name: 'socialMedia', defaultValue: '')
  String? socialMedia;
  @JsonKey(name: 'sleepingHabit', defaultValue: '')
  String? sleepingHabit;
  @JsonKey(name: 'drug', defaultValue: '')
  String? drug;
  @JsonKey(name: 'address', defaultValue: '')
  String? address;
  @JsonKey(name: 'avatars', defaultValue: [])
  List<AvatarDto> avatars;
  @JsonKey(name: 'prompts', defaultValue: [])
  List<PromptDto>? prompts;
  @JsonKey(name: 'personality', defaultValue: '')
  String? personality;

  ProfilesDto({
    required this.showCommon,
    this.interests,
    this.orientationSexuals,
    this.languages,
    this.ethnicitys,
    this.smartPhoto,
    this.favoriteSongs,
    this.about,
    this.gender,
    this.height,
    this.school,
    this.company,
    this.jobTitle,
    this.datingPurpose,
    this.childrenPlan,
    this.zodiac,
    this.education,
    this.familyPlan,
    this.covidVaccine,
    this.communicationType,
    this.loveStyle,
    this.pet,
    this.drinking,
    this.smoking,
    this.workout,
    this.dietaryPreference,
    this.socialMedia,
    this.sleepingHabit,
    this.drug,
    this.address,
    required this.avatars,
    this.prompts,
    this.personality
  }) : super();


  Future<void> sortAvatar() async {
    if (avatars == null) {return;}
    avatars!.sort((a, b) => (a.order ?? 0).compareTo((b.order ?? 0)));
  }

  static ProfilesDto createEmptyProfile() {
    final common = ShowCommonDto();
    return ProfilesDto(showCommon: common, prompts: [], avatars: [], school: '', smartPhoto: false);
  }

  factory ProfilesDto.fromJson(Map<String, dynamic> json) =>
      _$ProfilesDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfilesDtoToJson(this);
}
