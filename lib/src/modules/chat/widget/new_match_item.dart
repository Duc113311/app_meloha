import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../domain/dtos/customers/customers_dto.dart';
import '../../../general/constants/app_constants.dart';

class NewMatchItem extends StatefulWidget {
  CustomerDto customer;
  void Function(CustomerDto) onItemTap;

  NewMatchItem({super.key, required this.customer, required this.onItemTap});

  @override
  State<NewMatchItem> createState() =>
      _NewMatchItemState(customer: customer, onItemTap: onItemTap);
}

class _NewMatchItemState extends State<NewMatchItem> {
  _NewMatchItemState({required this.customer, required this.onItemTap});

  CustomerDto customer;
  void Function(CustomerDto) onItemTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.newMatchWidth + 16,
      child: GestureDetector(
        onTap: () => onItemTap(customer),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: AppConstants.newMatchWidth * 1.2,
                height: AppConstants.newMatchWidth * 1.2,
                color: Colors.transparent,
                child: Center(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppConstants.newMatchWidth / 2),
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(AppConstants.newMatchWidth / 2),
                      child: customer.getAvatarUrl.isNotEmpty
                      ? CacheImageView(
                        imageURL: customer.getAvatarUrl, fit: BoxFit.cover,
                      )
                      : Container(color: AppColors.color323232,),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              customer.fullname ?? "",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeUtils.getTextColor().withOpacity(0.79), fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}
