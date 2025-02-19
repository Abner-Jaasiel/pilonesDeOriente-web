import 'package:carkett/models/products_carrusel_model.dart';

/*class SearchModel {
  final List<ProductCarruselModel> products;

  SearchModel({required this.products});

  factory SearchModel.fromJson(List<dynamic> json) {
    List<ProductCarruselModel> productList =
        json.map((item) => ProductCarruselModel.fromJson(item)).toList();
    return SearchModel(products: productList);
  }

  List<Map<String, dynamic>> toJson() {
    return products.map((product) => product.toJson()).toList();
  }
}*/

class SearchModel {
  final List<ProductCarruselModel> products;

  SearchModel({required this.products});

  factory SearchModel.fromJson(List<dynamic> json) {
    try {
      List<ProductCarruselModel> productList =
          json.map((item) => ProductCarruselModel.fromJson(item)).toList();
      return SearchModel(products: productList);
    } catch (e) {
      // Si ocurre un error en la conversión, retorna un SearchModel vacío
      return SearchModel(products: []);
    }
  }

  List<Map<String, dynamic>> toJson() {
    return products.map((product) => product.toJson()).toList();
  }
}
