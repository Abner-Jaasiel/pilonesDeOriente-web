import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/custom_dropdown_button_widget.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:carkett/widgets/flutter_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  final int profileIndex;
  final List<ProfileModel>? profiles;

  const EditProfileScreen(
      {super.key, required this.profileIndex, this.profiles});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _legalNameController = TextEditingController();
  final TextEditingController _identityNumberController =
      TextEditingController();
  final TextEditingController _occasionDescriptionController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isDefault = false;

  double lat = 22.0;
  double long = 22.0;

  List<String> countries = [
    "Honduras",
    "Guatemala",
    "El Salvador",
    "Nicaragua",
    "México",
    "Estados Unidos",
    "Argentina",
    "España",
    "Colombia",
  ];
  String? selectedCountry;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();

    if (widget.profileIndex != -1 && widget.profiles != null) {
      var profile = widget.profiles![widget.profileIndex];
      _legalNameController.text = profile.legalName;
      _identityNumberController.text = profile.identityNumber;
      lat = profile.locationLatitude;
      long = profile.locationLongitude;
      _occasionDescriptionController.text = profile.locationDescription;
      _cardNumberController.text = profile.cardNumber;
      _phoneNumberController.text = profile.phoneNumber;
      isDefault = profile.isDefault;
      _detectCountryInDescription();
    }
  }

  void _submitData(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);
    String firebaseUid = user?.uid ?? '';

    if (_formKey.currentState!.validate()) {
      String legalName = _legalNameController.text;
      String identityNumber = _identityNumberController.text;
      double locationLatitude = locationController.locationLat ?? 0.0;
      double locationLongitude = locationController.locationLng ?? 0.0;
      String occasionDescription = _occasionDescriptionController.text;
      String cardNumber = _cardNumberController.text;
      String phoneNumber = _phoneNumberController.text;
      bool isDefaultProfile = isDefault;

      if (widget.profileIndex == -1) {
        await APIService().submitProfileData(
          firebaseUid,
          -1,
          legalName,
          locationLatitude,
          locationLongitude,
          occasionDescription,
          cardNumber,
          identityNumber,
          widget.profileIndex,
          phoneNumber,
          isDefaultProfile,
        );
      } else {
        var profile = widget.profiles![widget.profileIndex];
        var profileId = profile.id;

        await APIService().submitProfileData(
          firebaseUid,
          profileId,
          legalName,
          locationLatitude,
          locationLongitude,
          occasionDescription,
          cardNumber,
          identityNumber,
          widget.profileIndex,
          phoneNumber,
          isDefaultProfile,
        );
      }

      context.pop({
        'updated': true,
      });
    }
  }

  void _detectCountryInDescription() {
    final description = _occasionDescriptionController.text;
    final regExp = RegExp(r"\[\[(.*?)\]\]");
    final match = regExp.firstMatch(description);
    if (match != null && match.group(1) != null) {
      selectedCountry = match.group(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationController locationController =
        Provider.of<LocationController>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.profileIndex == -1 ? 'Añadir Perfil' : 'Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 3) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  _submitData(context);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              steps: [
                Step(
                  title: InkWell(
                    onTap: () {
                      setState(() {
                        _currentStep = 0;
                      });
                    },
                    child: const Text('Información Personal'),
                  ),
                  content: Column(
                    children: [
                      _buildInputField(
                        _legalNameController,
                        'Nombre Legal',
                        Icons.person,
                        validator: _validateLegalName,
                      ),
                      _buildInputField(
                        _identityNumberController,
                        'Número de ID',
                        Icons.account_circle,
                        validator: _validateIdentityNumber,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: InkWell(
                    onTap: () {
                      setState(() {
                        _currentStep = 1;
                      });
                    },
                    child: const Text('Ubicación y Mapa'),
                  ),
                  content: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            constraints: const BoxConstraints(maxWidth: 500),
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FlutterMapWidget(lat: lat, long: long),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              locationController.setLocation(LatLng(lat, long));
                              await GoRouter.of(context).push('/map');
                              if (_occasionDescriptionController.text.isEmpty) {
                                _occasionDescriptionController.text =
                                    locationController.locationName ?? "";
                              }
                            },
                            child: Container(
                              height: 130,
                              margin: const EdgeInsets.only(top: 100),
                            ),
                          ),
                        ],
                      ),
                      Text(locationController.locationName ?? ""),
                      _buildInputField(
                        _occasionDescriptionController,
                        'Descripción de la Ocasión',
                        Icons.description,
                        validator: _validateOccasionDescription,
                      ),
                      CustomDropdownButton(
                        selectedCountry: selectedCountry,
                        onChanged: (String? newValue) {
                          if (newValue != selectedCountry) {
                            setState(() {
                              selectedCountry = newValue;
                            });
                            _addCountryToDescription(newValue);
                          }
                        },
                        countries: countries,
                        hint: 'Selecciona un país',
                      ),
                    ],
                  ),
                ),
                Step(
                  title: InkWell(
                    onTap: () {
                      setState(() {
                        _currentStep = 2;
                      });
                    },
                    child: const Text('Información de la Tarjeta de Crédito'),
                  ),
                  content: Column(
                    children: [
                      CreditCardWidget(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        width: 500,
                        height: 250,
                        cardNumber: _cardNumberController.text,
                        expiryDate: '',
                        cardHolderName: '',
                        cvvCode: '',
                        showBackView: false,
                        cardBgColor: Colors.deepPurple,
                        glassmorphismConfig: Glassmorphism.defaultConfig(),
                        isHolderNameVisible: true,
                        onCreditCardWidgetChange: (CreditCardBrand brand) {},
                      ),
                      _buildInputField(
                        _cardNumberController,
                        'Número de Tarjeta',
                        Icons.credit_card,
                        obscure: true,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: InkWell(
                    onTap: () {
                      setState(() {
                        _currentStep = 3;
                      });
                    },
                    child: const Text('Información Adicional'),
                  ),
                  content: Column(
                    children: [
                      _buildInputField(
                        _phoneNumberController,
                        'Número de Teléfono',
                        Icons.phone,
                        validator: _validatePhoneNumber,
                      ),
                      Row(
                        children: [
                          const Text('¿Es por defecto?'),
                          Switch(
                            value: isDefault,
                            onChanged: (bool newValue) {
                              setState(() {
                                isDefault = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Anterior'),
                        ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child:
                            Text(_currentStep == 3 ? 'Guardar' : 'Siguiente'),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextField(
        hintText: hintText,
        prefixIcon: icon,
        controller: controller,
        filled: true,
        obscureText: obscure,
        validator: validator,
      ),
    );
  }

  String? _validateLegalName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final nameRegExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      return 'El nombre solo debe contener letras y espacios';
    }
    return null;
  }

  String? _validateIdentityNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _validateOccasionDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (selectedCountry == null || selectedCountry!.isEmpty) {
      return 'Selecciona un país primero';
    }

    // Expresiones regulares para cada país, permitiendo espacios opcionales
    final Map<String, String> phoneRegExMap = {
      'Honduras': r'^\+504\s?\d{8}$', // Ejemplo: +504 98765432 o +50498765432
      'Guatemala': r'^\+502\s?\d{8}$', // Ejemplo: +502 98765432 o +50298765432
      'El Salvador':
          r'^\+503\s?\d{8}$', // Ejemplo: +503 98765432 o +50398765432
      'Nicaragua': r'^\+505\s?\d{8}$', // Ejemplo: +505 98765432 o +50598765432
      'México': r'^\+52\s?\d{10}$', // Ejemplo: +52 987 654 3210 o +529876543210
      'Estados Unidos':
          r'^\+1\s?\(\d{3}\)\s?\d{3}-\d{4}$', // Ejemplo: +1 (123) 456-7890 o +1(123)456-7890
      'Argentina':
          r'^\+54\s?\d{10}$', // Ejemplo: +54 9 11 98765432 o +5491198765432
      'España': r'^\+34\s?\d{9}$', // Ejemplo: +34 987 654 321 o +34987654321
      'Colombia':
          r'^\+57\s?\d{10}$', // Ejemplo: +57 123 456 7890 o +571234567890
    };

    final phoneRegExp = RegExp(phoneRegExMap[selectedCountry]!);

    if (!phoneRegExp.hasMatch(value)) {
      return 'El número de teléfono no es válido para $selectedCountry';
    }

    return null;
  }

  void _addCountryToDescription(String? country) {
    if (country != null) {
      final currentDescription = _occasionDescriptionController.text;
      final regExp = RegExp(r"\[\[(.*?)\]\]");

      String updatedDescription = currentDescription.replaceAll(regExp, '');

      _occasionDescriptionController.text =
          '[[$country]] ${updatedDescription.trim()}';
    }
  }
}
