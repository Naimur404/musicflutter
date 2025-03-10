import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_application_1/config/theme.dart';
import 'package:flutter_application_1/config/routes.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/controllers/search_controller.dart' as custom;
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize background audio
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.music_streaming_app.audio',
    androidNotificationChannelName: 'Music Playback',
    androidNotificationOngoing: true,
    androidShowNotificationBadge: true,
    androidStopForegroundOnPause: true,
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: API_BASE_URL),
        ),
        ChangeNotifierProvider<PlayerController>(
          create: (_) => PlayerController(),
        ),
        ChangeNotifierProvider<custom.SearchController>(
          create: (_) => custom.SearchController(),
        ),
      ],
       child: MaterialApp(
        title: 'Harmonia Music',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: appRoutes,
      ),
    );
  }
}