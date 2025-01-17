import 'package:trancend/firebase_options_prod.dart';
import 'main.dart';

void main() async {
  final options = DefaultFirebaseOptions.currentPlatform;
  print('Platform Firebase options: $options');
  print('API Key: ${options.apiKey}');
  print('Project ID: ${options.projectId}');
  print('Messaging Sender ID: ${options.messagingSenderId}');
  print('App ID: ${options.appId}');
  runMainApp(options);
}
