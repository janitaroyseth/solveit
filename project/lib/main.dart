import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/firebase_options.dart';
import 'package:project/providers/settings_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/chat_screen.dart';
import 'package:project/screens/collaborators_screen.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/screens/edit_profile_screen.dart';
import 'package:project/screens/edit_project_screen.dart';
import 'package:project/screens/edit_task_screen.dart';
import 'package:project/screens/edit_tag_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/tags_screen.dart';
import 'package:project/screens/user_settings_screen.dart';
import 'package:project/services/preferences_service.dart';
import 'package:project/styles/theme.dart';
import 'package:project/screens/task_details_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/screens/home_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the preferences service.
  PreferencesService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Check if the user is logged in.
  /// They get send to the [HomeScreen] if logged in and [SignInScreen] if not.
  Widget initialScreenCheck(WidgetRef ref) {
    final userAsyncData = ref.watch(userAuthProvider);

    return userAsyncData.when(
      data: (user) {
        //String userId = user != null ? user.uid : "<unknown>";
        return user != null ? const HomeScreen() : const SignInScreen();
      },
      error: (err, stack) => Text("Error in auth stream: $err"),
      loading: () => const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    return Consumer(
      builder: (context, ref, child) => MaterialApp(
        title: "solveit",
        debugShowCheckedModeBanner: false,
        theme: Themes.themeData(ref),
        darkTheme: Themes.darkTheme(ref),
        themeMode:
            ref.watch(darkModeProvider) ? ThemeMode.dark : ThemeMode.light,
        home: initialScreenCheck(ref),
        routes: {
          SignInScreen.routeName: (context) => const SignInScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ProjectOverviewScreen.routeName: (context) =>
              const ProjectOverviewScreen(),
          ProjectPreviewScreen.routeName: (context) =>
              const ProjectPreviewScreen(),
          ProjectCalendarScreen.routeName: (context) =>
              const ProjectCalendarScreen(),
          EditProjectScreen.routeName: (context) => const EditProjectScreen(),
          TaskOverviewScreen.routeName: (context) => const TaskOverviewScreen(),
          TaskDetailsScreen.routeName: (context) => const TaskDetailsScreen(),
          EditTaskScreen.routeName: (context) => const EditTaskScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          EditProfileScreen.routeName: (context) => const EditProfileScreen(),
          CreateProfileScreen.routeName: (context) =>
              const CreateProfileScreen(),
          UserSettingsScreen.routeName: (context) => const UserSettingsScreen(),
          CollaboratorsScreen.routeName: (context) =>
              const CollaboratorsScreen(),
          TagsScreen.routeName: (context) => const TagsScreen(),
          EditTagScreen.routeName: (context) => const EditTagScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
        },
      ),
    );
  }
}
