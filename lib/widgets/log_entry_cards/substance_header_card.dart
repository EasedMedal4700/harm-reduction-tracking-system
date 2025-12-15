import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../constants/theme/app_theme_extension.dart';
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
    final t = context.theme;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Substance",
            subtitle: "Search by name or alias",
          ),

          CommonSpacer.vertical(t.spacing.md),

          _buildAutocompleteField(context),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // AUTOCOMPLETE
  // ----------------------------------------------------------

  Widget _buildAutocompleteField(BuildContext context) {
    final t = context.theme;
    
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
          style: t.typography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Search substance name...",
            suffixIcon: Icon(
              Icons.search,
              color: t.colors.textSecondary,
            ),
            hintStyle: t.typography.body.copyWith(
              color: t.colors.textSecondary.withValues(alpha: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.spacing.radiusMd),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.spacing.radiusMd),
              borderSide: BorderSide(
                color: t.colors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.spacing.radiusMd),
              borderSide: BorderSide(
                color: t.accent.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: t.colors.surfaceVariant,
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
          color: t.colors.surface,
          elevation: 8,
          borderRadius: BorderRadius.circular(t.spacing.radiusMd),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: t.spacing.sm,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final opt = options.elementAt(index);
                return ListTile(
                  dense: true,
                  leading: Icon(
                    opt.isAlias ? Icons.label : Icons.medication,
                    color: opt.isAlias
                        ? t.accent.secondary
                        : t.accent.primary,
                    size: 20,
                  ),
                  title: Text(
                    opt.displayName,
                    style: t.typography.body,
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
