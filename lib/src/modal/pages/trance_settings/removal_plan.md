# Plan for Removing Old Trance Settings Code

## Current Status

We have successfully created a new implementation of the trance settings modal in the `lib/src/modal/pages/trance_settings/` directory. The old implementation is still present in `root_sheet_page.dart`, which is a large file (1567 lines) that contains multiple components.

## References to the Old Implementation

1. **In `modal_sheet_helper.dart`**:
   - The `showModalSheet` method includes the old `TranceSettingsModalPage.build(context)` in its page list builder.
   - However, it already has a conditional check that redirects to the new implementation when `initialPage >= 3`.

2. **In `root_sheet_page.dart`**:
   - The file contains the old implementation of `TranceSettingsModalPage`, `ModalitySelectPage`, and related classes.
   - There are direct references to page indices (e.g., `pageIndexNotifier.value = 4`).

3. **In other files**:
   - `day.dart` calls `ModalSheetHelper.showModalSheet(context, initialPage: 3)` to show the modality selection page.

## Removal Strategy

### Step 1: Update `modal_sheet_helper.dart`

1. Remove the old trance settings related pages from the page list builder:
   - `TranceSettingsModalPage.build(context)`
   - `HypnotherapyMethodsPage.build(context)`
   - `SoundscapesPage.build(context)`
   - `BreathingMethodsPage.build(context)`
   - `MeditationMethodsPage.build(context)`

2. Update the conditional check to redirect all trance settings related pages to the new implementation.

### Step 2: Update Direct References

1. Update any direct references to the old implementation in other files:
   - In `day.dart`, replace `ModalSheetHelper.showModalSheet(context, initialPage: 3)` with `LegacyTranceSettingsWrapper.showTranceSettingsModal(context)`.

### Step 3: Remove Old Code from `root_sheet_page.dart`

1. Remove the following classes from `root_sheet_page.dart`:
   - `TranceSettingsModalPage`
   - `ModalitySelectPage`
   - `HypnotherapyMethodsPage`
   - `SoundscapesPage`
   - `BreathingMethodsPage`
   - `MeditationMethodsPage`

2. Keep the following classes in `root_sheet_page.dart`:
   - `RootSheetPage`
   - `CustomIntentionPage`
   - `PreviousIntentionsPage`
   - Any other classes not related to trance settings

### Step 4: Test the Application

1. Test all flows that involve trance settings to ensure they work correctly with the new implementation.
2. Test all flows that involve the remaining pages in `root_sheet_page.dart` to ensure they still work correctly.

### Step 5: Clean Up

1. Remove any unused imports or constants from `root_sheet_page.dart`.
2. Update comments and documentation to reflect the new implementation.

## Risks and Mitigations

1. **Risk**: Removing code from `root_sheet_page.dart` might break other functionality.
   **Mitigation**: Carefully identify and preserve code that is used by other parts of the application.

2. **Risk**: Page indices might be hardcoded in other parts of the application.
   **Mitigation**: Update all references to page indices to use the new implementation.

3. **Risk**: The new implementation might not handle all edge cases that the old implementation handled.
   **Mitigation**: Thoroughly test the new implementation with various scenarios.

## Timeline

1. **Day 1**: Update `modal_sheet_helper.dart` and direct references.
2. **Day 2**: Remove old code from `root_sheet_page.dart`.
3. **Day 3**: Test the application and fix any issues.
4. **Day 4**: Clean up and finalize the migration.

## Success Criteria

1. The application works correctly with the new implementation.
2. The `root_sheet_page.dart` file is significantly smaller and more focused.
3. All references to the old implementation have been updated to use the new one.
4. No regressions or new bugs are introduced. 