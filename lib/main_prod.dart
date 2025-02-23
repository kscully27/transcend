import 'package:firebase_core/firebase_core.dart';
import 'package:trancend/firebase_options_prod.dart';
import 'main.dart';

void main() async {
  final options = DefaultFirebaseOptions.currentPlatform;
  runMainApp(options);
}
