import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'core/router.dart';
import 'services/audio_player_service.dart';
import 'services/vision_board_service.dart';
import 'services/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await AppState.instance.init();
  await AudioPlayerService.instance.initialize();
  await VisionBoardService.instance.initialize();

  runApp(const ProviderScope(child: NishAffsApp()));
}

class NishAffsApp extends ConsumerWidget {
  const NishAffsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeData = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'NishAffs ✨',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: router,
    );
  }
}
