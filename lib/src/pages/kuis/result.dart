import 'package:SangKala/src/pages/kuis/kuis.dart';
import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  final int score;
  final String materialId;
  const QuizResultPage({
    super.key,
    required this.score,
    required this.materialId,
  });

  @override
  Widget build(BuildContext context) {
    final isGood = score >= 70; // ambang lulus misalnya
    final color = isGood ? Colors.greenAccent.shade700 : Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Quiz"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon dengan nuansa "trophy / feedback"
            CircleAvatar(
              radius: 50,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(
                isGood ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 64,
                color: color,
              ),
            ),
            const SizedBox(height: 24),

            // Judul
            Text(
              isGood ? "Selamat 🎉" : "Jangan menyerah!",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Skor
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Text(
                      "Skor Anda",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "$score",
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Kembali"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPage(materialId: materialId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.replay),
                  label: const Text("Coba Lagi"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class QuizResultPage extends StatelessWidget {
//   final int score;
//   const QuizResultPage({super.key, required this.score});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Quiz Result")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.emoji_events,
//                 size: 80, color: Colors.amberAccent),
//             const SizedBox(height: 20),
//             Text(
//               "Your Score",
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             Text(
//               "$score",
//               style: Theme.of(context).textTheme.displayLarge?.copyWith(
//                     color: Colors.blueAccent,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Back"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
