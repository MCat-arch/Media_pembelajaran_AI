import 'package:SangKala/src/pages/chat.dart';
import 'package:SangKala/src/pages/dashboard.dart';
import 'package:SangKala/src/pages/knowledge.dart';
import 'package:SangKala/src/pages/login.dart';
import 'package:SangKala/src/pages/profile.dart';
import 'package:SangKala/src/pages/register.dart';
import 'package:SangKala/src/pages/splash_page.dart'; // ✅ Tambahkan Splash
import 'package:SangKala/src/providers/auth_provider.dart';
import 'package:SangKala/src/providers/material_provider.dart';
import 'package:SangKala/src/providers/progress_provider.dart';
import 'package:SangKala/src/providers/quiz_provider.dart';
import 'package:SangKala/src/widget/content_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/controllers/chat_controller.dart';

void main() {
  // WidgetsBinding.instance.addPostFrameCallback();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MaterialProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        // 🔑 ProxyProvider agar ProgressProvider dapat token dari AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, ProgressProvider>(
          create: (_) => ProgressProvider(
            baseUrl:
                "https://besangkala-production.up.railway.app/api/progress",
          ),
          update: (_, authProvider, previous) {
            previous?.setToken(authProvider.token ?? "");
            return previous!;
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          // ✅ Start dari Splash Screen
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashPage(),
            '/home': (context) => const MyHomePage(),
            '/detailMateri': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>;
              return ContentViewer(
                materi: args['materi'],
                initialIndex: args['index'] ?? 0,
              );
            }, // ganti nanti
            '/quiz': (context) => const Placeholder(),
            '/chatAI': (context) => const Chat(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [Dashboard(), Knowledge(), ProfilePage()];

  void _onClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onClick,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: Colors.deepPurpleAccent,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                activeIcon: Icon(
                  Icons.home_rounded,
                  color: Colors.deepPurpleAccent,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_rounded),
                activeIcon: Icon(
                  Icons.book_rounded,
                  color: Colors.deepPurpleAccent,
                ),
                label: "Materi",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded),
                activeIcon: Icon(
                  Icons.person_2_rounded,
                  color: Colors.deepPurpleAccent,
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = const [Dashboard(), Knowledge(), ProfilePage()];

//   void _onClick(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Jika mau fetch progress otomatis:
//     // Future.microtask(() {
//     //   context.read<ProgressProvider>().fetchProgress();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onClick,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_rounded, color: Colors.black),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book_rounded, color: Colors.black),
//             label: "Materi",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_2_rounded, color: Colors.black),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:ai/src/pages/chat.dart';
// import 'package:ai/src/pages/dashboard.dart';
// import 'package:ai/src/pages/knowledge.dart';
// import 'package:ai/src/pages/login.dart';
// import 'package:ai/src/pages/profile.dart';
// import 'package:ai/src/pages/register.dart';
// import 'package:ai/src/providers/auth_provider.dart';
// import 'package:ai/src/providers/material_provider.dart';
// import 'package:ai/src/providers/progress_provider.dart';
// import 'package:ai/src/providers/quiz_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'src/controllers/chat_controller.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ChatController()),
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => MaterialProvider()),
//         ChangeNotifierProvider(create: (_) => QuizProvider()),
//         // 🔑 ProxyProvider agar ProgressProvider dapat token dari AuthProvider
//         ChangeNotifierProxyProvider<AuthProvider, ProgressProvider>(
//           create: (_) => ProgressProvider(
//             baseUrl: "http://localhost:5000/api/progress",
//             // token: "",
//           ), // sementara kosong
//           update: (_, authProvider, previous) {
//             previous?.setToken(authProvider.token ?? "");
//             return previous!;
//           },
//         ),
//       ],
//       child: MainApp(),
//     ),
//   );
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, _) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(primarySwatch: Colors.blue),
//           initialRoute: auth.isAuthenticated ? '/home' : '/login',
//           routes: {
//             '/home': (context) => const MyHomePage(),
//             '/detailMateri': (context) => const Placeholder(), // ganti nanti
//             '/quiz': (context) => const Placeholder(),
//             '/chatAI': (context) => const Chat(),
//             '/login': (context) => const LoginPage(),
//             '/register': (context) => const RegisterPage(),
//           },
//         );
//       },
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = const [Dashboard(), Knowledge(), ProfilePage()];

//   void _onClick(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Future.microtask(() {
//     //   context.read<ProgressProvider>().fetchProgress();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onClick,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_rounded, color: Colors.black),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book_rounded, color: Colors.black),
//             label: "Knowledge",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_2_rounded, color: Colors.black),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }
