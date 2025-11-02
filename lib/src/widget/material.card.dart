import 'package:flutter/material.dart';

class ActiveMaterialCard extends StatelessWidget {
  final String materialTitle;
  final String materialImage;
  final int lastSlide;
  final VoidCallback onContinue;

  const ActiveMaterialCard({
    super.key,
    required this.materialTitle,
    required this.materialImage,
    required this.lastSlide,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // Warna pastel untuk tema sejarah modern
    final Color primaryPastel = const Color(0xFF92B4EC); // biru pastel
    final Color accentPastel = const Color(0xFFF9D29D);  // oranye pastel

    Widget thumb;
    if (materialImage.isNotEmpty && materialImage.startsWith('http')) {
      thumb = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          materialImage,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
          ),
        ),
      );
    } else {
      thumb = Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [primaryPastel.withOpacity(0.4), accentPastel.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.menu_book, size: 64, color: Colors.white70),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
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
                Text(
                  materialTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.history_edu, size: 18, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      "Terakhir diakses: Slide $lastSlide",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPastel,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text(
                      "Lanjutkan",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ActiveMaterialCard extends StatelessWidget {
//   final String materialTitle;
//   final String materialImage;
//   final int lastSlide;
//   final VoidCallback onContinue;

//   const ActiveMaterialCard({
//     super.key,
//     required this.materialTitle,
//     required this.materialImage,
//     required this.lastSlide,
//     required this.onContinue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Widget thumb;
//     if (materialImage.isNotEmpty && materialImage.startsWith('http')) {
//       thumb = ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.network(
//           materialImage,
//           height: 220,
//           width: double.infinity,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) => Container(
//             height: 140,
//             color: Colors.grey[200],
//             child: const Icon(Icons.broken_image),
//           ),
//         ),
//       );
//     } else {
//       thumb = Container(
//         height: 140,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.grey[200],
//         ),
//         child: const Icon(Icons.image, size: 64, color: Colors.grey),
//       );
//     }

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             thumb,
//             const SizedBox(height: 12),
//             Text(materialTitle, style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 6),
//             Text("Terakhir diakses: Slide $lastSlide"),
//             const SizedBox(height: 12),
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton(
//                 onPressed: onContinue,
//                 child: const Text("Lanjutkan"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
