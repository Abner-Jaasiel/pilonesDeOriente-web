import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/models/user_model.dart';
import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/services/file_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/custom_appbar_widget.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:carkett/widgets/map_buttom_widget.dart';
import 'package:carkett/widgets/super_progressindicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:provider/provider.dart';

class LoginSellerScreen extends StatefulWidget {
  final String accountType;
  const LoginSellerScreen({super.key, this.accountType = "general"});

  @override
  _LoginSellerScreenState createState() => _LoginSellerScreenState();
}

class _LoginSellerScreenState extends State<LoginSellerScreen> {
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _numberIdController = TextEditingController();
  final _legalNameController = TextEditingController();
  String? _idImageUrl;
  String _selectedCountryCode = "+504";

  final List<String> _countryCodes = [
    "+1", //Estados Unidos
    "+502", // Guatemala
    "+503", // El Salvador
    "+504", // Honduras
    "+505", // Nicaragua
    "+506", // Costa Rica
    "+507", // Panamá
    "+508", // Haití
    "+509", // Haití
  ];

  XFile? _image;
  String _imageValidationMessage = '';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  List<Color> _getBackgroundColors(String accountType) {
    switch (accountType) {
      case 'premium':
        return [
          const Color.fromARGB(255, 236, 144, 5),
          const Color.fromARGB(22, 255, 235, 59)
        ];
      case 'enterprise':
        return [
          const Color.fromARGB(255, 0, 0, 0),
          const Color.fromARGB(9, 0, 0, 0)
        ];
      default:
        return [
          const Color.fromARGB(255, 38, 122, 192),
          const Color.fromARGB(7, 68, 137, 255)
        ];
    }
  }

  Future<void> _prevalidateAndLogin() async {
    if (_image != null) {
      String validationMessage = await ImageValidation.validateImage(_image!);
      setState(() {
        _imageValidationMessage = validationMessage;
      });

      if (validationMessage == "La imagen es válida") {
        _loginSeller(context);
      }
    } else {
      setState(() {
        _imageValidationMessage = "Por favor, seleccione una imagen.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      // Cargar datos guardados en preferencias o BD
      UserModel? userData = await loadUserFromPreferences(user.uid);

      if (userData != null) {
        setState(() {
          _phoneNumberController.text = userData.phoneNumber ?? '';
          _numberIdController.text = userData.identityNumber ?? '';
          _legalNameController.text = userData.legalName ?? '';

          // Si tiene una imagen guardada, la asignamos
          if (userData.idImageUrl != null && userData.idImageUrl!.isNotEmpty) {
            _idImageUrl = userData.idImageUrl;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final backgroundColors = _getBackgroundColors(widget.accountType);
    final FirebaseAuth auth = FirebaseAuth.instance;
    _emailController.text = auth.currentUser?.email ?? '';

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: CustomAppbarWidget()),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: backgroundColors,
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
                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          theme.colorScheme.onSurface.withOpacity(0.2),
                      child: Icon(
                        Icons.account_circle,
                        size: 64,
                        color: _getBackgroundColors(widget.accountType)[0],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to Our App',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to continue',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _legalNameController,
                      hintText: S.current.legalName,
                      prefixIcon: Icons.account_circle_outlined,
                      filled: true,
                      // onChanged: (value) => _legalNameController.text = value,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      enabled: false,
                      controller: _emailController,
                      hintText: S.current.email,
                      prefixIcon: Icons.email_outlined,
                      filled: true,
                      // onChanged: (value) => _emailController.text = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DropdownButton<String>(
                            value: _selectedCountryCode,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCountryCode = newValue!;
                              });
                            },
                            items: _countryCodes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              controller: _phoneNumberController,
                              hintText: S.current.phoneNumber,
                              prefixIcon: Icons.phone,
                              filled: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Instrucciones para la identificación",
                              ),
                              content: const SingleChildScrollView(
                                child: Text(
                                  "Por favor, sube una imagen clara y legible de tu documento de identificación oficial. "
                                  "Asegúrate de que sea uno de los siguientes: Tarjeta de Identidad, Cédula, Pasaporte o Licencia de Conducir. "
                                  "La imagen debe mostrar claramente tu nombre completo, número de identificación, fecha de nacimiento y fotografía. "
                                  "Esta información se utilizará únicamente para verificar tu identidad y cumplir con los requisitos legales.",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    textStyle: const TextStyle(
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Cerrar",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "[Presiona para ver las instrucciones]",
                        style: TextStyle(
                          color: _getBackgroundColors(widget.accountType)[0],
                          decoration: TextDecoration.none,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Identificación: ",
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 170,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          image: _image != null
                              ? DecorationImage(
                                  image: FileImage(File(_image!.path)),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: _idImageUrl != null
                                      ? CachedNetworkImageProvider(_idImageUrl!)
                                      : Image.asset(
                                              "/assets/images/profileUser.jpg")
                                          .image,
                                ),
                        ),
                        child: _image == null
                            ? Icon(
                                Icons.camera_alt,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                    ),
                    Text(
                      _imageValidationMessage,
                      style: TextStyle(
                        color: _imageValidationMessage == "La imagen es válida"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _numberIdController,
                      hintText: "Identity Card ID",
                      prefixIcon: Icons.credit_card,
                      filled: true,
                      //   onChanged: (value) => _numberIdController.text = value,
                    ),
                    const SizedBox(height: 20),
                    MapButtomWidget(
                      lat: 15.2000,
                      long: -86.2419,
                      height: 150,
                      onTap: () {
                        GoRouter.of(context).push("/map");
                      },
                    ),
                    ElevatedButton(
                      onPressed: _idImageUrl == null
                          ? _prevalidateAndLogin
                          : () {
                              _loginSeller(context);
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      child: Text(
                        S.current.save,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.current.seeMore,
                          style: theme.textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () {
                            //context.go('/register');
                          },
                          child: const Text('Click'),
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

  Future<void> _loginSeller(BuildContext context) async {
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingrese su correo electrónico."),
        ),
      );
      return;
    }

    if (_numberIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingrese su número de identificación."),
        ),
      );
      return;
    }

    /*if (_image == null && _idImageUrl != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, seleccione una imagen."),
        ),
      );
      return;
    }*/

    if (_legalNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingrese su nombre legal."),
        ),
      );
      return;
    }

    if (_phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingrese su número de teléfono."),
        ),
      );
      return;
    }

    superProgressIndicator(context);

    try {
      final String? imageUrl =
          _idImageUrl ?? await uploadIDImageFirebase(_image!, null);

      if (imageUrl == null) {
        throw Exception("No se pudo subir la imagen.");
      } else {
        await APIService().updateUserData(
            null,
            null,
            null,
            _legalNameController.text.trim(),
            imageUrl,
            _numberIdController.text,
            _phoneNumberController.text,
            widget.accountType,
            locationController.locationLat,
            locationController.locationLng);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Eres un nuevo vendedor! de tipo: ${widget.accountType}"),
          ),
        );
        User? user = FirebaseAuth.instance.currentUser;
        await loadUserFromPreferences(user!.uid, loadFromServer: true);
        GoRouter.of(context).go('/settings');
      }

      GoRouter.of(context).pop();
    } catch (e) {
      //GoRouter.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al iniciar sesión: ${e.toString()}"),
        ),
      );
    }
  }
}
