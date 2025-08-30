import 'package:flutter/material.dart';
import 'package:ai/src/services/ai_service.dart';

class ChatController extends ChangeNotifier {
  List<Map<String, String>> messages = [];
  final TextEditingController inputUser = TextEditingController();

  Future<void> sendMessage() async {
    String text = inputUser.text.trim();
    if (text.isEmpty) return;

    // Tambahkan pesan user ke UI
    messages.add({'sender': 'user', 'text': text});
    inputUser.clear();
    notifyListeners();

    // Panggil API
    final reply = await ApiService.sendMessage(text);

    // Tambahkan balasan bot
    messages.add({'sender': 'bot', 'text': reply});
    notifyListeners();
  }
}
