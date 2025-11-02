import 'package:SangKala/src/providers/material_provider.dart';
import 'package:SangKala/src/widget/list_materi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class Knowledge extends StatelessWidget {
  const Knowledge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Knowledge",
          style: AppFonts.subHeading.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer2<MaterialProvider, ProgressProvider>(
        builder: (context, materiProvider, progressProvider, _) {
          final materiList = materiProvider.materiList;

          if (materiList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📖 Heading
                Text(
                  "Jelajahi Materi",
                  style: AppFonts.heading.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Pilih materi untuk mulai belajar atau lanjutkan progresmu.",
                  style: AppFonts.bodySecondary,
                ),
                const SizedBox(height: 20),

                // 📚 List Materi
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: materiList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final materi = materiList[index];

                    // Tentukan status
                    bool isActive = progressProvider.isActiveMaterial(
                      materi.id,
                    );
                    bool isCompleted = progressProvider.isMaterialCompleted(
                      materi.id,
                    );

                    return ListMaterialCard(
                      materi: materi,
                      isActive: isActive,
                      isCompleted: isCompleted,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


// import 'package:ai/src/models/progress.model.dart';
// import 'package:ai/src/widget/list_materi.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/materi.model.dart';
// import '../providers/material_provider.dart';
// import '../providers/progress_provider.dart';


// class Knowledge extends StatefulWidget {
//   const Knowledge({super.key});

//   @override
//   State<Knowledge> createState() => _KnowledgeState();
// }

// class _KnowledgeState extends State<Knowledge> {
//   bool _isInit = true;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_isInit) {
//       final materiProvider = Provider.of<MaterialProvider>(context, listen: false);
//       final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

//       // Fetch materi dan progress user
//       Future.wait([
//         materiProvider.fetchMaterials(),
//         progressProvider.fetchProgress(),
//       ]).catchError((e) {
//         debugPrint("❌ Error fetching materi or progress: $e");
//       });

//       _isInit = false;
//     }
//   }

//   // Helper: gabungkan materi dengan progress user
//   List<Materi> _mapMateriWithProgress(
//       List<Materi> allMateri, Progress? activeProgress) {
//     return allMateri.map((m) {
//       if (activeProgress != null &&
//           activeProgress.material.id.toString() == m.id) {
//         // Hitung progress
//         final totalContent = m.content.length > 0 ? m.content.length : 1;
//         final prog = (activeProgress.currentIndex + 1) / totalContent;
//         return Materi(
//           id: m.id,
//           numericId: m.numericId,
//           title: m.title,
//           img: m.img,
//           quizId: m.quizId,
//           description: m.description,
//           content: m.content,
//           progress: prog.clamp(0.0, 1.0),
//           isCompleted: activeProgress.done,
//         );
//       }
//       return m; // materi tanpa progress user
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final materiProvider = Provider.of<MaterialProvider>(context);
//     final progressProvider = Provider.of<ProgressProvider>(context);

//     if (materiProvider.isLoading || progressProvider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (materiProvider.error != null) {
//       return Center(child: Text("Error: ${materiProvider.error}"));
//     }

//     final materiList = _mapMateriWithProgress(
//         materiProvider.materiList, progressProvider.activeProgress);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Materi")),
//       body: ListMaterial(materiList: materiList),
//     );
//   }
// }
