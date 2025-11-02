import 'package:SangKala/src/models/materi.model.dart';
import 'package:flutter/material.dart';

class CoverPageContent extends StatelessWidget {
  const CoverPageContent({super.key, required this.materi});
  final Materi materi;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isTablet = width > 600;
        final bool isLargeScreen = width > 900;

        // Skala dinamis
        final double horizontalPadding = isLargeScreen
            ? 80
            : isTablet
            ? 48
            : 24;

        final double titleSize = isLargeScreen
            ? 36
            : isTablet
            ? 28
            : 24;

        final double descSize = isLargeScreen
            ? 20
            : isTablet
            ? 16
            : 14;

        // 🔹 Gunakan rasio tinggi-lebar agar proporsional di semua layar
        final double imageAspectRatio = isLargeScreen
            ? 16 / 7
            : isTablet
            ? 16 / 9
            : 4 / 3;

        return Container(
          width: double.infinity,
          color: const Color(0xFFF7F9FC),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul
                Text(
                  materi.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Deskripsi
                if (materi.description.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width * 0.8),
                    child: Text(
                      materi.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: descSize,
                        height: 1.6,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // 🔹 Gambar proporsional (pakai AspectRatio)
                AspectRatio(
                  aspectRatio: imageAspectRatio,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: materi.img != null && materi.img!.isNotEmpty
                        ? Image.network(
                            materi.img!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

// import 'package:SangKala/src/models/materi.model.dart';
// import 'package:flutter/material.dart';

// class CoverPageContent extends StatelessWidget {
//   const CoverPageContent({super.key, required this.materi});
//   final Materi materi;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final double width = constraints.maxWidth;
//         final bool isTablet = width > 600;
//         final bool isLargeScreen = width > 900;

//         // Skala dinamis
//         final double horizontalPadding = isLargeScreen
//             ? 80
//             : isTablet
//             ? 48
//             : 24;

//         final double titleSize = isLargeScreen
//             ? 36
//             : isTablet
//             ? 28
//             : 24;

//         final double descSize = isLargeScreen
//             ? 20
//             : isTablet
//             ? 16
//             : 14;

//         final double imageHeight = isLargeScreen
//             ? constraints.maxHeight * 0.55
//             : isTablet
//             ? constraints.maxHeight * 0.45
//             : constraints.maxHeight * 0.4;

//         return SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: const Color(0xFFF7F9FC),
//             padding: EdgeInsets.symmetric(
//               horizontal: horizontalPadding,
//               vertical: 20,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // // Tombol kembali di pojok kiri atas
//                 // Align(
//                 //   alignment: Alignment.topLeft,
//                 //   child: IconButton(
//                 //     icon: const Icon(
//                 //       Icons.arrow_back_ios_new_rounded,
//                 //       color: Colors.black87,
//                 //       size: 22,
//                 //     ),
//                 //     onPressed: () => Navigator.pop(context),
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 10),

//                 // Judul
//                 Text(
//                   materi.title,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: titleSize,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Deskripsi
//                 if (materi.description.isNotEmpty)
//                   ConstrainedBox(
//                     constraints: BoxConstraints(maxWidth: width * 0.8),
//                     child: Text(
//                       materi.description,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: descSize,
//                         height: 1.6,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 24),

//                 // Gambar utama (responsif)
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: materi.img != null && materi.img!.isNotEmpty
//                         ? Image.network(
//                             materi.img!,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: imageHeight,
//                             loadingBuilder: (context, child, progress) {
//                               if (progress == null) return child;
//                               return Center(
//                                 child: CircularProgressIndicator(
//                                   value: progress.expectedTotalBytes != null
//                                       ? progress.cumulativeBytesLoaded /
//                                             progress.expectedTotalBytes!
//                                       : null,
//                                 ),
//                               );
//                             },
//                             errorBuilder: (_, __, ___) => Container(
//                               color: Colors.grey[200],
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.broken_image_outlined,
//                                   size: 60,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: imageHeight,
//                             color: Colors.grey[200],
//                             child: const Center(
//                               child: Icon(
//                                 Icons.image_outlined,
//                                 size: 60,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
