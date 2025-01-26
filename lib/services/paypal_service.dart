import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:io';

String clientId =
    Platform.environment['PAYPAL_CLIENT_ID'] ?? "PAYPAL_CLIENT_ID";
String clientSecret =
    Platform.environment['PAYPAL_CLIENT_SECRET'] ?? "PAYPAL_CLIENT_SECRET";

Future<String?> getAccessToken() async {
  const String authUrl =
      "https://api.sandbox.paypal.com/v1/oauth2/token"; // Sandbox URL (Production: api.paypal.com)

  // Solicitud para obtener el token de acceso
  final response = await http.post(
    Uri.parse(authUrl),
    headers: {
      "Accept": "application/json",
      "Accept-Language": "en_US",
      "Authorization":
          "Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}",
    },
    body: {"grant_type": "client_credentials"},
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data['access_token'];
  } else {
    print("Error al obtener el token de acceso: ${response.body}");
    return null;
  }
}
