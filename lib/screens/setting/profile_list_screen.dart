import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String getCardType(String cardNumber) {
  if (cardNumber.isEmpty || cardNumber.length < 6) {
    return 'unknown';
  }
  String bin = cardNumber.substring(0, 6);

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

class ProfileListScreen extends StatefulWidget {
  const ProfileListScreen({super.key});

  @override
  State<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  late Future<List<ProfileModel>> _profilesFuture;

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
      appBar: AppBar(
        title: const Text('Perfiles de Usuarios'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfiles,
        child: FutureBuilder<List<ProfileModel>>(
          future: _profilesFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData != true) {
              return Center(
                child: Text(S.current.empty),
              );
            }
            if (snapshot.error != null) {
              return Center(
                child: Text("${S.current.empty} ${snapshot.error}"),
              );
            }

            final profiles = snapshot.data ?? [];
            return ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (ctx, index) {
                var profile = profiles[index];

                String cardType = getCardType(profile.cardNumber);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: cardType != 'unknown'
                        ? Image.asset('assets/images/$cardType.png',
                            width: 30, height: 30)
                        : const Icon(Icons.credit_card),
                    title: Text(profile.legalName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.locationDescription),
                        const SizedBox(height: 4),
                        Text("# ID : ${profile.identityNumber}"),
                        const SizedBox(height: 4),
                        Text(
                            "# ${cardType.toUpperCase()} : ${profile.cardNumber}"),
                      ],
                    ),
                    onLongPress: () async {
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text(
                              '¿Estás seguro de que deseas eliminar este perfil?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: const Text('Eliminar'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      );

                      if (confirmed ?? false) {
                        try {
                          await APIService().deleteProfile(profile.id);
                          print('Perfil eliminado');
                          _loadProfiles();
                        } catch (error) {
                          print('Error al eliminar el perfil: $error');
                        }
                      }
                    },
                    onTap: () async {
                      final result = await context.push(
                        '/edit_profile',
                        extra: {
                          'profileIndex': index,
                          'profiles': profiles,
                        },
                      );

                      if (result != null) {
                        setState(() {
                          _loadProfiles();
                        });
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            '/edit_profile',
            extra: {
              'profileIndex': -1,
              'profile': null,
            },
          );
        },
        tooltip: 'Añadir Perfil',
        child: const Icon(Icons.add),
      ),
    );
  }
}
