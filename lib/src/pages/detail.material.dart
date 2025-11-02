// somewhere in your MaterialDetailPage
import 'package:SangKala/src/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SangKala/src/widget/content_view.dart';
import 'package:SangKala/src/models/materi.model.dart';

class MaterialDetailPage extends StatelessWidget {
  final Materi materi;
  const MaterialDetailPage({super.key, required this.materi});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Consumer<ProgressProvider>(
          builder: (context, provider, _) {
            return ContentViewer(
              materi: materi,
              initialIndex: provider.initialIndex,
              // initialIndex: 0,
              // onIndexChanged: (index) {
              //   // Optional: update local progress provider
              //   // Provider.of<ProgressProvider>(context, listen: false).updateCurrentIndex(materi.id, index);
              //   print("Current index: $index");
              // },
              // onFinish: () {
              //   // Optional: mark progress done and unlock next material
              //   // Provider.of<ProgressProvider>(context, listen: false).markAsDone(progressId);
              //   print("Reached last content");
              // },
            );
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../models/materi.model.dart';

// class MaterialDetailPage extends StatelessWidget {
//   const MaterialDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Ambil materi dari arguments
//     final materi = ModalRoute.of(context)!.settings.arguments as Materi;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(materi.title),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Gambar materi
//             if (materi.imageUrl.isNotEmpty)
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(16),
//                   bottomRight: Radius.circular(16),
//                 ),
//                 child: Image.network(
//                   materi.imageUrl,
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 200,
//                     color: Colors.grey.shade200,
//                     alignment: Alignment.center,
//                     child: const Icon(Icons.broken_image, size: 50),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 16),

//             // Konten materi
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     materi.title,
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     materi.description.isNotEmpty
//                         ? materi.description
//                         : "No description available for this material.",
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Tombol Aksi
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         backgroundColor: Colors.blueAccent,
//                       ),
//                       onPressed: () {
//                         // navigasi ke quiz
//                         Navigator.pushNamed(
//                           context,
//                           '/quiz',
//                           arguments: materi.quizId,
//                         );
//                       },
//                       icon: const Icon(Icons.quiz_rounded),
//                       label: const Text("Start Quiz"),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         // navigasi ke chat AI
//                         Navigator.pushNamed(context, '/chatAI');
//                       },
//                       icon: const Icon(Icons.smart_toy_rounded),
//                       label: const Text("Ask AI"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
