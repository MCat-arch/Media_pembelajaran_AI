import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF92B4EC); // pastel biru
    final Color accentColor = const Color(0xFFF9D29D); // pastel oranye

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        backgroundColor: primaryColor,
        elevation: 2,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? constraints.maxWidth * 0.15 : 20,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian deskripsi aplikasi
                Center(
                  child: Text(
                    "Tentang Aplikasi",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Aplikasi ini dirancang untuk membantu pengguna dalam mempelajari sejarah pergerakan nasional. "
                  "Dengan tampilan dan fitur yang disesuaikan dengan siswa sekolah, seperti fitur ai dan tampilan yang minimalis."
                  "Aplikasi ini diharapkan dapat memberikan pengalaman yang sederhana, efisien, "
                  "dan ramah pengguna dalam satu platform.",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Nama pengembang
                Text(
                  "Pengembang",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                _buildDeveloperCard("Tami", "Developer", accentColor),
                _buildDeveloperCard(
                  "Hani",
                  "Database Engineer",
                  Colors.greenAccent.shade100,
                ),
                _buildDeveloperCard(
                  "Alwi",
                  "App Content",
                  Colors.purpleAccent.shade100,
                ),

                const SizedBox(height: 24),

                // Daftar pustaka / referensi
                Text(
                  "Daftar Pustaka",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                const _ReferenceItem(
                  title: "Flutter Documentation",
                  link: "https://docs.flutter.dev/",
                ),
                const _ReferenceItem(
                  title: "Material Design Guidelines",
                  link: "https://m3.material.io/",
                ),
                const _ReferenceItem(
                  title: "Dart Language Tour",
                  link: "https://dart.dev/guides/language/language-tour",
                ),
                const _ReferenceItem(
                  title: "Organisasi Budi Utomo",
                  link:
                      "https://idsejarah.net/2016/01/organisasi-budi-utomo.html ",
                ),
                const _ReferenceItem(
                  title: "Jong Celebes Indonesia",
                  link:
                      "https://www.riau1.com/berita/politik/1603546873-jong-celebes-organisasi-pemuda-penentang-kolonial-belanda ",
                ),
                const _ReferenceItem(
                  title: "Jong Ambon Indonesia",
                  link: "https://www.tribunnewswiki.com/2021/08/15/jong-ambon",
                ),
                const _ReferenceItem(
                  title: "Sumpah Pemuda",
                  link:
                      "https://www.dewantaranews.com/nasional/89910659046/kongres-pemuda-ii-tonggak-bersejarah-dalam-perjalanan-kemerdekaan-indonesia",
                ),
                const _ReferenceItem(
                  title: "Partai Nasional Indonesia",
                  link:
                      "https://www.kompas.com/skola/read/2020/12/25/190917069/partai-politik-indonesia-dalam-volksraad?page=all. ",
                ),
                const SizedBox(height: 30),

                // Versi aplikasi
                Center(
                  child: Text(
                    "Versi Aplikasi 1.0.0",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeveloperCard(String name, String role, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      color: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.6),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(role),
      ),
    );
  }
}

class _ReferenceItem extends StatelessWidget {
  final String title;
  final String link;

  const _ReferenceItem({required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.link, color: Colors.blueAccent),
      title: Text(title),
      subtitle: Text(link, style: const TextStyle(color: Colors.blue)),
      onTap: () {
        // TODO: Tambahkan fungsi peluncur URL jika dibutuhkan
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }
}
