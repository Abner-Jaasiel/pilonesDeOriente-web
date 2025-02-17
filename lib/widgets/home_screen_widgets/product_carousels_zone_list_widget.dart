import 'package:carkett/models/products_carrusel_model.dart';
import 'package:carkett/providers/route_manager_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/cards/flutter_product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final bucketGlobal = PageStorageBucket();

/*class ProductCarouselsZoneListWidget extends StatelessWidget {
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
}*/

class ProductCarouselsZoneListWidget extends StatefulWidget {
  const ProductCarouselsZoneListWidget({super.key});

  @override
  _ProductCarouselsZoneListWidgetState createState() =>
      _ProductCarouselsZoneListWidgetState();
}

class _ProductCarouselsZoneListWidgetState
    extends State<ProductCarouselsZoneListWidget> {
  late List<dynamic> _productsData; // Almacenará los datos cargados
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final APIService apiService = APIService();

    try {
      final List<dynamic> data = await apiService.fetchCarouselProducts();

      setState(() {
        _productsData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');

      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final Map<int, Map<String, List<dynamic>>> productsByCategory = {};

    for (var productData in _productsData) {
      ProductCarruselModel product = ProductCarruselModel.fromJson(productData);

      if (product.categoryId != null && product.categoryName != null) {
        final int? categoryKey = product.parentCategoryId ?? product.categoryId;
        final categoryName = product.parentCategoryId != null
            ? ' ${product.categoryName}'
            : product.categoryName;

        if (categoryKey != null && categoryName != null) {
          productsByCategory.putIfAbsent(categoryKey, () => {categoryName: []});
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
                  padding:
                      const EdgeInsets.only(top: 15.0, bottom: 8, left: 15),
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
          "category_id": categoryId,
        }),
        builder: (context, snapshot) {
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
  List<dynamic>? _cachedProducts;
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
      _cachedProducts = products;
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

          List<Widget> carouselWidgets = [];
          int maxItemsPerCarousel =
              MediaQuery.of(context).size.width < 600 ? 2 : 5;

          for (int i = 0; i < items.length; i += maxItemsPerCarousel) {
            var limitedProducts =
                items.skip(i).take(maxItemsPerCarousel).toList();
            carouselWidgets.add(
              SizedBox(
                height: 340,
                child: ProductCarouselSellerListWidget(
                  data: limitedProducts,
                  withIntialSpace: widget.withIntialSpace,
                ),
              ),
            );
          }

          return Column(children: carouselWidgets);
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

class ProductCarouselSellerListWidget extends StatelessWidget {
  const ProductCarouselSellerListWidget(
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
          return const SizedBox(width: 180);
        }

        final productIndex = withIntialSpace ? index - 1 : index;

        if (productIndex >= 0 && productIndex < data.length) {
          final product = data[productIndex];

          return SizedBox(
            width: 180,
            child: Stack(
              children: [
                ProductCard(
                  imageUrl: product.urlImage,
                  categoryName: product.categoryName ?? 'Category',
                  productName: product.name,
                  price: product.price,
                  onTap: () {
                    kIsWeb
                        ? GoRouter.of(context).go('/product/${product.id}')
                        : GoRouter.of(context).push('/product/${product.id}');
                  },
                  rating: product.rating,
                  isAvailable: product.onSale,
                  borderRadius: 8.0,
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/product_aggregator', extra: product.id);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.black54),
                      shape: WidgetStateProperty.all(const CircleBorder()),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
