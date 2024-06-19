import '../../../../generated/l10n.dart';

class StaticInfoDto {
  String code = '';
  String value = '';

  StaticInfoDto(this.code, this.value);

  StaticInfoDto.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    value = json['value'] ?? '';
  }

  static StaticInfoDto get preferNotSay {
    return StaticInfoDto("notSay", S.current.txt_prefer_not_say);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['value'] = value;
    return data;
  }
}

class CategoryPromptStaticInfoDto {
  String code;
  String value;
  List<PromptStaticInfoDto> prompts;

  CategoryPromptStaticInfoDto({
    required this.code,
    required this.value,
    required this.prompts,
  });

  factory CategoryPromptStaticInfoDto.fromJson(Map<String, dynamic> json) =>
      CategoryPromptStaticInfoDto(
        code: json["code"],
        value: json["value"],
        prompts: List<PromptStaticInfoDto>.from(
            json["prompts"].map((x) => PromptStaticInfoDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "value": value,
        "prompts": List<dynamic>.from(prompts.map((x) => x.toJson())),
      };
}

class PromptStaticInfoDto {
  String code;
  String value;

  PromptStaticInfoDto({
    required this.code,
    required this.value,
  });

  factory PromptStaticInfoDto.fromJson(Map<String, dynamic> json) =>
      PromptStaticInfoDto(
        code: json["code"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "value": value,
      };
}

enum BasicInfoType {
  zodiac,
  education,
  familyPlan,
  covidVaccine,
  personality,
  communicationType,
  loveStyle
}

enum LifeStyleType {
  pet,
  drinking,
  smoking,
  workout,
  dietaryPreference,
  socialMedia,
  sleepingHabit
}
