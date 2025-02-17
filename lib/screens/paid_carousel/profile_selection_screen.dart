import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/providers/payment_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  late Future<List<ProfileModel>> _profilesFuture;
  int _selectedProfileIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String firebaseUid = "";
    if (user != null) {
      firebaseUid = user.uid;
    }
    setState(() {
      _profilesFuture = APIService().fetchProfiles(firebaseUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _loadProfiles,
        child: FutureBuilder<List<ProfileModel>>(
          future: _profilesFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.error != null) {
              return Center(
                child: Text('Ocurrió un error: ${snapshot.error}'),
              );
            }

            final profiles = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _paymentOptions(context),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: profiles.length + 1,
                      itemBuilder: (ctx, index) {
                        if (index < profiles.length) {
                          var profile = profiles[index];
                          bool isSelected = index == _selectedProfileIndex;

                          String cardType = getCardType(profile.cardNumber);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProfileIndex = index;
                              });
                            },
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: isSelected
                                  ? const Color.fromARGB(51, 132, 132, 132)
                                  : null,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('assets/images/$cardType.png'),
                                  radius: 25,
                                ),
                                title: Text(
                                  profile.legalName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(profile.locationDescription),
                                    const SizedBox(height: 4),
                                    Text("ID: ${profile.identityNumber}"),
                                    const SizedBox(height: 4),
                                    Text("Card: ${cardType.toUpperCase()}"),
                                  ],
                                ),
                                selected: isSelected,
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : null,
                              ),
                            ),
                          );
                        } else {
                          // Card para "Agregar perfil"
                          return GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/profile_list');
                            },
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                                title: const Text(
                                  "Agregar perfil",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward,
                                    color: Colors.grey),
                                onTap: () {
                                  GoRouter.of(context).push('/profile_list');
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _selectedProfileIndex == -1
                          ? null
                          : () {
                              PaymentController paymentController =
                                  Provider.of<PaymentController>(context,
                                      listen: false);

                              final selectedProfile =
                                  profiles[_selectedProfileIndex];
                              print(
                                  "Perfil seleccionado: ${selectedProfile.legalName}");

                              paymentController.legalName =
                                  selectedProfile.legalName;
                              paymentController.profileId = selectedProfile.id;
                              paymentController.locationDescription =
                                  selectedProfile.locationDescription;
                              paymentController.userId = selectedProfile.userId;
                              paymentController.updateCoordinates(
                                  selectedProfile.locationLatitude,
                                  selectedProfile.locationLongitude);
                              paymentController.identityId =
                                  selectedProfile.identityNumber;
                              paymentController.cardNumber =
                                  selectedProfile.cardNumber;

                              GoRouter.of(context).push('/card_details');
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Siguiente",
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _paymentOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Other Payment Options",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.paypal, color: Colors.blue),
          title: const Text("PayPal"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            GoRouter.of(context).push("/card_details");
          },
        ),
        ListTile(
          leading:
              const Icon(Icons.account_balance_wallet, color: Colors.green),
          title: const Text("Google Pay"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            GoRouter.of(context).push("/map");
          },
        ),
      ],
    );
  }
}

String getCardType(String cardNumber) {
  String bin = cardNumber.length >= 6 ? cardNumber.substring(0, 6) : cardNumber;

  if (bin.startsWith('4')) {
    return 'visa';
  } else if (bin.startsWith(RegExp(r'^(51|52|53|54|55)'))) {
    return 'mastercard';
  } else if (bin.startsWith('34') || bin.startsWith('37')) {
    return 'amex';
  } else {
    return 'unknown';
  }
}
