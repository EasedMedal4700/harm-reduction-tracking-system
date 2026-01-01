# Account Management Features

## Overview
Added comprehensive account management features to the Settings page with strong security measures and user-friendly confirmation flows.

## Features Added

### 1. Download My Data 📥
**Location:** Settings → Account Management → Download My Data

**Flow:**
1. User taps "Download My Data"
2. Password verification dialog appears
3. User enters password (with show/hide toggle)
4. System verifies password against Supabase auth
5. If verified, system collects all user data:
   - Drug use logs
   - Reflections
   - Cravings
   - Stockpile entries
   - User profile information
6. Data is exported as formatted JSON file
7. System uses native share sheet to let user save/share the file
8. Success message displayed

**Security:**
- Password required for verification
- Real-time password validation
- Secure authentication check via Supabase

---

### 2. Delete My Data 🗑️
**Location:** Settings → Account Management → Delete My Data

**Flow:**
1. User taps "Delete My Data" (orange warning styling)
2. Password verification dialog appears
3. User enters password
4. First confirmation dialog shows:
   - List of all data that will be deleted
   - Warning that action cannot be undone
   - Option to download data first
   - Clear visual warnings (orange theme)
5. If user proceeds, second confirmation requires typing "DELETE MY DATA"
6. System deletes all user data from:
   - drug_use table
   - reflections table
   - cravings table
   - stockpile table
7. Account remains active but all data is removed
8. Success message displayed

**Security:**
- Password required
- Double confirmation (dialog + typed confirmation)
- Prominent suggestion to download data first
- Visual warnings throughout

---

### 3. Delete Account ⚠️
**Location:** Settings → Account Management → Delete Account

**Flow:**
1. User taps "Delete Account" (scary red styling with border)
2. Password verification dialog appears
3. User enters password
4. First confirmation dialog (red theme) shows:
   - ⚠️ PERMANENT DELETION warning
   - Complete list of what will be deleted
   - Bold suggestion to download data first
   - Red background and warning icons
5. User can:
   - Cancel
   - Download data first (recommended)
   - Continue to deletion
6. Second confirmation requires typing "DELETE MY ACCOUNT"
7. System performs:
   - Deletes all user data from all tables
   - Deletes user record from users table
   - Signs user out
   - Navigates to login screen
8. Account is permanently gone

**Security:**
- Password required
- Triple protection:
  1. Password verification
  2. Scary confirmation dialog with warnings
  3. Typed confirmation "DELETE MY ACCOUNT"
- Multiple opportunities to cancel
- Strong visual warnings (red background, warning icons)
- Suggestion to download data first
- User must go through multiple "hoops" to reach deletion

---

## Visual Design

### Download Data Button
- Blue icon and theme
- Clean, professional appearance
- Simple arrow forward indicator

### Delete Data Button
- Orange icon and theme
- Clear warning styling
- Prominent but not scary

### Delete Account Button
- **RED THEME** - Scary and attention-grabbing
- Red border around the entire card
- Red background tint
- Warning icon (⚠️)
- Bold red text
- Stands out significantly from other options

### Confirmation Dialogs
All destructive actions use:
- Warning icons
- Color-coded themes (orange for data, red for account)
- Clear bullet lists of what will be deleted
- Informational boxes suggesting data download
- Disabled buttons until requirements met
- Loading states during operations

---

## Technical Implementation

### Files Created
- `lib/widgets/settings/account_management_section.dart`
  - Main section widget
  - Password verification dialog
  - All confirmation flows
  - Data export functionality
  - Data deletion functionality
  - Account deletion functionality

### Files Modified
- `lib/screens/settings_screen.dart`
  - Added import for AccountManagementSection
  - Inserted section before About section

- `pubspec.yaml`
  - Added `share_plus: ^10.1.2` for file sharing
  - Added `path_provider: ^2.1.5` for file system access

### Dependencies Used
- **supabase_flutter**: User authentication and data operations
- **share_plus**: Native file sharing
- **path_provider**: Temporary file storage
- **dart:convert**: JSON encoding/decoding
- **dart:io**: File operations

### Security Features
1. **Password Verification**
   - Uses Supabase `signInWithPassword` to verify
   - Prevents unauthorized actions
   - Clear error messages

2. **Multiple Confirmations**
   - Initial password check
   - Visual warning dialogs
   - Typed confirmation for destructive actions
   - Multiple cancel opportunities

3. **User Protection**
   - Strong visual warnings for dangerous actions
   - Suggestion to download data before deletion
   - "Last chance" messaging
   - Disabled action buttons until all requirements met

4. **Data Integrity**
   - All deletions wrapped in try-catch
   - Loading indicators during operations
   - Success/error feedback
   - Proper cleanup on errors

---

## User Experience Flow

### Download Data
```
Tap Button → Enter Password → Wait (with loading) → Share File → Done
```

### Delete Data
```
Tap Button → Enter Password → See Warning → Choose Action →
  ├─ Cancel
  ├─ Download First
  └─ Continue → Type "DELETE MY DATA" → Confirm → Wait → Done
```

### Delete Account
```
Tap Button → Enter Password → See SCARY WARNING → Choose Action →
  ├─ Cancel
  ├─ Download First
  └─ Continue → Type "DELETE MY ACCOUNT" → FINAL WARNING →
    Confirm → Wait → Logged Out → Redirected to Login
```

---

## Error Handling
- Network errors shown with SnackBar
- Authentication errors caught and displayed
- Database errors handled gracefully
- User always receives feedback
- Loading dialogs prevent UI interaction during operations

---

## Testing Checklist

### Download Data
- [ ] Password verification works
- [ ] Incorrect password shows error
- [ ] Data export includes all tables
- [ ] JSON is properly formatted
- [ ] Share dialog appears
- [ ] File can be saved/shared

### Delete Data
- [ ] Password verification works
- [ ] First warning dialog appears
- [ ] "Download First" button works
- [ ] Typed confirmation required
- [ ] Data actually deleted from database
- [ ] Account remains functional
- [ ] Success message appears

### Delete Account
- [ ] Password verification works
- [ ] Scary red warning appears
- [ ] "Download First" button works
- [ ] Typed confirmation required ("DELETE MY ACCOUNT")
- [ ] All data deleted
- [ ] User record deleted
- [ ] User logged out
- [ ] Redirected to login
- [ ] Cannot login with old credentials

---

## Future Enhancements

1. **Data Export Formats**
   - Add CSV export option
   - Add PDF report option
   - Include data visualizations

2. **Scheduled Exports**
   - Automatic monthly exports
   - Email delivery option

3. **Account Recovery**
   - Grace period before permanent deletion
   - Email confirmation for account deletion

4. **Data Portability**
   - Import from other apps
   - Standard format exports

5. **Audit Trail**
   - Log all account management actions
   - Show history of exports/deletions
