import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
import 'package:horti_vige/providers/consultations_provider.dart';
import 'package:horti_vige/ui/dialogs/waiting_dialog.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_outlined_button.dart';
import 'package:horti_vige/ui/widgets/app_simple_option_radios.dart';
import 'package:horti_vige/ui/widgets/app_text_input.dart';
import 'package:provider/provider.dart';

class CancelFeedbackBottomDialog extends StatelessWidget {
  const CancelFeedbackBottomDialog({
    super.key,
    required this.consultation,
    required this.onCancel,
  });
  final ConsultationModel consultation;
  final Function(ConsultationModel consultationModel) onCancel;

  @override
  Widget build(BuildContext context) {
    var comment = '';
    const radioOptions = [
      'Its overpriced',
      "I don't want to work with this person",
      'I no longer need consultation',
      'Other',
    ];
    var selectedReason = radioOptions[0];
    return Container(
      width: double.infinity,
      padding: 12.allPadding,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: AppColors.colorWhite,
      ),
      child: Wrap(
        children: [
          Column(
            children: [
              10.height,
              const Text(
                'We hate to see you going',
                style: AppTextStyles.titleStyle,
              ),
              const Text(
                'Please tell us what went wrong',
                style: AppTextStyles.titleStyle,
              ),
              20.height,
              AppSimpleOptionRadios(
                radioOptions: radioOptions,
                onValueSelect: (selection, index) {
                  selectedReason = selection;
                },
              ),
              6.height,
              AppTextInput(
                hint: 'Type your comment here',
                floatHint: false,
                onUpdateInput: (c) {
                  comment = c;
                },
                filledColor: AppColors.colorGrayBg,
                minLines: 4,
              ),
              25.height,
              AppFilledButton(
                onPress: () {
                  //Navigator.pop(context);
                  if (comment.isEmpty && selectedReason == 'Other') {
                    context.showSnack(
                      message: 'Please write some comment to proceed.',
                    );
                  } else {
                    submitCancelRequest(consultation, context);
                  }
                },
                title: 'Confirm',
                color: AppColors.colorRed,
              ),
              15.height,
              AppOutlinedButton(
                onPress: () {
                  Navigator.pop(context);
                },
                title: 'Go Back',
                btnColor: AppColors.appGrayMaterial,
              ),
              20.height,
            ],
          ),
        ],
      ),
    );
  }

  void submitCancelRequest(
    ConsultationModel consultation,
    BuildContext context,
  ) {
    context.showProgressDialog(
      dialog: const WaitingDialog(status: 'Canceling Consultation'),
    );
    Provider.of<ConsultationProvider>(context, listen: false)
        .cancelConsultation(consultation: consultation)
        .then((value) {
      Navigator.pop(context);
      context.showSnack(message: value);
      consultation.status = ConsultationStatus.canceled;
      onCancel(consultation);
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
      context.showSnack(message: 'Something went wrong, $error');
    });
  }
}
