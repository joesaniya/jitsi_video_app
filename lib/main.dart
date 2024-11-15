import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/call_state_provider.dart';
import 'package:sample/notification_service.dart';

import 'meeting_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => MeetingProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MeetingScreen(),
    );
  }
}
