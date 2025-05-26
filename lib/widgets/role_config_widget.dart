import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class RoleConfigWidget extends StatefulWidget {
  final ScrollController scrollController;

  const RoleConfigWidget({super.key, required this.scrollController});

  @override
  _RoleConfigWidgetState createState() => _RoleConfigWidgetState();
}

class _RoleConfigWidgetState extends State<RoleConfigWidget> {
  final TextEditingController _emailController = TextEditingController();

  String? _selectedRole;
  List<Map<String, String>> _assignedRoles = [];

  final List<String> roles = [
    dotenv.env['ROLE_ADMIN'] ?? 'admin',
    dotenv.env['ROLE_FORM'] ?? 'form',
    dotenv.env['ROLE_ORDERS_AND_DELIVERIES'] ?? 'orders_and_deliveries',
    dotenv.env['ROLE_REPORTS'] ?? 'reports',
  ];

  @override
  void initState() {
    super.initState();
    _loadAssignedRoles();
  }

  Future<void> _loadAssignedRoles() async {
    try {
      DatabaseEvent snapshot =
          await FirebaseDatabase.instance.ref('data/userRoles').once();
      if (snapshot.snapshot.value != null) {
        var rolesData = snapshot.snapshot.value as List<dynamic>;
        setState(() {
          _assignedRoles = rolesData.map((e) {
            return {
              'email': e['email']?.toString() ?? '',
              'role': e['role']?.toString() ?? '',
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error al cargar roles asignados: ${e.toString()}");
    }
  }

  Future<void> _saveUserRole() async {
    if (_emailController.text.isEmpty || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email y Rol son requeridos')));
      return;
    }

    try {
      DatabaseReference rolesRef =
          FirebaseDatabase.instance.ref('data/userRoles');
      DatabaseEvent snapshot = await rolesRef.once();
      List<dynamic> currentRoles = [];
      if (snapshot.snapshot.value != null) {
        currentRoles = snapshot.snapshot.value as List<dynamic>;
      }

      currentRoles.add({
        'email': _emailController.text.trim(),
        'role': _selectedRole,
      });

      await rolesRef.set(currentRoles);

      setState(() {
        _assignedRoles.add({
          'email': _emailController.text.trim(),
          'role': _selectedRole!,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol guardado exitosamente')));
    } catch (e) {
      print("Error: ${e.toString()}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _removeUserRole(String email) async {
    try {
      DatabaseReference rolesRef =
          FirebaseDatabase.instance.ref('data/userRoles');
      DatabaseEvent snapshot = await rolesRef.once();
      List<dynamic> currentRoles = [];
      if (snapshot.snapshot.value != null) {
        currentRoles = snapshot.snapshot.value as List<dynamic>;
      }

      currentRoles.removeWhere((role) => role['email'] == email);

      await rolesRef.set(currentRoles);

      setState(() {
        _assignedRoles.removeWhere((role) => role['email'] == email);
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol eliminado exitosamente')));
    } catch (e) {
      print("Error al eliminar rol: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar rol: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Configuración de Roles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: [AutofillHints.email],
              onChanged: (value) {
                /*setState(() {
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Correo electrónico no válido')),
                    );
                  }
                });*/
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Seleccionar Rol',
                border: OutlineInputBorder(),
              ),
              items: roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Asignar Rol'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveUserRole,
            ),
            const SizedBox(height: 16),
            const Text(
              'Roles Asignados',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _assignedRoles.isEmpty
                ? const Text('No hay roles asignados.')
                : ListView.builder(
                    controller: widget.scrollController,
                    shrinkWrap: true,
                    itemCount: _assignedRoles.length,
                    itemBuilder: (context, index) {
                      var role = _assignedRoles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text('${role['email']} - ${role['role']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => _removeUserRole(role['email']!),
                          ),
                        ),
                      );
                    },
                  ),
            TextButton(
              onPressed: () {
                context.go("/register");
              },
              child: const Text('Crear cuentas de usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
