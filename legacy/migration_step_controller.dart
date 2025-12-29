// // MIGRATION:
// // State: LEGACY
// // Navigation: N/A
// // Models: N/A
// // Theme: N/A
// // Common: N/A
// // Notes: Legacy controller.
// class MigrationStepController {
//   int currentStep = 1;
//   void goTo(int step) {
//     currentStep = step;
//   }

//   void next() {
//     currentStep++;
//   }

//   void back() {
//     if (currentStep > 1) currentStep--;
//   }

//   // Helpers
//   bool get isExplanation => currentStep == 1;
//   bool get isCreatePin => currentStep == 2;
//   bool get isConfirmPin => currentStep == 3;
//   bool get isMigrating => currentStep == 4;
//   bool get isShowRecovery => currentStep == 5;
// }
