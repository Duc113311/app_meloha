import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../domain/dtos/customers/customers_dto.dart';
import '../../../requests/api_update_customer_info.dart';
import '../../../utils/permission_dialog.dart';

class LocationPage extends StatefulWidget {
  final PageController pageController;

  const LocationPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isDeniedLocation = false;

  @override
  void initState() {
    super.initState();
    getLocationStatus();
  }

  Future<bool> getLocationStatus() async {
    if (await Permission.location.status.isDenied &&
        await Geolocator.isLocationServiceEnabled()) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => widget.pageController.previousPage(
                duration:
                    const Duration(milliseconds: ThemeDimen.animMillisDuration),
                curve: Curves.easeIn),
            icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                ? Brightness.light
                : Brightness.dark,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: ThemeDimen.paddingSuper),
              isDeniedLocation
                  ? SvgPicture.asset(
                      AppImages.icArtLocationDisable,
                      height: 96.toWidthRatio(),
                      width: 96.toWidthRatio(),
                      allowDrawingOutsideViewBox: true,
                      colorFilter: ColorFilter.mode(
                          ThemeUtils.getTextColor(), BlendMode.srcIn),
                    )
                  : SvgPicture.asset(
                      AppImages.icArtLocation,
                      height: 96.toWidthRatio(),
                      width: 96.toWidthRatio(),
                      allowDrawingOutsideViewBox: true,
                      colorFilter: ColorFilter.mode(
                          ThemeUtils.getTextColor(), BlendMode.srcIn),
                    ),
              SizedBox(height: ThemeDimen.paddingSuper),
              Center(
                child: Text(
                  S.current.enable_location,
                  style: ThemeUtils.getTitleStyle(),
                ),
              ),
              SizedBox(height: ThemeDimen.paddingBig),
              Text(
                S.current.your_location_need_allow_enabled,
                style: ThemeUtils.getCaptionStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 96.toWidthRatio()),
            ],
          ),
        ),
        bottomNavigationBar: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingSmall,
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingLarge),
              child: WidgetGenerator.bottomButton(
                selected: true,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onRequestEnableLocation,
                child: Center(
                  child: Text(
                    S.current.allow_location,
                    style: ThemeUtils.getButtonStyle(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onRequestEnableLocation() async {
    if ((await Permission.location.status.isGranted ||
            await Permission.locationWhenInUse.status.isGranted ||
            await Permission.locationAlways.status.isGranted) &&
        await Geolocator.isLocationServiceEnabled()) {
      getLocationThenNextPage();
    } else {
      if (await Permission.location.request().isGranted &&
          await Geolocator.isLocationServiceEnabled()) {
        getLocationThenNextPage();
      } else {
        showErrorDialog();
      }
    }
  }

  Future<void> showErrorDialog() async {
    setState(() {
      isDeniedLocation = true;
    });
    int? result = await PermissionDialog.showDialog(
        AppManager.globalKeyRootMaterial.currentContext!,
        PermissionDialog.ACCESS_LOCATION_PERMISSION,
        true);
    if (result == Utils.kDialogPositiveValue) {
      openAppSettings();
    }
    return Future.error('Location Service are disabled');
  }

  Future<void> getLocationThenNextPage() async {
    setState(() {
      isDeniedLocation = false;
    });
    Utils.showLoading();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    debugPrint(
        "LOCATION LAT : ${position.latitude}  LON : ${position.longitude}");

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final address = getAddress(placemarks);
    print("address: $address");
    PrefAssist.getMyCustomer().profiles?.address = address;

    PrefAssist.getMyCustomer().location = LocationDto(
        lat: position.latitude.toString(), long: position.longitude.toString());
    await PrefAssist.saveMyCustomer();

    if (PrefAssist.getAccessToken().isNotEmpty) {
      int codeSuccess = await ApiUpdateCustomerInfo.updateMyCustomerGPS(
          position.latitude, position.longitude);
      if (codeSuccess == 200) {
        debugPrint("update location success");
      } else {
        debugPrint("update location false");
      }
    }

    Utils.hideLoading();
    widget.pageController.nextPage(
        duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
        curve: Curves.easeIn);
  }

  String getAddress(List<Placemark> placemarks) {
    final placemark = placemarks.firstOrNull;
    if (placemark == null) {
      return "";
    }

    String address = placemark.street ?? "";

    final name = placemark.name ?? "";
    if (name.trim().isNotEmpty) {
      address += ", $name";
    }

    final locality = placemark.locality ?? placemark.subLocality ?? "";
    if (locality.trim().isNotEmpty) {
      address += ", $locality";
    } else {
      Placemark? subPlace = placemarks.firstWhereOrNull((element) =>
          (element.locality ?? "").trim().isNotEmpty ||
          (element.subLocality ?? "").trim().isNotEmpty);
      String subLocality = (subPlace?.locality ?? "").trim().isNotEmpty
          ? (subPlace?.locality ?? "").trim()
          : (subPlace?.subLocality ?? "").trim();

      if (subLocality.trim().isNotEmpty) {
        address += ", $subLocality";
      }
    }

    final subAdministrativeArea = placemark.subAdministrativeArea ?? "";
    if (subAdministrativeArea.trim().isNotEmpty) {
      address += ", $subAdministrativeArea";
    }

    final administrativeArea = placemark.administrativeArea ?? "";
    if (administrativeArea.trim().isNotEmpty) {
      address += ", $administrativeArea";
    }

    final country = placemark.country ?? "";
    if (country.trim().isNotEmpty) {
      address += ", $country";
    }

    return address;
  }
}
