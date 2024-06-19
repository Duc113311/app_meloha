import 'package:dating_app/main.dart';
import 'package:dating_app/src/components/bloc/card_action/card_action_cubit.dart';
import 'package:dating_app/src/components/bloc/chat/send_message_cubit.dart';
import 'package:dating_app/src/components/bloc/deleted_account/deleted_account_cubit.dart';
import 'package:dating_app/src/components/bloc/get_channels/remove_channel_cubit.dart';
import 'package:dating_app/src/components/bloc/messages/get_messages_cubit.dart';
import 'package:dating_app/src/modules/explore/bloc/explore/explore_detail_page/explore_detail_page_cubit.dart';
import 'package:dating_app/src/modules/likes_and_tops_pick/bloc/likes/likes_cubit.dart';
import 'package:dating_app/src/modules/splash/splash_page.dart';
import 'package:dating_app/src/modules/verify/bloc/verify_cubit.dart';
import 'package:dating_app/src/utils/connection_status.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'app_manager.dart';
import 'components/bloc/get_channels/get_channel_id_cubit.dart';
import 'modules/chat/bloc/chat_conversation_bloc.dart';
import 'modules/home/bloc/home_main_cubit.dart';
import 'modules/likes_and_tops_pick/bloc/for_you/for_you_cubit.dart';

class HeartLinkApp extends StatelessWidget {
  const HeartLinkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CardActionCubit()),
        BlocProvider(create: (context) => DeletedAccountCubit()),
        BlocProvider(create: (context) => ForYouCubit()),
        BlocProvider(create: (context) => ExploreDetailPageCubit()),
        BlocProvider(create: (context) => VerifyCubit()),
        BlocProvider(create: (context) => HomeMainCubit()),
        BlocProvider(create: (context) => ChatConversationBloc()),
        BlocProvider(create: (context) => SendMessageCubit()),
        BlocProvider(create: (context) => MessagesCubit()),
        BlocProvider(create: (context) => RemoveChannelCubit()),
        BlocProvider(create: (context) => GetChannelIdCubit()),
        BlocProvider(create: (context) => LikesCubit()),
      ],
      child: const InitPage(),
    );
  }
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _InitPageState? state = context.findAncestorStateOfType<_InitPageState>();

    state?.setState(() {
      state._locale = newLocale;
    });
  }

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  late bool _hasNetworkconnection;
  late bool _fallbackViewOn;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Get.deviceLocale!;
    _hasNetworkconnection = false;
    _fallbackViewOn = false;
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.connectionChange.listen(_updateConnectivity);
    ThemeNotifier.themeModeRef.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
        navigatorKey: AppManager.globalKeyRootMaterial,
        popGesture: true,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: S.delegate.supportedLocales,
        // supportedLocales: const [Locale('en')],
        themeMode:
            ThemeUtils.isDarkModeSetting() ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeNotifier.lightTheme,
        darkTheme: ThemeNotifier.darkTheme,
        home: SplashPage(isDarkOn: ThemeUtils.isDarkModeSetting()),
        builder: EasyLoading.init(),
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            Intl.defaultLocale = supportedLocales.first.toLanguageTag();
            return supportedLocales.first;
          }
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              Intl.defaultLocale = supportedLocale.toLanguageTag();
              return supportedLocale;
            }
          }
          Intl.defaultLocale = supportedLocales.first.toLanguageTag();
          return supportedLocales.first;
        });
  }

  void _updateConnectivity(dynamic hasConnection) {
    if (!_hasNetworkconnection) {
      if (!_fallbackViewOn) {
        // navigatorKey.currentState.pushNamed(FallbackConnection.route);
        setState(() {
          _fallbackViewOn = true;
          _hasNetworkconnection = hasConnection;
        });
      }
    } else {
      if (_fallbackViewOn) {
        // navigatorKey.currentState.pop(context);
        setState(() {
          _fallbackViewOn = false;
          _hasNetworkconnection = hasConnection;
        });
      }
    }
  }

}
