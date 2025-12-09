// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class DayUsageSheet extends StatefulWidget {
  final String substanceName;
  final int weekdayIndex;
  final String dayName;
  final Color accentColor;

  const DayUsageSheet({
    super.key,
    required this.substanceName,
    required this.weekdayIndex,
    required this.dayName,
    required this.accentColor,
  });

  @override
  State<DayUsageSheet> createState() => _DayUsageSheetState();
}

class _DayUsageSheetState extends State<DayUsageSheet> {
  List<Map<String, dynamic>> _allEntries = [];
  bool _loading = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('start_time, dose, consumption, medical')
          .eq('name', widget.substanceName)
          .order('start_time', ascending: false);

      final entries = (response as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList();

      // Filter entries for the selected weekday (with 5am cutoff logic)
      final filteredEntries = entries.where((entry) {
        final startTime = DateTime.tryParse(
          entry['start_time']?.toString() ?? '',
        );
        if (startTime == null) return false;

        // Apply 5am cutoff for non-medical use
        final isMedical = entry['medical'] == true || entry['medical'] == 1;
        DateTime adjustedTime = startTime;

        if (!isMedical && startTime.hour < 5) {
          adjustedTime = startTime.subtract(const Duration(hours: 5));
        }

        return adjustedTime.weekday % 7 == widget.weekdayIndex;
      }).toList();

      setState(() {
        _allEntries = filteredEntries;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load usage data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayEntries = _showAll || _allEntries.length <= 10
        ? _allEntries
        : _allEntries.take(10).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: ThemeConstants.space12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(ThemeConstants.space20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ThemeConstants.space8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.accentColor,
                            widget.accentColor.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.radiusMedium,
                        ),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: ThemeConstants.iconMedium,
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.substanceName,
                            style: TextStyle(
                              fontSize: ThemeConstants.fontLarge,
                              fontWeight: ThemeConstants.fontBold,
                              color: isDark
                                  ? UIColors.darkText
                                  : UIColors.lightText,
                            ),
                          ),
                          Text(
                            '${widget.dayName} Usage History',
                            style: TextStyle(
                              fontSize: ThemeConstants.fontMedium,
                              color: isDark
                                  ? UIColors.darkTextSecondary
                                  : UIColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary,
                    ),
                  ],
                ),
                SizedBox(height: ThemeConstants.space8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space12,
                    vertical: ThemeConstants.space8,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      ThemeConstants.radiusMedium,
                    ),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${_allEntries.length} ${_allEntries.length == 1 ? 'use' : 'uses'} on ${widget.dayName}s',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: ThemeConstants.fontSemiBold,
                      color: widget.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of entries
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space20,
                ),
                itemCount: displayEntries.length,
                itemBuilder: (context, index) {
                  final entry = displayEntries[index];
                  final startTime = DateTime.parse(entry['start_time']);
                  final dose = entry['dose']?.toString() ?? 'Unknown';
                  final route = entry['consumption']?.toString() ?? 'Unknown';
                  final isMedical =
                      entry['medical'] == true || entry['medical'] == 1;

                  return Container(
                    margin: EdgeInsets.only(bottom: ThemeConstants.space8),
                    padding: EdgeInsets.all(ThemeConstants.space12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? UIColors.darkBackground.withValues(alpha: 0.5)
                          : UIColors.lightBackground,
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.radiusMedium,
                      ),
                      border: Border.all(
                        color: isDark
                            ? UIColors.darkBorder
                            : UIColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Time
                        SizedBox(
                          width: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(startTime),
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontMedium,
                                  fontWeight: ThemeConstants.fontBold,
                                  color: widget.accentColor,
                                ),
                              ),
                              Text(
                                DateFormat('MMM d').format(startTime),
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontXSmall,
                                  color: isDark
                                      ? UIColors.darkTextSecondary
                                      : UIColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ThemeConstants.space12),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dose,
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontMedium,
                                  fontWeight: ThemeConstants.fontSemiBold,
                                  color: isDark
                                      ? UIColors.darkText
                                      : UIColors.lightText,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.route,
                                    size: 12,
                                    color: isDark
                                        ? UIColors.darkTextSecondary
                                        : UIColors.lightTextSecondary,
                                  ),
                                  SizedBox(width: ThemeConstants.space4),
                                  Text(
                                    route,
                                    style: TextStyle(
                                      fontSize: ThemeConstants.fontSmall,
                                      color: isDark
                                          ? UIColors.darkTextSecondary
                                          : UIColors.lightTextSecondary,
                                    ),
                                  ),
                                  if (isMedical) ...[
                                    SizedBox(width: ThemeConstants.space8),
                                    Icon(
                                      Icons.medical_services,
                                      size: 12,
                                      color: UIColors.lightAccentGreen,
                                    ),
                                  ],
                                ],
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

          // "Show All" button if more than 10
          if (!_showAll && _allEntries.length > 10)
            Padding(
              padding: EdgeInsets.all(ThemeConstants.space16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAll = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space20,
                    vertical: ThemeConstants.space12,
                  ),
                ),
                child: Text('Show All ${_allEntries.length} Uses'),
              ),
            ),

          SizedBox(height: ThemeConstants.space16),
        ],
      ),
    );
  }
}
