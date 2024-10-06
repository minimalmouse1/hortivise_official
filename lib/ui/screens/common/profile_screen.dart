import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:horti_vige/data/enums/user_type.dart';
import 'package:horti_vige/ui/screens/consultant/consultation_pricing/consultation_pricing_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/generated/assets.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/ui/dialogs/pick_image_dialog.dart';
import 'package:horti_vige/ui/dialogs/waiting_dialog.dart';
import 'package:horti_vige/ui/screens/auth/change_password_screen.dart';
import 'package:horti_vige/ui/screens/consultant/edit_availability_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_nav_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routeName = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;

  UserModel getCurrentUser() {
    return Provider.of<UserProvider>(context, listen: false).getCurrentUser()!;
  }

  void _updateProfile() async {
    FocusScope.of(context).unfocus();

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      return;
    }

    context.showProgressDialog(
      dialog: const WaitingDialog(status: 'Saving...'),
    );
    final user = getCurrentUser().copyWith(
      userName: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    await Provider.of<UserProvider>(context, listen: false)
        .updateUser(model: user);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, ZoomDrawerScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: getCurrentUser().userName);
    _emailController = TextEditingController(text: getCurrentUser().email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = getCurrentUser();
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20,
                          left: 20,
                          right: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            20.height,
                            CircleAvatar(
                              radius: 37,
                              backgroundColor: AppColors.colorGreen,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    currentUser.profileUrl.startsWith('http')
                                        ? NetworkImage(currentUser.profileUrl)
                                        : null,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                                        radius: 11,
                                        backgroundColor: AppColors.colorGreen,
                                        child: GestureDetector(
                                          onTap: () {
                                            context.showBottomSheet(
                                              bottomSheet: PickImageDialog(
                                                onGalleryClick: () {
                                                  _pickImageFromGallery();
                                                },
                                                onCameraClick: () {
                                                  _pickImageFromCamera();
                                                },
                                              ),
                                              dismissible: true,
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            Assets.pencilEditIcon,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            4.height,
                            Column(
                              children: [
                                Text(
                                  currentUser.userName,
                                  style: AppTextStyles.bodyStyle
                                      .changeColor(AppColors.appGreenMaterial)
                                      .changeSize(20)
                                      .changeFontWeight(FontWeight.bold),
                                ),
                                Text(
                                  'Hortivise ${currentUser.type.name.toLowerCase().capitalizeFirstLetter()}',
                                  style: AppTextStyles.bodyStyle
                                      .changeColor(AppColors.colorGray)
                                      .changeSize(10),
                                ),
                              ],
                            ),
                            45.height,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Name',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.inputBorderColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            25.height,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Name',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.inputBorderColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            12.height,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ChangePasswordScreen.routeName,
                                  );
                                },
                                child: const Text(
                                  'Change Password',
                                  style: AppTextStyles.bodyStyleMedium,
                                ),
                              ),
                            ),
                            16.height,
                          ],
                        ),
                      ),
                      20.height,
                      // TODO: Notifications
                      // ListTile(
                      //   title: Text(
                      //     'Notifications',
                      //     style: AppTextStyles.titleStyle
                      //         .changeSize(16)
                      //         .changeFontWeight(FontWeight.bold),
                      //   ),
                      //   trailing: Switch(value: true, onChanged: (b) {}),
                      // ),
                      if (currentUser.type != UserType.CUSTOMER)
                        Column(
                          children: [
                            // TODO: Vacation Mode
                            // ListTile(
                            //   title: Text(
                            //     'Vacation Mode',
                            //     style: AppTextStyles.titleStyle
                            //         .changeSize(16)
                            //         .changeFontWeight(FontWeight.bold),
                            //   ),
                            //   trailing: Switch(value: false, onChanged: (b) {}),
                            // ),
                            buildCustomButton(
                              context,
                              'Availability Settings',
                              () {
                                Navigator.pushNamed(
                                  context,
                                  EditAvailabilityScreen.routeName,
                                );
                              },
                            ),
                            16.height,
                            buildCustomButton(
                              context,
                              'Consultation Pricing',
                              () {
                                Navigator.pushNamed(
                                  context,
                                  ConsultationPricingScreen.routeName,
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              20.height,
              AppFilledButton(
                onPress: _updateProfile,
                title: 'Save Changes',
              ),
              30.height,
            ],
          ),
          Positioned(
            left: 8,
            top: 30,
            child: RawMaterialButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  ZoomDrawerScreen.routeName,
                );
              },
              elevation: 1,
              constraints: const BoxConstraints(
                minWidth: 26,
                minHeight: 26,
                maxWidth: 26,
                maxHeight: 26,
              ),
              fillColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickImageFromCamera() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      updateProfilePhoto(photo?.path ?? '');
    });
  }

  void _pickImageFromGallery() async {
    final photo = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      updateProfilePhoto(photo?.path ?? '');
    });
  }

  void updateProfilePhoto(String profileUrl) {
    context.showProgressDialog(
      dialog: const WaitingDialog(status: 'updating profile'),
    );
    Provider.of<UserProvider>(context, listen: false)
        .updateProfilePhoto(profileUri: profileUrl)
        .then((value) {
      Navigator.pop(context);
      context.showSnack(message: 'Profile photo updated successfully');
    }).catchError((e) {
      Navigator.pop(context);
      context.showSnack(
        message:
            'Something went wrong while updating profile, please try again!',
      );
    });
  }

  Widget buildCustomButton(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.colorGreen, // Border color as in the image
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color:
                      AppColors.colorGreen, // Text color similar to the image
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.colorGreen, // Icon color matching the text
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
