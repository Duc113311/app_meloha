
extension StringExt on String {

  String get removeLines {
    return replaceAll(RegExp('\n+'), "\n");
  }

  String get removeQuery {
    return split("?").firstOrNull ?? this;
  }

  String get toCapitalized {
    if(length == 0) {return this;}
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  double get parseDouble {
    return double.parse(this);
  }
}