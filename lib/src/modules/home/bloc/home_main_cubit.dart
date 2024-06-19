import 'package:bloc/bloc.dart';
import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/services/connect/connectivity_service.dart';
import 'package:dating_app/src/requests/api_update_customer_info.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/location_manager.dart';
import 'package:dating_app/src/utils/permission_dialog.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../domain/repositories/home_main/home_main_repo.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../../utils/pref_assist.dart';

part 'home_main_state.dart';

class HomeMainCubit extends Cubit<HomeMainState> {
  HomeMainCubit() : super(HomeMainInitial());

  HomeMainRepo homeMainRepo = getIt<HomeMainRepo>();

  //
  List<CustomerDto> cardCustomer = [];

  bool isGoSetting = false;

  Future<void> checkLocation() async {
    emit(HomeMainLoading());
    onRequestEnableLocation();
  }

  Future<void> onRequestEnableLocation() async {

    if (await Permission.location.request().isGranted || PrefAssist.getMyCustomer().location != null) {
      // Either the permission was already granted before or the user just granted it.
      getCards();
    } else {

      if (await Permission.location.isPermanentlyDenied ||
          await Permission.location.shouldShowRequestRationale) {
        int? result = await PermissionDialog.showDialog(
            AppManager.globalKeyRootMaterial.currentContext!,
            PermissionDialog.ACCESS_LOCATION_PERMISSION,
            false);
        if (result == Utils.kDialogPositiveValue) {
          openAppSettings();
        }
        return emit(HomeMainNotLocation());
      }
      //isGoSetting = true;
      // if (await Permission.location.isDenied &&
      //     await Permission.locationWhenInUse.isDenied &&
      //     await Permission.locationAlways.isDenied) {
      //   print(await Permission.location.isPermanentlyDenied);
      //   print(await Permission.location.shouldShowRequestRationale);
      //   if (await Permission.location.isPermanentlyDenied ||
      //       await Permission.location.shouldShowRequestRationale) {
      //     int? result = await PermissionDialog.showDialog(
      //         AppManager.globalKeyRootMaterial.currentContext!,
      //         PermissionDialog.ACCESS_LOCATION_PERMISSION,
      //         false);
      //     if (result == Utils.kDialogPositiveValue) {
      //       openAppSettings();
      //     } else {
      //       return emit(HomeMainNotLocation());
      //     }
      //     // return Future.error('Location permission are denied');
      //   } else {
      //     int? result = await PermissionDialog.showDialog(
      //         AppManager.globalKeyRootMaterial.currentContext!,
      //         PermissionDialog.ACCESS_LOCATION_PERMISSION,
      //         true);
      //     if (result == Utils.kDialogPositiveValue) {
      //       openAppSettings();
      //     } else {
      //       return emit(HomeMainNotLocation());
      //     }
      //     // return Future.error('Location permission are permanently denied, we can not request permission');
      //   }
      // }
    }

    final position = await LocationManager.shared().getCurrentLocation();
    if (position != null) {
      int codeSuccess = await ApiUpdateCustomerInfo.updateMyCustomerGPS(
          position.lat!.parseDouble, position.long!.parseDouble);
      if (codeSuccess == 200) {
      } else {
        Utils.toast('Đã có lỗi xảy ra');
      }
    }

    // if (!await Geolocator.isLocationServiceEnabled() && isGoSetting == false) {
    //   int? callback = await Utils.showMyActionsDialog(
    //     title: S.current.new_txtid_gps_not_enabled,
    //     content: '${S.current.new_txtid_gps_not_enabled_content}\n${S.current.new_txtid_you_can_change_anytime}',
    //     negativeAction: S.current.str_cancel,
    //     positiveAction: S.current.txtid_allow,
    //   );
    //   if (callback == Utils.kDialogPositiveValue) {
    //     await openAppSettings();
    //   }else{
    //     return emit(HomeMainNotLocation());
    //   }
    //   return Future.error('Location Service are disabled');
    // }
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //
    // int codeSuccess  = await ApiUpdateCustomerInfo.updateMyCustomerGPS(position.latitude, position.longitude);
    // if(codeSuccess == 200) {
    // }else{
    //   Utils.toast('Đã có lỗi xảy ra');
    // }
  }

  Future<void> getCards({int? checkData}) async {
    //check network
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return;
    }
    homeMainRepo.getCards().then(
          (value) => value.fold(
            (left) {
              return null;
            },
            (right) {
              if (right.data.isEmpty) {
                return emit(HomeMainNotData());
              }
              Future.delayed(const Duration(milliseconds: 600), () {
                emit(HomeMainSuccess(customDto: right.data));
              });
            },
          ),
        );
  }

  Future<void> card({int? checkData}) async {
    Future.delayed(const Duration(milliseconds: 1600), () {});
    emit(HomeMainLoading());
    //check network
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
    }
    homeMainRepo.getCards().then(
          (value) => value.fold(
            (left) {
              return null;
            },
            (right) {
              if (right.data.isEmpty) {
                return emit(HomeMainNotData());
              }
              Future.delayed(const Duration(milliseconds: 600), () {
                emit(HomeMainBuildSuccess(customDto: right.data));
              });
            },
          ),
        );
  }

  Future<void> addCard({int? checkData}) async {
    //check network
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
    }
    homeMainRepo.getCards().then(
          (value) => value.fold(
            (left) {
              return null;
            },
            (right) {
              if (right.data.isEmpty) {
                return;
              }
              Future.delayed(const Duration(milliseconds: 600), () {
                emit(HomeMainAddDataSuccess(customDto: right.data));
              });
            },
          ),
        );
  }
}
