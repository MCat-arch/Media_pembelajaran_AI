import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/material_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Login",
            style: AppFonts.subHeading.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Selamat Datang Kembali",
                  style: AppFonts.heading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Masuk untuk melanjutkan perjalanan belajar sejarah Indonesia",
                  style: AppFonts.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondary,
                    labelText: "Email",
                    labelStyle: AppFonts.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? "Please enter email" : null,
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondary,
                    labelText: "Password",
                    labelStyle: AppFonts.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter password" : null,
                ),
                const SizedBox(height: 24),

                // Button
                auth.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final success = await auth.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                                debugPrint("🔎 FE login success: $success");

                                if (success) {
                                  final materialProvider = context
                                      .read<MaterialProvider>();
                                  final token = auth.token;
                                  final user = auth.user;

                                  final progressProvider = context
                                      .read<ProgressProvider>();
                                  progressProvider.fetchProgress();
                                  progressProvider.setUser(auth.user!);
                                  if (token != null) {
                                    debugPrint("✅ Token didapat: $token");
                                    debugPrint(
                                      "Active Material ${progressProvider.activeProgress}",
                                    );
                                    progressProvider.setToken(token);

                                    if (user?.progress != null) {
                                      progressProvider.setProgress(
                                        user?.progress,
                                      );
                                      progressProvider.setActiveProgress(
                                        user?.progress,
                                      );
                                      debugPrint(
                                        "✅ Active progress di-set dari login:${user?.progress!.toJson()}",
                                      );
                                    } else {
                                      // await progressProvider.fetchProgress();
                                      debugPrint(
                                        "fetch progress setelah login :  ${progressProvider.activeProgress?.toJson()}",
                                      );
                                    }
                                  } else {
                                    debugPrint(
                                      "⚠️ Login success tapi token null",
                                    );
                                  }

                                  await materialProvider.fetchMaterials(
                                    forceRefresh: true,
                                  );
                                  debugPrint(
                                    "✅ fetchMaterials done: ${materialProvider.materiList.length}",
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Login success"),
                                    ),
                                  );
                                  Navigator.pushReplacementNamed(
                                    context,
                                    "/home",
                                  );
                                } else {
                                  debugPrint(
                                    "❌ Login gagal, token tidak didapat",
                                  );
                                }
                              } catch (e, stack) {
                                debugPrint("❌ Error di LoginPage: $e");
                                debugPrint("📌 Stacktrace: $stack");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Unexpected error occurred"),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: AppFonts.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 12),

                // Register link
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/register");
                  },
                  child: Text(
                    "Tidak Memiliki Akun? Daftar",
                    style: AppFonts.body.copyWith(
                      color: const Color.fromARGB(255, 230, 176, 176),
                      fontWeight: FontWeight.w600,
                    ),
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

// import 'package:ai/src/models/progress.model.dart';
// import 'package:ai/src/providers/material_provider.dart';
// import 'package:ai/src/providers/progress_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(labelText: "Email"),
//                   validator: (val) =>
//                       val!.isEmpty ? "Please enter email" : null,
//                 ),
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(labelText: "Password"),
//                   obscureText: true,
//                   validator: (val) =>
//                       val!.isEmpty ? "Please enter password" : null,
//                 ),
//                 const SizedBox(height: 20),
//                 auth.isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             try {
//                               final success = await auth.login(
//                                 _emailController.text,
//                                 _passwordController.text,
//                               );
//                               debugPrint("🔎 FE login success: $success");

//                               if (success) {
//                                 final materialProvider = context
//                                     .read<MaterialProvider>();
//                                 final token = auth.token;
//                                 final user = auth.user;

//                                 final progressProvider = context
//                                     .read<ProgressProvider>();
//                                 progressProvider.fetchProgress();
//                                 if (token != null) {
//                                   debugPrint("✅ Token didapat: $token");
//                                   debugPrint(
//                                     "Active Material ${progressProvider.activeProgress}",
//                                   );
//                                   progressProvider.setToken(token);

//                                   if (user?.progress != null) {
//                                     progressProvider.setProgress(
//                                       user?.progress,
//                                     );
//                                     progressProvider.setActiveProgress(
//                                       user?.progress,
//                                     );
//                                     debugPrint(
//                                       "✅ Active progress di-set dari login:${user?.progress!.toJson()}",
//                                     );
//                                   } else {
//                                     // await progressProvider.fetchProgress();
//                                     debugPrint(
//                                       "fetch progress setelah login :  ${progressProvider.activeProgress?.toJson()}",
//                                     );
//                                   }
//                                 } else {
//                                   debugPrint(
//                                     "⚠️ Login success tapi token null",
//                                   );
//                                 }

//                                 await materialProvider.fetchMaterials(
//                                   forceRefresh: true,
//                                 );
//                                 debugPrint(
//                                   "✅ fetchMaterials done: ${materialProvider.materiList.length}",
//                                 );

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Login success"),
//                                   ),
//                                 );
//                                 Navigator.pushReplacementNamed(
//                                   context,
//                                   "/home",
//                                 );
//                               } else {
//                                 debugPrint(
//                                   "❌ Login gagal, token tidak didapat",
//                                 );
//                               }
//                             } catch (e, stack) {
//                               debugPrint("❌ Error di LoginPage: $e");
//                               debugPrint("📌 Stacktrace: $stack");
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Unexpected error occurred"),
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                         child: const Text("Login"),
//                       ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, "/register");
//                   },
//                   child: const Text("Don't have an account? Sign up"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
