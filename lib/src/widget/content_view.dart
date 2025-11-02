import 'package:SangKala/src/pages/detail.material.dart';
import 'package:SangKala/src/pages/kuis/kuis.dart';
import 'package:SangKala/src/providers/material_provider.dart';
import 'package:SangKala/src/widget/card_content_material.dart';
import 'package:SangKala/src/widget/cover_page_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SangKala/src/models/materi.model.dart';
import 'package:SangKala/src/providers/progress_provider.dart';

class ContentViewer extends StatefulWidget {
  final Materi materi;
  final int initialIndex;

  const ContentViewer({super.key, required this.materi, this.initialIndex = 0});

  @override
  State<ContentViewer> createState() => _ContentViewerState();
}

class _ContentViewerState extends State<ContentViewer> {
  late PageController _controller;
  int _currentIndex = 0;
  bool _initializing = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
    Future.microtask(_initProgress);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Pastikan progress materi sudah tersedia
  Future<void> _initProgress() async {
    if (_initializing) return;
    _initializing = true;

    final progressProvider = context.read<ProgressProvider>();

    try {
      var progress = progressProvider.activeProgress;

      // Jika progress aktif bukan materi ini, ambil ulang
      // if (progress == null || progress.material.id != widget.materi.id) {
      //   progress = await progressProvider.fetchProgressByMaterial(
      //     widget.materi.id,
      //   );
      // }
      await progressProvider.fetchProgressByMaterial(widget.materi.id);
      progress = progressProvider.activeProgress;

      // Jika belum ada progress sama sekali, buat baru
      if (progress == null) {
        await progressProvider.addProgress(widget.materi.id);
        progress = progressProvider.activeProgress;
      }
      // Set posisi index sesuai data progress
      final savedIndex = (progress!.currentIndex).clamp(
        0,
        widget.materi.content.length - 1,
      );

      if (!mounted) return;
      setState(() => _currentIndex = savedIndex);
      _controller.jumpToPage(savedIndex);
    } catch (e) {
      debugPrint("Init progress error: $e");
    } finally {
      _initializing = false;
    }
  }

  /// Simpan perubahan halaman ke progress
  Future<void> _updateProgress(int index) async {
    final progressProvider = context.read<ProgressProvider>();
    final progress = progressProvider.activeProgress;

    if (progress == null) return;

    try {
      await progressProvider.saveState(progress.id, index);
      debugPrint("Progress saved: ${progress.id} -> index $index");
    } catch (e) {
      debugPrint("Error saving progress: $e");
    }

    // Tandai selesai jika di akhir
    // if (index >= widget.materi.content.length) {
    //   try {
    //     await progressProvider.markAsDone(progress.id);
    //     await progressProvider.goToNextMaterial(progress.id);
    //     debugPrint("Materi ${widget.materi.id} selesai.");
    //   } catch (e) {
    //     debugPrint("Error marking as done: $e");
    //   }
    // }
  }

  /// Saat ganti halaman
  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _updateProgress(index);
  }

  /// Navigasi ke materi berikutnya
  Future<void> _goToNextMaterial() async {
    final progressProvider = context.read<ProgressProvider>();
    final materialProvider = context.read<MaterialProvider>();

    try {
      // Jalankan API next material
      // await progressProvider.goToNextMaterial(
      //   progressProvider.activeProgress?.id ?? "",
      // );

      final nextProgress = progressProvider.activeProgress;

      // if (nextProgress == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Tidak ada progress berikutnya.")),
      //   );
      //   return;
      // }

      // Ambil materi dari provider berdasarkan hasil progress baru
      // final nextMateri = materialProvider.findMaterialById(
      //   nextProgress.material.id,
      // );
      final nextMateri = materialProvider.getNextMateri(nextProgress!.material);

      // Pastikan materi baru benar-benar berbeda
      if (mounted && nextMateri != null && nextMateri.id != widget.materi.id) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MaterialDetailPage(
              materi: nextMateri,
              // initialIndex: 0,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 Anda telah menyelesaikan semua materi!"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error goToNextMaterial: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final contents = widget.materi.content;

    return Column(
      children: [
        // 🔹 HEADER
        _buildHeader(contents.length + 1),

        // 🔹 CONTENT
        Expanded(
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: contents.length + 1, // +1 untuk CoverPage
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SafeArea(child: CoverPageContent(materi: widget.materi));
              } else {
                final item = contents[index - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: MaterialContentView(content: item),
                );
              }
            },
          ),
        ),

        // 🔹 FOOTER
        _buildFooter(contents.length + 1),
      ],
    );
  }

  // ====================== UI Components =========================

  Widget _buildHeader(int totalContent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF90CAF9), Color(0xFFE3F2FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kiri: Back + Title
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.materi.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),

          // Kanan: Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${_currentIndex + 1}/${totalContent}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      value: (_currentIndex + 1) / (totalContent),
                      backgroundColor: Colors.white.withOpacity(0.4),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.school_rounded,
                    size: 18,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(int totalContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          // Tombol Prev
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.grey[300],
            ),
            onPressed: _currentIndex > 0
                ? () => _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  )
                : null,
            icon: const Icon(Icons.arrow_upward, color: Colors.black87),
            label: const Text("Prev", style: TextStyle(color: Colors.black87)),
          ),
          const Spacer(),

          // Tombol Next atau Quiz
          if (_currentIndex < totalContent - 1)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () => _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
              icon: const Icon(Icons.arrow_downward),
              label: const Text("Next"),
            )
          else
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.quiz,
                  label: "Quiz",
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPage(
                          materialId:
                              // widget.materi.quizId ??
                              widget.materi.id, // fallback
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.arrow_forward,
                  label: "Next",
                  color: Colors.green,
                  onTap: _goToNextMaterial,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: "AI",
                  color: Colors.purpleAccent,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/chatAI",
                      arguments: {"materiId": widget.materi.id},
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

// import 'package:SangKala/src/pages/detail.material.dart';
// import 'package:SangKala/src/pages/kuis/kuis.dart';
// import 'package:SangKala/src/providers/material_provider.dart';
// import 'package:SangKala/src/widget/card_content_material.dart';
// import 'package:SangKala/src/widget/cover_page_content.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/progress_provider.dart';
// import '../models/materi.model.dart';

// class ContentViewer extends StatefulWidget {
//   final Materi materi;
//   final int initialIndex;

//   const ContentViewer({super.key, required this.materi, this.initialIndex = 0});
//   // : super(key: key);

//   @override
//   State<ContentViewer> createState() => _ContentViewerState();
// }

// class _ContentViewerState extends State<ContentViewer> {
//   late PageController _controller;
//   late int _currentIndex;
//   bool _isEnsuringProgress = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _controller = PageController(initialPage: _currentIndex);
//     Future.microtask(() => _ensureProgressAndInit());
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   /// Pastikan progress ada untuk materi ini
//   Future<void> _ensureProgressAndInit() async {
//     if (_isEnsuringProgress) return;
//     _isEnsuringProgress = true;

//     final progressProvider = context.read<ProgressProvider>();
//     try {
//       var progress = progressProvider.activeProgress;
//       debugPrint(
//         "ContentViewer: checking activeProgress for materi ${widget.materi.id}",
//       );

//       // Jika activeProgress bukan materi ini, fetch ulang
//       if (progress != null && progress.material.id != widget.materi.id) {
//         await progressProvider.fetchProgressByMaterial(widget.materi.id);
//         progress = progressProvider.activeProgress;
//       }

//       // Jika belum ada progress, fetch semua, kalau tetap null, buat baru
//       if (progress == null) {
//         await progressProvider.fetchProgress();
//         if (progressProvider.activeProgress == null ||
//             progressProvider.activeProgress!.material.id != widget.materi.id) {
//           await progressProvider.addProgress(widget.materi.id);
//         }
//         progress = progressProvider.activeProgress;
//       }

//       // Tentukan index yang disimpan
//       final savedIndex = progress?.currentIndex ?? 0;
//       final clamped = savedIndex.clamp(0, widget.materi.content.length - 1);

//       if (!mounted) return;
//       setState(() {
//         _currentIndex = clamped;
//       });
//       await progressProvider.saveState(progress!.id, _currentIndex);
//       _controller.jumpToPage(_currentIndex);
//     } catch (e, st) {
//       debugPrint("ContentViewer _ensureProgressAndInit error: $e\n$st");
//     } finally {
//       _isEnsuringProgress = false;
//     }
//   }

//   // bool _looksLikeImage(String url) {
//   //   final lower = url.toLowerCase();
//   //   return lower.endsWith('.png') ||
//   //       lower.endsWith('.jpg') ||
//   //       lower.endsWith('.jpeg') ||
//   //       (lower.contains('res.cloudinary.com') &&
//   //           (lower.contains('.jpg') || lower.contains('.png')));
//   // }

//   /// Saat halaman berubah
//   Future<void> _onPageChangedAsync(int idx) async {
//     final progressProvider = context.read<ProgressProvider>();
//     final progress = progressProvider.activeProgress;

//     if (progress != null) {
//       try {
//         await progressProvider.saveState(
//           progress.id,
//           // (idx - 1).clamp(0, widget.materi.content.length - 1),
//           idx
//         );
//         debugPrint("ContentViewer: saveState success ${progress.id} -> $idx");
//       } catch (e) {
//         debugPrint("ContentViewer: saveState failed $e");
//       }
//     }

//     // Jika sudah di slide terakhir → tandai selesai & siap ke next materi
//     if (idx == widget.materi.content.length && progress != null) {
//       try {
//         await progressProvider.markAsDone(progress.id);
//         await progressProvider.goToNextMaterial(progress.id);
//         debugPrint("ContentViewer: materi selesai, next materi siap");
//       } catch (e) {
//         debugPrint("ContentViewer: error finishing/going next: $e");
//       }
//     }
//   }

//   void _onPageChanged(int idx) {
//     if (!mounted) return;
//     setState(() => _currentIndex = idx);
//     _onPageChangedAsync(idx);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final contents = widget.materi.content;

//     // return Column(
//     //   children: [
//     // Header
//     // Container(
//     //   width: double.infinity,
//     //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//     //   decoration: BoxDecoration(
//     //     color: Colors.blue[50],
//     //     borderRadius: const BorderRadius.vertical(
//     //       bottom: Radius.circular(20),
//     //     ),
//     //     boxShadow: [
//     //       BoxShadow(
//     //         color: Colors.black12.withOpacity(0.05),
//     //         blurRadius: 6,
//     //         offset: const Offset(0, 3),
//     //       ),
//     //     ],
//     //   ),
//     //   child: Row(
//     //     children: [
//     //       Expanded(
//     //         child: Row(
//     //           crossAxisAlignment: CrossAxisAlignment.start,
//     //           children: [
//     //             IconButton(
//     //               icon: const Icon(Icons.arrow_back_ios_new_rounded),
//     //               color: Colors.black87,
//     //               iconSize: 20,
//     //               onPressed: () => Navigator.pop(context),
//     //             ),

//     //             const SizedBox(height: 10),
//     //             Text(
//     //               widget.materi.title,
//     //               style: const TextStyle(
//     //                 fontSize: 18,
//     //                 fontWeight: FontWeight.w700,
//     //                 color: Colors.black87,
//     //               ),
//     //             ),
//     //             // if (widget.materi.description.isNotEmpty) ...[
//     //             //   const SizedBox(height: 4),
//     //             //   Text(
//     //             //     widget.materi.description,
//     //             //     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//     //             //     maxLines: 2,
//     //             //     overflow: TextOverflow.ellipsis,
//     //             //   ),
//     //             // ],
//     //           ],
//     //         ),
//     //       ),
//     //       Column(
//     //         children: [
//     //           Text(
//     //             "${_currentIndex + 1}/${contents.length}",
//     //             style: const TextStyle(fontWeight: FontWeight.w600),
//     //           ),
//     //           const SizedBox(height: 6),
//     //           SizedBox(
//     //             width: 36,
//     //             height: 36,
//     //             child: CircularProgressIndicator(
//     //               strokeWidth: 3,
//     //               value: (_currentIndex + 1) / contents.length,
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //     ],
//     //   ),
//     // ),

//     return Column(
//       children: [
//         // Header modern
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF90CAF9), Color(0xFFE3F2FD)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: const BorderRadius.vertical(
//               bottom: Radius.circular(24),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Kiri: Tombol kembali + Judul materi
//               Row(
//                 children: [
//                   InkWell(
//                     borderRadius: BorderRadius.circular(12),
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.7),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios_new_rounded,
//                         color: Colors.black87,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.materi.title,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       // Text(
//                       //   "Pembelajaran ke-${_currentIndex + 1}",
//                       //   style: TextStyle(fontSize: 13, color: Colors.grey[800]),
//                       // ),
//                     ],
//                   ),
//                 ],
//               ),

//               // Kanan: Indikator progres
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     "${_currentIndex + 1}/${contents.length}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 38,
//                         height: 38,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 4,
//                           value: (_currentIndex + 1) / contents.length,
//                           backgroundColor: Colors.white.withOpacity(0.4),
//                           valueColor: const AlwaysStoppedAnimation<Color>(
//                             Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                       const Icon(
//                         Icons.school_rounded,
//                         size: 18,
//                         color: Colors.blueAccent,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         // Content
//         Expanded(
//           child: PageView.builder(
//             controller: _controller,
//             scrollDirection: Axis.vertical,
//             itemCount: contents.length,
//             onPageChanged: _onPageChanged,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return CoverPageContent(materi: widget.materi);
//               } else {
//                 final item = contents[index - 1];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   child: MaterialContentView(content: item),
//                 );
//               }
//             },
//           ),
//         ),

//         // Footer Actions
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12.withOpacity(0.05),
//                 blurRadius: 6,
//                 offset: const Offset(0, -2),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   backgroundColor: Colors.grey[300],
//                 ),
//                 onPressed: _currentIndex > 0
//                     ? () => _controller.previousPage(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.ease,
//                       )
//                     : null,
//                 icon: const Icon(Icons.arrow_upward, color: Colors.black87),
//                 label: const Text(
//                   "Prev",
//                   style: TextStyle(color: Colors.black87),
//                 ),
//               ),
//               const Spacer(),
//               if (_currentIndex < contents.length - 1)
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     backgroundColor: Colors.blueAccent,
//                   ),
//                   onPressed: () => _controller.nextPage(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.ease,
//                   ),
//                   icon: const Icon(Icons.arrow_downward),
//                   label: const Text("Next"),
//                 )
//               else
//                 Row(
//                   children: [
//                     _buildActionButton(
//                       icon: Icons.quiz,
//                       label: "Quiz",
//                       color: Colors.orangeAccent,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 QuizPage(materialId: widget.materi.id),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     _buildActionButton(
//                       icon: Icons.arrow_forward,
//                       label: "Next",
//                       color: Colors.green,
//                       onTap: () async {
//                         final progressProvider = context
//                             .read<ProgressProvider>();
//                         final nextProgress = progressProvider.activeProgress;

//                         if (nextProgress != null &&
//                             nextProgress.material.id != widget.materi.id) {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ContentViewer(
//                                 materi: nextProgress.material,
//                                 initialIndex: nextProgress.currentIndex,
//                               ),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 "Selamat Anda Menyelesaikan Materi Sejarah Pergerakan Nasional!",
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     _buildActionButton(
//                       icon: Icons.chat_bubble_outline,
//                       label: "AI",
//                       color: Colors.purpleAccent,
//                       onTap: () {
//                         Navigator.pushNamed(
//                           context,
//                           "/chatAI",
//                           arguments: {"materiId": widget.materi.id},
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         backgroundColor: color,
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       ),
//       onPressed: onTap,
//       icon: Icon(icon, color: Colors.white),
//       label: Text(label, style: const TextStyle(color: Colors.white)),
//     );
//   }
// }
// // lib/src/widgets/content_viewer.dart
// import 'package:ai/src/pages/kuis/kuis.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ai/src/models/materi.model.dart';
// import 'package:ai/src/providers/progress_provider.dart';

// class ContentViewer extends StatefulWidget {
//   final Materi materi;
//   final int initialIndex;
//   const ContentViewer({
//     super.key,
//     required this.materi,
//     required this.initialIndex,
//   });

//   @override
//   State<ContentViewer> createState() => _ContentViewerState();
// }

// class _ContentViewerState extends State<ContentViewer> {
//   late PageController _controller;
//   late int _currentIndex;
//   bool _isEnsuringProgress = false;

//   @override
//   void initState() {
//     super.initState();

//     _currentIndex = widget.initialIndex;
//     _controller = PageController(initialPage: _currentIndex);

//     // lakukan async setup setelah frame pertama
//     Future.microtask(() => _ensureProgressAndInit());
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _ensureProgressAndInit() async {
//     if (_isEnsuringProgress) return;
//     _isEnsuringProgress = true;

//     final progressProvider = context.read<ProgressProvider>();
//     try {
//       // jika token belum diset di provider, pastikan sudah di-set oleh AuthProvider saat login
//       debugPrint(
//         "ContentViewer: checking activeProgress for materi ${widget.materi.id}",
//       );

//       var progress = progressProvider.activeProgress;

//       // jika ada activeProgress tapi bukan untuk materi ini, coba fetch spesifik
//       if (progress != null && progress.material.id != widget.materi.id) {
//         debugPrint(
//           "ContentViewer: activeProgress exists but for different materi, fetching specific",
//         );
//         await progressProvider.fetchProgressByMaterial(widget.materi.id);
//         progress = progressProvider.activeProgress;
//       }

//       // kalau belum ada progress untuk materi ini, coba fetch semua progress lalu cari
//       if (progress == null) {
//         debugPrint(
//           "ContentViewer: no activeProgress yet, fetching all progress...",
//         );
//         await progressProvider.fetchProgress();
//         // cek kembali apakah ada progress untuk this materi
//         if (progressProvider.activeProgress != null &&
//             progressProvider.activeProgress!.material.id == widget.materi.id) {
//           progress = progressProvider.activeProgress;
//         } else {
//           // mungkin server tidak mengembalikan progress untuk this material
//           debugPrint(
//             "ContentViewer: still no progress for this materi, creating one via addProgress",
//           );
//           await progressProvider.addProgress(widget.materi.id);
//           progress = progressProvider.activeProgress;
//         }
//       }

//       // sekarang tentukan savedIndex jika ada progress
//       final savedIndex = progress?.currentIndex ?? 0;
//       final clamped = savedIndex.clamp(0, widget.materi.content.length - 1);

//       if (!mounted) return;
//       setState(() {
//         _currentIndex = clamped;
//         // _controller = PageController(initialPage: _currentIndex);
//       });

//       _controller.jumpToPage(_currentIndex);

//       debugPrint("ContentViewer: initialized currentIndex=$_currentIndex");
//     } catch (e, st) {
//       debugPrint("ContentViewer error while ensuring progress: $e");
//       debugPrint("$st");
//     } finally {
//       _isEnsuringProgress = false;
//     }
//   }

//   bool _looksLikeImage(String url) {
//     final lower = url.toLowerCase();
//     return lower.endsWith('.png') ||
//         lower.endsWith('.jpg') ||
//         lower.endsWith('.jpeg') ||
//         (lower.contains('res.cloudinary.com') &&
//             (lower.contains('.jpg') || lower.contains('.png')));
//   }

//   Widget _buildContentCard(String item) {
//     if (item.startsWith('http') && _looksLikeImage(item)) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           color: Colors.grey[200],
//           child: InteractiveViewer(
//             child: Image.network(
//               item,
//               fit: BoxFit.contain,
//               loadingBuilder: (context, child, progress) {
//                 if (progress == null) return child;
//                 final p = progress.expectedTotalBytes != null
//                     ? progress.cumulativeBytesLoaded /
//                           (progress.expectedTotalBytes ?? 1)
//                     : null;
//                 return Center(child: CircularProgressIndicator(value: p));
//               },
//               errorBuilder: (context, error, stack) =>
//                   const Center(child: Icon(Icons.broken_image, size: 64)),
//             ),
//           ),
//         ),
//       );
//     }

//     if (item.startsWith('http')) {
//       return Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: InkWell(
//           onTap: () {
//             // launchUrl(Uri.parse(item));
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 const Icon(Icons.link, size: 48, color: Colors.blue),
//                 const SizedBox(height: 8),
//                 Text(
//                   item,
//                   style: const TextStyle(
//                     color: Colors.blue,
//                     decoration: TextDecoration.underline,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: SingleChildScrollView(
//           child: Text(item, style: const TextStyle(fontSize: 16, height: 1.5)),
//         ),
//       ),
//     );
//   }

//   Future<void> _onPageChangedAsync(int idx) async {
//     final progressProvider = context.read<ProgressProvider>();
//     final progress = progressProvider.activeProgress;

//     debugPrint(
//       "ContentViewer: page changed -> $idx (progress=${progress?.id})",
//     );

//     if (progress != null) {
//       try {
//         // simpan posisi halaman terakhir
//         await progressProvider.saveState(progress.id, idx);
//         debugPrint(
//           "ContentViewer: saveState success for ${progress.id} -> $idx",
//         );
//       } catch (e) {
//         debugPrint("ContentViewer: saveState failed: $e");
//       }
//     }

//     // jika user sudah di halaman terakhir konten
//     if (idx == widget.materi.content.length - 1 && progress != null) {
//       try {
//         // tandai progress selesai
//         await progressProvider.markAsDone(progress.id);
//         debugPrint("ContentViewer: markAsDone success for ${progress.id}");

//         // minta backend bikin progress baru untuk materi berikutnya
//         await progressProvider.goToNextMaterial(progress.id);
//         debugPrint("ContentViewer: materi selesai, ready to go next");
//         // final nextProgress = progressProvider.activeProgress;

//         // if (nextProgress != null &&
//         //     nextProgress.material.id != widget.materi.id) {
//         //   debugPrint(
//         //     "ContentViewer: next materi loaded: ${nextProgress.material.id}",
//         //   );

//         //   if (!mounted) return;
//         //   ScaffoldMessenger.of(context).showSnackBar(
//         //     const SnackBar(
//         //       content: Text(
//         //         "Materi selesai 🎉 — melanjutkan ke materi berikutnya.",
//         //       ),
//         //     ),
//         //   );

//         //   // langsung navigasi ke ContentViewer baru
//         //   // Navigator.pushReplacement(
//         //   //   context,
//         //   //   MaterialPageRoute(
//         //   //     builder: (_) => ContentViewer(
//         //   //       materi: nextProgress.material,
//         //   //       initialIndex: nextProgress.currentIndex,
//         //   //     ),
//         //   //   ),
//         //   // );
//         // }
//       } catch (e) {
//         debugPrint("ContentViewer: error finishing/going next: $e");
//       }
//     }
//   }

//   void _onPageChanged(int idx) {
//     // update UI segera
//     if (!mounted) return;
//     setState(() => _currentIndex = idx);

//     // jalankan side-effect async tanpa menunggu UI
//     _onPageChangedAsync(idx);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final contents = widget.materi.content;
//     if (contents.isEmpty) {
//       return Center(
//         child: Text(
//           widget.materi.description.isNotEmpty
//               ? widget.materi.description
//               : "Tidak ada konten pada materi ini.",
//           style: const TextStyle(fontSize: 16),
//         ),
//       );
//     }

//     return Column(
//       children: [
//         // Header
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.materi.title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (widget.materi.description.isNotEmpty) ...[
//                       const SizedBox(height: 6),
//                       Text(
//                         widget.materi.description,
//                         style: TextStyle(color: Colors.grey[700]),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "${_currentIndex + 1}/${contents.length}",
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 6),
//                   SizedBox(
//                     width: 40,
//                     height: 40,
//                     child: CircularProgressIndicator(
//                       value: (_currentIndex + 1) / contents.length,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         // PageView
//         Expanded(
//           child: PageView.builder(
//             controller: _controller,
//             scrollDirection: Axis.vertical,
//             itemCount: contents.length,
//             onPageChanged: _onPageChanged,
//             itemBuilder: (context, index) {
//               final item = contents[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 12.0,
//                 ),
//                 child: _buildContentCard(item),
//               );
//             },
//           ),
//         ),

//         // Footer actions
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//           child: Row(
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _currentIndex > 0
//                     ? () {
//                         _controller.previousPage(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.ease,
//                         );
//                       }
//                     : null,
//                 icon: const Icon(Icons.arrow_upward),
//                 label: const Text("Prev"),
//               ),
//               const Spacer(),
//               if (_currentIndex < contents.length - 1)
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     _controller.nextPage(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.ease,
//                     );
//                   },
//                   icon: const Icon(Icons.arrow_downward),
//                   label: const Text("Next"),
//                 )
//               else
//                 Row(
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 QuizPage(materialId: widget.materi.id),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.quiz),
//                       label: const Text("Quiz"),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton.icon(
//                       onPressed: () async {
//                         final progressProvider = context
//                             .read<ProgressProvider>();
//                         final nextProgress = progressProvider.activeProgress;

//                         if (nextProgress != null &&
//                             nextProgress.material.id != widget.materi.id) {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ContentViewer(
//                                 materi: nextProgress.material,
//                                 initialIndex: nextProgress.currentIndex,
//                               ),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Belum ada materi berikutnya 🎉"),
//                             ),
//                           );
//                         }
//                       },
//                       icon: const Icon(Icons.arrow_forward),
//                       label: const Text("Next Materi"),
//                     ),

//                     const SizedBox(width: 8),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                           context,
//                           "/chatAI",
//                           arguments: {"materiId": widget.materi.id},
//                         );
//                       },
//                       icon: const Icon(Icons.chat_bubble_outline),
//                       label: const Text("Ask AI"),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
