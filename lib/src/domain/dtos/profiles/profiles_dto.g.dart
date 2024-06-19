// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profiles_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilesDto _$ProfilesDtoFromJson(Map<String, dynamic> json) => ProfilesDto(
      showCommon:
          ShowCommonDto.fromJson(json['showCommon'] as Map<String, dynamic>),
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      orientationSexuals: (json['orientationSexuals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      ethnicitys: (json['ethnicitys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      smartPhoto: json['smartPhoto'] as bool? ?? false,
      favoriteSongs: (json['favoriteSongs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      about: json['about'] as String? ?? '',
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble() ?? -1,
      school: json['school'] as String? ?? '',
      company: json['company'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      datingPurpose: json['datingPurpose'] as String? ?? '',
      childrenPlan: json['childrenPlan'] as String? ?? '',
      zodiac: json['zodiac'] as String? ?? '',
      education: json['education'] as String? ?? '',
      familyPlan: json['familyPlan'] as String? ?? '',
      covidVaccine: json['covidVaccine'] as String? ?? '',
      communicationType: json['communicationType'] as String? ?? '',
      loveStyle: json['loveStyle'] as String? ?? '',
      pet: json['pet'] as String? ?? '',
      drinking: json['drinking'] as String? ?? '',
      smoking: json['smoking'] as String? ?? '',
      workout: json['workout'] as String? ?? '',
      dietaryPreference: json['dietaryPreference'] as String? ?? '',
      socialMedia: json['socialMedia'] as String? ?? '',
      sleepingHabit: json['sleepingHabit'] as String? ?? '',
      drug: json['drug'] as String? ?? '',
      address: json['address'] as String? ?? '',
      avatars: (json['avatars'] as List<dynamic>?)
              ?.map((e) => AvatarDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      prompts: (json['prompts'] as List<dynamic>?)
              ?.map((e) => PromptDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      personality: json['personality'] as String? ?? '',
    );

Map<String, dynamic> _$ProfilesDtoToJson(ProfilesDto instance) =>
    <String, dynamic>{
      'showCommon': instance.showCommon,
      'interests': instance.interests,
      'orientationSexuals': instance.orientationSexuals,
      'languages': instance.languages,
      'ethnicitys': instance.ethnicitys,
      'smartPhoto': instance.smartPhoto,
      'favoriteSongs': instance.favoriteSongs,
      'about': instance.about,
      'gender': instance.gender,
      'height': instance.height,
      'school': instance.school,
      'company': instance.company,
      'jobTitle': instance.jobTitle,
      'datingPurpose': instance.datingPurpose,
      'childrenPlan': instance.childrenPlan,
      'zodiac': instance.zodiac,
      'education': instance.education,
      'familyPlan': instance.familyPlan,
      'covidVaccine': instance.covidVaccine,
      'communicationType': instance.communicationType,
      'loveStyle': instance.loveStyle,
      'pet': instance.pet,
      'drinking': instance.drinking,
      'smoking': instance.smoking,
      'workout': instance.workout,
      'dietaryPreference': instance.dietaryPreference,
      'socialMedia': instance.socialMedia,
      'sleepingHabit': instance.sleepingHabit,
      'drug': instance.drug,
      'address': instance.address,
      'avatars': instance.avatars,
      'prompts': instance.prompts,
      'personality': instance.personality,
    };
