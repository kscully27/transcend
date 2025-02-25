# Trance Settings Modal Refactoring

This directory contains the refactored code for the trance settings modal flow. The original implementation was in a single large file (`root_sheet_page.dart`), which made it difficult to maintain and extend. This refactoring breaks down the code into smaller, more focused components.

## Files

- `modal_page_definitions.dart`: Contains constants for page indices and provider definitions.
- `trance_utils.dart`: Contains utility methods for working with trance settings.
- `advanced_settings_modal.dart`: Contains the implementation of the advanced settings modal.
- `root_page.dart`: Contains the implementation of the root page (intention selection).
- `modality_select_page.dart`: Contains the implementation of the modality selection page.
- `settings_page.dart`: Contains the implementation of the settings page.
- `trance_settings_modal.dart`: Contains the main implementation of the trance settings modal.
- `trance_settings_modal_provider.dart`: Contains a provider wrapper for the trance settings modal.
- `example_usage.dart`: Contains an example of how to use the trance settings modal.

## Usage

To use the trance settings modal, simply call:

```dart
TranceSettingsModalProvider.show(context);
```

This will open the modal with a provider scope to isolate the modal's state from the rest of the app.

## Benefits of Refactoring

1. **Improved Maintainability**: Each component is now in its own file, making it easier to understand and modify.
2. **Better Organization**: The code is now organized by functionality, making it easier to find and modify specific parts.
3. **Reduced Complexity**: Each component is now focused on a specific task, reducing the complexity of the code.
4. **Easier Testing**: Each component can now be tested in isolation, making it easier to write tests.
5. **Better Reusability**: Components can now be reused in other parts of the app.

## Implementation Details

### Page Flow

1. The modal starts at the root page, which shows the intention selection UI.
2. After selecting an intention, the user is taken to the modality selection page.
3. After selecting a modality, the user is taken to the settings page for that modality.
4. The settings page includes a button to open the advanced settings modal.
5. The advanced settings modal includes options for break between sentences, background volume, and voice volume.

### State Management

The modal uses Riverpod for state management. The following providers are used:

- `pageIndexNotifierProvider`: Tracks the current page index.
- `previousPageIndexProvider`: Tracks the previous page index for navigation.
- `selectedModalityProvider`: Tracks the selected modality.
- `tranceSettingsProvider`: Tracks the trance settings.
- `intentionSelectionProvider`: Tracks the selected intention.

### Navigation

Navigation between pages is handled by updating the `pageIndexNotifier` value. The `WoltModalSheet` widget automatically handles the page transitions based on the page index.

### UI Components

The modal uses the following UI components:

- `GlassContainer`: A container with a glass-like appearance.
- `ModalityCard`: A card for displaying a modality option.
- `WoltModalSheetPage`: A page in the modal sheet.
- `WoltModalSheetRoute`: A route for the modal sheet.

## Future Improvements

- Add more comprehensive error handling.
- Add more unit tests for each component.
- Add more documentation for each component.
- Add more customization options for the modal. 