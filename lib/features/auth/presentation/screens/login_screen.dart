import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import 'signup_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI states
  bool isLoading = false;
  bool showPassword = false;

  // =========================
  // LOGIN FUNCTION
  // =========================

  Future<void> login() async {
    // Check empty fields
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showMessage('Please enter email and password');
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Call Cubit
    final success = await context.read<AuthCubit>().login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      showMessage('Invalid email or password');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =========================
              // LOGO
              // =========================
              Center(
                child: Container(
                  height: 75,
                  width: 75,

                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: const Icon(
                    Icons.apps_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // TITLE
              // =========================
              const Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'Login to continue to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // EMAIL LABEL
              // =========================
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // EMAIL FIELD
              // =========================
              TextField(
                controller: emailController,

                keyboardType: TextInputType.emailAddress,

                decoration: const InputDecoration(
                  hintText: 'Enter your email',

                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // PASSWORD LABEL
              // =========================
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // PASSWORD FIELD
              // =========================
              TextField(
                controller: passwordController,

                obscureText: !showPassword,

                decoration: InputDecoration(
                  hintText: 'Enter your password',

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.primaryColor,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },

                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,

                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // =========================
              // FORGOT PASSWORD
              // =========================
              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: () {
                    // We will add Firebase
                    // password reset later.
                  },

                  child: const Text(
                    'Forgot Password?',

                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // LOGIN BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: isLoading ? null : login,

                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,

                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Login',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // SIGNUP LINK
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(
                    "Don't have an account?",

                    style: TextStyle(color: AppTheme.secondaryTextColor),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Sign Up',

                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
