# Trance Settings Modal Implementation Guide

This guide provides detailed instructions on how to implement and use the trance settings modal in your application.

## Basic Usage

The simplest way to use the trance settings modal is to call the `show` method from the `TranceSettingsModalProvider`:

```dart
ElevatedButton(
  onPressed: () {
    TranceSettingsModalProvider.show(context);
  },
  child: const Text('Open Trance Settings'),
)
```

This will open the modal with a provider scope to isolate the modal's state from the rest of the app.

## Accessing Trance Settings

To access the current trance settings in your application, you can use the `tranceSettingsProvider`:

```dart
final tranceSettings = ref.watch(tranceSettingsProvider);

// Access specific settings
final tranceMethod = tranceSettings.tranceMethod;
final sessionDuration = tranceSettings.sessionDuration;
final backgroundSound = tranceSettings.backgroundSound;
```

## Listening for Changes

To listen for changes to the trance settings, you can use a `Consumer` widget:

```dart
Consumer(
  builder: (context, ref, _) {
    final tranceSettings = ref.watch(tranceSettingsProvider);
    
    return Text('Current method: ${tranceSettings.tranceMethod.name}');
  },
)
```

## Updating Settings Programmatically

If you need to update the trance settings programmatically, you can use the notifier:

```dart
final tranceSettingsNotifier = ref.read(tranceSettingsProvider.notifier);

// Update specific settings
tranceSettingsNotifier.setTranceMethod(TranceMethod.Meditation);
tranceSettingsNotifier.setSessionDuration(15);
tranceSettingsNotifier.setBackgroundSound(BackgroundSound.Ocean);
```

## Integration with Existing UI

### Adding to a Settings Screen

You can add a button to open the trance settings modal in your settings screen:

```dart
ListTile(
  title: const Text('Trance Settings'),
  subtitle: const Text('Configure your trance experience'),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
    TranceSettingsModalProvider.show(context);
  },
)
```

### Adding to a Pre-Session Screen

You can add a button to open the trance settings modal in your pre-session screen:

```dart
ElevatedButton.icon(
  icon: const Icon(Icons.settings),
  label: const Text('Customize Session'),
  onPressed: () {
    TranceSettingsModalProvider.show(context);
  },
)
```

## Advanced Usage

### Custom Initial Settings

If you want to set custom initial settings before showing the modal, you can update the trance settings provider before showing the modal:

```dart
void showWithCustomSettings(BuildContext context, WidgetRef ref) {
  // Set custom initial settings
  final notifier = ref.read(tranceSettingsProvider.notifier);
  notifier.setTranceMethod(TranceMethod.Hypnosis);
  notifier.setSessionDuration(20);
  
  // Show the modal
  TranceSettingsModalProvider.show(context);
}
```

### Handling Modal Dismissal

If you need to perform an action when the modal is dismissed, you can use the `then` method:

```dart
TranceSettingsModalProvider.show(context).then((_) {
  // Modal was dismissed, perform any necessary actions
  final settings = ref.read(tranceSettingsProvider);
  print('Modal dismissed with method: ${settings.tranceMethod.name}');
});
```

### Customizing the Modal Appearance

The modal uses a `GlassContainer` for its appearance. If you want to customize the appearance, you would need to modify the `trance_settings_modal.dart` file.

## Troubleshooting

### Modal Not Showing

If the modal is not showing, check that you're calling `TranceSettingsModalProvider.show(context)` with a valid `BuildContext`.

### Settings Not Updating

If the settings are not updating, make sure you're using `ref.watch(tranceSettingsProvider)` to listen for changes, not `ref.read(tranceSettingsProvider)`.

### Navigation Issues

If you're experiencing navigation issues within the modal, check that you're using the correct page indices defined in `PageIndices` class.

## Best Practices

1. **Isolate State**: The modal uses a provider scope to isolate its state from the rest of the app. This is a good practice to follow.

2. **Use Consumers**: Use `Consumer` widgets to listen for changes to the trance settings.

3. **Handle Errors**: Add error handling to your code to handle any potential issues.

4. **Test Thoroughly**: Test the modal thoroughly to ensure it works as expected in all scenarios.

5. **Document Changes**: Document any changes you make to the modal to make it easier for others to understand your code.

## Example Implementation

See the `example_usage.dart` file for a complete example of how to use the trance settings modal in your application. 