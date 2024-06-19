import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:flutter/widgets.dart';


/// Used to make provided [User] class available through the whole package.
class InheritedUser extends InheritedWidget {
  /// Creates [InheritedWidget] from a provided [User] class.
  const InheritedUser({
    super.key,
    required this.user,
    required super.child,
  });

  static InheritedUser of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedUser>()!;

  /// Represents current logged in user. Used to determine message's author.
  final CustomerDto user;

  @override
  bool updateShouldNotify(InheritedUser oldWidget) =>
      user.id != oldWidget.user.id;
}
