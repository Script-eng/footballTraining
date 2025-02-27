import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class FirebaseConfig {
  static Future<FirebaseApp> initializeFirebase() async {
    if (Firebase.apps.isEmpty) {
      return await Firebase.initializeApp(
        name: 'foottraining-4051b', // ✅ Keep this so iOS still works
        options: Platform.isIOS || Platform.isMacOS
            ? const FirebaseOptions(
                apiKey: 'AIzaSyBPwPSHkw1rupR_PCwaaKeFknpSqoBeUfM',
                appId: '1:388672883836:ios:5d90d92b8467e1407e0df9',
                messagingSenderId: '388672883836',
                projectId: 'foottraining-4051b',
                storageBucket: 'foottraining-4051b.appspot.com',
              )
            : const FirebaseOptions(
                apiKey: 'AIzaSyBPwPSHkw1rupR_PCwaaKeFknpSqoBeUfM',
                appId: '1:388672883836:android:924ffec1dc97af7d7e0df9',
                messagingSenderId: '388672883836',
                projectId: 'foottraining-4051b',
                storageBucket: 'foottraining-4051b.appspot.com',
              ),
      );
    } else {
      print("✅ Firebase already initialized, using existing app.");
      return Firebase.app(
          'foottraining-4051b'); // ✅ Explicitly retrieve named app
    }
  }
}
