import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class PickImageDialog extends StatelessWidget {
  const PickImageDialog({
    super.key,
    required this.onGalleryClick,
    required this.onCameraClick,
  });
  final Function() onGalleryClick;
  final Function() onCameraClick;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.colorBeige,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Wrap(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 70,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.colorGreen,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'Pick Image from',
                style: AppTextStyles.bodyStyleMedium
                    .changeSize(16)
                    .changeColor(AppColors.appGreenMaterial),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.colorGrayLight.withAlpha(150),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  onCameraClick();
                },
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.appGreenMaterial,
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.colorWhite,
                    size: 18,
                  ),
                ),
                title: const Text('Camera'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.colorGrayLight.withAlpha(150),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  onGalleryClick();
                },
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.colorGreen,
                  child: Icon(
                    Icons.image_rounded,
                    color: AppColors.colorWhite,
                    size: 18,
                  ),
                ),
                title: const Text('Gallery'),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
            width: 30,
          ),
        ],
      ),
    );
  }
}
