import 'package:flutter/material.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/ui/dialogs/waiting_dialog.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/extensions/validation_helpers.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_text_input.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const String routeName = 'changePassword';
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var _oldPassword = '';
  String? _oldPasswordError;
  var _password = '';
  String? _passwordError;
  var _confirmPassword = '';
  String? _confirmPasswordError;

  Future<void> _updatePassword() async {
    FocusScope.of(context).unfocus();

    if (_password.isEmpty || _confirmPassword.isEmpty) {
      return;
    }

    if (_password != _confirmPassword) {
      setState(() {
        _confirmPasswordError = 'Password does not match';
      });
      return;
    }

    context.showProgressDialog(
      dialog: const WaitingDialog(status: 'Changing password...'),
    );

    try {
      final value = await Provider.of<UserProvider>(context, listen: false)
          .changePassword(
        oldPassword: _oldPassword,
        newPassword: _password,
        context: context,
      );

      if (value == 'something_went_wrong') {
        context.showSnack(message: 'Something went wrong');
      } else if (value == 'invalid_password') {
        context.showSnack(message: 'Check Current Password');
      } else {
        context.showSnack(message: 'Password Updated ');
      }
    } catch (e) {
      if (!mounted) return;
      context.showSnack(message: 'Something went wrong, $e');
    } finally {
      if (mounted) {
        Navigator.pop(context); // Close the progress dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: AppBar(
        leadingWidth: 32,
        title: const Text('Change Password'),
        backgroundColor: AppColors.colorWhite,
        shadowColor: AppColors.colorWhite,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: 12.allPadding,
              child: const Text(
                'Create new password to login\n'
                'Password must be at least 6 characters long',
              ),
            ),
            32.height,
            AppTextInput(
              hint: 'Current Password',
              floatHint: false,
              fieldHeight: 50,
              errorText: _oldPasswordError,
              isPasswordField: true,
              onUpdateInput: (value) {
                _oldPassword = value;
                setState(() {
                  _oldPasswordError = isPasswordValid(_oldPassword);
                });
                debugPrint('Email -> $_oldPassword');
              },
            ),
            12.height,
            AppTextInput(
              hint: 'Password',
              floatHint: false,
              fieldHeight: 50,
              errorText: _passwordError,
              isPasswordField: true,
              onUpdateInput: (value) {
                _password = value;
                setState(() {
                  _passwordError = isPasswordValid(_password);
                });
                debugPrint('Email -> $_password');
              },
            ),
            12.height,
            AppTextInput(
              hint: 'Confirm Password ',
              floatHint: false,
              isPasswordField: true,
              fieldHeight: 50,
              errorText: _confirmPasswordError,
              onUpdateInput: (value) {
                _confirmPassword = value;
                setState(() {
                  _confirmPasswordError =
                      isConfirmPasswordValid(_password, _confirmPassword);
                });
                debugPrint('Email -> $_confirmPassword');
              },
            ),
            36.height,
            AppFilledButton(
              onPress: _updatePassword,
              title: 'Update Password',
            ),
            30.height,
          ],
        ),
      ),
    );
  }
}
