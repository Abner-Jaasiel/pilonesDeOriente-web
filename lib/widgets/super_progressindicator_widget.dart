import 'package:carkett/generated/l10n.dart';
import 'package:flutter/material.dart';

Future<dynamic> superProgressIndicator(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16.0),
            Text("${S.current.loading}..."),
          ],
        ),
      );
    },
  );
}

Future<dynamic> progressIndicator(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16.0),
          Text("${S.current.loading}..."),
        ],
      );
    },
  );
}
