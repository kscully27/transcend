import 'package:get_it/get_it.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/navigation.service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  print('Initializing Navigator Service');

  // Services

  locator.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );

  locator.registerLazySingleton<FirestoreService>(
    () => FirestoreServiceAdapter(),
  );
}
