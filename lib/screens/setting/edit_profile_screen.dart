/*

import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/flutter_map_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final int profileIndex;
  final List<ProfileModel>? profiles;

  const EditProfileScreen({
    super.key,
    required this.profileIndex,
    this.profiles,
  });

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
  double lat = 22.0;
  double long = 22.0;

  @override
  void initState() {
    if (widget.profileIndex != -1 && widget.profiles != null) {
      var profile = widget.profiles![widget.profileIndex];
      _legalNameController.text = profile.legalName;
      _identityNumberController.text = profile.identityNumber;
      lat = profile.locationLatitude;
      long = profile.locationLongitude;
      _occasionDescriptionController.text = profile.locationDescription;
      _cardNumberController.text = profile.cardNumber;

      LocationController locationController =
          Provider.of<LocationController>(context, listen: false);
      LatLng latLng = LatLng(lat, long);
      _fetchLocationName(latLng, locationController);
    }
    super.initState();
  }

  Future<void> _submitData(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);
    String firebaseUid = "";
    if (user != null) {
      firebaseUid = user.uid;
    }
    if (_formKey.currentState!.validate()) {
      String legalName = _legalNameController.text;
      String identityNumber = _identityNumberController.text;
      double locationLatitude = locationController.locationLat ?? 0.0;
      double locationLongitude = locationController.locationLng ?? 0.0;
      String occasionDescription = _occasionDescriptionController.text;
      String cardNumber = _cardNumberController.text;

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
        );
      }
    }

    context.pop({
      'updated': true,
    });
  }

  Future<void> _fetchLocationName(
      LatLng location, LocationController locationController) async {
    final locationName = await getLocationName(location);

    if (locationName != null) {
      locationController.setLocationName(locationName);
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
          child: ListView(
            children: [
              CustomTextField(
                hintText: 'Nombre Legal',
                prefixIcon: Icons.person,
                controller: _legalNameController,
                filled: true,
              ),
              CustomTextField(
                hintText: 'Número de ID',
                prefixIcon: Icons.account_circle,
                controller: _identityNumberController,
                filled: true,
              ),
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
                            locationController.locationName ??
                                locationController.locationName ??
                                "";
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
         //aquie poner el menu desplegable con listas d epaise que se insertara al inicio del _occasionDescriptionController.text, entre [[]] aquie tendra que identificar lo que hay
         // dentro de los [[]] en caso se esten cargando los datos, de lo contrario solo se pondra ninguno
              CustomTextField(
                hintText: 'Descripción de la Ocasión', //en esta descriocion se van aprecargar los datos(si existen de lo coantrario se tendra que rellenar el ussuario), 
                prefixIcon: Icons.description, // aqui, no se pondra el nombre del paiz al inicio se me ocurre identificar el pais con los [[]] 
                controller: _occasionDescriptionController,
                filled: true,
              ),
              CustomTextField(
                hintText: 'Número de Tarjeta',
                prefixIcon: Icons.credit_card,
                controller: _cardNumberController,
                filled: true,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitData(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(widget.profileIndex == -1
                    ? 'Crear Perfil'
                    : 'Actualizar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/custom_dropdown_button_widget.dart';
import 'package:carkett/widgets/flutter_map_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final int profileIndex;
  final List<ProfileModel>? profiles;

  const EditProfileScreen({
    super.key,
    required this.profileIndex,
    this.profiles,
  });

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
  double lat = 22.0;
  double long = 22.0;

  List<String> countries = [
    "México",
    "Estados Unidos",
    "Argentina",
    "España",
    "Colombia",
  ];
  String? selectedCountry;

  @override
  void initState() {
    if (widget.profileIndex != -1 && widget.profiles != null) {
      var profile = widget.profiles![widget.profileIndex];
      _legalNameController.text = profile.legalName;
      _identityNumberController.text = profile.identityNumber;
      lat = profile.locationLatitude;
      long = profile.locationLongitude;
      _occasionDescriptionController.text = profile.locationDescription;
      _cardNumberController.text = profile.cardNumber;

      _detectCountryInDescription();
      LocationController locationController =
          Provider.of<LocationController>(context, listen: false);
      LatLng latLng = LatLng(lat, long);
      _fetchLocationName(latLng, locationController);
    }
    super.initState();
  }

  void _detectCountryInDescription() {
    final description = _occasionDescriptionController.text;
    final regExp = RegExp(r"\[\[(.*?)\]\]");
    final match = regExp.firstMatch(description);
    if (match != null && match.group(1) != null) {
      selectedCountry = match.group(1);
    }
  }

  Future<void> _submitData(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);
    String firebaseUid = "";
    if (user != null) {
      firebaseUid = user.uid;
    }
    if (_formKey.currentState!.validate()) {
      String legalName = _legalNameController.text;
      String identityNumber = _identityNumberController.text;
      double locationLatitude = locationController.locationLat ?? 0.0;
      double locationLongitude = locationController.locationLng ?? 0.0;
      String occasionDescription = _occasionDescriptionController.text;
      String cardNumber = _cardNumberController.text;

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
        );
      }
    }

    context.pop({
      'updated': true,
    });
  }

  Future<void> _fetchLocationName(
      LatLng location, LocationController locationController) async {
    final locationName = await getLocationName(location);

    if (locationName != null) {
      locationController.setLocationName(locationName);
    }
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
          child: ListView(
            children: [
              CustomTextField(
                hintText: 'Nombre Legal',
                prefixIcon: Icons.person,
                controller: _legalNameController,
                filled: true,
              ),
              CustomTextField(
                hintText: 'Número de ID',
                prefixIcon: Icons.account_circle,
                controller: _identityNumberController,
                filled: true,
              ),
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
              CustomTextField(
                hintText: 'Descripción de la Ocasión',
                prefixIcon: Icons.description,
                controller: _occasionDescriptionController,
                filled: true,
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
              CustomTextField(
                hintText: 'Número de Tarjeta',
                prefixIcon: Icons.credit_card,
                controller: _cardNumberController,
                filled: true,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitData(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(widget.profileIndex == -1
                    ? 'Crear Perfil'
                    : 'Actualizar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/custom_dropdown_button_widget.dart';
import 'package:carkett/widgets/flutter_map_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class EditProfileScreen extends StatefulWidget {
  final int profileIndex;
  final List<ProfileModel>? profiles;

  const EditProfileScreen({
    super.key,
    required this.profileIndex,
    this.profiles,
  });

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
  double lat = 22.0;
  double long = 22.0;

  List<String> countries = [
    "México",
    "Estados Unidos",
    "Argentina",
    "España",
    "Colombia",
  ];
  String? selectedCountry;

  @override
  void initState() {
    if (widget.profileIndex != -1 && widget.profiles != null) {
      var profile = widget.profiles![widget.profileIndex];
      _legalNameController.text = profile.legalName;
      _identityNumberController.text = profile.identityNumber;
      lat = profile.locationLatitude;
      long = profile.locationLongitude;
      _occasionDescriptionController.text = profile.locationDescription;
      _cardNumberController.text = profile.cardNumber;

      _detectCountryInDescription();
      LocationController locationController =
          Provider.of<LocationController>(context, listen: false);
      LatLng latLng = LatLng(lat, long);
      _fetchLocationName(latLng, locationController);
    }
    super.initState();
  }

  void _detectCountryInDescription() {
    final description = _occasionDescriptionController.text;
    final regExp = RegExp(r"\[\[(.*?)\]\]");
    final match = regExp.firstMatch(description);
    if (match != null && match.group(1) != null) {
      selectedCountry = match.group(1);
    }
  }

  Future<void> _submitData(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);
    String firebaseUid = "";
    if (user != null) {
      firebaseUid = user.uid;
    }
    if (_formKey.currentState!.validate()) {
      String legalName = _legalNameController.text;
      String identityNumber = _identityNumberController.text;
      double locationLatitude = locationController.locationLat ?? 0.0;
      double locationLongitude = locationController.locationLng ?? 0.0;
      String occasionDescription = _occasionDescriptionController.text;
      String cardNumber = _cardNumberController.text;

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
        );
      }
    }

    context.pop({
      'updated': true,
    });
  }

  Future<void> _fetchLocationName(
      LatLng location, LocationController locationController) async {
    final locationName = await getLocationName(location);

    if (locationName != null) {
      locationController.setLocationName(locationName);
    }
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
          child: ListView(
            children: [
              _buildSectionTitle("1. Información Personal"),
              Center(
                child: _buildInputField(
                    _legalNameController, 'Nombre Legal', Icons.person,
                    maxWidth: 600),
              ),
              Center(
                child: _buildInputField(_identityNumberController,
                    'Número de ID', Icons.account_circle,
                    maxWidth: 600),
              ),
              _buildSectionTitle("2. Ubicación y Mapa"),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            locationController.setLocation(LatLng(lat, long));
                            await GoRouter.of(context).push('/map');
                            if (_occasionDescriptionController.text.isEmpty) {
                              _occasionDescriptionController.text =
                                  locationController.locationName ??
                                      locationController.locationName ??
                                      "";
                            }
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: FlutterMapWidget(lat: lat, long: long),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth / 2 - 20,
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              _buildInputField(
                                  _occasionDescriptionController,
                                  'Descripción de la Ocasión',
                                  Icons.description),
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
                      ],
                    );
                  } else {
                    return Column(
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
                                locationController
                                    .setLocation(LatLng(lat, long));
                                await GoRouter.of(context).push('/map');
                                if (_occasionDescriptionController
                                    .text.isEmpty) {
                                  _occasionDescriptionController.text =
                                      locationController.locationName ??
                                          locationController.locationName ??
                                          "";
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
                        _buildInputField(_occasionDescriptionController,
                            'Descripción de la Ocasión', Icons.description),
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
                    );
                  }
                },
              ),
              _buildSectionTitle("3. Información de la Tarjeta de Crédito"),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CreditCardWidget(
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
                ),
              ),
              Center(
                child: _buildInputField(_cardNumberController,
                    'Número de Tarjeta', Icons.credit_card,
                    obscure: true, maxWidth: 600),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitData(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(widget.profileIndex == -1
                    ? 'Crear Perfil'
                    : 'Actualizar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool obscure = false,
    double maxWidth = 500,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextField(
        hintText: hintText,
        prefixIcon: icon,
        controller: controller,
        filled: true,
        obscureText: obscure,
        maxWidth: maxWidth,
      ),
    );
  }
}
