import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../services/drug_profile_service.dart';

/// Substance header card with selected drug name
class SubstanceHeaderCard extends StatefulWidget {
  final String substance;
  final TextEditingController? substanceCtrl;
  final ValueChanged<String> onSubstanceChanged;

  const SubstanceHeaderCard({
    required this.substance,
    required this.onSubstanceChanged,
    this.substanceCtrl,
    super.key,
  });

  @override
  State<SubstanceHeaderCard> createState() => _SubstanceHeaderCardState();
}

class _SubstanceHeaderCardState extends State<SubstanceHeaderCard> {
  final _drugProfileService = DrugProfileService();
  List<String>? _allDrugs;
  TextEditingController? _fieldController;
  
  @override
  void initState() {
    super.initState();
    _loadAllDrugs();
  }
  
  Future<void> _loadAllDrugs() async {
    try {
      final drugs = await _drugProfileService.getAllDrugNames();
      if (mounted) {
        setState(() => _allDrugs = drugs);
      }
    } catch (e) {
      // Silently fail if Supabase is not initialized
      if (mounted) {
        setState(() => _allDrugs = []);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Substance',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Autocomplete field with database search
          Autocomplete<DrugSearchResult>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              try {
                if (textEditingValue.text.isEmpty) {
                  // Return all drugs as simple results
                  return _allDrugs?.map((name) => DrugSearchResult(
                    displayName: name,
                    canonicalName: name,
                    isAlias: false,
                  )).toList() ?? [];
                }
                // Search database for matching drugs and aliases
                return await _drugProfileService.searchDrugNamesWithAliases(textEditingValue.text);
              } catch (e) {
                // Return empty list if database connection fails
                return [];
              }
            },
            // Show canonical name in the text field after selection, but still
            // render the human-friendly display name in the options list.
            displayStringForOption: (DrugSearchResult option) => option.canonicalName,
            onSelected: (DrugSearchResult selection) {
              // Use canonical name (normalized from aliases)
              widget.onSubstanceChanged(selection.canonicalName);
              // Also set the inner text field to the canonical name so the
              // normalized value is shown to the user instead of the alias
              // (e.g., "Ritalin" -> "methylphenidate").
              if (_fieldController != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _fieldController!.text = selection.canonicalName;
                  _fieldController!.selection = TextSelection.fromPosition(
                    TextPosition(offset: _fieldController!.text.length),
                  );
                });
              }
              // Also sync to any external controller passed in
              if (widget.substanceCtrl != null) {
                widget.substanceCtrl!.text = selection.canonicalName;
                widget.substanceCtrl!.selection = TextSelection.fromPosition(
                  TextPosition(offset: widget.substanceCtrl!.text.length),
                );
              }
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              // Keep a reference to the Autocomplete's inner controller so
              // we can modify it when an alias is selected.
              _fieldController = textEditingController;
              // Initialize with current substance value
              if (textEditingController.text.isEmpty && widget.substance.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text = widget.substance;
                  textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textEditingController.text.length),
                  );
                });
              }
              
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Search substance name...',
                  hintStyle: TextStyle(
                    color: isDark 
                        ? UIColors.darkTextSecondary.withOpacity(0.5)
                        : UIColors.lightTextSecondary.withOpacity(0.5),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    borderSide: BorderSide(
                      color: isDark 
                          ? UIColors.darkBorder
                          : UIColors.lightBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    borderSide: BorderSide(
                      color: isDark 
                          ? UIColors.darkBorder
                          : UIColors.lightBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    borderSide: BorderSide(
                      color: isDark 
                          ? UIColors.darkNeonBlue
                          : UIColors.lightAccentBlue,
                      width: 2,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontMediumWeight,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a substance';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Update state as user types
                  widget.onSubstanceChanged(value);
                  
                  // Sync to external controller if provided
                  if (widget.substanceCtrl != null) {
                    final selection = textEditingController.selection;
                    widget.substanceCtrl!.text = value;
                    widget.substanceCtrl!.selection = selection;
                  }
                },
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space8),
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            option.isAlias ? Icons.label : Icons.medication,
                            color: option.isAlias 
                                ? (isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple)
                                : (isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue),
                            size: 20,
                          ),
                          title: Text(
                            option.displayName,
                            style: TextStyle(
                              color: isDark ? UIColors.darkText : UIColors.lightText,
                              fontSize: ThemeConstants.fontMedium,
                            ),
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    if (isDark) {
      return BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 1,
        ),
        boxShadow: UIColors.createNeonGlow(
          UIColors.darkNeonBlue,
          intensity: 0.1,
        ),
      );
    } else {
      return BoxDecoration(
        color: UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}
