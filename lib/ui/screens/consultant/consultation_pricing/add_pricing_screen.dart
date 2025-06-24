import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horti_vige/data/models/consultation_pricing/consultation_pricing.dart';
import 'package:horti_vige/data/models/consultation_pricing/text_pricing_model.dart';
import 'package:horti_vige/data/models/consultation_pricing/video_pricing_model.dart';
import 'package:horti_vige/providers/consultation_pricing_provider.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/api.dart';

class AddPricingScreen extends StatefulWidget {
  const AddPricingScreen({super.key});

  static const String routeName = 'add_pricing';

  @override
  State<AddPricingScreen> createState() => _AddPricingScreenState();
}

class _AddPricingScreenState extends State<AddPricingScreen>
    with TickerProviderStateMixin {
  final double maxSlide = 100; // Slide width to show delete button

  late TabController _tabController;

  // TEXT PRICING
  int textPackagesCount = 0;
  final List<int> _onOfTextOptions = [15, 30, 50];
  final List<TextEditingController> _noOfTextPriceControllers = [];
  List<bool> isDeletingTexts = [false, false, false]; // Track deletion state
  List<bool> enabledTexts = [false, false, false];

  // VIDEO PRICING
  int videoPackagesCount = 0;
  final List<int> _videoPricingOptions = [30, 1, 2];
  final List<TextEditingController> _videoPricingControllers = [];
  List<bool> isDeletingVideoPricing = [false, false, false];
  List<bool> enabledVideos = [false, false, false];
  final List<VideoDurationEnum> _videoDurations = [
    VideoDurationEnum.minute,
    VideoDurationEnum.hour,
    VideoDurationEnum.hour,
  ];

  // This method adjusts the value based on the button presses
  void _adjustCount(
    int index,
    int change, [
    bool isVideoPricing = false,
  ]) {
    if (isVideoPricing) {
      setState(() {
        _videoPricingOptions[index] += change;
        if (_videoPricingOptions[index] < 1) {
          _videoPricingOptions[index] = 1; // Minimum texts
        }
      });
    } else {
      setState(() {
        _onOfTextOptions[index] += change;
        if (_onOfTextOptions[index] < 1) {
          _onOfTextOptions[index] = 1; // Minimum texts
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _populateValues();
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _noOfTextPriceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        titleSpacing: 0,
        title: const Text(
          'Add New',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.colorGreen,
              labelColor: AppColors.colorGreen,
              unselectedLabelColor: Colors.black26,
              tabs: const [
                Tab(
                  text: 'Text',
                ),
                Tab(
                  text: 'Video Call',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              20.height,
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: context.height * 0.05,
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'No. of texts',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.6,
                                child: ListView.builder(
                                  itemCount: textPackagesCount == 0
                                      ? _onOfTextOptions.length
                                      : textPackagesCount,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          transform: isDeletingTexts[index]
                                              ? Matrix4.translationValues(
                                                  -maxSlide,
                                                  0,
                                                  0,
                                                )
                                              : Matrix4.translationValues(
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Radio + Stepper controls for number of texts
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: enabledTexts[index],
                                                    activeColor:
                                                        AppColors.colorGreen,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        enabledTexts[index] =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        border: Border.all(
                                                          color: AppColors
                                                              .colorGreen,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: AppColors
                                                            .colorGreen,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        _adjustCount(index, -1),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      '${_onOfTextOptions[index]}',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        border: Border.all(
                                                          color: AppColors
                                                              .colorGreen,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: AppColors
                                                            .colorGreen,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        _adjustCount(index, 1),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 80,
                                                height: 40,
                                                child: CustomTextField(
                                                  controller:
                                                      _noOfTextPriceControllers[
                                                          index],
                                                  hintText: 'Price',
                                                  prefixText: '',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.height,
                      Consumer<ConsultationPricingProvider>(
                        builder: (context, ref, child) {
                          return AppFilledButton(
                            title: 'Save Changes',
                            isEnabled: enabledTexts.any((e) => e == true),
                            showLoading: ref.isLoading,
                            onPress: () {
                              if (ref.isLoading) return;
                              _saveValues();
                            },
                          );
                        },
                      ),
                      40.height,
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              20.height,
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: context.height * 0.05,
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Call Duration',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.6,
                                child: ListView.builder(
                                  itemCount: videoPackagesCount == 0
                                      ? _videoPricingOptions.length
                                      : videoPackagesCount,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Stack(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            transform:
                                                isDeletingVideoPricing[index]
                                                    ? Matrix4.translationValues(
                                                        -maxSlide,
                                                        0,
                                                        0,
                                                      )
                                                    : Matrix4.translationValues(
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      activeColor:
                                                          AppColors.colorGreen,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      value:
                                                          enabledVideos[index],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          enabledVideos[index] =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                            color: AppColors
                                                                .colorGreen,
                                                          ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.remove,
                                                          color: AppColors
                                                              .colorGreen,
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          _adjustCount(
                                                        index,
                                                        -1,
                                                        true,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '${_videoPricingOptions[index]}',
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                            color: AppColors
                                                                .colorGreen,
                                                          ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: AppColors
                                                              .colorGreen,
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          _adjustCount(
                                                        index,
                                                        1,
                                                        true,
                                                      ),
                                                    ),
                                                    DurationDropDown(
                                                      duration: _videoDurations[
                                                          index],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _videoDurations[
                                                              index] = value;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  height: 40,
                                                  child: CustomTextField(
                                                    controller:
                                                        _videoPricingControllers[
                                                            index],
                                                    hintText: 'Price',
                                                    prefixText: '',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.height,
                      Consumer<ConsultationPricingProvider>(
                        builder: (context, ref, child) {
                          return AppFilledButton(
                            title: 'Save Changes',
                            isEnabled: enabledVideos.any((e) => e == true),
                            showLoading: ref.isLoading,
                            onPress: () {
                              if (ref.isLoading) return;
                              _saveValues();
                            },
                          );
                        },
                      ),
                      40.height,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _populateValues() {
    final provider =
        Provider.of<ConsultationPricingProvider>(context, listen: false);

    final model = provider.consultationPricingModel;
    if (model != null) {
      _populateTextValues(model);
      _populateVideoValues(model);
    }
  }

  void _populateTextValues(
    ConsultationPricingModel model,
  ) {
    final textPackages = model.textPackages;
    final defaultTextPricingList = [r'$20.00', r'$37.00', r'$45.00'];

    if (textPackages.isEmpty) {
      for (var i = 0; i < defaultTextPricingList.length; i++) {
        _noOfTextPriceControllers.add(
          TextEditingController(
            text: defaultTextPricingList[i],
          ),
        );
      }
      return;
    }

    textPackagesCount = textPackages.length;

    for (var i = 0; i < textPackages.length; i++) {
      final package = textPackages[i];

      final text =
          package.isEnabled ? '\$${package.price}' : defaultTextPricingList[i];
      _noOfTextPriceControllers.add(
        TextEditingController(
          text: text,
        ),
      );

      enabledTexts[i] = package.isEnabled;
      _onOfTextOptions[i] = package.noOfTexts;
    }
  }

  void _populateVideoValues(
    ConsultationPricingModel model,
  ) {
    final videoPackages = model.videoPackages;

    final defaultVideoPricingList = [r'$20.00', r'$37.00', r'$45.00'];

    if (videoPackages.isEmpty) {
      for (var i = 0; i < defaultVideoPricingList.length; i++) {
        _videoPricingControllers.add(
          TextEditingController(
            text: defaultVideoPricingList[i],
          ),
        );
      }
      return;
    }

    videoPackagesCount = videoPackages.length;

    for (var i = 0; i < videoPackages.length; i++) {
      final package = videoPackages[i];

      final text =
          package.isEnabled ? '\$${package.price}' : defaultVideoPricingList[i];

      _videoPricingControllers.add(
        TextEditingController(
          text: text,
        ),
      );

      enabledVideos[i] = package.isEnabled;
      _videoPricingOptions[i] = package.noOf;
      _videoDurations[i] = package.duration;
    }
  }

  void _saveValues() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (enabledTexts.every((e) => e == false)) {
      return;
    }
    if (enabledVideos.every((e) => e == false)) {
      return;
    }
    _saveTextValues();
    _saveVideoValues();

    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        Navigator.of(context).pop();
      },
    );
  }

  void _saveTextValues() async {
    final textPackages = <TextPricingModel>[];
    for (var i = 0; i < _noOfTextPriceControllers.length; i++) {
      final controller = _noOfTextPriceControllers[i];
      var price = controller.text;
      if (price.isEmpty) {
        continue;
      }

      final noOfTexts = _onOfTextOptions[i];
      final isEnabled = enabledTexts[i];

      if (price.isNotEmpty) {
        // price without $
        price = price.substring(1);
        final api = Api();
        final response = await api.request(
          path: '/products',
          method: 'POST',
          data: {
            'name': 'text-product-$noOfTexts',
            'description': 'text description',
            'price': num.parse(price),
            'active':true,
          },
        );
        debugPrint('text response ==> $response');
        final responseData = response.data;
        debugPrint('text response data ==> ${responseData['result']['price_id']}');
        debugPrint('text response data ==> ${responseData['result']['product_id']}');
        final stripePriceId = responseData['result']['price_id'] ?? '';
        final stripeProductId = responseData['result']['product_id'] ?? '';



        textPackages.add(
          TextPricingModel(
            stripe_price_id: stripePriceId,
            stripe_product_id: stripeProductId,
            isEnabled: isEnabled,
            price: double.parse(price),
            noOfTexts: noOfTexts,
          ),
        );
      }
    }

    final provider =
        Provider.of<ConsultationPricingProvider>(context, listen: false);
    final model = provider.consultationPricingModel;

    if (model == null) return;

    if (textPackages.isEmpty) {
      context.showSnack(message: "You can't delete all packages");
      return;
    }
    provider.updateConsultationPricing(
      model.copyWith(textPackages: textPackages),
    );
  }

  void _saveVideoValues() async {
    final videoPackages = <VideoPricingModel>[];
    for (var i = 0; i < _videoPricingControllers.length; i++) {
      final controller = _videoPricingControllers[i];
      var price = controller.text;
      if (price.isEmpty) {
        continue;
      }
      final noOf = _videoPricingOptions[i];
      final duration = _videoDurations[i];
      final isEnabled = enabledVideos[i];

      if (price.isNotEmpty) {
        // price without $
        price = price.substring(1);
        final api = Api();
        final response = await api.request(
          path: '/products',
          method: 'POST',
          data: {
            'name': 'video-product-$noOf-$duration',
            'description': 'video description',
            'price': num.parse(price),
            'active':true,
          },
        );
        debugPrint('video response ==> $response');
        final responseData = response.data;
        debugPrint('video response data ==> ${responseData['result']['price_id']}');
        debugPrint('video response data ==> ${responseData['result']['product_id']}');
        final stripePriceId = responseData['result']['price_id'] ?? '';
        final stripeProductId = responseData['result']['product_id'] ?? '';
        videoPackages.add(
          VideoPricingModel(
            stripe_price_id: stripePriceId,
            stripe_product_id: stripeProductId,
            duration: duration,
            isEnabled: isEnabled,
            price: double.parse(price),
            noOf: noOf,
          ),
        );
      }
    }

    final provider =
        Provider.of<ConsultationPricingProvider>(context, listen: false);
    final model = provider.consultationPricingModel;

    if (model == null) return;
    if (videoPackages.isEmpty) {
      context.showSnack(message: "You can't delete all packages");
      return;
    }
    provider.updateConsultationPricing(
      model.copyWith(videoPackages: videoPackages),
    );
  }
}

class TimeInputField extends StatelessWidget {
  const TimeInputField({
    super.key,
    required this.noOfController,
    required this.duration,
    required this.onChanged,
  });
  final TextEditingController noOfController;
  final VideoDurationEnum duration;
  final ValueChanged<VideoDurationEnum> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '00',
                  prefixText: '    ',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.colorGreen,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: duration.title,
              dropdownColor: AppColors.colorGreen,
              style: const TextStyle(color: Colors.white),
              items: VideoDurationEnum.values.map((e) => e.title).map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                onChanged(
                  VideoDurationEnum.values.firstWhere((element) {
                    return element.title == newValue;
                  }),
                );
              },
              underline: const SizedBox(),
              iconEnabledColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class DurationDropDown extends StatelessWidget {
  const DurationDropDown({
    super.key,
    required this.duration,
    required this.onChanged,
  });
  final VideoDurationEnum duration;
  final ValueChanged<VideoDurationEnum> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorGreen,
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: duration.title,
        dropdownColor: AppColors.colorGreen,
        style: const TextStyle(color: Colors.white),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: VideoDurationEnum.values.map((e) => e.title).map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          onChanged(
            VideoDurationEnum.values.firstWhere((element) {
              return element.title == newValue;
            }),
          );
        },
        underline: const SizedBox(),
        iconEnabledColor: Colors.white,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixText,
  });
  final TextEditingController controller;
  final String hintText;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextFormField(
          controller: controller,
          inputFormatters: [
            CurrencyInputFormatter(),
          ],
          textAlign: TextAlign.center,
          maxLength: 7,
          decoration: InputDecoration(
            counterText: '',
            prefixText: prefixText,
            prefixStyle: Theme.of(context).textTheme.bodyLarge,
            hintText: hintText,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Allow only numbers and a single decimal point
    final newText =
        newValue.text.replaceAll(r'$', ''); // Remove $ symbol for validation
    if (newText.contains('.') &&
        newText.substring(newText.indexOf('.') + 1).contains('.')) {
      return oldValue;
    }

    // Ensure only numeric input
    final textWithoutDollar = newText.replaceAll(RegExp('[^0-9.]'), '');
    return newValue.copyWith(
      text: '\$$textWithoutDollar', // Add $ symbol
      selection: TextSelection.collapsed(
        offset: textWithoutDollar.length + 1,
      ), // Keep cursor in position
    );
  }
}
