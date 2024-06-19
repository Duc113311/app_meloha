import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/domain/dtos/reason/reason_dto.dart';
import 'package:dating_app/src/utils/extensions/object_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/datasource/static_info/static_info_datasource.dart';
import '../../../data/remote/api_endpoint.dart';
import '../../../domain/dtos/static_info/static_info.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

enum StaticInfoType {
  genders,
  genderFilters,
  sexuals,
  childrens,
  interests,
  datingPurposes,
  languages,
  schools,
  jobTitles,
  zodiacs,
  educations,
  familyPlans,
  covidVaccines,
  personalities,
  communicationStyles,
  ethnicities,
  pets,
  drinkings,
  smokings,
  drugs,
  workouts,
  foodPreferences,
  socials,
  sleepingStyles,
  loveStyles,
}

class StaticInfoManager {
  static final StaticInfoManager _shared = StaticInfoManager._internal();

  StaticInfoManager._internal();

  static StaticInfoManager shared() => _shared;
  static const kPreferNotSay = 'notSay';

  StaticInfoDataSource get datasource => getIt<StaticInfoDataSource>();

  List<StaticInfoDto> _genders = [];
  List<StaticInfoDto> _genderFilters = [];
  List<StaticInfoDto> _sexuals = [];
  List<StaticInfoDto> _interests = [];
  List<StaticInfoDto> _datingPurposes = [];
  List<StaticInfoDto> _languages = [];
  List<StaticInfoDto> _zodiacs = [];
  List<StaticInfoDto> _educations = [];
  List<StaticInfoDto> _familyPlans = [];
  List<StaticInfoDto> _covidVaccines = [];
  List<StaticInfoDto> _personalities = [];
  List<StaticInfoDto> _communicationStyles = [];
  List<StaticInfoDto> _childrens = [];
  List<StaticInfoDto> _pets = [];
  List<StaticInfoDto> _drinkings = [];
  List<StaticInfoDto> _smokings = [];
  List<StaticInfoDto> _drugs = [];
  List<StaticInfoDto> _workouts = [];
  List<StaticInfoDto> _foodPreferences = [];
  List<StaticInfoDto> _socials = [];
  List<StaticInfoDto> _sleepingStyles = [];
  List<StaticInfoDto> _ethnicities = [];
  List<StaticInfoDto> _loveStyles = [];
  List<String> _schools = [];
  List<String> _jobTitles = [];
  List<CategoryPromptStaticInfoDto> _prompts = [];

  //MARK: Public functions
  ///Get values
  List<String> get gendersValue {
    return _genders.map((e) => e.value).toList();
  }

  List<String> get genderFiltersValue {
    return _genderFilters.map((e) => e.value).toList();
  }

  List<String> get sexualsValue {
    return _sexuals.map((e) => e.value).toList();
  }

  List<String> get interestsValue {
    return _interests.map((e) => e.value).toList();
  }

  List<String> get datingPurposesValue {
    return _datingPurposes.map((e) => e.value).toList();
  }

  List<String> get languagesValue {
    return _languages.map((e) => e.value).toList();
  }

  List<String> get zodiacsValue {
    return _zodiacs.map((e) => e.value).toList();
  }

  List<String> get educationsValue {
    return _educations.map((e) => e.value).toList();
  }

  List<String> get familyPlansValue {
    return _familyPlans.map((e) => e.value).toList();
  }

  List<String> get covidVaccinesValue {
    return _covidVaccines.map((e) => e.value).toList();
  }

  List<String> get personalitiesValue {
    return _personalities.map((e) => e.value).toList();
  }

  List<String> get communicationStylesValue {
    return _communicationStyles.map((e) => e.value).toList();
  }

  List<String> get petsValue {
    return _pets.map((e) => e.value).toList();
  }

  List<String> get drinkingsValue {
    return _drinkings.map((e) => e.value).toList();
  }

  List<String> get smokingValue {
    return _smokings.map((e) => e.value).toList();
  }

  List<String> get workoutsValue {
    return _workouts.map((e) => e.value).toList();
  }

  List<String> get foodPreferencesValue {
    return _foodPreferences.map((e) => e.value).toList();
  }

  List<String> get socialsValue {
    return _socials.map((e) => e.value).toList();
  }

  List<String> get sleepingStylesValue {
    return _sleepingStyles.map((e) => e.value).toList();
  }

  List<String> get ethnicitiesValue {
    return _ethnicities.map((e) => e.value).toList();
  }

  List<String> get loveStylesValue {
    return _loveStyles.map((e) => e.value).toList();
  }

  //
  List<StaticInfoDto> get genders {
    return _genders;
  }

  List<StaticInfoDto> get childrens {
    return _childrens;
  }

  List<StaticInfoDto> get genderFilters {
    return _genderFilters;
  }

  List<StaticInfoDto> get sexuals {
    return _sexuals;
  }

  List<StaticInfoDto> get interests {
    return _interests;
  }

  List<StaticInfoDto> get datingPurposes {
    return _datingPurposes;
  }

  List<StaticInfoDto> get languages {
    return _languages;
  }

  List<StaticInfoDto> get zodiacs {
    return _zodiacs;
  }

  List<StaticInfoDto> get educations {
    return _educations;
  }

  List<StaticInfoDto> get familyPlans {
    return _familyPlans;
  }

  List<StaticInfoDto> get covidVaccines {
    return _covidVaccines;
  }

  List<StaticInfoDto> get personalities {
    return _personalities;
  }

  List<StaticInfoDto> get communicationStyles {
    return _communicationStyles;
  }

  List<StaticInfoDto> get pets {
    return _pets;
  }

  List<StaticInfoDto> get drinkings {
    return _drinkings;
  }

  List<StaticInfoDto> get drugs {
    return _drugs;
  }

  List<StaticInfoDto> get smokings {
    return _smokings;
  }

  List<StaticInfoDto> get workouts {
    return _workouts;
  }

  List<StaticInfoDto> get foodPreferences {
    return _foodPreferences;
  }

  List<StaticInfoDto> get socials {
    return _socials;
  }

  List<StaticInfoDto> get sleepingStyles {
    return _sleepingStyles;
  }

  List<StaticInfoDto> get ethnicities {
    return _ethnicities;
  }

  List<StaticInfoDto> get loveStyles {
    return _loveStyles;
  }

  List<String> get schools {
    return _schools;
  }

  List<String> get jobTitles {
    return _jobTitles;
  }

  List<CategoryPromptStaticInfoDto> get prompts {
    return _prompts;
  }

  ///Convert
  String convertDatingPurpose(String item) {
    return _datingPurposes
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  List<String> convertListLanguages(List<String> languages) {
    return languages.map((e) {
      return _languages
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  List<String> convertListInterests(List<String> interests) {
    return interests.map((e) {
      return _interests
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  List<String> convertListSexual(List<String> orientationSexuals) {
    return orientationSexuals.map((e) {
      if (e == kPreferNotSay) {
        return S.current.txt_prefer_not_say;
      } else {
        return sexuals
                .firstWhereOrNull((element) => element.code == e)
                ?.value ??
            e;
      }
    }).toList();
  }

  List<String> convertListChildrens(List<String> childrens) {
    return childrens.map((e) {
      if (e == kPreferNotSay) {
        return S.current.txt_prefer_not_say;
      } else {
        return _childrens
                .firstWhereOrNull((element) => element.code == e)
                ?.value ??
            e;
      }
    }).toList();
  }

  List<String> convertListEthnicities(List<String> ethnicities) {
    return ethnicities.map((e) {
      if (e == kPreferNotSay) {
        return S.current.txt_prefer_not_say;
      } else {
        return _ethnicities
                .firstWhereOrNull((element) => element.code == e)
                ?.value ??
            e;
      }
    }).toList();
  }

  List<String> convertGenders(List<String> genders) {
    return genders.map((e) {
      return _genders.firstWhereOrNull((element) => element.code == e)?.value ??
          e;
    }).toList();
  }

  List<String> convertGenderFilters(List<String> genders) {
    return genders.map((e) {
      return _genderFilters
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  String convertZodiac(String zodiac) {
    return _zodiacs
            .firstWhereOrNull((element) => element.code == zodiac)
            ?.value ??
        zodiac;
  }

  List<String> convertEducations(List<String> educations) {
    return educations.map((e) {
      return _educations
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  String convertEducation(String education) {
    return _educations
            .firstWhereOrNull((element) => element.code == education)
            ?.value ??
        education;
  }

  String convertFamilyPlan(String e) {
    return _familyPlans
            .firstWhereOrNull((element) => element.code == e)
            ?.value ??
        e;
  }

  List<String> convertFamilyPlans(List<String> familyPlans) {
    return familyPlans.map((e) {
      return _familyPlans
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  List<String> convertCovidVaccines(List<String> covidVaccines) {
    return covidVaccines.map((e) {
      return _covidVaccines
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  List<String> convertPersonalities(List<String> personalities) {
    return personalities.map((e) {
      return _personalities
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  List<String> convertCommunicationStyles(List<String> communicationStyles) {
    return communicationStyles.map((e) {
      return _communicationStyles
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  List<String> convertLoveStyles(List<String> loveStyles) {
    return loveStyles.map((e) {
      return _loveStyles
              .firstWhereOrNull((element) => element.code == e)
              ?.value ??
          e;
    }).toList();
  }

  String convertPet(String item) {
    return _pets.firstWhereOrNull((element) => element.code == item)?.value ??
        item;
  }

  String convertDrinking(String item) {
    return _drinkings
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  String convertSmoking(String item) {
    return _smokings
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  String convertDrug(String item) {
    return _drugs.firstWhereOrNull((element) => element.code == item)?.value ??
        item;
  }

  String convertWorkout(String item) {
    return _workouts
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  String convertFoodPreferences(String item) {
    return _foodPreferences
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  String convertSocials(String item) {
    return _socials
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  String convertSleepingStyle(String item) {
    return _sleepingStyles
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  String convertPrompt(String item) {
    return _prompts
            .expand((element) => element.prompts)
            .toList()
            .firstWhereOrNull((element) => element.code == item)
            ?.value ??
        item;
  }

  Future<void> loadData() async {
    final register = await datasource.requestStaticInfo<Map<String, dynamic>>(AppPath.guestStatics);
    if (register != null) {
      await _saveData(register);
    }

    final prompts = await datasource.requestStaticInfo<List<dynamic>>(AppPath.staticsPrompt);
    if (prompts != null) {
      await _savePrompts(prompts);
    }

    if (PrefAssist.getAccessToken().isEmpty) {
      await _loadLocalData();
      return;
    }

    final common = await datasource.requestStaticInfo<Map<String, dynamic>>(AppPath.staticsCommon);
    if (common != null) {
      await _saveData(common);
    }

    final basic = await datasource.requestStaticInfo<Map<String, dynamic>>(AppPath.staticsBasics);
    if (basic != null) {
      await _saveData(basic);
    }

    final lifeStyle =
        await datasource.requestStaticInfo<Map<String, dynamic>>(AppPath.staticsLifeStyles);
    if (lifeStyle != null) {
      await _saveData(lifeStyle);
    }

    await _loadLocalData();
  }

  Future<List<StaticInfoDto>> getValues(StaticInfoType type) async {
    final values = await _getData<StaticInfoDto>(type.name);
    return values ?? [];
  }

  Future<ReasonResponseDto?> getReasons() async {
    final result = await datasource.requestStaticInfo(AppPath.staticsReason);
    if (result != null) {
      return ReasonResponseDto.fromJson(result);
    } else {
      return null;
    }
  }

  //MARK: Private functions
  Future<void> _loadLocalData() async {
    _genders = await _getData<StaticInfoDto>(StaticInfoType.genders.name) ?? [];
    _childrens =
        await _getData<StaticInfoDto>(StaticInfoType.childrens.name) ?? [];
    _genderFilters =
        await _getData<StaticInfoDto>(StaticInfoType.genderFilters.name) ?? [];
    _sexuals = await _getData<StaticInfoDto>(StaticInfoType.sexuals.name) ?? [];
    _interests =
        await _getData<StaticInfoDto>(StaticInfoType.interests.name) ?? [];
    _datingPurposes =
        await _getData<StaticInfoDto>(StaticInfoType.datingPurposes.name) ?? [];
    _languages =
        await _getData<StaticInfoDto>(StaticInfoType.languages.name) ?? [];
    _zodiacs = await _getData<StaticInfoDto>(StaticInfoType.zodiacs.name) ?? [];
    _educations =
        await _getData<StaticInfoDto>(StaticInfoType.educations.name) ?? [];
    _familyPlans =
        await _getData<StaticInfoDto>(StaticInfoType.familyPlans.name) ?? [];
    _covidVaccines =
        await _getData<StaticInfoDto>(StaticInfoType.covidVaccines.name) ?? [];
    _personalities =
        await _getData<StaticInfoDto>(StaticInfoType.personalities.name) ?? [];
    _communicationStyles = await _getData<StaticInfoDto>(
            StaticInfoType.communicationStyles.name) ??
        [];
    _pets = await _getData<StaticInfoDto>(StaticInfoType.pets.name) ?? [];
    _drinkings =
        await _getData<StaticInfoDto>(StaticInfoType.drinkings.name) ?? [];
    _smokings =
        await _getData<StaticInfoDto>(StaticInfoType.smokings.name) ?? [];
    _drugs = await _getData<StaticInfoDto>(StaticInfoType.drugs.name) ?? [];
    _workouts =
        await _getData<StaticInfoDto>(StaticInfoType.workouts.name) ?? [];
    _foodPreferences =
        await _getData<StaticInfoDto>(StaticInfoType.foodPreferences.name) ??
            [];
    _socials = await _getData<StaticInfoDto>(StaticInfoType.socials.name) ?? [];
    _sleepingStyles =
        await _getData<StaticInfoDto>(StaticInfoType.sleepingStyles.name) ?? [];
    _ethnicities =
        await _getData<StaticInfoDto>(StaticInfoType.ethnicities.name) ?? [];
    _loveStyles =
        await _getData<StaticInfoDto>(StaticInfoType.loveStyles.name) ?? [];

    _schools = await _getData<String>(StaticInfoType.schools.name) ?? [];
    _jobTitles = await _getData<String>(StaticInfoType.jobTitles.name) ?? [];
    _prompts = await _getPrompts();
  }

  Future<List<CategoryPromptStaticInfoDto>> _getPrompts() async {
    final result = PrefAssist.getDynamic("kStaticInfoPrompts", null);
    final castList = tryCast<List<dynamic>>(result);

    if (castList != null) {
      List<CategoryPromptStaticInfoDto> prompts = [];

      await Future.forEach(castList!, (element) {
        Map<String, dynamic> dict = tryCast(element);

        final model = CategoryPromptStaticInfoDto.fromJson(dict);
        if (model != null) {
          prompts.add(model);
        }
      });
      return prompts;
    } else {
      return [];
    }
  }

  Future<List<T>?> _getData<T>(String key) async {
    final result = PrefAssist.getDynamic(key, null);
    final castList = tryCast<List<dynamic>>(result);
    if (castList != null) {
      List<T> listValues = [];
      await Future.forEach(castList!, (element) {
        if (T == StaticInfoDto && element is Map<String, dynamic>) {
          final model = StaticInfoDto.fromJson(element);
          if (model != null) {
            listValues.add(model as T);
          }
        } else if (T == String && element is String) {
          listValues.add(element as T);
        } else {
          debugPrint('error cast T');
        }
      });
      return listValues;
    } else {
      return null;
    }
  }

  Future<void> _saveData(Map<String, dynamic> objects) async {
    return await Future.forEach(objects.keys, (key) async {
      if (key is String) {
        await PrefAssist.setDynamic(key, objects[key]);
      }
    });
  }

  Future<void> _savePrompts(List<dynamic> objects) async {
    return await PrefAssist.setDynamic("kStaticInfoPrompts", objects);
  }
}
