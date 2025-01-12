import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:trancend/src/services/authentication.service.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/localStorage.service.dart';
import 'package:trancend/src/services/navigation.service.dart';
import 'package:trancend/src/services/user.service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  print('Initializing Services');

  // Create a ProviderContainer with a ProviderRef
  if (!locator.isRegistered<ProviderContainer>()) {
    final container = ProviderContainer();
    locator.registerSingleton<ProviderContainer>(container);
  }

  // Register FirestoreService
  if (!locator.isRegistered<FirestoreService>()) {
    locator.registerSingleton<FirestoreService>(FirestoreServiceAdapter());
  }

  // Register AuthenticationService
  if (!locator.isRegistered<AuthenticationService>()) {
    // Create a Provider that will give us access to Ref
    final provider = Provider((ref) => ref);
    final container = locator<ProviderContainer>();
    final ref = container.read(provider);
    
    locator.registerSingleton<AuthenticationService>(
      AuthenticationServiceAdapter(ref),
    );
  }

  // Register UserService
  if (!locator.isRegistered<UserService>()) {
    locator.registerSingleton<UserService>(UserService());
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
}
