import 'package:carkett/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carkett/providers/register_data_controller.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerData = Provider.of<RegisterDataController>(context);
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Opacity(
                opacity: 0.4,
                child:
                    Image.asset('assets/images/carkett_ico.png', height: 550),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: isPortrait ? 400 : 600),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  //  backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      Icons.app_registration,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      S.current.signUp,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: S.current.name,
                      prefixIcon: Icons.person,
                      filled: true,
                      //  fillColor: theme.colorScheme.background,
                      onChanged: (value) => registerData.name = value,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: S.current.email,
                      prefixIcon: Icons.email_outlined,
                      filled: true,
                      //   fillColor: theme.colorScheme.background,
                      onChanged: (value) => registerData.email = value,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: S.current.password,
                      prefixIcon: Icons.lock_outline,
                      filled: true,
                      //   fillColor: theme.colorScheme.background,
                      obscureText: true,
                      onChanged: (value) => registerData.password = value,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: S.current.confirmPassword,
                      prefixIcon: Icons.lock,
                      filled: true,
                      //  fillColor: theme.colorScheme.background,
                      obscureText: true,
                      onChanged: (value) =>
                          registerData.confirmPassword = value,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: registerData.termsConditions,
                          onChanged: (value) {
                            if (value != null) {
                              registerData.termsConditions = value;
                            }
                          },
                        ),
                        Expanded(
                          child: Text(
                            S.current.termsConditions,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: registerData.termsConditions == false
                          ? null
                          : () async {
                              if (registerData.password ==
                                  registerData.confirmPassword) {
                                if (registerData.name.isNotEmpty &&
                                    registerData.email.isNotEmpty) {
                                  await _register(registerData, context);
                                } else {
                                  _showMessage(
                                      context, S.current.errorFillFields);
                                }
                              } else {
                                _showMessage(context, 'Passwords do not match');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      child: Text(
                        S.current.signUp,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.current.alreadyHaveAnAccount,
                          style: theme.textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () => GoRouter.of(context).pop(),
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register(
      RegisterDataController registerData, BuildContext context) async {
    final auth = AuthFirebaseService();
    final password = registerData.password;
    final email = registerData.email;
    final name = registerData.name;

    try {
      await auth.registerWithEmailAndPassword(password, email, name);
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        GoRouter.of(context).push('/');
      } else {
        throw 'Registration failed';
      }
    } catch (e) {
      _showMessage(context, 'Failed to sign up: ${e.toString()}');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
