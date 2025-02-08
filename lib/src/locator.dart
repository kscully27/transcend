import 'package:get_it/get_it.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/localStorage.service.dart';
import 'package:trancend/src/services/navigation.service.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:trancend/src/services/analytics.service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  print('Initializing Services');

  // Register FirestoreService
  if (!locator.isRegistered<FirestoreService>()) {
    locator.registerSingleton<FirestoreService>(FirestoreServiceAdapter());
  }

  // Register NavigationService
  if (!locator.isRegistered<NavigationService>()) {
    locator.registerSingleton<NavigationService>(NavigationService());
  }

  // Register LocalStorageService
  if (!locator.isRegistered<LocalStorageService>()) {
    final service = await LocalStorageService.getInstance();
    locator.registerSingleton<LocalStorageService>(service);
  }

  // Register StorageService
  if (!locator.isRegistered<CloudStorageService>()) {
    locator.registerSingleton<CloudStorageService>(CloudStorageServiceAdapter());
  }

  // Register BackgroundAudioService
  if (!locator.isRegistered<BackgroundAudioService>()) {
    locator.registerSingleton<BackgroundAudioService>(BackgroundAudioService());
  }

  // Register analytics service
  if (!locator.isRegistered<AnalyticsService>()) {
    locator.registerLazySingleton<AnalyticsService>(() => FirebaseAnalyticsService());
    await locator<AnalyticsService>().loadService();
  }
}
