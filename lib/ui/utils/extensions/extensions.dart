import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:horti_vige/ui/dialogs/waiting_dialog.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

extension Logger on Object? {
  void log() {
    if (this == null) {
      dev.log('HORTIVISE: null');
      return;
    }
    dev.log('HORTIVISE: $this');
  }

  void logError() {
    if (this == null) {
      dev.log('HORTIVISE: null');
      return;
    }
    dev.log('HORTIVISE ERROR: $this');
  }
}

extension CapitalizeFirstLetterExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

extension EmptySpace on num {
  SizedBox get height => SizedBox(
        height: toDouble(),
      );

  SizedBox get width => SizedBox(
        width: toDouble(),
      );
}

extension AppPadding on num {
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get allPadding => EdgeInsets.all(toDouble());
}

extension DivideSpace on num {
  Divider get heightDivide => Divider(
        height: toDouble(),
      );
}

extension MediaSizes on BuildContext {
  double get safeHeight =>
      MediaQuery.sizeOf(this).height -
      MediaQuery.of(this).padding.top -
      MediaQuery.of(this).padding.bottom;
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  double get safeHeightWithAppBar =>
      MediaQuery.sizeOf(this).height -
      AppBar().preferredSize.height -
      MediaQuery.of(this).padding.top -
      MediaQuery.of(this).padding.bottom;
}

extension DialogExtension on BuildContext {
  void showProgressDialog({required WaitingDialog dialog}) {
    showDialog(
      context: this,
      builder: (context) {
        return WillPopScope(child: dialog, onWillPop: () async => false);
      },
    );
  }

  void showSnack({
    required String message,
    String? actionText,
    Function()? onAction,
    Color? actionTextColor,
  }) {
    if (mounted) {
      ScaffoldMessenger.of(this).clearSnackBars();
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.colorBlack,
          content: Text(
            message,
            style:
                AppTextStyles.bodyStyleMedium.changeColor(AppColors.colorWhite),
          ),
          action: actionText != null
              ? SnackBarAction(
                  textColor: actionTextColor ?? AppColors.colorGreen,
                  label: actionText,
                  onPressed: onAction!,
                )
              : SnackBarAction(
                  textColor: AppColors.colorGreen,
                  label: 'Close',
                  onPressed: () {
                    try {
                      ScaffoldMessenger.of(this).hideCurrentSnackBar();
                    } catch (e) {
                      e.logError();
                    }
                  },
                ),
        ),
      );
    }
  }

  void showBottomSheet({
    required Widget bottomSheet,
    bool dismissible = false,
  }) {
    showModalBottomSheet(
      context: this,
      builder: (context) => bottomSheet,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: dismissible,
    );
  }
}
