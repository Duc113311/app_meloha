


enum AppLocaleEnum {
  JP('ja'),
  VN('vi'),
  EN('en'),
  AR('ar');

  const AppLocaleEnum(this.languageCode);
  final String languageCode;

  static getLocaleString(String currentLocale) {
    switch (currentLocale) {
      case 'ja':
        return AppLocaleEnum.JP.languageCode;
      case 'vi':
        return AppLocaleEnum.VN.languageCode;
      case 'en':
        return AppLocaleEnum.EN.languageCode;
      case 'ar':
        return AppLocaleEnum.AR.languageCode;
     default:    AppLocaleEnum.AR.languageCode;
    }
  }

  // String getLanguageName() {
  //   switch (this) {
  //     case AppLocaleEnum.JP:
  //       return '日本語';
  //     case AppLocaleEnum.VN:
  //       return 'Tiếng Việt';
  //     case AppLocaleEnum.EN:
  //       return 'English';
  //   }
  // }
}
