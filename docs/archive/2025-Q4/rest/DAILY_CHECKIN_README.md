# Daily Check-In Feature

## Overview
The Daily Check-In feature allows users to track their mood and emotional state throughout the day. Users can log check-ins for morning, midday (afternoon), and evening, providing a comprehensive view of their daily mental health patterns.

## Database Schema
The feature uses the `daily_checkins` table with the following structure:

```sql
CREATE TABLE daily_checkins (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  checkin_date DATE NOT NULL,
  mood VARCHAR(50) NOT NULL,
  emotions TEXT[] NOT NULL,
  time_of_day VARCHAR(20) NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Features

### 1. Daily Check-In Screen
- **Location**: `lib/screens/daily_checkin_screen.dart`
- **Route**: `/daily-checkin`
- **Features**:
  - Date selection (defaults to today)
  - Time of day selection: Morning, Midday (Afternoon), Evening
  - Mood selection: Great, Good, Okay, Struggling, Poor
  - Multi-select emotions from a predefined list
  - Optional notes field
  - Automatic detection of existing check-ins (prevents duplicates)
  - Update existing check-ins for the same date/time

### 2. Check-In History Screen
- **Location**: `lib/screens/checkin_history_screen.dart`
- **Route**: `/checkin-history`
- **Features**:
  - View last 7 days of check-ins
  - Color-coded mood indicators
  - Displays emotions as chips
  - Shows notes if provided
  - Friendly date formatting (Today, Yesterday, or date)

### 3. Components Created

#### Model
- `lib/models/daily_checkin_model.dart` - Data model with JSON serialization

#### Service
- `lib/services/daily_checkin_service.dart` - Database operations
  - `saveCheckin()` - Create new check-in
  - `updateCheckin()` - Update existing check-in
  - `fetchCheckinsByDate()` - Get check-ins for specific date
  - `fetchCheckinsInRange()` - Get check-ins for date range
  - `fetchCheckinByDateAndTime()` - Check for existing check-in
  - `deleteCheckin()` - Remove check-in

#### Provider
- `lib/providers/daily_checkin_provider.dart` - State management
  - Manages form state
  - Handles loading and saving
  - Auto-detects existing check-ins
  - Provides default time of day based on current time

## Usage

### Accessing the Feature

1. **From Home Page**: Click the "Daily Check-In" button
2. **From Drawer Menu**: Select "Daily Check-In" from the side menu
3. **Direct Navigation**: Use route `/daily-checkin`

### Creating a Check-In

1. Open the Daily Check-In screen
2. Select the date (defaults to today)
3. Choose time of day: Morning, Midday, or Evening
4. Select your overall mood
5. Choose one or more emotions that describe how you're feeling
6. Optionally add notes about your day
7. Click "Save Check-In"

### Viewing History

1. Click the history icon in the app bar on the Daily Check-In screen
2. Or navigate to `/checkin-history`
3. View your recent check-ins with mood and emotion data

## Time of Day Logic

The feature automatically suggests a time of day based on the current time:
- **Morning**: Before 12:00 PM
- **Afternoon**: 12:00 PM - 4:59 PM
- **Evening**: 5:00 PM onwards

## Mood Colors

The UI uses color coding to make moods easily identifiable:
- **Great**: Green
- **Good**: Light Green
- **Okay**: Yellow
- **Struggling**: Orange
- **Poor**: Red

## Available Emotions

- Happy
- Calm
- Energetic
- Tired
- Anxious
- Stressed
- Sad
- Angry
- Content
- Motivated
- Overwhelmed
- Peaceful

## Integration Points

### Routes Updated
- `lib/main.dart` - Added routes with provider setup
- `lib/routes/app_routes.dart` - Added builder methods
- `lib/screens/home_page.dart` - Added quick action button
- `lib/widgets/common/drawer_menu.dart` - Added menu item

## Future Enhancements

Potential improvements:
1. Analytics for mood patterns over time
2. Notifications/reminders for check-ins
3. Custom emotion lists
4. Export check-in data
5. Correlation with drug use logs
6. Mood trend visualization
7. Weekly/monthly summaries
