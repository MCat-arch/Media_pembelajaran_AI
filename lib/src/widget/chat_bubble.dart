import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final Color userColor = const Color(0xFF92B4EC); // pastel biru
    final Color botColor = Colors.white; // bot putih clean
    final Color userTextColor = Colors.white;
    final Color botTextColor = Colors.black87;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? userColor : botColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? userTextColor : botTextColor,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;

//   const ChatBubble({super.key, required this.text, required this.isUser});

//   @override
//   Widget build(BuildContext context) {
//     // Warna pastel
//     final Color userColor = const Color(0xFF92B4EC); // biru pastel
//     final Color botColor = const Color(0xFFE0E0E0); // abu pastel
//     final Color userTextColor = Colors.white;
//     final Color botTextColor = Colors.black87;

//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.7,
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isUser ? userColor : botColor,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: Radius.circular(isUser ? 16 : 4),
//             bottomRight: Radius.circular(isUser ? 4 : 16),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withOpacity(0.05),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isUser ? userTextColor : botTextColor,
//             fontSize: 15,
//             height: 1.4,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // class ChatBubble extends StatelessWidget {
// //   final String text;
// //   final bool isUser;

// //   const ChatBubble({super.key, required this.text, required this.isUser});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Align(
// //       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: isUser ? Colors.blue : Colors.grey[300],
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Text(
// //           text,
// //           style: TextStyle(
// //             color: isUser ? Colors.white : Colors.black,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
