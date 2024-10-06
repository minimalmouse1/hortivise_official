import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horti_vige/core/exceptions/app_exception.dart';
import 'package:horti_vige/generated/assets.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/ui/screens/auth/signup_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/extensions/validation_helpers.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_text_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = 'Login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _email = '';
  var _password = '';
  String? _emailError;
  String? _passwordError;

  late UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.colorBeige,
      body: Stack(
        children: [
          Positioned(
            left: -220,
            top: -90,
            bottom: -50,
            child: SvgPicture.asset(
              Assets.assetsImagesLeftLeafs,
              fit: BoxFit.fill,
              color: AppColors.appGreenMaterial.withAlpha(150),
            ),
          ),
          Positioned(
            right: -220,
            top: -90,
            bottom: -50,
            child: SvgPicture.asset(
              Assets.assetsImagesRightLeafs,
              fit: BoxFit.fill,
              color: AppColors.appGreenMaterial.withAlpha(150),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  150.height,
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: AppTextStyles.titleStyle
                            .changeColor(AppColors.colorGreen)
                            .changeSize(28),
                      ),
                    ),
                  ),
                  20.height,
                  AppTextInput(
                    hint: 'Email',
                    floatHint: false,
                    fieldHeight: 50,
                    errorText: _emailError,
                    onUpdateInput: (value) {
                      _email = value;
                      setState(() {
                        _emailError = isEmailValid(_email);
                      });
                      debugPrint('Email -> $_email');
                    },
                  ),
                  20.height,
                  AppTextInput(
                    hint: 'Password',
                    floatHint: false,
                    fieldHeight: 50,
                    isPassword: true,
                    errorText: _passwordError,
                    onUpdateInput: (value) {
                      _password = value;
                      setState(() {
                        _passwordError = isPasswordValid(_password);
                      });
                      debugPrint('Password -> $_password');
                    },
                  ),
                  5.height,
                  InkWell(
                    onTap: () {
                      print('forgot password');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password?',
                          style: AppTextStyles.buttonStyle
                              .changeColor(AppColors.colorGreen),
                        ),
                      ),
                    ),
                  ),
                  80.height,
                  Consumer<UserProvider>(
                    builder: (context, value, child) => AppFilledButton(
                      onPress: () async {
                        FocusScope.of(context).unfocus();
                        await loginUser();
                      },
                      title: 'Login',
                      showLoading: value.isLoading,
                    ),
                  ),
                  20.height,
                  const Text(
                    'Not Registered?',
                    style: AppTextStyles.hintStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.bodyStyle
                          .changeColor(AppColors.colorGreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginUser() async {
    final exp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (_email.isEmpty) {
      setState(() {
        _emailError = 'Please enter your registered email';
      });
    } else if (!exp.hasMatch(_email)) {
      setState(() {
        _emailError = 'Email is not in proper format, please check it again';
      });
    } else if (_password.isEmpty || _password.length < 6) {
      setState(() {
        _emailError = null;
        _passwordError = 'Password must be at-least 6 characters';
      });
    } else {
      setState(() {
        _emailError = null;
        _passwordError = null;
      });

      debugPrint('Data is ready for login');

      try {
        await _userProvider.loginUser(email: _email, password: _password);
      } on AppException catch (e) {
        e.logError();
        if (!mounted) return;
        context.showSnack(message: e.message);
      } catch (e) {
        e.logError();
      }
    }
  }
}
