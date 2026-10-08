import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import 'login_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;

  // =========================
  // SIGNUP FUNCTION
  // =========================
  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Check empty fields
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    // Password validation
    if (password.length < 6) {
      showMessage(
        'Password must be at least 6 characters',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Call AuthCubit signup
    final error =
        await context.read<AuthCubit>().signup(
              name,
              email,
              password,
            );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    // If signup failed
    if (error != null) {
      handleSignupError(error);
      return;
    }

    // Signup successful
    showMessage('Account created successfully');

    // Go to Home Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  // =========================
  // SIGNUP ERROR HANDLING
  // =========================
  void handleSignupError(String error) {
    if (error == 'email-already-in-use') {
      showMessage(
        'This email is already registered',
      );
    } else if (error == 'weak-password') {
      showMessage(
        'Password is too weak',
      );
    } else if (error == 'invalid-email') {
      showMessage(
        'Please enter a valid email',
      );
    } else {
      showMessage(
        'Could not create account. Please try again.',
      );
    }
  }

  // =========================
  // SHOW MESSAGE
  // =========================
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text('Create Account'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // =========================
              // TITLE
              // =========================

              const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'Create your account to get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        AppTheme.secondaryTextColor,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // =========================
              // NAME
              // =========================

              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: nameController,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color:
                        AppTheme.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // EMAIL
              // =========================

              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color:
                        AppTheme.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // PASSWORD
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

              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                textInputAction:
                    TextInputAction.done,
                decoration:
                    InputDecoration(
                  hintText:
                      'Enter your password',

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color:
                        AppTheme.primaryColor,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword =
                            !showPassword;
                      });
                    },

                    icon: Icon(
                      showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color:
                          AppTheme.secondaryTextColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // SIGNUP BUTTON
              // =========================

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : signup,

                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // LOGIN LINK
              // =========================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color:
                          AppTheme.secondaryTextColor,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color:
                            AppTheme.primaryColor,
                        fontWeight:
                            FontWeight.bold,
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