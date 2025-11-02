import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  // Fungsi pembuka link, telp, dan email
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Tidak dapat membuka $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryPastel = const Color(0xFF92B4EC);
    final Color accentPastel = const Color(0xFFBEE1E6);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
      appBar: AppBar(
        title: const Text(
          "Pusat Bantuan",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pengantar
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: accentPastel.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Jika Anda mengalami gangguan dalam penggunaan aplikasi, "
                  "seperti masalah login, data tidak muncul, atau kesulitan dalam mengikuti materi, "
                  "silakan hubungi kami melalui kontak di bawah ini. "
                  "Tim kami akan dengan senang hati membantu Anda 😊",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Judul bagian kontak
              Text(
                "Kontak Kami",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // Daftar kontak
              _buildContactTile(
                icon: Icons.phone,
                title: "Hubungi via Telepon",
                subtitle: "+6288215767052",
                color: primaryPastel,
                onTap: () => _launchUrl("tel:+6288215767052"),
              ),
              const SizedBox(height: 10),

              _buildContactTile(
                icon: Icons.email,
                title: "Kirim Email",
                subtitle: "SangKala@gmail.com",
                color: Colors.orangeAccent.shade100,
                onTap: () => _launchUrl("khoerunnisautami22@gmail.com"),
              ),
              const SizedBox(height: 10),

              _buildContactTile(
                icon: Icons.message_rounded,
                title: "Chat WhatsApp",
                subtitle: "Klik untuk membuka obrolan langsung",
                color: Colors.greenAccent.shade100,
                onTap: () => _launchUrl("https://wa.me/6288215767052"),
              ),
              const SizedBox(height: 10),

              // _buildContactTile(
              //   icon: Icons.public,
              //   title: "Kunjungi Website",
              //   subtitle: "https://www.appku.id/support",
              //   color: Colors.purpleAccent.shade100,
              //   onTap: () => _launchUrl("https://www.appku.id/support"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[700], fontSize: 13),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
