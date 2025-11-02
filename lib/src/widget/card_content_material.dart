import 'package:flutter/material.dart';



class MaterialContentView extends StatelessWidget {
  final String content;

  const MaterialContentView({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFF7F9FC); // pastel putih kebiruan
    final Color textColor = Colors.black87;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      color: backgroundColor,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon header kecil opsional
                const Icon(
                  Icons.book_rounded,
                  color: Color(0xFF92B4EC),
                  size: 40,
                ),
                const SizedBox(height: 16),

                // Teks konten
                Text(
                  content,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//jika ada image


  // Widget _buildContentCard(String item) {
  //   if (item.startsWith('http') && _looksLikeImage(item)) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(16),
  //       child: Container(
  //         color: Colors.grey[100],
  //         child: InteractiveViewer(
  //           panEnabled: true,
  //           minScale: 0.8,
  //           maxScale: 3,
  //           child: Image.network(
  //             item,
  //             fit: BoxFit.contain,
  //             loadingBuilder: (context, child, progress) {
  //               if (progress == null) return child;
  //               final p = progress.expectedTotalBytes != null
  //                   ? progress.cumulativeBytesLoaded /
  //                         (progress.expectedTotalBytes ?? 1)
  //                   : null;
  //               return Center(child: CircularProgressIndicator(value: p));
  //             },
  //             errorBuilder: (_, __, ___) =>
  //                 const Center(child: Icon(Icons.broken_image, size: 64)),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   if (item.startsWith('http')) {
  //     return Card(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       elevation: 3,
  //       child: InkWell(
  //         onTap: () {
  //           // launchUrl(Uri.parse(item));
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: Column(
  //             children: [
  //               const Icon(Icons.link, size: 48, color: Colors.blueAccent),
  //               const SizedBox(height: 10),
  //               Text(
  //                 item,
  //                 style: const TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 14,
  //                   decoration: TextDecoration.underline,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     elevation: 2,
  //     child: Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Text(
  //         item,
  //         style: const TextStyle(
  //           fontSize: 16,
  //           height: 1.6,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ),
  //   );
  // }