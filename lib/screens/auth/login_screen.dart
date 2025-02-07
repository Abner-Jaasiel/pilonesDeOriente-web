import 'package:carkett/widgets/super_progressindicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:carkett/providers/register_data_controller.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      Icons.account_circle,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      S.current.welcomeToCarkett,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.current.logInToContinue,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: S.current.email,
                      prefixIcon: Icons.email_outlined,
                      filled: true,
                      onChanged: (value) => registerData.email = value,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: S.current.password,
                      prefixIcon: Icons.lock_outline,
                      filled: true,
                      obscureText: true,
                      onChanged: (value) => registerData.password = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (registerData.email.isNotEmpty &&
                            registerData.password.isNotEmpty) {
                          await _login(registerData, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.current.errorFillFields),
                            ),
                          );
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
                        S.current.logIn,
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
                          S.current.dontHaveAnAccount,
                          style: theme.textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () =>
                              GoRouter.of(context).push('/register'),
                          child: Text(S.current.signUp),
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

  Future<void> _login(
      RegisterDataController registerData, BuildContext context) async {
    superProgressIndicator(context);
    final auth = AuthFirebaseService();
    final password = registerData.password;
    final email = registerData.email;

    try {
      await auth.signOut();
      await auth.signInWithEmailAndPassword(password, email);
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        GoRouter.of(context).pop();

        GoRouter.of(context).push('/');
      } else {
        GoRouter.of(context).pop();
        throw 'The user does not exist';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log in: ${e.toString()}'),
        ),
      );
    }
  }
}
