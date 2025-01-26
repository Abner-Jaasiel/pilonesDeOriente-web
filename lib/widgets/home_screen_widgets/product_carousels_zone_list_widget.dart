import 'package:carkett/models/products_carrusel_model.dart';
import 'package:carkett/providers/route_manager_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/cards/flutter_product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final bucketGlobal = PageStorageBucket();

/*
class ProductCarouselsZoneListWidget extends StatelessWidget {
  const ProductCarouselsZoneListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    APIService apiService = APIService();
    Future<List<dynamic>> data = apiService.fetchCarouselProducts();

    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final Map<int, Map<String, List<dynamic>>> productsByCategory = {};

          for (var productData in snapshot.data!) {
            ProductCarruselModel product =
                ProductCarruselModel.fromJson(productData);

            if (product.categoryId != null && product.categoryName != null) {
              final int? categoryKey =
                  product.parentCategoryId ?? product.categoryId;
              final categoryName = product.parentCategoryId != null
                  ? ' ${product.categoryName}'
                  : product.categoryName;
              if (categoryKey != null && categoryName != null) {
                productsByCategory.putIfAbsent(
                  categoryKey,
                  () => {
                    categoryName: [],
                  },
                );
              }

              productsByCategory[categoryKey]![categoryName]!.add(product);
            }
          }

          List<Widget> carouselWidgets = [];
          productsByCategory.forEach((categoryId, categoryData) {
            categoryData.forEach((categoryName, products) {
              if (carouselWidgets.length < 6) {
                var limitedProducts = products.take(5).toList();

                carouselWidgets.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 8, left: 15),
                        child: Text(
                          categoryName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(
                        height: 340,
                        child: ProductCarouselListWidget(data: limitedProducts),
                      ),
                    ],
                  ),
                );
              }
            });
          });

          return Column(children: carouselWidgets);
        } else {
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}*/
class ProductCarouselsZoneListWidget extends StatelessWidget {
  const ProductCarouselsZoneListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final APIService apiService = APIService();

    return StreamBuilder<List<dynamic>>(
      stream: apiService.carouselProductsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Procesar datos como antes
          final Map<int, Map<String, List<dynamic>>> productsByCategory = {};

          for (var productData in snapshot.data!) {
            ProductCarruselModel product =
                ProductCarruselModel.fromJson(productData);

            if (product.categoryId != null && product.categoryName != null) {
              final int? categoryKey =
                  product.parentCategoryId ?? product.categoryId;
              final categoryName = product.parentCategoryId != null
                  ? ' ${product.categoryName}'
                  : product.categoryName;
              if (categoryKey != null && categoryName != null) {
                productsByCategory.putIfAbsent(
                  categoryKey,
                  () => {
                    categoryName: [],
                  },
                );
              }

              productsByCategory[categoryKey]![categoryName]!.add(product);
            }
          }

          List<Widget> carouselWidgets = [];
          productsByCategory.forEach((categoryId, categoryData) {
            categoryData.forEach((categoryName, products) {
              if (carouselWidgets.length < 6) {
                var limitedProducts = products.take(5).toList();

                carouselWidgets.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 8, left: 15),
                        child: Text(
                          categoryName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(
                        height: 340,
                        child: ProductCarouselListWidget(data: limitedProducts),
                      ),
                    ],
                  ),
                );
              }
            });
          });

          return Column(children: carouselWidgets);
        } else {
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}

class ProductCarouselListWithCategoryWidget extends StatelessWidget {
  const ProductCarouselListWithCategoryWidget(
      {super.key, required this.categoryId});

  final int categoryId;
//!OJOIOOOOOOOOOOOOOOOOOOOOOOOOOOOFL
  @override
  Widget build(BuildContext context) {
    print("🩸😀 $categoryId");
    return PageStorage(
      bucket: bucketGlobal,
      child: FutureBuilder(
        key: const PageStorageKey<String>('pageStorageKey2'),
        future: APIService().getFilteredProducts({
          'category_id': categoryId,
          'tags': null,
          'seller': null,
          'name': null,
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No se encontraron productos'),
            );
          }

          try {
            List<dynamic> jsonList = snapshot.data as List<dynamic>;
            List items = [];
            for (var productData in jsonList) {
              ProductCarruselModel product =
                  ProductCarruselModel.fromJson(productData);
              items.add(product);
            }
            //SearchModel data = SearchModel.fromJson(jsonList);
            print(items);
            return SizedBox(
              height: 340,
              child: ProductCarouselListWidget(
                data: items,
              ),
            );
          } catch (e) {
            return Center(
              child: Text('Error procesando los datos: $e'),
            );
          }
        },
      ),
    );
  }
}

class ProductCarouselListWithSellerWidget extends StatefulWidget {
  const ProductCarouselListWithSellerWidget({
    super.key,
    required this.seller,
    this.withIntialSpace = true,
  });

  final String seller;
  final bool withIntialSpace;

  @override
  State<ProductCarouselListWithSellerWidget> createState() =>
      _ProductCarouselListWithSellerWidgetState();
}

class _ProductCarouselListWithSellerWidgetState
    extends State<ProductCarouselListWithSellerWidget> {
  final APIService apiService = APIService();
  List<dynamic>? _cachedProducts; // Cache local de los productos
  late Future<List<dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchAndCacheProducts();
  }

  Future<List<dynamic>> _fetchAndCacheProducts() async {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    } else {
      final products = await apiService.getFilteredProducts({
        'category_id': null,
        'tags': null,
        'seller_firebase_uid': widget.seller,
        'name': null,
      });
      _cachedProducts = products; // Almacena los productos en cache
      return products!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _futureProducts,
      key: const PageStorageKey<String>('pageStorageKey2'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No se encontraron productos'),
          );
        }

        try {
          List<dynamic> jsonList = snapshot.data!;
          List<ProductCarruselModel> items = jsonList
              .map((productData) => ProductCarruselModel.fromJson(productData))
              .toList();

          return SizedBox(
            height: 340,
            child: ProductCarouselListWidget(
              data: items,
              withIntialSpace: widget.withIntialSpace,
            ),
          );
        } catch (e) {
          return Center(
            child: Text('Error procesando los datos: $e'),
          );
        }
      },
    );
  }
}

class ProductCarouselListWidget extends StatelessWidget {
  const ProductCarouselListWidget(
      {super.key, required this.data, this.withIntialSpace = false});

  final data;
  final bool withIntialSpace;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey<String>('pageStorageKey2'),
      scrollDirection: Axis.horizontal,
      itemCount: withIntialSpace ? data.length + 1 : data.length,
      itemBuilder: (context, index) {
        if (withIntialSpace && index == 0) {
          return const SizedBox(
            width: 180,
          );
        }

        final productIndex = withIntialSpace ? index - 1 : index;
        /* final routeManager =
            Provider.of<RouteManagerController>(context, listen: false);*/
        if (productIndex >= 0 && productIndex < data.length) {
          final product = data[productIndex];
          return SizedBox(
            width: 180,
            child: ProductCard(
              imageUrl: product.urlImage,
              categoryName: product.categoryName ?? 'Category',
              productName: product.name,
              price: product.price,
              currency: '\$',
              onTap: () {
                //  routeManager.navigateTo(context, '/product/${product.id}');

                kIsWeb
                    ? GoRouter.of(context).go('/product/${product.id}')
                    : GoRouter.of(context).push('/product/${product.id}');
              },
              rating: product.rating,
              isAvailable: product.onSale,
              borderRadius: 8.0,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
