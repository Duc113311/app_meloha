import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';
import '../card_action/card_action_dto.dart';
import '../customer_setting/customer_setting_dto.dart';
import '../profiles/profiles_dto.dart';
import '../profiles/prompt_dto.dart';
import 'explore_dto.dart';

part 'customers_dto.g.dart';

@JsonSerializable()
class LocationDto {
  @JsonKey(name: 'lat', defaultValue: "0")
  final String? lat;
  @JsonKey(name: 'long', defaultValue: "0")
  final String? long;

  LocationDto({
    this.lat,
    this.long,
  }) : super();

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}

@JsonSerializable()
class ShowCommonDto {
  @JsonKey(name: 'showSexual', defaultValue: false)
  bool showSexual;
  @JsonKey(name: 'showGender', defaultValue: false)
  bool showGender;
  @JsonKey(name: 'showAge', defaultValue: false)
  bool showAge;
  @JsonKey(name: 'showHeight', defaultValue: false)
  bool showHeight;
  @JsonKey(name: 'showEthnicity', defaultValue: false)
  bool showEthnicity;
  @JsonKey(name: 'showChildrenPlan', defaultValue: false)
  bool showChildrenPlan;
  @JsonKey(name: 'showFamilyPlan', defaultValue: false)
  bool showFamilyPlan;
  @JsonKey(name: 'showWork', defaultValue: false)
  bool showWork;
  @JsonKey(name: 'showSchool', defaultValue: false)
  bool showSchool;
  @JsonKey(name: 'showEducation', defaultValue: false)
  bool showEducation;
  @JsonKey(name: 'showDrinking', defaultValue: false)
  bool showDrinking;
  @JsonKey(name: 'showSmoking', defaultValue: false)
  bool showSmoking;
  @JsonKey(name: 'showDrug', defaultValue: false)
  bool showDrug;
  @JsonKey(name: 'showDistance', defaultValue: false)
  bool showDistance;

  ShowCommonDto(
      {this.showSexual = false,
      this.showGender = false,
      this.showAge = false,
      this.showHeight = false,
      this.showEthnicity = false,
      this.showChildrenPlan = false,
      this.showFamilyPlan = false,
      this.showWork = false,
      this.showSchool = false,
      this.showEducation = false,
      this.showDrinking = false,
      this.showSmoking = false,
      this.showDrug = false,
      this.showDistance = false})
      : super();

  factory ShowCommonDto.fromJson(Map<String, dynamic> json) =>
      _$ShowCommonDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShowCommonDtoToJson(this);
}

@JsonSerializable()
class CustomersDto {
  @JsonKey(required: false, defaultValue: '')
  String message;
  @JsonKey(name: 'data')
  List<CustomerDto> data;

  CustomersDto(this.message, this.data);

  factory CustomersDto.fromJson(Map<String, dynamic> json) =>
      _$CustomersDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomersDtoToJson(this);
}

@JsonSerializable()
class CustomerDto {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'oAuth2Id', defaultValue: '')
  String? oAuth2Id;
  @JsonKey(name: 'fullname', defaultValue: '')
  String fullname;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'profiles')
  ProfilesDto profiles;
  @JsonKey(name: 'dob', fromJson: _dob, toJson: _dobDateFormat)
  DateTime? dob;
  @JsonKey(name: 'settings')
  CustomerSettingDto? settings;
  @JsonKey(name: 'verifyStatus', defaultValue: false)
  bool? verifyStatus; // Xác minh tài khoản
  @JsonKey(name: 'onlineNow', defaultValue: false)
  bool? onlineNow; // Trạng thái online
  @JsonKey(name: 'activeStatus')
  bool? activeStatus; // Trạng thái hoạt động
  @JsonKey(
      name: 'lastActiveTime',
      fromJson: _lastActiveTime,
      toJson: _lastActiveTimeDateFormat)
  DateTime? lastActiveTime; // Thời gian hoạt động gần đây nhất
  @JsonKey(
      name: 'pkgRegistrationDate',
      fromJson: _pkgRegistrationDate,
      toJson: _pkgRegistrationDateDateFormat)
  DateTime? pkgRegistrationDate; // Ngày đăng ký gói
  @JsonKey(
      name: 'pkgExpirationDate',
      fromJson: _pkgExpirationDate,
      toJson: _pkgExpirationDateDateFormat)
  DateTime? pkgExpirationDate; // Ngày hết hạn sử dụng gói
  @JsonKey(name: 'numberBooster')
  int? numberBooster; // Số lượt tăng tốc
  @JsonKey(name: 'location')
  LocationDto? location; // Vị trí hoạt động gần nhất
  @JsonKey(name: 'coins')
  int? coins; // Tiền xu thanh toán trong app
  @JsonKey(name: 'numberSuperLike')
  int? numberSuperLike; // Số lượt siêu thích
  @JsonKey(name: 'numberNotiSeenMsg')
  int?
      numberNotiSeenMsg; // Số lượt thông báo đối tương (quẹt, tương hợp) đã xem tin nhắn
  @JsonKey(name: 'packageId')
  String? packageId; // Gói mua
  @JsonKey(name: 'disable', defaultValue: false)
  bool? disable;
  @JsonKey(name: 'distanceKm', defaultValue: 0)
  double? distanceKm;
  @JsonKey(name: 'channelId', defaultValue: "")
  String? channelId;
  @JsonKey(name: 'explore')
  ExploreDto? explore;
  @JsonKey(name: 'plusCtrl')
  PlusCtrlDto? plusCtrl;
  @JsonKey(name: 'boostInfo')
  BoostDto? boostInfo;
  @JsonKey(name: 'languageMachine')
  String? languageMachine;

  CustomerDto(
      {this.distanceKm,
      this.oAuth2Id,
      required this.id,
      required this.fullname,
      this.email,
      this.phone,
      this.dob,
      required this.profiles,
      this.settings,
      this.verifyStatus,
      this.onlineNow,
      this.activeStatus,
      this.lastActiveTime,
      this.pkgRegistrationDate,
      this.pkgExpirationDate,
      this.numberBooster,
      this.location,
      this.coins,
      this.numberSuperLike,
      this.numberNotiSeenMsg,
      this.packageId,
      this.disable,
      this.channelId,
      this.boostInfo,
      this.explore,
      this.plusCtrl,
      this.languageMachine});

  factory CustomerDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomerDtoToJson(this);

  bool get isEmpty {
    return id.isEmpty || fullname.isEmpty;
  }


  bool get isNotEmpty {
    return id.isNotEmpty && fullname.isNotEmpty;
  }

  int getAge() {
    if (dob == null) return 0;
    return DateTimeUtils.getAgeFromMilliseconds(dob!.millisecondsSinceEpoch);
  }

  int get verified {
    return explore?.verified ?? 0;
  }

  bool get isVerified {
    return verified == Const.kVerifyAccountSuccess;
  }

  String get getNameForHinge {
    if (profiles.showCommon.showAge && getAge() > 0) {
      if (fullname.length > 20) {
        return "${fullname.substring(0, 17)}..., ${getAge()}";
      } else {
        return "${fullname}, ${getAge()}";
      }
    } else {
      return fullname;
    }
  }

  String get verifyImage {
    final status = explore?.verified ?? 0;
    if (status == Const.kVerifyAccountSuccess) {
      return ThemeUtils.isDarkModeSetting()
          ? AppImages.icVerifiedEnableDark
          : AppImages.icVerifiedEnable;
    } else {
      return ThemeUtils.isDarkModeSetting()
          ? AppImages.icVerifiedDisableDark
          : AppImages.icVerifiedDisable;
    }
  }

  String get myVerifyImage {
    switch (explore?.verified ?? 0) {
      case 1:
        return AppImages.icVerifiedPending;
      case 2:
        return ThemeUtils.isDarkModeSetting()
            ? AppImages.icVerifiedEnableDark
            : AppImages.icVerifiedEnable;
      case -1:
        return AppImages.icVerifiedFail;
      default:
        return ThemeUtils.isDarkModeSetting()
            ? AppImages.icVerifiedDisableDark
            : AppImages.icVerifiedDisable;
    }
  }

  String get getAbout {
    return profiles?.about ?? '';
  }

  String get getFirebaseFolderName {
    return email ?? phone ?? fullname;
  }

  String get getAvatarUrl {
    final avatars = profiles.avatars ?? [];
    if (avatars.isEmpty) {
      return '';
    }
    return avatars.firstOrNull?.url ?? '';
  }

  String get getAvatarCacheKeyId {
    return getAvatarUrl.removeQuery;
  }

  AvatarDto? get getAvatarModel {
    return profiles?.avatars?.firstOrNull;
  }

  String get getThumbnailAvatarUrl {
    return profiles?.avatars?.firstOrNull?.thumbnail ?? '';
  }

  String get getGenderValue {
    return profiles?.gender ?? '';
  }

  String get getGender {
    if (profiles?.showCommon?.showGender ?? true) {
      return profiles?.gender ?? '';
    } else {
      return "";
    }
  }

  String get getGenderConvert {
    return StaticInfoManager.shared().convertGenders([getGender]).first ?? '';
  }

  double get getHeight {
    return profiles?.height ?? -1;
  }

  String get getDrug {
    return profiles?.drug ?? '';
  }

  String get getDrugConvert {
    return StaticInfoManager.shared().convertDrug(getDrug);
  }

  String get getDrinking {
    return profiles?.drinking ?? '';
  }

  String get getPet {
    return profiles?.pet ?? '';
  }

  String get getSmoking {
    return profiles?.smoking ?? '';
  }

  String get getWorkout {
    return profiles?.workout ?? '';
  }

  String get getDietaryPreference {
    return profiles?.dietaryPreference ?? '';
  }

  String get getSocialMedia {
    return profiles?.socialMedia ?? '';
  }

  String get getSleepingHabit {
    return profiles?.sleepingHabit ?? '';
  }

  String get getEducation {
    return profiles?.education ?? '';
  }

  String get getSchool {
    return profiles?.school ?? '';
  }

  String get getJobTitle {
    return profiles?.jobTitle ?? '';
  }

  String get getCompany {
    return profiles?.company ?? '';
  }

  String get getJobInCompany {
    final job = profiles?.jobTitle ?? '';
    final company = profiles?.company ?? '';

    if (job.isEmpty) {
      return company;
    }
    if (company.isEmpty) {
      return job;
    }

    return '$job ${S.current.txt_at} $company';
  }

  String get getAddress {
    return profiles?.address ?? '';
  }

  String get getFirstAddress {
    final childs = getAddress.split(', ');
    if (childs.length < 2) {
      return getAddress;
    } else if (childs.length < 3) {
      return childs.last;
    } else {
      return childs[childs.length - 2];
    }
  }

  bool get showSexual {
    return profiles?.showCommon?.showSexual ?? false;
  }

  String get getSexual {
    if (showSexual) {
      return (profiles?.orientationSexuals ?? []).join(', ');
    } else {
      return "";
    }
  }

  String get getDatingPurpose {
    return profiles?.datingPurpose ?? '';
  }

  String get getDatingPurposeConvert {
    if (getDatingPurpose.isNotEmpty) {
      return StaticInfoManager.shared().convertDatingPurpose(getDatingPurpose);
    } else {
      return "";
    }
  }

  bool get showHeight {
    return profiles?.showCommon?.showHeight ?? false;
  }

  String get getHeightValue {
    if (profiles?.height == null) {
      return "";
    }
    if (profiles!.height == -1) {
      return "";
    }
    return "${profiles!.height!.toInt().toString()} cm";
  }

  String get getHeightInfo {
    if (profiles?.height == null) {
      return "";
    }
    if (profiles!.height == -1 || !showHeight) {
      return "";
    }
    return "${profiles!.height!.toInt().toString()} cm";
  }

  List<String> get getListAvatarUrls {
    return profiles?.avatars?.map((e) => e.url).toList() ?? [];
  }

  List<String> get getListAvatarThumbnailUrls {
    return profiles?.avatars?.map((e) => e.thumbnail).toList() ?? [];
  }

  List<AvatarDto> get getListAvatarModels {
    return profiles?.avatars ?? [];
  }

  List<String> get getListOrientationSexualsConvert {
    final orientationSexuals = profiles?.orientationSexuals ?? [];
    return StaticInfoManager.shared().convertListSexual(orientationSexuals);
  }

  List<String> get getListOrientationSexuals {
    return profiles?.orientationSexuals ?? [];
  }

  List<String> get getListInterestsConvert {
    final interests = profiles?.interests ?? [];
    return StaticInfoManager.shared().convertListInterests(interests);
  }

  List<String> get getListInterests {
    return profiles?.interests ?? [];
  }

  List<String> get getListLanguagesConvert {
    final languages = profiles?.languages ?? [];
    return StaticInfoManager.shared().convertListLanguages(languages);
  }

  List<String> get getListLanguages {
    return profiles?.languages ?? [];
  }

  List<PromptDto> get getListPrompts {
    return profiles?.prompts ?? [];
  }

  String get getZodiac {
    return profiles?.zodiac ?? '';
  }

  String get getFamilyPlan {
    return profiles?.familyPlan ?? '';
  }

  String get getChildrenPlan {
    return profiles?.childrenPlan ?? '';
  }

  String get getCovidVaccine {
    return profiles?.covidVaccine ?? '';
  }

  String get getPersonality {
    return profiles?.personality ?? '';
  }

  String get getCommunicationType {
    return profiles?.communicationType ?? '';
  }

  String get getLoveStyle {
    return profiles?.loveStyle ?? '';
  }

  String get getZodiacConvert {
    return StaticInfoManager.shared().convertZodiac(getZodiac);
  }

  String get getFamilyPlanConvert {
    return StaticInfoManager.shared().convertFamilyPlan(getFamilyPlan);
  }

  String get getChildrenPlanConvert {
    return StaticInfoManager.shared()
        .convertListChildrens([getChildrenPlan]).first;
  }

  String get getCovidVaccineConvert {
    return StaticInfoManager.shared()
        .convertCovidVaccines([getCovidVaccine]).first;
  }

  String get getPersonalityConvert {
    return StaticInfoManager.shared()
        .convertPersonalities([getPersonality]).first;
  }

  String get getCommunicationTypeConvert {
    return StaticInfoManager.shared()
        .convertCommunicationStyles([getCommunicationType]).first;
  }

  String get getLoveStyleConvert {
    return StaticInfoManager.shared().convertLoveStyles([getLoveStyle]).first;
  }

  List<String> get getEthnicitiesConvert {
    return StaticInfoManager.shared().convertListEthnicities(getEthnicities);
  }

  String get getEducationConvert {
    return StaticInfoManager.shared().convertEducation(getEducation);
  }

  List<String> get getEthnicities {
    return profiles?.ethnicitys ?? [];
  }

  List<AvatarDto> get getListImageVerified {
    return getListAvatarModels
        .where((element) => element.getVerified == true)
        .toList();
  }

  int get basicPercentCompleted {
    if (getZodiac.isNotEmpty ||
        getEducation.isNotEmpty ||
        getFamilyPlan.isNotEmpty ||
        getCovidVaccine.isNotEmpty ||
        getPersonality.isNotEmpty ||
        getCommunicationType.isNotEmpty ||
        getLoveStyle.isNotEmpty) {
      return Const.kCustomerMaxPercentBasics;
    }
    return 0;
  }

  int get lifestylePercentCompleted {
    if (getPet.isNotEmpty ||
        getDrinking.isNotEmpty ||
        getSmoking.isNotEmpty ||
        getWorkout.isNotEmpty ||
        getDietaryPreference.isNotEmpty ||
        getSocialMedia.isNotEmpty ||
        getSleepingHabit.isNotEmpty) {
      return Const.kCustomerMaxPercentLifestyle;
    }
    return 0;
  }

  int get getPercentCompleted {
    int percent = 0;
    if (profiles == null) {
      return 0;
    }

    percent +=
        getListAvatarModels.length >= 6 ? Const.kCustomerMaxPercentAvatars : 0;
    percent += getAbout.isNotEmpty ? Const.kCustomerMaxPercentAbout : 0;
    percent +=
        getListInterests.length >= 3 ? Const.kCustomerMaxPercentInterests : 0;
    percent += getDatingPurpose.isNotEmpty
        ? Const.kCustomerMaxPercentDatingPurpose
        : 0;
    percent +=
        getListLanguages.isNotEmpty ? Const.kCustomerMaxPercentLanguages : 0;
    percent += basicPercentCompleted;
    percent += lifestylePercentCompleted;
    percent += getJobTitle.isNotEmpty ? Const.kCustomerMaxPercentJobTitle : 0;
    percent += (getCompany.isNotEmpty || getCompany.isNotEmpty)
        ? Const.kCustomerMaxPercentCompany
        : 0;
    percent += getSchool.isNotEmpty ? Const.kCustomerMaxPercentSchool : 0;
    percent += getAddress.isNotEmpty ? Const.kCustomerMaxPercentAddress : 0;

    return percent.clamp(0, 100);
  }

  static CustomerDto deletedAccount() {
    return CustomerDto(
        fullname: S.current.deleted_account,
        id: Const.deletedAccount,
        profiles: ProfilesDto.createEmptyProfile(),
        settings: CustomerSettingDto.createEmptySettings());
  }

  static CustomerDto createEmptyCustomer() {
    return CustomerDto(
        fullname: '',
        id: '',
        profiles: ProfilesDto.createEmptyProfile(),
        settings: CustomerSettingDto.createEmptySettings());
  }

  //from json
  static DateTime? _dob(String? dob) =>
      DateTimeUtils.convertStringToDateTime(dob);

  static DateTime? _lastActiveTime(String? lastActiveTime) =>
      DateTimeUtils.convertStringToDateTime(lastActiveTime);

  static DateTime? _pkgRegistrationDate(String? pkgRegistrationDate) =>
      DateTimeUtils.convertStringToDateTime(pkgRegistrationDate);

  static DateTime? _pkgExpirationDate(String? pkgExpirationDate) =>
      DateTimeUtils.convertStringToDateTime(pkgExpirationDate);

  //to json
  static String? _dobDateFormat(DateTime? dob) {
    if (dob == null) return '';
    return DateFormat(ApiUtils.DATE_TIME_FORMAT).format(dob);
  }

  static String? _lastActiveTimeDateFormat(DateTime? lastActiveTime) {
    if (lastActiveTime != null) {
      return DateFormat(ApiUtils.DATE_TIME_FORMAT).format(lastActiveTime!);
    } else {
      return null;
    }
  }

  static String? _pkgRegistrationDateDateFormat(DateTime? pkgRegistrationDate) {
    if (pkgRegistrationDate != null) {
      return DateFormat(ApiUtils.DATE_TIME_FORMAT).format(pkgRegistrationDate!);
    } else {
      return null;
    }
  }

  static String? _pkgExpirationDateDateFormat(DateTime? pkgExpirationDate) {
    if (pkgExpirationDate != null) {
      return DateFormat(ApiUtils.DATE_TIME_FORMAT).format(pkgExpirationDate!);
    } else {
      return null;
    }
  }

  String getStringDob() {
    if (dob == null) return '';
    return DateFormat(ApiUtils.DATE_TIME_FORMAT).format(dob!);
  }

  LocationDto? getLocation() {
    return location == null
        ? null
        : location?.long == 0 && location?.lat == 0
            ? null
            : location;
  }

  bool get isBoosting {
    if (boostInfo?.endTime == null) {
      return false;
    }
    return boostInfo!.endTime!.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch;
  }

  String get getPetConvert {
    if (profiles?.pet != null) {
      return StaticInfoManager.shared().convertPet(profiles!.pet!);
    } else {
      return '';
    }
  }

  String get getDrinkingConvert {
    if (profiles?.drinking != null) {
      return StaticInfoManager.shared().convertDrinking(profiles!.drinking!);
    } else {
      return '';
    }
  }

  String get getSmokingConvert {
    if (profiles?.smoking != null) {
      return StaticInfoManager.shared().convertSmoking(profiles!.smoking!);
    } else {
      return '';
    }
  }

  String get getWorkoutConvert {
    if (profiles?.workout != null) {
      return StaticInfoManager.shared().convertWorkout(profiles!.workout!);
    } else {
      return '';
    }
  }

  String get getDietaryPreferenceConvert {
    if (profiles?.dietaryPreference != null) {
      return StaticInfoManager.shared()
          .convertFoodPreferences(profiles!.dietaryPreference!);
    } else {
      return '';
    }
  }

  String get getSocialMediaConvert {
    if (profiles?.socialMedia != null) {
      return StaticInfoManager.shared().convertSocials(profiles!.socialMedia!);
    } else {
      return '';
    }
  }

  String get getSleepingHabitConvert {
    if (profiles?.sleepingHabit != null) {
      return StaticInfoManager.shared()
          .convertSleepingStyle(profiles!.sleepingHabit!);
    } else {
      return '';
    }
  }
}
