import 'package:flutter/material.dart';
import 'package:SangKala/src/models/materi.model.dart';
import 'package:SangKala/src/pages/detail.material.dart';
import 'package:SangKala/src/utils/app_colors.dart';
import 'package:SangKala/src/utils/app_fonts.dart';

class ListMaterialCard extends StatelessWidget {
  final Materi materi;
  final bool isActive;
  final bool isCompleted;

  const ListMaterialCard({
    super.key,
    required this.materi,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    IconData statusIcon;
    Color statusColor;

    if (isCompleted) {
      statusText = "Selesai";
      statusIcon = Icons.check_circle;
      statusColor = AppColors.success;
    } else if (isActive) {
      statusText = "Sedang dipelajari";
      statusIcon = Icons.play_circle_fill;
      statusColor = AppColors.accent;
    } else {
      statusText = "Belum dipelajari";
      statusIcon = Icons.radio_button_unchecked;
      statusColor = AppColors.textSecondary;
    }

    Widget thumb;
    if (materi.img.isNotEmpty && materi.img.startsWith("http")) {
      thumb = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          materi.img,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      );
    } else {
      thumb = Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.secondary,
        ),
        child: const Icon(Icons.menu_book, size: 60, color: Colors.white70),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MaterialDetailPage(materi: materi)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : isCompleted
                    ? AppColors.success.withOpacity(0.6)
                    : Colors.grey[200]!,
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(isActive ? 0.2 : 0.08),
              blurRadius: isActive ? 10 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            thumb,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    materi.title,
                    style: AppFonts.subHeading.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Deskripsi
                  Text(
                    materi.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodySecondary,
                  ),
                  const SizedBox(height: 12),

                  // Progress bar
                  LinearProgressIndicator(
                    value: materi.progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.grey[300],
                    color: isCompleted ? AppColors.success : AppColors.primary,
                  ),
                  const SizedBox(height: 8),

                  // Status row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            statusText,
                            style: AppFonts.body.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${(materi.progress * 100).toStringAsFixed(0)}%",
                        style: AppFonts.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:ai/src/models/materi.model.dart';
// import 'package:ai/src/pages/detail.material.dart';

// class ListMaterialCard extends StatelessWidget {
//   final Materi materi;
//   final bool isActive;
//   final bool isCompleted;

//   const ListMaterialCard({
//     super.key,
//     required this.materi,
//     required this.isActive,
//     required this.isCompleted,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Warna tema pastel
//     final Color primaryPastel = const Color(0xFF92B4EC); // biru pastel
//     final Color accentPastel = const Color(0xFFF9D29D); // oranye pastel
//     final Color successPastel = const Color(0xFF9DC08B); // hijau pastel

//     String statusText;
//     IconData statusIcon;
//     Color statusColor;

//     if (isCompleted) {
//       statusText = "Selesai";
//       statusIcon = Icons.check_circle;
//       statusColor = successPastel;
//     } else if (isActive) {
//       statusText = "Sedang dipelajari";
//       statusIcon = Icons.play_circle_fill;
//       statusColor = accentPastel;
//     } else {
//       statusText = "Belum dipelajari";
//       statusIcon = Icons.radio_button_unchecked;
//       statusColor = Colors.grey;
//     }

//     Widget thumb;
//     if (materi.img.isNotEmpty && materi.img.startsWith("http")) {
//       thumb = ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Image.network(
//           materi.img,
//           height: 160,
//           width: double.infinity,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) => Container(
//             height: 160,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: Colors.grey[200],
//             ),
//             child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//           ),
//         ),
//       );
//     } else {
//       thumb = Container(
//         height: 160,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             colors: [
//               primaryPastel.withOpacity(0.4),
//               accentPastel.withOpacity(0.4),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: const Icon(Icons.menu_book, size: 60, color: Colors.white70),
//       );
//     }

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => MaterialDetailPage(materi: materi)),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//         decoration: BoxDecoration(
//           color: isActive ? primaryPastel.withOpacity(0.12) : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: isActive
//               ? Border.all(color: accentPastel, width: 2)
//               : Border.all(color: Colors.grey[200]!),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withOpacity(isActive ? 0.15 : 0.08),
//               blurRadius: isActive ? 10 : 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             thumb,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Judul
//                   Text(
//                     materi.title,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 6),

//                   // Deskripsi
//                   Text(
//                     materi.description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodySmall?.copyWith(color: Colors.black54),
//                   ),
//                   const SizedBox(height: 12),

//                   // Progress bar
//                   LinearProgressIndicator(
//                     value: materi.progress,
//                     minHeight: 8,
//                     borderRadius: BorderRadius.circular(8),
//                     backgroundColor: Colors.grey[300],
//                     color: materi.isCompleted ? successPastel : primaryPastel,
//                   ),
//                   const SizedBox(height: 8),

//                   // Status row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(statusIcon, color: statusColor, size: 18),
//                           const SizedBox(width: 6),
//                           Text(
//                             statusText,
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: statusColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "${(materi.progress * 100).toStringAsFixed(0)}%",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
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

// import 'package:ai/src/pages/detail.material.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ai/src/models/materi.model.dart';
// import '../providers/progress_provider.dart';

// class ListMaterial extends StatelessWidget {
//   final List<Materi> materiList;

//   const ListMaterial({super.key, required this.materiList});

//   @override
//   Widget build(BuildContext context) {
//     // Warna tema pastel konsisten
//     final Color primaryPastel = const Color(0xFF92B4EC); // biru pastel
//     final Color accentPastel = const Color(0xFFF9D29D); // oranye pastel
//     final Color completedColor = const Color(0xFF9DC08B); // hijau pastel

//     if (materiList.isEmpty) {
//       return const Center(
//         child: Text(
//           "Belum ada materi aktif.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       );
//     }

//     return Consumer<ProgressProvider>(
//       builder: (context, progressProv, _) {
//         return ListView.separated(
//           itemCount: materiList.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 16),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           itemBuilder: (context, index) {
//             final materi = materiList[index];
//             final matId = materi.id.toString();

//             // Ambil progress (bisa null)
//             final prog = progressProv.progressForMaterial(matId);
//             final isActive = progressProv.isActiveMaterial(matId);
//             final isCompleted = progressProv.isMaterialCompleted(matId);

//             // Hitung progress fraction (untuk materi yang belum selesai)
//             final fraction = progressProv.materialProgressFraction(matId);

//             final imageUrl = (materi.img.isNotEmpty)
//                 ? materi.img
//                 : 'https://via.placeholder.com/600x400?text=No+Image';

//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12.withOpacity(0.08),
//                     blurRadius: 6,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(20),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => MaterialDetailPage(materi: materi),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(18),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Judul materi
//                       Text(
//                         materi.title,
//                         style: Theme.of(context).textTheme.titleMedium
//                             ?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color: Colors.black87,
//                             ),
//                       ),
//                       const SizedBox(height: 6),

//                       // Deskripsi singkat
//                       Text(
//                         materi.description,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           fontSize: 14,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       const SizedBox(height: 14),

//                       // TAMPILKAN progress bar hanya kalau belum completed
//                       if (!isCompleted) ...[
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: LinearProgressIndicator(
//                             value: fraction,
//                             minHeight: 10,
//                             backgroundColor: Colors.grey[200],
//                             valueColor: AlwaysStoppedAnimation(
//                               isActive ? primaryPastel : primaryPastel,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                       ] else
//                         const SizedBox(height: 6),

//                       // Status row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 isCompleted
//                                     ? Icons.check_circle
//                                     : (isActive
//                                           ? Icons.play_circle_fill
//                                           : Icons.hourglass_bottom),
//                                 size: 18,
//                                 color: isCompleted
//                                     ? completedColor
//                                     : accentPastel,
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 isCompleted
//                                     ? "Selesai"
//                                     : (isActive
//                                           ? "Sedang dipelajari"
//                                           : "Belum dipelajari"),
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: isCompleted
//                                       ? completedColor
//                                       : accentPastel,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           // persentase: kalau completed tampil "100%" atau kalau belum ada progress tampil "0%"
//                           Text(
//                             isCompleted
//                                 ? "100%"
//                                 : "${(fraction * 100).toStringAsFixed(0)}%",
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// import 'package:ai/src/pages/detail.material.dart';
// import 'package:flutter/material.dart';
// import 'package:ai/src/models/materi.model.dart';

// class ListMaterial extends StatelessWidget {
//   final List<Materi> materiList;

//   const ListMaterial({super.key, required this.materiList});

//   @override
//   Widget build(BuildContext context) {
//     // Warna tema pastel konsisten
//     final Color primaryPastel = const Color(0xFF92B4EC); // biru pastel
//     final Color accentPastel = const Color(0xFFF9D29D); // oranye pastel
//     final Color completedColor = const Color(0xFF9DC08B); // hijau pastel

//     if (materiList.isEmpty) {
//       return const Center(
//         child: Text(
//           "Belum ada materi aktif.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       );
//     }

//     return ListView.separated(
//       itemCount: materiList.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 16),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       itemBuilder: (context, index) {
//         final materi = materiList[index];

//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12.withOpacity(0.08),
//                 blurRadius: 6,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(20),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => MaterialDetailPage(materi: materi),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Judul materi
//                   Text(
//                     materi.title,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 6),

//                   // Deskripsi singkat
//                   Text(
//                     materi.description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       fontSize: 14,
//                       color: Colors.black54,
//                     ),
//                   ),
//                   const SizedBox(height: 14),

//                   // Progress bar
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: LinearProgressIndicator(
//                       value: materi.progress,
//                       minHeight: 10,
//                       backgroundColor: Colors.grey[200],
//                       valueColor: AlwaysStoppedAnimation(
//                         materi.isCompleted ? completedColor : primaryPastel,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Status row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             materi.isCompleted
//                                 ? Icons.check_circle
//                                 : Icons.play_circle_fill,
//                             size: 18,
//                             color: materi.isCompleted
//                                 ? completedColor
//                                 : accentPastel,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             materi.isCompleted
//                                 ? "Selesai"
//                                 : "Sedang dipelajari",
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: materi.isCompleted
//                                   ? completedColor
//                                   : accentPastel,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "${(materi.progress * 100).toStringAsFixed(0)}%",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

//sampai sini

// import 'package:ai/src/pages/detail.material.dart';
// import 'package:flutter/material.dart';
// import 'package:ai/src/models/materi.model.dart';

// class ListMaterial extends StatelessWidget {
//   final List<Materi> materiList;

//   const ListMaterial({super.key, required this.materiList});

//   @override
//   Widget build(BuildContext context) {
//     if (materiList.isEmpty) {
//       return const Center(child: Text("No active materials yet."));
//     }

//     return ListView.separated(
//       itemCount: materiList.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemBuilder: (context, index) {
//         final materi = materiList[index];
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 3,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(16),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => MaterialDetailPage(materi: materi),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Judul materi
//                   Text(
//                     materi.title,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 6),

//                   // Deskripsi (max 2 lines)
//                   Text(
//                     materi.description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 12),

//                   // Progress bar
//                   LinearProgressIndicator(
//                     value: materi.progress,
//                     minHeight: 8,
//                     borderRadius: BorderRadius.circular(8),
//                     backgroundColor: Colors.grey[300],
//                     color: materi.isCompleted
//                         ? Colors.green
//                         : Colors.blueAccent,
//                   ),
//                   const SizedBox(height: 8),

//                   // Status row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         materi.isCompleted ? "Completed" : "In Progress",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: materi.isCompleted
//                               ? Colors.green
//                               : Colors.orange,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         "${(materi.progress * 100).toStringAsFixed(0)}%",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
