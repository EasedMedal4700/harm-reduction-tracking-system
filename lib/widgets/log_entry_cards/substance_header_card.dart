import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../services/drug_profile_service.dart';

class SubstanceHeaderCard extends StatefulWidget {
  final String substance;
  final TextEditingController? substanceCtrl;
  final ValueChanged<String> onSubstanceChanged;

  const SubstanceHeaderCard({
    super.key,
    required this.substance,
    required this.onSubstanceChanged,
    this.substanceCtrl,
  });

  @override
  State<SubstanceHeaderCard> createState() => _SubstanceHeaderCardState();
}

class _SubstanceHeaderCardState extends State<SubstanceHeaderCard> {
  final _drugProfileService = DrugProfileService();
  List<String>? _allDrugs;
  TextEditingController? _innerFieldCtrl;

  @override
  void initState() {
    super.initState();
    _loadAllDrugs();
  }

  Future<void> _loadAllDrugs() async {
    try {
      final drugs = await _drugProfileService.getAllDrugNames();
      if (mounted) setState(() => _allDrugs = drugs);
    } catch (_) {
      if (mounted) setState(() => _allDrugs = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Substance",
            subtitle: "Search by name or alias",
          ),

          const CommonSpacer.vertical(ThemeConstants.space16),

          _buildAutocompleteField(context, isDark),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // AUTOCOMPLETE
  // ----------------------------------------------------------

  Widget _buildAutocompleteField(BuildContext context, bool isDark) {
    return Autocomplete<DrugSearchResult>(
      displayStringForOption: (opt) => opt.canonicalName,
      optionsBuilder: (TextEditingValue value) async {
        try {
          if (value.text.isEmpty) {
            return _allDrugs?.map((name) {
                  return DrugSearchResult(
                    displayName: name,
                    canonicalName: name,
                    isAlias: false,
                  );
                }).toList() ??
                [];
          }
          return await _drugProfileService
              .searchDrugNamesWithAliases(value.text);
        } catch (_) {
          return [];
        }
      },
      onSelected: (selection) {
        widget.onSubstanceChanged(selection.canonicalName);

        // update inner
        if (_innerFieldCtrl != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _innerFieldCtrl!.text = selection.canonicalName;
            _innerFieldCtrl!.selection = TextSelection.collapsed(
              offset: selection.canonicalName.length,
            );
          });
        }

        // update external
        if (widget.substanceCtrl != null) {
          widget.substanceCtrl!.text = selection.canonicalName;
          widget.substanceCtrl!.selection = TextSelection.collapsed(
            offset: selection.canonicalName.length,
          );
        }
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        _innerFieldCtrl = textEditingController;

        if (textEditingController.text.isEmpty &&
            widget.substance.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            textEditingController.text = widget.substance;
            textEditingController.selection = TextSelection.collapsed(
              offset: widget.substance.length,
            );
          });
        }

        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          style: TextStyle(
            color: isDark ? UIColors.darkText : UIColors.lightText,
            fontSize: ThemeConstants.fontLarge,
            fontWeight: ThemeConstants.fontMediumWeight,
          ),
          decoration: InputDecoration(
            hintText: "Search substance name...",
            suffixIcon: Icon(
              Icons.search,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
            hintStyle: TextStyle(
              color: isDark
                  ? UIColors.darkTextSecondary.withOpacity(0.5)
                  : UIColors.lightTextSecondary.withOpacity(0.5),
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeConstants.radiusMedium),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark
                    ? UIColors.darkBorder
                    : UIColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark
                    ? UIColors.darkNeonBlue
                    : UIColors.lightAccentBlue,
                width: 2,
              ),
            ),
            filled: true,
            fillColor:
                isDark ? const Color(0x08FFFFFF) : Colors.grey.shade50,
          ),
          validator: (v) =>
              (v == null || v.isEmpty) ? "Please enter a substance" : null,
          onChanged: (value) {
            widget.onSubstanceChanged(value);

            if (widget.substanceCtrl != null) {
              widget.substanceCtrl!.text = value;
              widget.substanceCtrl!.selection =
                  textEditingController.selection;
            }
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
          elevation: 8,
          borderRadius:
              BorderRadius.circular(ThemeConstants.radiusMedium),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: ThemeConstants.space8,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final opt = options.elementAt(index);
                return ListTile(
                  dense: true,
                  leading: Icon(
                    opt.isAlias ? Icons.label : Icons.medication,
                    color: opt.isAlias
                        ? (isDark
                            ? UIColors.darkNeonPurple
                            : UIColors.lightAccentPurple)
                        : (isDark
                            ? UIColors.darkNeonBlue
                            : UIColors.lightAccentBlue),
                    size: 20,
                  ),
                  title: Text(
                    opt.displayName,
                    style: TextStyle(
                      color: isDark
                          ? UIColors.darkText
                          : UIColors.lightText,
                      fontSize: ThemeConstants.fontMedium,
                    ),
                  ),
                  onTap: () => onSelected(opt),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
