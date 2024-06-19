class PackageIntroData {
  late String _icon;
  late double _iconH;
  late double _iconW;
  late String _title;
  late String _subTitle;

  PackageIntroData(String icon, double iconH, double iconW, String title, String subTitle) {
    _icon = icon;
    _iconH = iconH;
    _iconW = iconW;
    _title = title;
    _subTitle = subTitle;
  }

  get icon => _icon;

  set icon(value) => _icon = value;

  get iconH => _iconH;

  set iconH(value) => _iconH = value;

  get iconW => _iconW;

  set iconW(value) => _iconW = value;

  get title => _title;

  set title(value) => _title = value;

  get subTitle => _subTitle;

  set subTitle(value) => _subTitle = value;
}
