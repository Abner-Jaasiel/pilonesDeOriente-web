import 'dart:async';

import 'package:carkett/models/order_seller_model.dart';
import 'package:carkett/models/order_user_model.dart';
import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/models/product_model.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final String apiUrl = dotenv.env['API_URL'] ?? 'API_URL not found';
  String geminiKey = dotenv.env['API_GEMINI_KEY'] ?? 'API_GEMINI_KEY not found';
  String geminiUrl = dotenv.env['API_GEMINI_URL'] ?? 'API_GEMINI_URL not found';

  Future<Map<String, dynamic>> getUserWithFirebaseId(String firebaseId) async {
    final response =
        await http.get(Uri.parse("$apiUrl/users/firebase/$firebaseId"));
    print("USER BY [API] ");
    try {
      if (response.statusCode == 200) {
        print(
            "🤺🤺😀😀😀😀🤷‍♂️🤣❤️🤣🩸👌👌>   ${jsonDecode(response.body)}   <🤺🤺😀😀😀😀🤷‍♂️🤣❤️🤣🩸👌👌");
        return jsonDecode(response.body);
      } else {
        throw Exception('Error');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<Map<String, dynamic>> fetchProduct(String productId) async {
    final response = await http.get(Uri.parse("$apiUrl/products/$productId"));
    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  //## STREAM CONTROLLER FOR CAROUSEL PRODUCTS:

  final StreamController<List<dynamic>> _carouselStreamController =
      StreamController<List<dynamic>>.broadcast();
  List<dynamic>? _cachedProducts;

  Stream<List<dynamic>> get carouselProductsStream =>
      _carouselStreamController.stream;

  APIService() {
    _fetchAndEmitProducts();
  }

  Future<void> _fetchAndEmitProducts() async {
    if (_cachedProducts != null) {
      _carouselStreamController.add(_cachedProducts!);
    }
    try {
      final products = await fetchCarouselProducts();
      _cachedProducts = products;
      _carouselStreamController.add(products);
    } catch (error) {
      _carouselStreamController.addError('Failed to fetch products: $error');
    }
  }

  Future<List<dynamic>> fetchCarouselProducts() async {
    final response = await http.get(Uri.parse("$apiUrl/products/carrusel"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Error fetching carousel products: ${response.statusCode}');
    }
  }

  // Disponer del StreamController al cerrar la aplicación
  void dispose() {
    _carouselStreamController.close();
  }

  //##########################################################################

  Future<Map<String, dynamic>?> sendProductToServer(
    Map<String, dynamic> data, {
    String route = "",
    String method = "POST",
  }) async {
    String? token = await AuthFirebaseService().getIdToken();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      data["seller"] = user.uid;
    }

    try {
      print("$apiUrl/products$route");

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await (method == "PATCH"
          ? http.patch(
              Uri.parse("$apiUrl/products$route"),
              headers: headers,
              body: jsonEncode(data),
            )
          : http.post(
              Uri.parse("$apiUrl/products$route"),
              headers: headers,
              body: jsonEncode(data),
            ));

      if (response.statusCode == 200) {
        print('FULL');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('cartItems');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception $e');
    }
    return null;
  }

  /*Future<List<dynamic>?> getFilteredProducts(
      Map<String, dynamic> filter) async {
    final Uri uri =
        Uri.parse("$apiUrl/products/filter").replace(queryParameters: {
      'tags': filter['tags'].isNotEmpty ? filter['tags'].join(',') : null,
      'category': filter['category'],
      'seller': filter['seller'],
      'name': filter['name'],
    });

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener productos filtrados');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }*/
  Future<List<dynamic>?> getFilteredProducts(
      Map<String, dynamic> filter) async {
    print("Todos los filtros:  ~$filter");
    if ((filter['category_id'] == null || filter['category_id'] < 0) &&
        (filter['tags'] == null || filter['tags'].isEmpty) &&
        (filter['seller_firebase_uid'] == null ||
            filter['seller_firebase_uid'].toString().isEmpty) &&
        (filter['name'] == null || filter['name'].toString().isEmpty)) {
      print(
          "Todos los filtros están vacíos. No se realizará ninguna solicitud.   ~$filter");
      return [];
    }

    final Map<String, dynamic> queryParams = {};

    if (filter['category_id'] != null && filter['category_id'] != 0) {
      print("Todos los filtro categprys:  ~$filter");
      queryParams['category_id'] = filter['category_id'].toString();
    }
    if (filter['tags'] != null && filter['tags'].isNotEmpty) {
      queryParams['tags'] = filter['tags'];
    }
    if (filter['seller_firebase_uid'] != null &&
        filter['seller_firebase_uid'].toString().isNotEmpty) {
      queryParams['seller_firebase_uid'] =
          filter['seller_firebase_uid'].toString();
    }
    if (filter['name'] != null && filter['name'].toString().isNotEmpty) {
      queryParams['name'] = filter['name'];
    }

    final Uri uri = Uri.parse("$apiUrl/products/filter")
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> products = jsonDecode(response.body);
        print(products);
        return products;
      } else {
        throw Exception('Error al obtener productos filtrados');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  //Model
  Future<Map<String, dynamic>> fetchGeminiResponse(
      String query, String descripcionProducto) async {
    try {
      final Uri uri = Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$geminiKey");

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'model': 'gemini-1.5-flash-latest',
        'contents': [
          {
            'role': 'USER',
            'parts': [
              {'text': "user: '$query'"},
              {'text': "product description: '$descripcionProducto'"}
            ]
          }
        ],
        'systemInstruction': {
          'role': 'SYSTEM',
          'parts': [
            {'text': 'Responde segun lo que el user pida'},
            {'text': 'Debes ser objetiva en la respuesta'},
            {'text': 'Se breve, pero detallada'}
          ]
        },
        'generationConfig': {
          'maxOutputTokens': 100,
        }
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al conectar con Gemini: $e');
    }
  }

  /*Future<List<dynamic>> fetchCartItems(String firebaseId) async {
    String? token = await AuthFirebaseService().getIdToken();

    try {
      final response = await http.get(
        Uri.parse("$apiUrl/products/cart?uid=$firebaseId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print(decodedResponse.runtimeType);
        if (decodedResponse is List) {
          return decodedResponse;
        } else if (decodedResponse is Map && decodedResponse['items'] is List) {
          return decodedResponse['items'];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }*/

  Future<List<dynamic>> fetchCartItems(String firebaseId) async {
    String? token = await AuthFirebaseService().getIdToken();

    try {
      final response = await http.get(
        Uri.parse("$apiUrl/products/cart?uid=$firebaseId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        if (decodedResponse is List) {
          return decodedResponse.isEmpty ? [] : decodedResponse;
        } else if (decodedResponse is Map && decodedResponse['items'] is List) {
          return decodedResponse['items'] ?? [];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  /* Future<List<dynamic>> fetchCartItems(String firebaseId,
      {String status = 'pending'}) async {
    String? token = await AuthFirebaseService().getIdToken();

    try {
      final response = await http.get(
        Uri.parse("$apiUrl/products/cart?uid=$firebaseId&status=$status"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        if (decodedResponse is List) {
          return decodedResponse.isEmpty ? [] : decodedResponse;
        } else if (decodedResponse is Map && decodedResponse['items'] is List) {
          return decodedResponse['items'] ?? [];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }*/

  Future<bool> removeCartItem(String firebaseId, String productId) async {
    String? token = await AuthFirebaseService().getIdToken();

    final url = Uri.parse("$apiUrl/products/cart?uid=$firebaseId");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'productId': productId,
    });

    try {
      final response = await http.delete(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Product removed");
        return true;
      } else {
        print("Failed to remove product: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  /*Future<void> updateUserData(
      String? name, String? description, String? profileImageUrl) async {
    String? token = await AuthFirebaseService().getIdToken();
    final url = Uri.parse("$apiUrl/users/update");
    print("$profileImageUrl 🩸🩸d");
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      }),
    );

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }*/
  Future<void> updateUserData(
    String? name,
    String? description,
    String? profileImageUrl,
    String? legalName,
    String? idImageUrl,
    String? identityNumber,
    String? phoneNumber,
    String? seller,
    double? locationLatitude,
    double? locationLongitude,
  ) async {
    String? token = await AuthFirebaseService().getIdToken();
    final url = Uri.parse("$apiUrl/users/update");

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
        if (legalName != null) 'legal_name': legalName,
        if (idImageUrl != null) 'id_image_url': idImageUrl,
        if (identityNumber != null) 'identity_number': identityNumber,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (seller != null) 'seller': seller,
        if (locationLatitude != null) 'location_latitude': locationLatitude,
        if (locationLongitude != null) 'location_longitude': locationLongitude,
      }),
    );

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<CommentModel> insertCommentToProduct(
    String productId,
    User user,
    String comment,
  ) async {
    String? token = await AuthFirebaseService().getIdToken();
    final url = Uri.parse("$apiUrl/products/comment");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'productId': productId,
        'userId': user.uid,
        'comment': comment,
      }),
    );

    if (response.statusCode == 200) {
      final commentData = jsonDecode(response.body);
      return CommentModel.fromJson(commentData); // Ahora recibe todos los datos
    } else {
      throw Exception('Failed to insert comment: ${response.statusCode}');
    }
  }

  Future<bool> createUser(String firebaseUid, String name) async {
    final url = Uri.parse("$apiUrl/users");

    try {
      print("object $firebaseUid $name $url");
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'firebaseUid': firebaseUid,
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchCategories(int? limit,
      {bool withSubcategories = false}) async {
    String url = "$apiUrl/products/categories";

    List<String> queryParams = [];
    if (limit != null) {
      queryParams.add("limit=$limit");
    }
    if (withSubcategories) {
      queryParams.add("withSubcategories=true");
    }

    if (queryParams.isNotEmpty) {
      url += "?${queryParams.join("&")}";
    }

    final response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        print(" 🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️ ${jsonDecode(response.body)}");

        return jsonDecode(response.body);
      } else {
        throw Exception('Error');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<ProfileModel>> fetchProfiles(String firebaseUid) async {
    print(firebaseUid);
    String url = "$apiUrl/users/profiles/$firebaseUid";
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final List<dynamic> profileData = jsonDecode(response.body);
      print(profileData);
      return profileData.map((data) => ProfileModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  /* Future<void> submitProfileData(
    String firebaseUid,
    int id,
    String legalName,
    String locationId,
    List locationCoordinates,
    String locationDescription,
    String cardNumber,
    String identityNumber, // NUEVO CAMPO
    int profileIndex,
  ) async {
    final Map<String, dynamic> profileData = {
      'firebaseUid': firebaseUid,
      'legalName': legalName,
      'locationId': locationId,
      'locationCoordinates': locationCoordinates,
      'locationDescription': locationDescription,
      'cardNumber': cardNumber,
      'identityNumber': identityNumber,
    };

    try {
      print(profileData);
      final url = profileIndex == -1
          ? Uri.parse('$apiUrl/users/profiles')
          : Uri.parse('$apiUrl/users/profiles/$id');

      final response = profileIndex == -1
          ? await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(profileData),
            )
          : await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(profileData),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
            'Perfil ${profileIndex == -1 ? "Nuevo" : "Editado"} guardado correctamente');
      } else {
        print('Error al guardar perfil');
      }
    } catch (error) {
      print('Error: $error');
    }
  }*/

  Future<void> submitProfileData(
    String firebaseUid,
    int id,
    String legalName,
    double locationLatitude,
    double locationLongitude,
    String locationDescription,
    String cardNumber,
    String identityNumber,
    int profileIndex,
    String phoneNumber,
    bool isDefault,
  ) async {
    print("$locationLatitude   $firebaseUid  😫😫😫😫😫😫😫😫😫😫😫😫😫😫");

    final Map<String, dynamic> profileData = {
      'firebaseUid': firebaseUid,
      'legalName': legalName,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'locationDescription': locationDescription,
      'cardNumber': cardNumber,
      'identityNumber': identityNumber,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
    };

    try {
      print(profileData);
      final url = profileIndex == -1
          ? Uri.parse('$apiUrl/users/profiles')
          : Uri.parse('$apiUrl/users/profiles/$id');

      final response = profileIndex == -1
          ? await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(profileData),
            )
          : await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(profileData),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
            'Perfil ${profileIndex == -1 ? "Nuevo" : "Editado"} guardado correctamente');
      } else {
        print('Error al guardar perfil');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> deleteProfile(int profileId) async {
    final url = Uri.parse('$apiUrl/users/profiles/$profileId');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Perfil eliminado correctamente');
      } else {
        print('Error al eliminar perfil: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al intentar eliminar el perfil: $error');
    }
  }

  /* Future<bool> uploadPurchasedProducts({
    required List<String> productIds,
    required String legalName,
    required String location,
    required int userId,
    required String locationDescription,
    required String provider,
    required String identityId,
    required String cardNumber,
    required double amountToPay,
    required double subtotal,
    required double shipping,
    required double lat,
    required double long,
    required String firebaseUid,
  }) async {
    try {
      // Obtener el token de Firebase del usuario actualmente autenticado
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if (idToken == null) {
        // Si no hay un token, retorna false ya que no se puede realizar la acción
        print("Error: No se pudo obtener el token de autenticación.");
        return false;
      }

      final purchasedProductsJson = {
        "firebaseUid": firebaseUid,
        "products": productIds.map((id) {
          return {
            "id": id,
            "legalName": legalName,
            "location": location,
            "userId": userId,
            "locationDescription": locationDescription,
            "provider": provider,
            "identityId": identityId,
            "cardNumber": cardNumber,
            "coordinates": {
              "lat": lat,
              "long": long,
            },
          };
        }).toList(),
        "summary": {
          "amountToPay": amountToPay,
          "subtotal": subtotal,
          "shipping": shipping,
        },
      };

      final response = await http.post(
        Uri.parse("$apiUrl/insert-purchased-product"),
        headers: {
          'Authorization':
              'Bearer $idToken', // Incluir el token de Firebase en los encabezados
          'Content-Type': 'application/json',
        },
        body: jsonEncode(purchasedProductsJson),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        if (responseJson['status'] == 'success' &&
            responseJson['isValid'] == true) {
          // La validación es exitosa, por lo tanto retornamos true
          print("Respuesta del servidor: ${responseJson['message']}");
          return true; // Retorno el valor de éxito
        } else {
          // La validación falló, se retorna false
          print("Error: ${responseJson['message']}");
          return false; // Retorno el valor de error
        }
      } else {
        // Si la solicitud falla (por ejemplo, un error en el servidor)
        print("Error al enviar productos comprados: ${response.statusCode}");
        print("Mensaje del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      // En caso de excepción
      print("Excepción al enviar productos comprados: $e");
      return false;
    }
  }*/
  /*Future<bool> uploadPurchasedProducts({
    required List<String> productIds,
    required String legalName,
    required String location,
    required int userId,
    required String locationDescription,
    required String provider,
    required String identityId,
    required String cardNumber,
    required double amountToPay,
    required double subtotal,
    required double shipping,
    required double lat,
    required double long,
    required String firebaseUid,
    required String paymentToken,
  }) async {
    try {
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      print("$productIds  ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️🩸🩸");
      if (idToken == null) {
        print("Error: No se pudo obtener el token de autenticación.");
        return false;
      }

      final purchasedProductsJson = {
        "firebaseUid": firebaseUid,
        "products": productIds.map((id) {
          return {
            "product_id": id, // Aquí debería ser "product_id"
          };
        }).toList(),
        "summary": {
          "amountToPay": amountToPay,
          "subtotal": subtotal,
          "shipping": shipping,
        },
        "paymentToken": paymentToken,
      };

      final response = await http.post(
        Uri.parse("$apiUrl/insert-purchased-product"),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(purchasedProductsJson),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        if (responseJson['status'] == 'success' &&
            responseJson['isValid'] == true) {
          print("Respuesta del servidor: ${responseJson['message']}");
          return true;
        } else {
          print("Error: ${responseJson['message']}");
          return false;
        }
      } else {
        print("Error al enviar productos comprados: ${response.statusCode}");
        print("Mensaje del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Excepción al enviar productos comprados: $e");
      return false;
    }
  }*/
  Future<bool> uploadPurchasedProducts({
    required List<String> productIds,
    required int profileId,
    required String legalName,
    required String location,
    required int userId,
    required String locationDescription,
    required String provider,
    required String identityId,
    required String cardNumber,
    required double amountToPay,
    required double subtotal,
    required double shipping,
    required double lat,
    required double long,
    required String firebaseUid,
    required String paymentToken,
  }) async {
    try {
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if (idToken == null) {
        print("Error: No se pudo obtener el token de autenticación.");
        return false;
      }
      print(productIds);
      final purchasedProductsJson = {
        "firebaseUid": firebaseUid,
        "products": productIds.map((id) {
          return {
            "id": id,
            "legalName": legalName,
            "location": location,
            "userId": userId,
            "locationDescription": locationDescription,
            "provider": provider,
            "identityId": identityId,
            "cardNumber": cardNumber,
            "coordinates": {
              "lat": lat,
              "long": long,
            },
          };
        }).toList(),
        "summary": {
          "profileId": profileId,
          "amountToPay": amountToPay,
          "subtotal": subtotal,
          "shipping": shipping,
        },
        "paymentToken": paymentToken,
      };

      final response = await http.post(
        Uri.parse("$apiUrl/insert-purchased-product"),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(purchasedProductsJson),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        if (responseJson['status'] == 'success' &&
            responseJson['isValid'] == true) {
          print("Respuesta del servidor: ${responseJson['message']}");
          return true;
        } else {
          print("Error: ${responseJson['message']}");
          return false;
        }
      } else {
        print("Error al enviar productos comprados: ${response.statusCode}");
        print("Mensaje del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Excepción al enviar productos comprados: $e");
      return false;
    }
  }

  /*Future<double> convertUSDToCurrency(
      double amountInUSD, String currencyCode) async {
    const String url = 'https://open.er-api.com/v6/latest/USD';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double rate = data['rates'][currencyCode];

        double amountInTargetCurrency = amountInUSD * rate;
        return amountInTargetCurrency;
      } else {
        throw Exception(
            'Error al obtener la tasa de cambio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<double> convertCurrencyToUSD(
      double amountInTargetCurrency, String currencyCode) async {
    const String url = 'https://open.er-api.com/v6/latest/USD';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double rate = data['rates'][currencyCode];

        double amountInUSD = amountInTargetCurrency / rate;
        return amountInUSD;
      } else {
        throw Exception(
            'Error al obtener la tasa de cambio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }*/

  Future<double> getCurrencyValue(String currencyCode) async {
    const String url = 'https://open.er-api.com/v6/latest/USD';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double rate = data['rates'][currencyCode];
        return rate;
      } else {
        throw Exception(
            'Error al obtener la tasa de cambio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> deleteCommentFromProduct(int commentId) async {
    String? token = await AuthFirebaseService().getIdToken();
    final url = Uri.parse("$apiUrl/products/comment/$commentId");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Comentario eliminado correctamente');
        return true;
      } else {
        print('Error al eliminar comentario: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error al intentar eliminar el comentario: $error');
      return false;
    }
  }

  Future<List<OrderUserModel>> getUserOrders(String firebaseUid) async {
    String? token = await AuthFirebaseService().getIdToken();
    final String url = '$apiUrl/orders/$firebaseUid';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((order) => OrderUserModel.fromJson(order)).toList();
      } else {
        throw Exception('Error al obtener las órdenes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectarse al servidor: $e');
    }
  }

  /* Future<List<OrderSellerModel>> fetchOrdersBySeller(
      String sellerFirebaseUid, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/orders/seller/$sellerFirebaseUid'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => OrderSellerModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los pedidos');
    }
  }*/
  Future<List<OrderSellerModel>> fetchOrdersBySeller(
      String sellerFirebaseUid, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/orders/seller/$sellerFirebaseUid'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => OrderSellerModel.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar los pedidos');
      }
    } catch (e) {
      print('Error al obtener pedidos: $e');
      return [];
    }
  }
}
