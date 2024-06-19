import 'package:dating_app/src/utils/theme_const.dart';
import 'package:flutter/material.dart';

import '../../../general/constants/app_constants.dart';

class AlertBannerItem extends StatelessWidget {
  final String title ;
  final String message;
  final String? imageName;
  final String? imageURL;

   const AlertBannerItem(
      {super.key,
       this.title = '',
       this.message = '',
      this.imageURL,
      this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      constraints:
          BoxConstraints(maxWidth: AppConstants.width),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(ThemeDimen.borderRadiusTiny),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipOval(
                    child: SizedBox.fromSize(
                        size: const Size.fromRadius(30), child: icon())),
              ),
              const SizedBox(
                width: 15,
              ),
               Expanded(
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.blueAccent, fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ],
              ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  Widget icon() => imageName != null
      ? Image.asset(
          imageName!,
          fit: BoxFit.fill,
          width: 40,
          height: 40,
        )
      : Image.network(
          imageURL ?? '',
          fit: BoxFit.fill,
          width: 40,
          height: 40,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        );
}
