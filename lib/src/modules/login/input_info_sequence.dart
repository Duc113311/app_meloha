import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/modules/login/info/info_drinking_page.dart';
import 'package:dating_app/src/modules/login/info/info_drug_page.dart';
import 'package:dating_app/src/modules/login/info/info_education_page.dart';
import 'package:dating_app/src/modules/login/info/info_familyplan_page.dart';
import 'package:dating_app/src/modules/login/info/info_promts_page.dart';
import 'package:dating_app/src/modules/login/info/info_smoking_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../utils/pref_assist.dart';
import '../Login/info/info_sexual_page.dart';
import 'info/add_photo_page.dart';
import 'info/info_birth_page.dart';
import 'info/info_children_page.dart';
import 'info/info_ethnicity_page.dart';
import 'info/info_gender_page.dart';
import 'info/info_height_page.dart';
import 'info/info_interest_page.dart';
import 'info/info_name_page.dart';
import 'info/info_school_page.dart';
import 'info/info_work_page.dart';
import 'info/register_completed_page.dart';
import 'location/location_page.dart';
import 'verify/dating_rules_page.dart';

class InputInfoSequence extends StatefulWidget {
  const InputInfoSequence({Key? key}) : super(key: key);

  @override
  State<InputInfoSequence> createState() => _InputInfoSequenceState();

  static Future<int?> showExitConfirmDialog(BuildContext context) async {
    return await Utils.showMyActionsDialog(
        title: S.current.txt_quit_the_sign_up_title,
        content: S.current.alert_quit_signin,
        negativeAction: S.current.str_cancel,
        positiveAction: S.current.txtid_ok.toUpperCase());
  }
}

class _InputInfoSequenceState extends State<InputInfoSequence>
    with WidgetsBindingObserver {
  PageController pageController = PageController();

  final _GetxControllerInputProgress getxControllerInputProgress =
      _GetxControllerInputProgress();
  bool isActive = false;

  List<Widget> totalPages = [];

  @override
  void initState() {
    totalPages = [
      DatingRulesPage(pageController),
      InfoNamePage(pageController),
      InfoBirthPage(pageController),
      LocationPage(pageController),
      InfoGenderPage(pageController),
      InfoSexualPage(pageController),
      InfoHeightPage(pageController),
      InfoEthnicityPage(pageController),
      InfoChildrenPlanPage(pageController),
      InfoFamilyPlanPage(pageController),
      InfoWorkPage(pageController),
      InfoSchoolPage(pageController),
      InfoEducationPage(pageController),
      InfoDrinkingPage(pageController),
      InfoSmokingPage(pageController),
      InfoDrugPage(pageController),
      AddPhotoPage(pageController),
      InfoInterestPage(pageController),
      InfoPromptPage(pageController),
      RegisterCompletedPage(pageController),
    ];

    super.initState();

    pageController.addListener(() {
      double progressPercentage = (pageController.page! / totalPages.length);
      if (progressPercentage < 0) progressPercentage = 0.0;
      if (progressPercentage > 1) progressPercentage = 1.0;
      getxControllerInputProgress.changeProgress(progressPercentage);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = PrefAssist.getMyCustomer();
      int pageIndex = 0;

      if (user.getListPrompts.isNotEmpty) {
        pageIndex = 18;
      } else if (user.getListInterests.isNotEmpty) {
        pageIndex = 17;
      } else if (user.getListAvatarModels.isNotEmpty) {
        pageIndex = 16;
      } else if (user.getDrug.isNotEmpty) {
        pageIndex = 15;
      } else if (user.getSmoking.isNotEmpty) {
        pageIndex = 14;
      } else if (user.getDrinking.isNotEmpty) {
        pageIndex = 13;
      } else if (user.getEducation.isNotEmpty) {
        pageIndex = 12;
      } else if (user.getSchool.isNotEmpty) {
        pageIndex = 11;
      } else if (user.getCompany.isNotEmpty) {
        pageIndex = 10;
      } else if (user.getFamilyPlan.isNotEmpty) {
        pageIndex = 9;
      } else if (user.getChildrenPlan.isNotEmpty) {
        pageIndex = 8;
      } else if (user.getEthnicities.isNotEmpty) {
        pageIndex = 7;
      } else if (user.getHeight != -1) {
        pageIndex = 6;
      } else if (user.getListOrientationSexuals.isNotEmpty) {
        pageIndex = 5;
      } else if (user.getGender.isNotEmpty) {
        pageIndex = 4;
      } else if (user.location != null) {
        pageIndex = 3;
      } else if (user.dob != null) {
        pageIndex = 2;
      } else if (user.fullname.isNotEmpty) {
        pageIndex = 1;
      } else {
        pageIndex = 0;
      }

      if (pageIndex == 0) return;
      pageController.jumpToPage(pageIndex);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    getxControllerInputProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {},
      child: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: totalPages,
            ),
            Obx(() {
              final currentPage = pageController.page ?? 0;
              final endPage = (currentPage >= totalPages.length - 1 || currentPage == 0);
              return Column(
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: endPage ? Colors.transparent : AppColors.obxColor.withOpacity(0.39),
                          ),
                          width: Get.width,
                          height: ThemeDimen.paddingTiny,
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: endPage ? Colors.transparent :  AppColors.obxColor,
                          ),
                          width: Get.width *
                              getxControllerInputProgress.progress.value,
                          height: ThemeDimen.paddingTiny,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _GetxControllerInputProgress extends GetxController {
  var progress = 0.0.obs;

  changeProgress(double sp) {
    progress.value = sp;
  }
}
