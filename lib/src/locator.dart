import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:trancend/src/providers/topics_provider.dart';
import 'package:trancend/src/services/authentication.service.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/localStorage.service.dart';
import 'package:trancend/src/services/navigation.service.dart';
import 'package:trancend/src/services/user.service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  print('Initializing Services');
  
  // Register UserService with GetX
  Get.put(UserService(), permanent: true);
  
  // Services
  locator.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );
  locator.registerLazySingleton<FirestoreService>(
    () => FirestoreServiceAdapter(),
  );
  locator.registerLazySingleton(() => TopicsProvider());

  var localStorageService = await LocalStorageServiceAdapter.getInstance();
  locator.registerSingleton(localStorageService);

  locator.registerLazySingleton<AuthenticationService>(
    () => AuthenticationServiceAdapter(),
  );
}
