import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

//ignore: must_be_immutable
class AppHorizontalChoiceChips extends StatefulWidget {
  const AppHorizontalChoiceChips({
    super.key,
    required this.chips,
    required this.onSelected,
    this.onMultiSelection,
    this.unSelectedBackgroundColor,
    this.selectedChipColor,
    this.selectedLabelColor,
    this.unSelectedLabelColor,
    this.cornerRadius,
    this.subLabel,
    this.horizontalPadding,
    this.multiSelection,
    this.defaultSelection,
    this.selectable,
    this.labelSize,
    this.selectAbleList,
    this.selected = 0,
  });
  final List<String> chips;
  final Function(int index)? onSelected;
  final Function(List<int> indexes)? onMultiSelection;
  final Color? unSelectedBackgroundColor;
  final Color? selectedChipColor;
  final Color? selectedLabelColor;
  final Color? unSelectedLabelColor;
  final double? cornerRadius;
  final List<String>? subLabel;
  final int? horizontalPadding;
  final bool? multiSelection;
  final List<String>? defaultSelection;
  final bool? selectable;
  final double? labelSize;
  final List<bool>? selectAbleList;
  final int selected;

  @override
  State<AppHorizontalChoiceChips> createState() =>
      _AppHorizontalChoiceChipsState();
}

class _AppHorizontalChoiceChipsState extends State<AppHorizontalChoiceChips> {
  late int _selected;
  final List<int> _multiSelected = [];

  @override
  void initState() {
    super.initState();

    if (widget.defaultSelection != null &&
        widget.defaultSelection!.isNotEmpty) {
      if (widget.multiSelection ?? false) {
        for (final item in widget.defaultSelection!) {
          _multiSelected.add(widget.chips.indexOf(item));
        }
      } else {
        if (widget.defaultSelection?.isEmpty ?? true) return;
        _selected = widget.chips.indexOf(widget.defaultSelection![0]);
      }
    } else {
      _selected = widget.selected;
    }
  }

  @override
  void dispose() {
    _multiSelected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        itemCount: widget.chips.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 12 : 0,
              right: index == widget.chips.length - 1 ? 12 : 0,
            ),
            child: RawChip(
              elevation: 0,
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.cornerRadius ?? 2),
              ),
              onSelected: (isSelected) {
                if (widget.selectable ?? true) {
                  setState(() {
                    if (widget.multiSelection ?? false) {
                      if (widget.onMultiSelection != null) {
                        if (_multiSelected.contains(index)) {
                          _multiSelected.remove(index);
                          widget.onMultiSelection!(_multiSelected);
                        } else {
                          _multiSelected.add(index);
                          widget.onMultiSelection!(_multiSelected);
                        }
                      }
                    } else {
                      if (widget.selectAbleList != null &&
                          widget.selectAbleList![index]) {
                        _selected = index;
                        widget.onSelected!(index);
                      }
                      if (widget.selectAbleList == null) {
                        _selected = index;
                        widget.onSelected!(index);
                      }
                    }
                  });
                }
              },
              selectedColor: widget.selectedChipColor ??
                  const Color(0xFF087750).withOpacity(0.1),
              backgroundColor:
                  widget.unSelectedBackgroundColor ?? AppColors.colorBeige,
              clipBehavior: Clip.antiAlias,
              selectedShadowColor: const Color(0xFF087750),
              label: widget.subLabel != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.chips[index],
                          style: AppTextStyles.chipTextStyle
                              .changeColor(
                                widget.multiSelection ?? false
                                    ? _multiSelected.contains(index)
                                        ? widget.selectedLabelColor ??
                                            AppColors.colorGreen
                                        : widget.unSelectedLabelColor ??
                                            AppColors.colorGrayLight
                                    : _selected == index
                                        ? widget.selectedLabelColor ??
                                            AppColors.colorGreen
                                        : widget.unSelectedLabelColor ??
                                            AppColors.colorGrayLight,
                              )
                              .changeSize(widget.labelSize ?? 12)
                              .changeFontWeight(
                                _selected == index
                                    ? FontWeight.w500
                                    : FontWeight.w300,
                              ),
                        ),
                        Text(
                          widget.subLabel![index],
                          style: AppTextStyles.chipTextStyle
                              .changeColor(
                                widget.multiSelection == true
                                    ? _multiSelected.contains(index)
                                        ? widget.selectedLabelColor ??
                                            AppColors.colorGreen
                                        : widget.unSelectedLabelColor ??
                                            AppColors.colorGrayLight
                                    : _selected == index
                                        ? widget.selectedLabelColor ??
                                            AppColors.colorGreen
                                        : widget.unSelectedLabelColor ??
                                            AppColors.colorGrayLight,
                              )
                              .changeFontWeight(
                                _selected == index
                                    ? FontWeight.w500
                                    : FontWeight.w300,
                              )
                              .changeSize(9),
                        ),
                      ],
                    )
                  : Text(
                      widget.chips[index],
                      style: AppTextStyles.chipTextStyle
                          .changeColor(
                            widget.multiSelection ?? false
                                ? _multiSelected.contains(index)
                                    ? widget.selectedLabelColor ??
                                        AppColors.colorGreen
                                    : widget.unSelectedLabelColor ??
                                        AppColors.colorGrayLight
                                : _selected == index
                                    ? widget.selectedLabelColor ??
                                        AppColors.colorGreen
                                    : widget.unSelectedLabelColor ??
                                        AppColors.colorGrayLight,
                          )
                          .changeSize(widget.labelSize ?? 11)
                          .changeFontWeight(
                            widget.multiSelection == true
                                ? _multiSelected.contains(index)
                                    ? FontWeight.w500
                                    : FontWeight.w400
                                : _selected == index
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                          ),
                    ),
              selected: widget.multiSelection != null && widget.multiSelection!
                  ? _multiSelected.contains(index)
                  : _selected == index,
            ),
          );
        },
      ),
    );
  }
}
