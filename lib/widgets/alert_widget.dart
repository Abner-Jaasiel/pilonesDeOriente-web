import 'package:carkett/generated/l10n.dart';
import 'package:flutter/material.dart';

void alertWidget(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar la alerta
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

Future<bool?> showLogoutConfirmationDialog(
    BuildContext context, String title, String content) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(S.current.no),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(S.current.yes),
          ),
        ],
      );
    },
  );
}
