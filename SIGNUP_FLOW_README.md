# Sign-Up Flow Implementation

## Overview

This is a comprehensive two-part, step-by-step sign-up flow with role-based branching for Mentor and Mentee users. The implementation follows best practices for user experience with a fixed progress indicator, inline validation, and a review screen before final submission.

## Features

### Core Functionality
- **Two-Part Flow**: Part 1 (General Info) + Part 2 (Role-Specific Info)
- **Role Selection**: Users choose between Mentor or Mentee with large selectable cards
- **Dynamic Branching**: Progress indicator and screens adapt based on selected role
- **Progress Tracking**: Fixed progress indicator at the top showing current step and total steps
- **Inline Validation**: Real-time validation on blur and before proceeding to next step
- **Save & Continue Later**: Option to save progress (placeholder for local storage integration)
- **Review Screen**: Final review with inline editing capability
- **JSON Output**: Exact schema output after confirmation

### User Experience
- One question/screen at a time to reduce cognitive load
- Short, concise copy with helpful placeholders
- Sensitive fields include "Prefer not to say" and self-description options
- Back/Next navigation on all screens (except first step has no Back)
- Role change warning that resets role-specific data
- Clean, modern UI with Material Design 3

## Flow Structure

### Part 1: Welcome & Role (Step 1)
- **Role Selection**: Mentor or Mentee (large cards)
- **Email**: With format validation
- **Name**: Full name
- **Password**: Minimum 8 characters, with show/hide toggle

### Part 2A: Mentee Branch (Steps 2-5)
1. **Location** (Step 2)
   - City (required)
   - State (required)
   - Neighborhood (optional)

2. **Identity** (Step 3)
   - Gender (with inclusive options + self-describe)
   - Color/Race (with inclusive options + self-describe)
   - Person with Disability (Yes/No/Prefer not to say)

3. **School** (Step 4)
   - School Name
   - School Location (city/state or neighborhood)

4. **Interests & Strengths** (Step 5)
   - Academic Interests (free text)
   - Strengths (free text)
   - Areas of Interest (free text)

5. **Review** (Step 6)

### Part 2B: Mentor Branch (Steps 2-6)
1. **Background** (Step 2)
   - Age (numeric, 18-100)
   - Hometown City
   - Hometown State

2. **Identity** (Step 3)
   - Gender (with inclusive options + self-describe)
   - Color/Race (with inclusive options + self-describe)
   - Person with Disability (Yes/No/Prefer not to say)

3. **Education** (Step 4)
   - Family Income During School (Low/Medium/High/Prefer not to say)
   - Education Level (dropdown with options)
   - High School Name
   - High School Location

4. **Strengths & Focus** (Step 5)
   - Strengths (free text)
   - Areas of Interest (free text)

5. **Activities** (Step 6)
   - Extracurricular Activities (free text)

6. **Review** (Step 7)

## File Structure

```
lib/
├── models/
│   └── signup_data_new.dart          # Data model with JSON serialization
├── screens/
│   └── signup_flow/
│       ├── signup_flow_screen.dart   # Main coordinator screen
│       └── screens/
│           ├── welcome_role_screen.dart
│           ├── review_screen.dart
│           ├── mentee/
│           │   ├── mentee_location_screen.dart
│           │   ├── mentee_identity_screen.dart
│           │   ├── mentee_school_screen.dart
│           │   └── mentee_interests_screen.dart
│           └── mentor/
│               ├── mentor_background_screen.dart
│               ├── mentor_identity_screen.dart
│               ├── mentor_education_screen.dart
│               ├── mentor_strengths_screen.dart
│               └── mentor_activities_screen.dart
└── main.dart
```

## Data Model

The `SignUpDataNew` class stores all form data and provides:
- Separate fields for mentor and mentee data
- `toJson()` method that outputs the exact required schema
- `resetRoleSpecificData()` method for role changes

### JSON Output Schema

```json
{
  "user": {
    "email": "",
    "name": "",
    "password": "",
    "isMentor": false
  },
  "mentee": {
    "city": "",
    "state": "",
    "neighborhood": "",
    "gender": "",
    "color_race": "",
    "is_disabled": null,
    "school_name": "",
    "school_location": "",
    "academic_interests": "",
    "strengths": "",
    "areas_of_interest": ""
  },
  "mentor": {
    "age": null,
    "hometown_city": "",
    "hometown_state": "",
    "gender": "",
    "color_race": "",
    "is_disabled": null,
    "family_income_during_school": "",
    "education_level": "",
    "high_school_name": "",
    "high_school_location": "",
    "strengths": "",
    "areas_of_interest": "",
    "extracurricular_activities": ""
  }
}
```

## Validation Rules

### Part 1 (Welcome & Role)
- Email: Required, must be valid email format
- Name: Required, non-empty
- Password: Required, minimum 8 characters
- Role: Required (Mentor or Mentee)

### Mentee Validation
- City, State: Required
- Neighborhood: Optional
- Gender, Color/Race, Disability Status: Required (with "Prefer not to say" option)
- School Name, School Location: Required
- Academic Interests, Strengths, Areas of Interest: Required

### Mentor Validation
- Age: Required, numeric, 18-100
- Hometown City, Hometown State: Required
- Gender, Color/Race, Disability Status: Required (with "Prefer not to say" option)
- Family Income, Education Level: Required (with "Prefer not to say" option)
- High School Name, High School Location: Required
- Strengths, Areas of Interest, Extracurricular Activities: Required

## Key Implementation Details

### Progress Indicator
- Shows "Step X of Y" where Y changes based on role selection
- Updates in real-time as user navigates
- Shows step label (e.g., "Location", "Identity")

### Validation Strategy
- **On Blur**: Clears error when field is focused, validates when focus is lost
- **On Next**: Validates current step before allowing navigation
- **Inline Errors**: Displayed below each field with red text
- **Global Error**: Displayed in a banner above navigation buttons

### Role Change Handling
- Warns user that changing role will reset role-specific data
- Requires confirmation via dialog
- Resets to Step 1 after role change
- Preserves Part 1 data (email, name, password)

### Review Screen
- Groups information by section (matching the collection flow)
- Each section has an "Edit" button that jumps to that step
- Returns to Review screen after editing
- Final "Submit" button outputs JSON

## Usage

To use this signup flow in your app:

1. Import the screen:
```dart
import 'screens/signup_flow/signup_flow_screen.dart';
```

2. Navigate to it:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SignUpFlowScreen()),
);
```

3. The final JSON output is displayed in a dialog after submission. In a production app, you would:
   - Send the JSON to your backend API
   - Store user credentials securely
   - Navigate to the main app screen

## Customization

### Adding New Fields
1. Add field to `SignUpDataNew` model
2. Add validation in `_validateCurrentStep()` in `signup_flow_screen.dart`
3. Create or update the appropriate screen file
4. Update the Review screen to display the new field

### Styling
- All screens use Material Design 3 components
- Colors are derived from the app's theme
- Spacing follows 8px grid system
- Typography uses Material Design type scale

### Localization
To add multi-language support:
1. Extract all strings to localization files
2. Use Flutter's `intl` package (already in dependencies)
3. Replace hardcoded strings with localized versions

## Testing Recommendations

1. **Validation Testing**
   - Test all required fields
   - Test email format validation
   - Test password length validation
   - Test age bounds (18-100)
   - Test role switching

2. **Navigation Testing**
   - Test Back/Next buttons
   - Test role change warning
   - Test jump to edit from Review screen
   - Test Save & Continue Later

3. **Data Persistence**
   - Verify data persists when navigating back
   - Verify data is reset when role changes
   - Verify final JSON output matches schema

4. **UI/UX Testing**
   - Test on different screen sizes
   - Test keyboard navigation
   - Test accessibility features
   - Test error message clarity

## Future Enhancements

1. **Local Storage**: Implement actual save/resume functionality
2. **Backend Integration**: Connect to API for user registration
3. **Email Verification**: Add email verification step
4. **Password Strength**: Add password strength indicator
5. **Profile Pictures**: Add image upload capability
6. **Social Auth**: Add Google/Facebook sign-in options
7. **Analytics**: Track drop-off rates at each step
8. **A/B Testing**: Test different question orders or groupings

## Dependencies

- Flutter SDK: ^3.8.1
- Material Design 3: Built-in
- intl: ^0.20.2 (for date formatting, can be used for localization)

No additional packages required for the core functionality.

