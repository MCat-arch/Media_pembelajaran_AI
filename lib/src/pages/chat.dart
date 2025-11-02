import 'package:flutter/material.dart';
import '../widget/chat_bubble.dart';
import '../services/ai_service.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _hasGreeted = false;

  static const String aiGreeting =
      "Halo! Saya siap membantu terkait sejarah pergerakan nasional. Silakan tanyakan apa saja.";

  @override
  void initState() {
    super.initState();
    // Tambahkan bubble pengantar AI di awal percakapan
    if (_messages.isEmpty) {
      _messages.add({"text": aiGreeting, "isUser": false});
      _hasGreeted = true;
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      if (!_hasGreeted) {
        _messages.add({"text": aiGreeting, "isUser": false});
        _hasGreeted = true;
      }
      _messages.add({"text": text, "isUser": true});
      _isLoading = true;
      _controller.clear();
      // Bubble loading
      _messages.add({"text": "...", "isUser": false, "isLoading": true});
    });

    try {
      // Panggil API
      final reply = await ApiService.sendMessage(text);

      setState(() {
        // Hapus bubble loading
        _messages.removeWhere((msg) => msg["isLoading"] == true);
        // Tambahkan balasan AI
        _messages.add({"text": reply, "isUser": false});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.removeWhere((msg) => msg["isLoading"] == true);
        _messages.add({
          "text": "Maaf, terjadi kesalahan. Silakan coba lagi.",
          "isUser": false,
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgGradientStart = const Color(0xFFF9F9F9);
    final Color bgGradientEnd = const Color(0xFFEFF3FA);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.white),
            SizedBox(width: 8),
            Text("Sang Kala AI"),
          ],
        ),
        backgroundColor: const Color(0xFF92B4EC),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgGradientStart, bgGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  if (msg["isLoading"] == true) {
                    // Bubble loading AI
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF92B4EC),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ChatBubble(
                    text: msg["text"],
                    isUser: msg["isUser"] ?? false,
                  );
                },
              ),
            ),

            /// Input bar
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: "Tulis pesan...",
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF92B4EC),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _isLoading ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
