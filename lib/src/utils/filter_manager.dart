import 'dart:convert';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/like_and_top_pick/filter_like_dto.dart';
import 'package:dating_app/src/domain/dtos/static_info/static_info.dart';
import 'package:dating_app/src/utils/const.dart';
import 'package:dating_app/src/utils/pref_assist.dart';

class FilterLikeManager {
  static final FilterLikeManager shared = FilterLikeManager._internal();

  FilterLikeManager._internal();

  final String _kFilterLike = '_kFilterLike';

  FilterBodyDto? _oldFilter;

  FilterBodyDto getFilter() {
    if (_oldFilter != null) {
      return _oldFilter!;
    }

    _oldFilter = _defaultFilter;
    return _oldFilter!;
    // String localJson = PrefAssist.getString(_kFilterLike, '');
    // if (localJson.isEmpty) {
    //   return _defaultFilter;
    // } else {
    //   _oldFilter = FilterBodyDto.fromJson(json.decode(localJson));
    //   return _oldFilter!;
    // }
  }

  void resetFilter() {
    _oldFilter = _defaultFilter;
  }

  Future<void> updateFilter(
      {double? distance,
      int? ageMin,
      int? ageMax,
      int? numberPhoto,
      List<String>? interests,
      bool? statusVerified,
      bool? statusBio,
      double? lat,
      double? long}) async {
    FilterBodyDto model = _oldFilter ?? _defaultFilter;
    if (distance != null) {
      model.distance = distance!;
    }
    if (ageMin != null) {
      model.ageMin = ageMin!;
    }
    if (ageMax != null) {
      model.ageMax = ageMax!;
    }
    if (numberPhoto != null) {
      model.numberPhoto = numberPhoto!;
    }
    if (interests != null) {
      model.interests = interests!;
    }
    if (statusVerified != null) {
      model.statusVerified = statusVerified!;
    }
    if (statusBio != null) {
      model.statusBio = statusBio!;
    }
    if (lat != null) {
      model.lat = lat!;
    }
    if (long != null) {
      model.long = long!;
    }

    _oldFilter = model;
    //await PrefAssist.setString(_kFilterLike, json.encode(model.toJson())); //// Xem có cần thiết để lưu lại hay ko
  }

  FilterBodyDto get _defaultFilter {
    double lat = double.parse(PrefAssist.getMyCustomer().location?.lat ?? '0');
    double long = double.parse(PrefAssist.getMyCustomer().location?.lat ?? '0');

    return FilterBodyDto(
        distance: Const.kSettingMaxDistance,
        ageMin: Const.kSettingMinAgeRange,
        ageMax: Const.kSettingMaxAgeRange,
        numberPhoto: Const.kNumberOfImagesRequired,
        interests: [],
        statusVerified: false,
        statusBio: false,
        lat: lat,
        long: long);
  }
}
