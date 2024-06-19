// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dating_app/src/data/datasource/card_action/card_action_datasource.dart'
    as _i3;
import 'package:dating_app/src/data/datasource/chat_datasource/edit_message_datasource.dart'
    as _i4;
import 'package:dating_app/src/data/datasource/chat_datasource/get_channel_id_datasource.dart'
    as _i6;
import 'package:dating_app/src/data/datasource/chat_datasource/get_channels_datasource.dart'
    as _i5;
import 'package:dating_app/src/data/datasource/chat_datasource/get_friends_datasource.dart'
    as _i7;
import 'package:dating_app/src/data/datasource/chat_datasource/message_datasource.dart'
    as _i8;
import 'package:dating_app/src/data/datasource/chat_datasource/remove_channel_datasource.dart'
    as _i9;
import 'package:dating_app/src/data/datasource/chat_datasource/send_message_datasource.dart'
    as _i10;
import 'package:dating_app/src/data/datasource/deleted_account/deleted_account_datasource.dart'
    as _i11;
import 'package:dating_app/src/data/datasource/explore/explore_datasource.dart'
    as _i12;
import 'package:dating_app/src/data/datasource/home_main/home_main_datasource.dart'
    as _i13;
import 'package:dating_app/src/data/datasource/like_and_for_you/like_and_for_you_datasource.dart'
    as _i14;
import 'package:dating_app/src/data/datasource/report/report_datasource.dart'
    as _i15;
import 'package:dating_app/src/data/datasource/static_info/static_info_datasource.dart'
    as _i16;
import 'package:dating_app/src/data/datasource/verify/verify_datasource.dart'
    as _i17;
import 'package:dating_app/src/data/remote/app-client.dart' as _i18;
import 'package:dating_app/src/domain/repositories/card_action/card_action_repo.dart'
    as _i19;
import 'package:dating_app/src/domain/repositories/chat_repo/edit_message_repo.dart'
    as _i20;
import 'package:dating_app/src/domain/repositories/chat_repo/get_channel_id_repo.dart'
    as _i22;
import 'package:dating_app/src/domain/repositories/chat_repo/get_channels_repo.dart'
    as _i21;
import 'package:dating_app/src/domain/repositories/chat_repo/get_friends_repo.dart'
    as _i23;
import 'package:dating_app/src/domain/repositories/chat_repo/message_repo.dart'
    as _i24;
import 'package:dating_app/src/domain/repositories/chat_repo/remove_channel_repo.dart'
    as _i25;
import 'package:dating_app/src/domain/repositories/chat_repo/send_message_repo.dart'
    as _i26;
import 'package:dating_app/src/domain/repositories/deleted_account/deleted_account_repo.dart'
    as _i27;
import 'package:dating_app/src/domain/repositories/home_main/home_main_repo.dart'
    as _i28;
import 'package:dating_app/src/domain/repositories/like_and_for_you/like_an_for_you_repo.dart'
    as _i29;
import 'package:dating_app/src/domain/repositories/report/report_repo.dart'
    as _i30;
import 'package:dating_app/src/domain/repositories/verify/verify_repo.dart'
    as _i31;
import 'package:dating_app/src/domain/services/navigator/route_service.dart'
    as _i32;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt $initDependencies({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.CardActionDataSource>(() => _i3.CardActionDataSource());
    gh.singleton<_i4.EditMessageDataSource>(() => _i4.EditMessageDataSource());
    gh.singleton<_i5.GetChannelsDataSource>(() => _i5.GetChannelsDataSource());
    gh.singleton<_i6.GetChannelIdDataSource>(
        () => _i6.GetChannelIdDataSource());
    gh.singleton<_i7.GetFriendsDataSource>(() => _i7.GetFriendsDataSource());
    gh.singleton<_i8.MessageDataSource>(() => _i8.MessageDataSource());
    gh.singleton<_i9.RemoveChannelDataSource>(
        () => _i9.RemoveChannelDataSource());
    gh.singleton<_i10.SendMessageDataSource>(
        () => _i10.SendMessageDataSource());
    gh.singleton<_i11.DeletedAccountDataSource>(
        () => _i11.DeletedAccountDataSource());
    gh.singleton<_i12.ExploreDataSource>(() => _i12.ExploreDataSource());
    gh.singleton<_i13.HomeMainDataSource>(() => _i13.HomeMainDataSource());
    gh.singleton<_i14.LikeAndForYouDataSource>(
        () => _i14.LikeAndForYouDataSource());
    gh.singleton<_i15.ReportDataSource>(() => _i15.ReportDataSource());
    gh.singleton<_i16.StaticInfoDataSource>(() => _i16.StaticInfoDataSource());
    gh.singleton<_i17.VerifyDataSource>(() => _i17.VerifyDataSource());
    gh.singleton<_i18.AppClient>(() => _i18.AppClient());
    gh.singleton<_i19.CardActionRepo>(() => _i19.CardActionRepo());
    gh.singleton<_i20.EditMessageRepo>(() => _i20.EditMessageRepo());
    gh.singleton<_i21.GetChannelsRepo>(() => _i21.GetChannelsRepo());
    gh.singleton<_i22.GetChannelIdRepo>(() => _i22.GetChannelIdRepo());
    gh.singleton<_i23.GetFriendsRepo>(() => _i23.GetFriendsRepo());
    gh.singleton<_i24.MessagesRepo>(() => _i24.MessagesRepo());
    gh.singleton<_i25.RemoveChannelRepo>(() => _i25.RemoveChannelRepo());
    gh.singleton<_i26.SendMessageRepo>(() => _i26.SendMessageRepo());
    gh.singleton<_i27.DeletedAccountRepo>(() => _i27.DeletedAccountRepo());
    gh.singleton<_i28.HomeMainRepo>(() => _i28.HomeMainRepo());
    gh.singleton<_i29.LikeAndForYouRepo>(() => _i29.LikeAndForYouRepo());
    gh.singleton<_i30.ReportRepo>(() => _i30.ReportRepo());
    gh.singleton<_i31.VerifyRepo>(() => _i31.VerifyRepo());
    gh.singleton<_i32.RouteService>(() => _i32.RouteService());
    return this;
  }
}
