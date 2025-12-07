import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/log_entry_cards/substance_header_card.dart';
import '../widgets/log_entry_cards/dosage_card.dart';
import '../widgets/log_entry_cards/route_of_administration_card.dart';
import '../widgets/log_entry_cards/feelings_card.dart';
import '../widgets/log_entry_cards/time_of_use_card.dart';
import '../widgets/log_entry_cards/location_card.dart';
import '../widgets/log_entry_cards/intention_craving_card.dart';
import '../widgets/log_entry_cards/triggers_card.dart';
import '../widgets/log_entry_cards/body_signals_card.dart';
import '../widgets/log_entry_cards/medical_purpose_card.dart';
import '../widgets/log_entry_page/log_entry_app_bar.dart';
import '../states/log_entry_state.dart';
import '../constants/deprecated/ui_colors.dart';
import '../constants/deprecated/theme_constants.dart';
import '../common/cards/common_card.dart';
import '../common/text/common_section_header.dart';
import '../common/inputs/common_textarea.dart';
import '../common/buttons/common_primary_button.dart';
import '../common/layout/common_spacer.dart';

class QuickLogEntryPage extends StatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage>
    with SingleTickerProviderStateMixin {
  late final LogEntryState _state;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _state = LogEntryState();
    
    // Setup fade-in animation
    _animationController = AnimationController(
      duration: ThemeConstants.animationNormal,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ChangeNotifierProvider<LogEntryState>.value(
      value: _state,
      child: Consumer<LogEntryState>(
        builder: (context, state, child) {
          return Scaffold(
            backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
            appBar: LogEntryAppBar(
              isSimpleMode: state.isSimpleMode,
              onSimpleModeChanged: state.setIsSimpleMode,
            ),
            drawer: const DrawerMenu(),
            body: Stack(
              children: [
                // Main form content
                Form(
                  key: state.formKey,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Substance
                                SubstanceHeaderCard(
                                  substance: state.substance,
                                  substanceCtrl: state.substanceCtrl,
                                  onSubstanceChanged: state.setSubstance,
                                ),
                                
                                const SizedBox(height: ThemeConstants.cardSpacing),
                                
                                // Dosage
                                DosageCard(
                                  dose: state.dose,
                                  unit: state.unit,
                                  units: const ['μg', 'mg', 'g', 'pills', 'ml'],
                                  doseCtrl: state.doseCtrl,
                                  onDoseChanged: state.setDose,
                                  onUnitChanged: state.setUnit,
                                ),
                                
                                const SizedBox(height: ThemeConstants.cardSpacing),
                                
                                // Route of Administration
                                RouteOfAdministrationCard(
                                  route: state.route,
                                  onRouteChanged: state.setRoute,
                                  availableROAs: state.getAvailableROAs(),
                                  isROAValidated: (roa) => state.substanceDetails != null && state.isROAValidated(roa),
                                ),
                                
                                const SizedBox(height: ThemeConstants.cardSpacing),
                                
                                // Feelings
                                FeelingsCard(
                                  feelings: state.feelings,
                                  secondaryFeelings: state.secondaryFeelings,
                                  onFeelingsChanged: state.setFeelings,
                                  onSecondaryFeelingsChanged: state.setSecondaryFeelings,
                                ),
                                
                                const SizedBox(height: ThemeConstants.cardSpacing),
                                
                                // Medical Purpose (simple mode only)
                                if (state.isSimpleMode) ...[
                                  MedicalPurposeCard(
                                    isMedicalPurpose: state.isMedicalPurpose,
                                    onChanged: state.setIsMedicalPurpose,
                                  ),
                                  const SizedBox(height: ThemeConstants.cardSpacing),
                                ],
                                
                                // Time of Use
                                TimeOfUseCard(
                                  date: state.date,
                                  hour: state.hour,
                                  minute: state.minute,
                                  onDateChanged: state.setDate,
                                  onHourChanged: state.setHour,
                                  onMinuteChanged: state.setMinute,
                                ),
                                
                                const SizedBox(height: ThemeConstants.cardSpacing),
                                
                                // Location
                                LocationCard(
                                  location: state.location,
                                  onLocationChanged: state.setLocation,
                                ),
                                
                                // Complex fields (only show in detailed mode)
                                if (!state.isSimpleMode) ...[
                                  const SizedBox(height: ThemeConstants.cardSpacing),
                                  
                                  // Intention & Craving
                                  IntentionCravingCard(
                                    intention: state.intention,
                                    cravingIntensity: state.cravingIntensity,
                                    isMedicalPurpose: state.isMedicalPurpose,
                                    onIntentionChanged: state.setIntention,
                                    onCravingIntensityChanged: state.setCravingIntensity,
                                    onMedicalPurposeChanged: state.setIsMedicalPurpose,
                                  ),
                                  
                                  const SizedBox(height: ThemeConstants.cardSpacing),
                                  
                                  // Triggers
                                  TriggersCard(
                                    selectedTriggers: state.triggers,
                                    onTriggersChanged: state.setTriggers,
                                  ),
                                  
                                  const SizedBox(height: ThemeConstants.cardSpacing),
                                  
                                  // Body Signals
                                  BodySignalsCard(
                                    selectedBodySignals: state.bodySignals,
                                    onBodySignalsChanged: state.setBodySignals,
                                  ),
                                ],
                                
                                CommonSpacer.vertical(ThemeConstants.cardSpacing),
                                
                                // Notes
                                CommonCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CommonSectionHeader(
                                        title: 'Additional Notes',
                                        subtitle: 'Any other details worth recording',
                                      ),
                                      CommonSpacer.vertical(ThemeConstants.space12),
                                      CommonTextarea(
                                        controller: state.notesCtrl,
                                        hintText: 'Enter any additional notes...',
                                        maxLines: 5,
                                        minLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Extra padding for bottom button
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                        
                        // Sticky bottom save button
                        Container(
                          padding: const EdgeInsets.all(ThemeConstants.space16),
                          decoration: BoxDecoration(
                            color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
                            border: Border(
                              top: BorderSide(
                                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                                width: 1,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: CommonPrimaryButton(
                            onPressed: () => state.save(context),
                            label: 'Save Entry',
                            icon: Icons.save,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Loading overlay
                if (state.isSaving)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}