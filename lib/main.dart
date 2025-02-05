import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/firebase_notification.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';
import 'package:todo_list_riverpod/viewmodels/show_notification_firebase.dart';
import 'package:todo_list_riverpod/views/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.subscribeToTopic('all');
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.iosOptions,
    );
  }

  //nếu android thì getToken còn ios thì getAPNSToken

  // Xử lý thông báo khi nhận thông báo khi app ở chế độ background
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // Chuyển đổi message thành JSON
    FirebaseNotification messageJson =
        FirebaseNotification.fromRemoteMessage(message);

    ShowNotificationFirebase().showNotification(messageJson);
  });
  await dotenv.load(fileName: ".env");

  runApp(ProviderScope(child: MyApp()));
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidOptions;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosOptions;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static FirebaseOptions androidOptions = const FirebaseOptions(
    apiKey: 'AIzaSyBzDOiiVinLEbHTfi__XSXnj2G2LU8mnD4',
    appId: '1:865494246343:android:78624b47513a1fbf5fefe2',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'chatapp-efe5a',
  );

  static FirebaseOptions iosOptions = const FirebaseOptions(
    apiKey: 'AIzaSyBzDOiiVinLEbHTfi__XSXnj2G2LU8mnD4',
    appId: '1:865494246343:ios:97c680283073485c5fefe2',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'chatapp-efe5a',
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initToken(ref);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Login(),
    );
  }
}

Future<void> initToken(WidgetRef ref) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    String? token = await FirebaseMessaging.instance.getToken();
    ref.read(fcmToken.notifier).state = token ?? '';
    print('Token: $token');
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    String? token = await FirebaseMessaging.instance.getAPNSToken();
    print('Token: $token');
  }
}
