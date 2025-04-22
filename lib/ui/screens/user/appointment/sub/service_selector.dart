import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/package/package_model.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_option_radios.dart';

class ServiceSelector extends StatefulWidget {
  const ServiceSelector({
    super.key,
    required this.packages,
    required this.onPackageSelect,
  });
  final List<PackageModel> packages;
  final Function(PackageModel selectedPackage) onPackageSelect;

  @override
  State<ServiceSelector> createState() => _ServiceSelectorState();
}

class _ServiceSelectorState extends State<ServiceSelector> {
  var _textSelection = -1;
  var _videoSelection = -1;

  var _textPlans = <PackageModel>[];
  var _videoPlans = <PackageModel>[];

  @override
  void initState() {
    _textPlans = widget.packages
        .where((element) => element.type == PackageType.text)
        .toList();
    _videoPlans = widget.packages
        .where((element) => element.type == PackageType.video)
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    _textPlans.clear();
    _videoPlans.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 12.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          7.height,
          Text(
            'Text',
            style: AppTextStyles.bodyStyleMedium
                .changeSize(14)
                .changeFontWeight(FontWeight.w600),
          ),
          4.height,
          AppOptionRadios(
            selection: _textSelection,
            radioOptions: _textPlans,
            onValueSelect: (key, index) {
              setState(() {
                _videoSelection = -1;
                _textSelection = index;
              });
              //  print("Selected radio is $key");
              widget.onPackageSelect(key);
            },
          ),
          7.height,
          Text(
            'Video',
            style: AppTextStyles.bodyStyleMedium
                .changeSize(14)
                .changeFontWeight(FontWeight.w600),
          ),
          4.height,
          AppOptionRadios(
            selection: _videoSelection,
            radioOptions: _videoPlans,
            onValueSelect: (key, index) {
              setState(() {
                _textSelection = -1;
                _videoSelection = index;
              });
              // print("Selected radio is $key");
              widget.onPackageSelect(key);
            },
          ),
        ],
      ),
    );
  }
}
