import 'dart:io';
import 'package:SangKala/src/pages/bantuan.dart';
import 'package:SangKala/src/pages/tentang.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('user_avatar');
    if (path != null && mounted) {
      setState(() => _avatarFile = File(path));
    }
  }

  Future<void> _saveAvatar(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_avatar', path);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      final file = File(pickedFile.path);
      await _saveAvatar(file.path);
      setState(() => _avatarFile = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user == null) {
      return const Scaffold(
        body: Center(child: Text("No user data available")),
      );
    }

    final user = authProvider.user!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            _buildProfileHeader(user.username, user.email),
            const SizedBox(height: 28),
            SettingsSection(
              onLogout: () {
                authProvider.logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    final Color primaryPastel = const Color(0xFF92B4EC);

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryPastel.withOpacity(0.4),
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : null,
                  child: _avatarFile == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryPastel,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
      ],
    );
  }
}

class SettingsSection extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsSection({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final Color primaryPastel = const Color(0xFF92B4EC);
    final Color accentPastel = const Color(0xFFF9D29D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            "Pengaturan",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        Card(
          elevation: 3,
          shadowColor: Colors.black12.withOpacity(0.1),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                _buildSettingTile(
                  context,
                  icon: Icons.settings,
                  title: "Pengaturan Akun",
                  subtitle: "Kelola informasi dan preferensi akun Anda",
                  color: primaryPastel,
                  onTap: () {
                    // TODO: buat halaman Pengaturan Akun
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Halaman Pengaturan Akun belum dibuat"),
                      ),
                    );
                  },
                ),
                // const Divider(height: 1, indent: 16),
                // _buildSettingTile(
                //   context,
                //   icon: Icons.privacy_tip,
                //   title: "Privasi & Keamanan",
                //   subtitle: "Kontrol data pribadi dan keamanan login",
                //   color: accentPastel,
                //   onTap: () {},
                // ),
                const Divider(height: 1, indent: 16),
                _buildSettingTile(
                  context,
                  icon: Icons.help_outline,
                  title: "Bantuan",
                  subtitle: "Dapatkan panduan dan dukungan pengguna",
                  color: Colors.greenAccent.shade100,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  },
                ),
                const Divider(height: 1, indent: 16),
                _buildSettingTile(
                  context,
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                  subtitle: "Pelajari lebih lanjut tentang platform ini",
                  color: Colors.purpleAccent.shade100,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            icon: const Icon(Icons.logout),
            label: const Text(
              "Keluar Akun",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onPressed: onLogout,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: color?.withOpacity(0.25) ?? Colors.blue.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: color ?? Colors.blueAccent, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// // src/pages/profile_page.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   File? _avatarFile;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _loadAvatar();
//   }

//   /// Ambil foto profil dari SharedPreferences
//   Future<void> _loadAvatar() async {
//     final prefs = await SharedPreferences.getInstance();
//     final path = prefs.getString('user_avatar');
//     if (path != null && mounted) {
//       setState(() => _avatarFile = File(path));
//     }
//   }

//   /// Simpan foto profil ke SharedPreferences
//   Future<void> _saveAvatar(String path) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_avatar', path);
//   }

//   /// Pilih gambar dari galeri
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null && mounted) {
//       final file = File(pickedFile.path);
//       await _saveAvatar(file.path);
//       setState(() => _avatarFile = file);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     if (authProvider.user == null) {
//       return const Scaffold(
//         body: Center(child: Text("No user data available")),
//       );
//     }

//     final user = authProvider.user!;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FBFD),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black87,
//         title: const Text(
//           "Profil Saya",
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//         centerTitle: true,
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.logout_rounded),
//         //     onPressed: () {
//         //       authProvider.logout();
//         //       Navigator.pop(context);
//         //     },
//         //   ),
//         // ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//         child: Column(
//           children: [
//             _buildProfileHeader(user.username, user.email),
//             const SizedBox(height: 32),
//             _buildSettingsSection(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader(String name, String email) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: _pickImage,
//           child: Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.blue.shade100, width: 3),
//                 ),
//                 child: CircleAvatar(
//                   radius: 56,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: _avatarFile != null
//                       ? FileImage(_avatarFile!)
//                       : null,
//                   child: _avatarFile == null
//                       ? const Icon(Icons.person, size: 60, color: Colors.grey)
//                       : null,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: const BoxDecoration(
//                   color: Colors.blueAccent,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.edit, color: Colors.white, size: 18),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           name,
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(email, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
//       ],
//     );
//   }

//   Widget _buildSettingsSection(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Column(
//           children: [
//             _buildSettingTile(
//               icon: Icons.settings,
//               title: "Pengaturan Akun",
//               onTap: () {},
//             ),
//             const Divider(height: 1, indent: 16),
//             _buildSettingTile(
//               icon: Icons.privacy_tip,
//               title: "Privasi & Keamanan",
//               onTap: () {},
//             ),
//             const Divider(height: 1, indent: 16),
//             _buildSettingTile(
//               icon: Icons.help_outline,
//               title: "Bantuan",
//               onTap: () {},
//             ),
//             const Divider(height: 1, indent: 16),
//             _buildSettingTile(
//               icon: Icons.info_outline,
//               title: "Tentang Aplikasi",
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingTile({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color ?? Colors.blueAccent),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: color ?? Colors.black87,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       trailing: const Icon(Icons.chevron_right, color: Colors.grey),
//       onTap: onTap,
//     );
//   }
// }
