// // MIGRATION:
// // State: LEGACY
// // Navigation: LEGACY
// // Models: LEGACY
// // Theme: COMPLETE
// // Common: COMPLETE
// // Notes: One-time encryption migration screen.
// //        All users migrated as of YYYY-MM-DD.
// //        This file is intentionally frozen.
// import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
// import 'package:mobile_drug_use_app/constants/theme/app_typography.dart';
// import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
// import 'package:flutter/material.dart';
// import '../lib/common/layout/common_spacer.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:mobile_drug_use_app/core/providers/core_providers.dart';
// import 'package:mobile_drug_use_app/core/services/encryption_migration_service.dart';
// import 'package:mobile_drug_use_app/core/utils/error_handler.dart';
// import 'migration_step_controller.dart';

// class EncryptionMigrationScreen extends ConsumerStatefulWidget {
//   const EncryptionMigrationScreen({super.key});
//   @override
//   ConsumerState<EncryptionMigrationScreen> createState() =>
//       _EncryptionMigrationScreenState();
// }

// class _EncryptionMigrationScreenState
//     extends ConsumerState<EncryptionMigrationScreen> {
//   final EncryptionMigrationService _migrationService =
//       EncryptionMigrationService();
//   final MigrationStepController _stepController = MigrationStepController();
//   String _pin = '';
//   String _confirmPin = '';
//   bool _pinVisible = false;
//   bool _confirmPinVisible = false;
//   String _recoveryKey = '';
//   @override
//   Widget build(BuildContext context) {
//     final tx = context.text;
//     final c = context.colors;
//     final sp = context.spacing;
//     return Scaffold(
//       backgroundColor: c.background,
//       appBar: _stepController.currentStep < 4
//           ? AppBar(
//               title: Text('Security Upgrade', style: tx.headlineSmall),
//               backgroundColor: c.surface,
//               foregroundColor: c.textPrimary,
//               elevation: context.sizes.elevationNone,
//             )
//           : null,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(sp.xl),
//           child: _buildStepContent(context),
//         ),
//       ),
//     );
//   }

//   Widget _buildStepContent(BuildContext context) {
//     switch (_stepController.currentStep) {
//       case 1:
//         return _buildExplanationStep(context);
//       case 2:
//         return _buildCreatePinStep(context);
//       case 3:
//         return _buildConfirmPinStep(context);
//       case 4:
//         return _buildMigratingStep(context);
//       case 5:
//         return _buildRecoveryKeyStep(context);
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   // Step 1: Explain the migration
//   Widget _buildExplanationStep(BuildContext context) {
//     final c = context.colors;
//     final tx = context.text;
//     final sp = context.spacing;

//     final sh = context.shapes;
//     final ac = context.accent;
//     return Column(
//       mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
//       crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
//       children: [
//         Icon(Icons.security, size: context.sizes.icon2xl, color: ac.primary),
//         CommonSpacer.vertical(sp.xl2),
//         Text(
//           'Security Upgrade Required',
//           style: tx.headlineMedium.copyWith(color: c.textPrimary),
//         ),
//         CommonSpacer.vertical(sp.lg),
//         Text(
//           'We\'ve upgraded our encryption system to be more secure and reliable.',
//           style: tx.bodyMedium.copyWith(color: c.textSecondary),
//         ),
//         CommonSpacer.vertical(sp.xl),
//         _buildFeatureItem(
//           context,
//           Icons.pin,
//           'PIN Protection',
//           'Unlock your data with a 6-digit PIN',
//         ),
//         CommonSpacer.vertical(sp.lg),
//         _buildFeatureItem(
//           context,
//           Icons.fingerprint,
//           'Biometric Unlock',
//           'Use your fingerprint or face (optional)',
//         ),
//         CommonSpacer.vertical(sp.lg),
//         _buildFeatureItem(
//           context,
//           Icons.key,
//           'Recovery Key',
//           'Never lose access to your data',
//         ),
//         CommonSpacer.vertical(sp.lg),
//         _buildFeatureItem(
//           context,
//           Icons.cloud_off,
//           'Zero-Knowledge',
//           'Your data stays private, even from us',
//         ),
//         CommonSpacer.vertical(sp.xl2),
//         Container(
//           padding: EdgeInsets.all(sp.lg),
//           decoration: BoxDecoration(
//             color: ac.primary.withValues(alpha: context.opacities.overlay),
//             borderRadius: BorderRadius.circular(sh.radiusMd),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.info_outline,
//                 color: ac.primary,
//                 size: context.sizes.iconMd,
//               ),
//               CommonSpacer.horizontal(sp.md),
//               Expanded(
//                 child: Text(
//                   'This will take a moment to re-encrypt your data. Don\'t close the app during migration.',
//                   style: tx.bodySmall.copyWith(color: c.textPrimary),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Spacer(),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _stepController.goTo(2);
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ac.primary,
//               foregroundColor: c.textInverse,
//               padding: EdgeInsets.symmetric(vertical: sp.lg),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(sh.radiusMd),
//               ),
//             ),
//             child: Text(
//               'Continue',
//               style: tx.labelLarge.copyWith(
//                 fontWeight: tx.bodyBold.fontWeight,
//                 color: c.textInverse,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFeatureItem(
//     BuildContext context,
//     IconData icon,
//     String title,
//     String subtitle,
//   ) {
//     final c = context.colors;
//     final ac = context.accent;
//     final tx = context.text;
//     final sp = context.spacing;
//     final sh = context.shapes;

//     return Row(
//       children: [
//         Container(
//           width: context.sizes.iconXl,
//           height: context.sizes.iconXl,
//           decoration: BoxDecoration(
//             color: ac.primary.withValues(alpha: context.opacities.selected),
//             borderRadius: BorderRadius.circular(sh.radiusMd),
//           ),
//           child: Icon(icon, color: ac.primary),
//         ),
//         SizedBox(width: sp.lg),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
//             children: [
//               Text(
//                 title,
//                 style: tx.labelLarge.copyWith(
//                   fontWeight: tx.bodyBold.fontWeight,
//                   color: c.textPrimary,
//                 ),
//               ),
//               Text(
//                 subtitle,
//                 style: tx.bodySmall.copyWith(color: c.textSecondary),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Step 2: Create PIN
//   Widget _buildCreatePinStep(BuildContext context) {
//     final c = context.colors;
//     final ac = context.accent;
//     final tx = context.text;
//     final sp = context.spacing;
//     final sh = context.shapes;

//     return Column(
//       mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
//       children: [
//         Text(
//           'Create Your PIN',
//           style: tx.headlineMedium.copyWith(color: c.textPrimary),
//         ),
//         SizedBox(height: sp.lg),
//         Text(
//           'Enter a 6-digit PIN to protect your data',
//           style: tx.bodyMedium.copyWith(color: c.textSecondary),
//         ),
//         SizedBox(height: sp.xl2),
//         TextField(
//           obscureText: !_pinVisible,
//           enableInteractiveSelection: false,
//           keyboardType: TextInputType.number,
//           maxLength: 6,
//           textAlign: AppLayout.textAlignCenter,
//           style: tx.headlineSmall.copyWith(
//             letterSpacing: 8,
//             color: c.textPrimary,
//           ),
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           decoration: InputDecoration(
//             hintText: '••••••',
//             counterText: '',
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _pinVisible ? Icons.visibility_off : Icons.visibility,
//                 color: c.textSecondary,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _pinVisible = !_pinVisible;
//                 });
//               },
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: c.border),
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: ac.primary),
//             ),
//           ),
//           onChanged: (value) {
//             setState(() {
//               _pin = value;
//             });
//           },
//         ),
//         SizedBox(height: sp.xl2),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: _pin.length == 6
//                 ? () {
//                     setState(() {
//                       _stepController.goTo(3);
//                     });
//                   }
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ac.primary,
//               foregroundColor: c.textInverse,
//               padding: EdgeInsets.symmetric(vertical: sp.lg),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(sh.radiusMd),
//               ),
//             ),
//             child: Text(
//               'Next',
//               style: tx.labelLarge.copyWith(
//                 fontWeight: tx.bodyBold.fontWeight,
//                 color: c.textInverse,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Step 3: Confirm PIN
//   Widget _buildConfirmPinStep(BuildContext context) {
//     final c = context.colors;
//     final ac = context.accent;
//     final tx = context.text;
//     final sp = context.spacing;
//     final sh = context.shapes;

//     return Column(
//       mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
//       children: [
//         Text(
//           'Confirm Your PIN',
//           style: tx.headlineMedium.copyWith(color: c.textPrimary),
//         ),
//         SizedBox(height: sp.lg),
//         Text(
//           'Enter your PIN again to confirm',
//           style: tx.bodyMedium.copyWith(color: c.textSecondary),
//         ),
//         SizedBox(height: sp.xl2),
//         TextField(
//           obscureText: !_confirmPinVisible,
//           enableInteractiveSelection: false,
//           keyboardType: TextInputType.number,
//           maxLength: 6,
//           textAlign: AppLayout.textAlignCenter,
//           style: tx.headlineSmall.copyWith(
//             letterSpacing: 8,
//             color: c.textPrimary,
//           ),
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           decoration: InputDecoration(
//             hintText: '••••••',
//             counterText: '',
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _confirmPinVisible ? Icons.visibility_off : Icons.visibility,
//                 color: c.textSecondary,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _confirmPinVisible = !_confirmPinVisible;
//                 });
//               },
//             ),
//             errorText: _confirmPin.length == 6 && _confirmPin != _pin
//                 ? 'PINs do not match'
//                 : null,
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: c.border),
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: ac.primary),
//             ),
//             errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: c.error),
//             ),
//             focusedErrorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: c.error),
//             ),
//           ),
//           onChanged: (value) {
//             setState(() {
//               _confirmPin = value;
//             });
//           },
//         ),
//         SizedBox(height: sp.xl2),
//         Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: () {
//                   setState(() {
//                     _stepController.goTo(2);
//                     _confirmPin = '';
//                   });
//                 },
//                 style: OutlinedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: sp.lg),
//                   side: BorderSide(color: c.border),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(sh.radiusMd),
//                   ),
//                 ),
//                 child: Text('Back', style: TextStyle(color: c.textPrimary)),
//               ),
//             ),
//             SizedBox(width: sp.lg),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: _confirmPin.length == 6 && _confirmPin == _pin
//                     ? _startMigration
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ac.primary,
//                   foregroundColor: c.textInverse,
//                   padding: EdgeInsets.symmetric(vertical: sp.lg),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(sh.radiusMd),
//                   ),
//                 ),
//                 child: Text(
//                   'Start Migration',
//                   style: tx.labelLarge.copyWith(
//                     fontWeight: tx.bodyBold.fontWeight,
//                     color: c.textInverse,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Step 4: Migrating (progress indicator)
//   Widget _buildMigratingStep(BuildContext context) {
//     final c = context.colors;
//     final ac = context.accent;
//     final tx = context.text;
//     final sp = context.spacing;

//     return Column(
//       mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
//       children: [
//         CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(ac.primary),
//         ),
//         SizedBox(height: sp.xl2),
//         Text(
//           'Upgrading Security...',
//           style: tx.headlineMedium.copyWith(color: c.textPrimary),
//         ),
//         SizedBox(height: sp.lg),
//         Text(
//           'Re-encrypting your data with the new system.\nThis may take a minute.',
//           textAlign: AppLayout.textAlignCenter,
//           style: tx.bodyMedium.copyWith(color: c.textSecondary),
//         ),
//       ],
//     );
//   }

//   // Step 5: Show recovery key
//   Widget _buildRecoveryKeyStep(BuildContext context) {
//     final c = context.colors;
//     final ac = context.accent;
//     final tx = context.text;
//     final sp = context.spacing;
//     final sh = context.shapes;

//     return Column(
//       mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
//       crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
//       children: [
//         Icon(Icons.check_circle, size: 64, color: c.success),
//         SizedBox(height: sp.xl),
//         Text(
//           'Migration Complete!',
//           style: tx.headlineMedium.copyWith(color: c.textPrimary),
//         ),
//         SizedBox(height: sp.lg),
//         Text(
//           'Your data has been successfully upgraded to the new encryption system.',
//           style: tx.bodyMedium.copyWith(color: c.textSecondary),
//         ),
//         SizedBox(height: sp.xl2),
//         Container(
//           padding: EdgeInsets.all(sp.lg),
//           decoration: BoxDecoration(
//             color: c.error.withValues(alpha: 0.1),
//             border: Border.all(color: c.error.withValues(alpha: 0.3)),
//             borderRadius: BorderRadius.circular(sh.radiusMd),
//           ),
//           child: Column(
//             crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.warning, color: c.error),
//                   SizedBox(width: sp.sm),
//                   Text(
//                     'IMPORTANT: Save Your Recovery Key',
//                     style: tx.labelLarge.copyWith(
//                       fontWeight: tx.bodyBold.fontWeight,
//                       color: c.error,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: sp.md),
//               Text(
//                 'If you forget your PIN, you\'ll need this recovery key to access your data. Store it somewhere safe.',
//                 style: tx.bodyMedium.copyWith(color: c.textPrimary),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: sp.lg),
//         Text(
//           'Recovery Key:',
//           style: tx.labelMedium.copyWith(
//             fontWeight: tx.bodyBold.fontWeight,
//             color: c.textSecondary,
//           ),
//         ),
//         SizedBox(height: sp.sm),
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(sp.lg),
//           decoration: BoxDecoration(
//             color: c.surface,
//             borderRadius: BorderRadius.circular(sh.radiusMd),
//             border: Border.all(color: c.border),
//           ),
//           child: SelectableText(
//             _recoveryKey,
//             style: TextStyle(
//               fontSize: tx.heading4.fontSize,
//               fontFamily: AppTypographyConstants.fontFamilyMonospace,
//               color: ac.primary,
//               letterSpacing: 2,
//             ),
//           ),
//         ),
//         SizedBox(height: sp.lg),
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             onPressed: () {
//               Clipboard.setData(ClipboardData(text: _recoveryKey));
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Recovery key copied to clipboard'),
//                   backgroundColor: c.success,
//                 ),
//               );
//             },
//             icon: Icon(Icons.copy, color: ac.primary),
//             label: Text(
//               'Copy Recovery Key',
//               style: TextStyle(color: ac.primary),
//             ),
//             style: OutlinedButton.styleFrom(
//               padding: EdgeInsets.symmetric(vertical: sp.lg),
//               side: BorderSide(color: ac.primary),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(sh.radiusMd),
//               ),
//             ),
//           ),
//         ),
//         const Spacer(),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               unawaited(
//                 ref.read(appLockControllerProvider.notifier).recordUnlock(),
//               );
//               // Navigate to home screen
//               Navigator.of(context).pushReplacementNamed('/home_page');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ac.primary,
//               foregroundColor: c.textInverse,
//               padding: EdgeInsets.symmetric(vertical: sp.lg),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(sh.radiusMd),
//               ),
//             ),
//             child: Text(
//               'Continue to App',
//               style: tx.labelLarge.copyWith(
//                 fontWeight: tx.bodyBold.fontWeight,
//                 color: c.textInverse,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Start the migration process
//   Future<void> _startMigration() async {
//     setState(() {
//       _stepController.goTo(4);
//     });
//     try {
//       final user = Supabase.instance.client.auth.currentUser;
//       if (user == null) {
//         throw Exception('No user logged in');
//       }
//       // Perform migration
//       final recoveryKey = await _migrationService.migrateUserData(
//         user.id,
//         _pin,
//       );
//       setState(() {
//         _recoveryKey = recoveryKey;
//         _stepController.goTo(5);
//       });
//     } catch (e, stack) {
//       ErrorHandler.logError(
//         'EncryptionMigrationScreen',
//         'Migration failed: $e',
//         stack,
//       );
//       setState(() {
//         _stepController.goTo(2); // Back to create PIN step
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Migration failed: ${e.toString()}'),
//             backgroundColor: context.theme.colors.error,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       }
//     }
//   }
// }
