import 'dart:io';

import 'package:flutter/material.dart';

class UserGreetingCard extends StatelessWidget {
  final String userName;
  final String? avatarPath; // bisa null jika belum ada foto

  const UserGreetingCard({super.key, required this.userName, this.avatarPath});

  @override
  Widget build(BuildContext context) {
    final Color primaryPastel = const Color(0xFF92B4EC); // biru pastel
    final Color accentPastel = const Color(0xFFF9D29D); // oranye pastel muda
    final Color textColor = Colors.black87;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 500; // adaptasi untuk tablet / web

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: isWide
              ? Row(
                  children: [
                    _buildAvatar(primaryPastel),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildGreetingText(textColor, accentPastel),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatar(primaryPastel),
                    const SizedBox(height: 16),
                    _buildGreetingText(textColor, accentPastel),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildAvatar(Color primaryPastel) {
    return GestureDetector(
      onTap: () {
        // TODO: tambahkan aksi edit foto (navigasi ke halaman edit profil / file picker)
      },
      child: CircleAvatar(
        radius: 45,
        backgroundColor: primaryPastel.withOpacity(0.5),
        backgroundImage: avatarPath != null && avatarPath!.isNotEmpty
            ? FileImage(File(avatarPath!))
            : null,
        child: avatarPath == null || avatarPath!.isEmpty
            ? const Icon(Icons.person, size: 50, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildGreetingText(Color textColor, Color accentPastel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Halo, $userName 👋",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        // const SizedBox(height: 8),
        // Text(
        //   "Semangat belajar sejarah pergerakan nasional!\n"
        //   "Setiap langkah kecil membawa kita lebih dekat pada pemahaman besar bangsa ini",
        //   style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
        // ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accentPastel.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "💡 Hari ini waktu yang baik untuk belajar sejarah pergerakan nasional!",
            style: TextStyle(fontSize: 13.5, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class UserStatsCard extends StatelessWidget {
//   final String userName;
//   final int completedMaterials;
//   final int totalProgress; // persentase progress total

//   const UserStatsCard({
//     super.key,
//     required this.userName,
//     required this.completedMaterials,
//     required this.totalProgress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 180,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               const CircleAvatar(
//                 radius: 32,
//                 // backgroundImage: AssetImage("assets/images/user.png"), // ganti sesuai aset
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       userName,
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 4),
//                     Text("Selesai: $completedMaterials materi"),
//                     const SizedBox(height: 8),
//                     LinearProgressIndicator(
//                       value: totalProgress / 100,
//                       backgroundColor: Colors.grey[300],
//                       color: Colors.blue,
//                     ),
//                     const SizedBox(height: 4),
//                     Text("$totalProgress% progress"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
