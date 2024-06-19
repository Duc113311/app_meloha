import 'dart:ui';

import 'package:dating_app/src/data/datasource/explore/explore_datasource.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import '../domain/dtos/customers/customers_dto.dart';
import '../domain/dtos/topics/topic_dto.dart';
import '../domain/services/connect/connectivity_service.dart';

class ExploreManager {
  static final ExploreManager _shared = ExploreManager._internal();

  ExploreManager._internal();

  static ExploreManager shared() => _shared;

  final ExploreDataSource _exploreDataSource = ExploreDataSource();

  String verifyProfileId = "01HRVEWTG6XM3K4NV61QVHAX75";
  String blindDateId = "01HRVEWTHGDQ8K30H8W0GYYW5F";
  String letsBeFriendId = "01HRVEWTHNVG3DMZ23EYG9T4K8";
  String lookingForLoveId = "01HRVEWTHCZ1Z2VQT2ZN1X8WX1";
  String coffeeDateId = "01HRVEWTHSJV6BZPP95ARH3C5K";

  List<TopicDto> _topics = [];

  Future<List<TopicDto>> getListTopic() async {
    if (_topics.isNotEmpty) {
      return _topics;
    }
    final topicResults = await _exploreDataSource.getListTopics();
    _topics = topicResults.data
        .where((element) => element.id != blindDateId)
        .toList();
    return _topics;
  }

  Future<CustomerDto?> outTopic(String idTopic) async {
    final customer = await _exploreDataSource.outTopic(idTopic);
    return customer;
  }

  Future<CustomerDto?> joinTopic(String idTopic) async {
    final customer = await _exploreDataSource.joinExplore(idTopic);
    return customer;
  }

  Future<List<CustomerDto>?> getTopicCards(
      String idTopic, int pageSize, int currentPage) async {
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return null;
    }

    return await _exploreDataSource.getTopicCards(
        idTopic, pageSize, currentPage);
  }

  Future<List<CustomerDto>?> getVerifiedCards(
      int pageSize, int currentPage) async {
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return null;
    }

    return await _exploreDataSource.getVerifiedCards(pageSize, currentPage);
  }

  Color topicColor(String id) {
    if (id == coffeeDateId) {
      return HexColor("FFCACA");
    } else if (id == letsBeFriendId) {
      return HexColor("BACC94");
    } else if (id == lookingForLoveId) {
      return HexColor("FB75BD");
    } else {
      return HexColor("71C3FF");
    }
  }
}
