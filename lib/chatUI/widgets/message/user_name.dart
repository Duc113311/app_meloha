import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/material.dart';

import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Renders user's name as a message heading according to the theme.
class UserName extends StatelessWidget {
  /// Creates user name.
  const UserName({
    super.key,
    required this.author,
  });

  /// Author to show name from.
  final CustomerDto author;

  @override
  Widget build(BuildContext context) {
    final theme = InheritedChatTheme.of(context).theme;
    final color = getUserAvatarNameColor(author.id, theme.userAvatarNameColors);
    final name = getUserName(author);

    return name.isEmpty || author.id == PrefAssist.getMyCustomer().id
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.userNameTextStyle.copyWith(color: color),
            ),
          );
  }
}