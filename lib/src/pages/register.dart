import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sign Up",
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
                // Title
                Text(
                  "Buat Akun Baru",
                  style: AppFonts.heading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Gabung untuk mulai menjelajahi sejarah Indonesia dengan cara yang seru!",
                  style: AppFonts.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondary,
                    labelText: "Username",
                    labelStyle: AppFonts.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? "Please enter username" : null,
                ),
                const SizedBox(height: 16),

                // Email
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

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
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
                  validator: (val) =>
                      val!.isEmpty ? "Please enter password" : null,
                ),
                const SizedBox(height: 24),

                // Register button
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
                              final success = await auth.register(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registration success"),
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/login",
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registration failed"),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Register",
                            style: AppFonts.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 12),

                // Already have account
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: Text(
                    "Already have an account? Login",
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign Up")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(labelText: "Username"),
//                   validator: (val) =>
//                       val!.isEmpty ? "Please enter username" : null,
//                 ),
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
//                             final success = await auth.register(
//                               _usernameController.text,
//                               _emailController.text,
//                               _passwordController.text,
//                             );
//                             if (success && mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text("Registration success")),
//                               );
//                               Navigator.pushReplacementNamed(context, "/login");
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text("Registration failed")),
//                               );
//                             }
//                           }
//                         },
//                         child: const Text("Register"),
//                       ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, "/login");
//                   },
//                   child: const Text("Already have an account? Login"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
