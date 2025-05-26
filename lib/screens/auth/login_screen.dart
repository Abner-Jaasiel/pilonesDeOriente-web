/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:pilones_de_oriente/service/auth_firebase_service.dart';
import 'package:pilones_de_oriente/service/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        await AuthFirebaseService().signInWithEmailAndPassword(password, email);

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String? role = await FirebaseService().getCurrentUserRole();

          final String adminRole = dotenv.env['ADMIN_ROLE'] ?? 'admin';
          final String userRole = dotenv.env['ROLE_FORM'] ?? 'form';
          final String ordersRole = dotenv.env['ROLE_ORDERS_AND_DELIVERIES'] ??
              'orders_and_deliveries';
          final String reportsRole = dotenv.env['ROLE_REPORTS'] ?? 'reports';

          if (role == adminRole) {
            context.go("/admin");
          } else if (role == userRole) {
            context.go("/formSent");
          } else if (role == ordersRole) {
            context.go("/Orders");
          } else if (role == reportsRole) {
            context.go("/reports");
          } else {
            context.go("/");
          }
        } else {
          throw Exception("User not authenticated");
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage =
            "Ocurrió un error. Por favor, inténtelo de nuevo.";
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = "No se encontró un usuario con este correo.";
              break;
            case 'wrong-password':
              errorMessage = "Contraseña incorrecta.";
              break;
            case 'invalid-email':
              errorMessage = "Dirección de correo inválida.";
              break;
            case 'user-disabled':
              errorMessage = "Esta cuenta ha sido deshabilitada.";
              break;
            default:
              errorMessage =
                  "Error de inicio de sesión. Por favor, inténtelo de nuevo.";
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Color.fromARGB(255, 72, 72, 72);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            /* gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade700, Colors.blue.shade300],
          ),*/
            ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                ),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bienvendio a Pilones de Oriente',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: color,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: color),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo';
                              } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+")
                                  .hasMatch(value)) {
                                return 'Por favor ingrese un correo valido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: color,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: color),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24.0),
                          _isLoading
                              ? CircularProgressIndicator(color: color)
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    //  backgroundColor: Colors.blue.shade800,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'Iniciar Sesión',
                                      style:
                                          TextStyle(fontSize: 16, color: color),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:pilones_de_oriente/service/auth_firebase_service.dart';
import 'package:pilones_de_oriente/service/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Load saved credentials from SharedPreferences, with web fallback
  Future<void> _loadSavedCredentials() async {
    if (kIsWeb) {
      // En web, intentamos usar SharedPreferences pero manejamos el fallo
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedEmail = prefs.getString('email') ?? '';
        final savedPassword = prefs.getString('password') ?? '';

        setState(() {
          _emailController.text = savedEmail;
          _passwordController.text = savedPassword;
        });
      } catch (e) {
        debugPrint('SharedPreferences no disponible en web: $e');
        // Continuamos sin autocompletar si falla
      }
    } else {
      // En plataformas móviles, usamos SharedPreferences normalmente
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('email') ?? '';
      final savedPassword = prefs.getString('password') ?? '';

      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      });
    }
  }

  // Save credentials to SharedPreferences, with web fallback
  Future<void> _saveCredentials(String email, String password) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      } catch (e) {
        debugPrint('No se pudo guardar en SharedPreferences en web: $e');
        // Continuamos sin guardar si falla
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    }
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        // Intentamos guardar las credenciales antes del login
        await _saveCredentials(email, password);

        await AuthFirebaseService().signInWithEmailAndPassword(password, email);

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String? role = await FirebaseService().getCurrentUserRole();

          final String adminRole = dotenv.env['ADMIN_ROLE'] ?? 'admin';
          final String userRole = dotenv.env['ROLE_FORM'] ?? 'form';
          final String ordersRole = dotenv.env['ROLE_ORDERS_AND_DELIVERIES'] ??
              'orders_and_deliveries';
          final String reportsRole = dotenv.env['ROLE_REPORTS'] ?? 'reports';

          if (role == adminRole) {
            context.go("/admin");
          } else if (role == userRole) {
            context.go("/formSent");
          } else if (role == ordersRole) {
            context.go("/Orders");
          } else if (role == reportsRole) {
            context.go("/reports");
          } else {
            context.go("/");
          }
        } else {
          throw Exception("User not authenticated");
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage =
            "Ocurrió un error. Por favor, inténtelo de nuevo.";
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = "No se encontró un usuario con este correo.";
              break;
            case 'wrong-password':
              errorMessage = "Contraseña incorrecta.";
              break;
            case 'invalid-email':
              errorMessage = "Dirección de correo inválida.";
              break;
            case 'user-disabled':
              errorMessage = "Esta cuenta ha sido deshabilitada.";
              break;
            default:
              errorMessage =
                  "Error de inicio de sesión. Por favor, inténtelo de nuevo.";
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Color.fromARGB(255, 72, 72, 72);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            /* gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade700, Colors.blue.shade300],
          ), */
            ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                ),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bienvenido a Pilones de Oriente',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: color,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: color),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo';
                              } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+")
                                  .hasMatch(value)) {
                                return 'Por favor ingrese un correo válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: color,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: color),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24.0),
                          _isLoading
                              ? CircularProgressIndicator(color: color)
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'Iniciar Sesión',
                                      style:
                                          TextStyle(fontSize: 16, color: color),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
