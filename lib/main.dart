import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/controllers/chat_controller.dart';
import 'src/pages/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
