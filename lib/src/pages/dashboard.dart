import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/progress_provider.dart';
import '../providers/material_provider.dart';
import '../providers/auth_provider.dart';
import '../models/materi.model.dart';
import 'package:SangKala/src/pages/detail.material.dart';
import 'package:SangKala/src/pages/chat.dart';
import 'package:SangKala/src/widget/material.card.dart';
import 'package:SangKala/src/widget/user_stats_card.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _initialized = false;
  String? _avatarPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadInitialData();
      _loadAvatarPath();
    }
  }

  Future<void> _loadAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('user_avatar');
    if (mounted) {
      setState(() {
        _avatarPath = path;
      });
    }
  }

  Future<void> _loadInitialData() async {
    final progressProvider = context.read<ProgressProvider>();
    final materialProvider = context.read<MaterialProvider>();

    await progressProvider.fetchProgress();
    await materialProvider.fetchMaterials(forceRefresh: false);
    setState(() {}); // supaya rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProgressProvider>(
      builder: (context, authProvider, progressProvider, _) {
        final materialProvider = context.read<MaterialProvider>();

        final activeProgress = progressProvider.activeProgress;
        final isLoadingProgress = progressProvider.isLoading;
        final userName = authProvider.user?.username ?? "Guest";

        if (isLoadingProgress && activeProgress == null) {
          return const Center(child: CircularProgressIndicator());
        }

        Widget bodyContent;
        if (activeProgress == null) {
          bodyContent = Card(
            color: AppColors.secondary,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Belum ada materi aktif", style: AppFonts.body),
            ),
          );
        } else {
          final materi = activeProgress.material;
          Materi? nextMateri = materialProvider.getNextMateri(materi);
          final imageUrl = (materi.img.isNotEmpty)
              ? materi.img
              : 'https://via.placeholder.com/600x400?text=No+Image';

          bodyContent = ActiveMaterialCard(
            materialTitle: materi.title,
            materialImage: imageUrl,
            lastSlide: (activeProgress.currentIndex ?? 0) + 1,
            onContinue: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MaterialDetailPage(materi: materi),
                ),
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              "Sang Kala",
              style: AppFonts.subHeading.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👋 Greeting
                // Text(
                //   "Selamat datang, $userName 👋",
                //   style: AppFonts.heading.copyWith(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 20),

                // 📊 User stats
                UserGreetingCard(
                  userName: userName,
                  avatarPath: _avatarPath,
                  // completedMaterials: progressProvider.completedMaterialCount,
                  // totalProgress: progressProvider.progressPercentage,
                ),
                const SizedBox(height: 24),

                // 📚 Materi Aktif
                Center(child: Text("Materi Aktif", style: AppFonts.subHeading)),
                const SizedBox(height: 12),
                Center(child: bodyContent),
              ],
            ),
          ),

          // 🤖 Floating AI Chat Button
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Chat()),
              );
            },
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
          ),
        );
      },
    );
  }
}

// import 'package:ai/src/pages/chat.dart';
// import 'package:ai/src/widget/material.card.dart';
// import 'package:ai/src/widget/user_stats_card.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/progress_provider.dart';
// import '../providers/material_provider.dart';
// import '../models/materi.model.dart';
// import 'package:ai/src/pages/detail.material.dart';

// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       _initialized = true;
//       _loadInitialData();
//     }
//   }

//   Future<void> _loadInitialData() async {
//     final progressProvider = context.read<ProgressProvider>();
//     final materialProvider = context.read<MaterialProvider>();

//     await progressProvider.fetchProgress();
//     await materialProvider.fetchMaterials(forceRefresh: false);
//     setState(() {}); // supaya rebuild
//   }

//   @override
//   Widget build(BuildContext context) {
//     final progressProvider = context.watch<ProgressProvider>();
//     final materialProvider = context.read<MaterialProvider>();

//     final activeProgress = progressProvider.activeProgress;
//     final isLoadingProgress = progressProvider.isLoading;
//     final userName = progressProvider.getUsername;

//     // jika masih loading progress
//     if (isLoadingProgress && activeProgress == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     Widget bodyContent;
//     if (activeProgress == null) {
//       bodyContent = Center(
//         child: Card(
//           margin: const EdgeInsets.all(16),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Text("Belum ada materi aktif"),
//           ),
//         ),
//       );
//     } else {
//       final materi = activeProgress.material;
//       Materi? nextMateri = materialProvider.getNextMateri(materi);
//       final imageUrl = (materi.img.isNotEmpty)
//           ? materi.img
//           : 'https://via.placeholder.com/600x400?text=No+Image';

//       bodyContent = ActiveMaterialCard(
//         materialTitle: materi.title,
//         materialImage: imageUrl,
//         // imageHeight: 220, // 🖼️ gambar diperbesar
//         lastSlide: (activeProgress.currentIndex ?? 0) + 1,
//         onContinue: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => MaterialDetailPage(materi: materi!),
//             ),
//           );
//         },
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//         centerTitle: true,
//         elevation: 7,
//       ),
//       body: SingleChildScrollView(
//         // biar bisa scroll
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 👋 Greeting
//             Text(
//               "Selamat datang, $userName 👋",
//               style: Theme.of(
//                 context,
//               ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             // 📊 User stats (dibuat lebih tinggi)
//             UserStatsCard(
//               userName: userName,
//               completedMaterials: progressProvider.completedMaterialCount,
//               totalProgress: progressProvider.progressPercentage,
//               // height: 180, // card user lebih tinggi
//             ),
//             const SizedBox(height: 20),

//             // 📚 Materi Aktif
//             Text(
//               "Materi Aktif",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 10),
//             bodyContent,
//           ],
//         ),
//       ),

//       // 🤖 Floating AI Chat Button
//       floatingActionButton: FloatingActionButton(
//         shape: const CircleBorder(),
//         backgroundColor: Colors.blue,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const Chat()),
//           );
//         },
//         child: const Icon(
//           Icons.smart_toy_rounded,
//           color: Colors.white,
//         ), // 🤖 robotic icon
//       ),
//     );
//   }
// }

// // import 'package:ai/src/pages/chat.dart';
// // import 'package:ai/src/widget/material.card.dart';
// // import 'package:ai/src/widget/user_stats_card.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/progress_provider.dart';
// // import '../providers/material_provider.dart';
// // import '../models/materi.model.dart';
// // import 'package:ai/src/pages/detail.material.dart';

// // class Dashboard extends StatefulWidget {
// //   const Dashboard({super.key});

// //   @override
// //   State<Dashboard> createState() => _DashboardState();
// // }

// // class _DashboardState extends State<Dashboard> {
// //   bool _initialized = false;

// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     if (!_initialized) {
// //       _initialized = true;
// //       _loadInitialData();
// //     }
// //   }

// //   Future<void> _loadInitialData() async {
// //     final progressProvider = context.read<ProgressProvider>();
// //     final materialProvider = context.read<MaterialProvider>();

// //     // Pastikan token sudah di-set sebelumnya
// //     // Fetch progress & materials
// //     await progressProvider.fetchProgress();
// //     await materialProvider.fetchMaterials(forceRefresh: false);
// //     setState(() {
// //       // supaya rebuild
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final progressProvider = context.watch<ProgressProvider>();
// //     final materialProvider = context.watch<MaterialProvider>();

// //     final activeProgress = progressProvider.activeProgress;
// //     final isLoadingProgress = progressProvider.isLoading;

// //     // jika masih loading progress
// //     if (isLoadingProgress && activeProgress == null) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     Widget bodyContent;

// //     if (activeProgress == null) {
// //       bodyContent = Center(
// //         child: Card(
// //           margin: const EdgeInsets.all(16),
// //           child: Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Text("Belum ada materi aktif"),
// //           ),
// //         ),
// //       );
// //     } else {
// //       final materi = activeProgress.material;
// //       final imageUrl = (materi.img.isNotEmpty)
// //           ? materi.img
// //           : 'https://via.placeholder.com/600x400?text=No+Image';

// //       bodyContent = ActiveMaterialCard(
// //         materialTitle: materi.title,
// //         materialImage: imageUrl,
// //         // gunakan field yang sesuai (currentPage atau currentIndex)
// //         lastSlide: (activeProgress.currentIndex ?? 0) + 1,
// //         onContinue: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => MaterialDetailPage(materi: materi),
// //             ),
// //           );
// //         },
// //       );
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Dashboard"),
// //         centerTitle: true,
// //         elevation: 7,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             UserStatsCard(
// //               userName: progressProvider.getUsername,
// //               completedMaterials: progressProvider.completedMaterialCount,
// //               totalProgress: progressProvider.progressPercentage,
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               "Materi Aktif",
// //               style: Theme.of(context).textTheme.titleMedium,
// //             ),
// //             const SizedBox(height: 10),
// //             bodyContent,
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         shape: const CircleBorder(),
// //         backgroundColor: Colors.blue,
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => const Chat()),
// //           );
// //         },
// //         child: const Icon(Icons.chat, color: Colors.white),
// //       ),
// //     );
// //   }
// // }
